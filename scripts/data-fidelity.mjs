#!/usr/bin/env node
/*
 * data-fidelity — seeded asset values must match the archived sample mocks.
 *
 * WHY: no other gate compares DATA. structural-diff ignores model values,
 * the view-gates render gate mocks the model — so a port that seeds a wrong asset value
 * renders green everywhere and only a human audit catches it. That class of
 * bug happened three times before the 2026-07-24 audit swept it (apps 162,
 * 142, 119: values copied from the nearest NEIGHBOUR port instead of the
 * sample's own mock — e.g. `HT-1000.jpg` seeded where the sample's img.json
 * says `HT-7777-large.jpg`). This gate makes the asset half of that audit
 * deterministic and repeatable:
 *
 *   1. every asset-like literal in a port (…​.jpg/.png/…) must have its
 *      BASENAME somewhere in the port's own mock corpus = the archived
 *      sample folder ui5/<lib>/<Name>/ plus every ui5/mock/*.json that
 *      corpus references — an asset the sample never mentions is exactly
 *      the wrong-neighbour-copy signature;
 *   2. a full-path literal must match a corpus occurrence end-to-end
 *      (host-absolutization via https://sdk.openui5.org tolerated both
 *      ways) — right basename but wrong folder is a typo;
 *   3. no asset may point at a non-OpenUI5 UI5 host (SAPUI5 CDN) — the
 *      AGENTS rule is sdk.openui5.org, never SAPUI5.
 *
 * Escape hatches (same conventions as the other gates): a deviation whose
 * `what` names the asset's basename verbatim declares it; a sidecar
 * "data_fidelity": { "skip": true, "reason": "…" } skips the port.
 *
 * STAGE 2 (2026-07-26) — value-level table fidelity. Every ABAP
 * `VALUE #( … )` block that inlines a mock array (matched by >= 3 shared
 * field names, >= 2 rows) is compared against that array:
 *
 *   - equal row counts  -> row-by-row, field-by-field STRING comparison
 *     (positional; a field the mock row omits is skipped — the port seeds
 *     the UI5 default there by rule);
 *   - fewer rows        -> per-field SET membership: every seeded string
 *     value must exist among that field's mock values (subsets can be
 *     legitimate — the original may bind /Coll/0..n — but INVENTED values
 *     are the 142-class bug this catches);
 *   - numbers stay uncompared (formatting freedom: 6.99 vs `6.99`), and a
 *     value is cleared by a deviation whose `what` names it (or the field),
 *     same convention as the asset checks.
 *
 * KNOWN BLIND SPOT — a block with MORE rows than the matched array is not
 * checked at all (neither branch takes it). Extending the subset check to it
 * looks obvious and is wrong today: the matcher scores by field overlap and
 * only breaks ties on an equal row count, so a block that outgrew its array
 * tends to get paired with a same-shaped SIBLING instead. Measured over the
 * corpus, exactly one port lands here — 407 (sap.tnt.sample.
 * SideNavigationSearch), whose mock holds `navigation` and `fixedNavigation`
 * with three rows each while the port inlines eight and seven; it is matched
 * against `fixedNavigation` and a strict membership check would report ~89
 * invented values in a correct port. The gap is real but closing it needs a
 * matcher that can say WHICH array a block belongs to, not a third branch
 * here.
 *
 * Residual value-level review beyond tables (scalar folds): --report prints,
 * per port, the mock string values that never appear in the ABAP source, as
 * a scannable audit worksheet — informational only.
 *
 * Run:  node scripts/data-fidelity.mjs [--report]     (exit 1 on any error)
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const META = path.join(ROOT, 'meta');
const UI5 = path.join(ROOT, 'ui5');
const MOCK = path.join(UI5, 'mock');
const REPORT = process.argv.includes('--report');

const ASSET_RE = /([\w./:\-]+\.(?:jpg|jpeg|png|gif|svg|webp|bmp|ico|mp3|mp4|pdf))\b/gi;
const BAD_HOSTS = ['sapui5.hana.ondemand.com', '//ui5.sap.com'];
const TEXT_EXT = ['.json', '.xml', '.js', '.html', '.properties', '.css', '.ts'];

let errors = 0;
const err = (m) => { console.log(`ERROR ${m}`); errors++; };

function walk(dir, out = []) {
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) walk(p, out);
    else out.push(p);
  }
  return out;
}

// a token is checkable when its basename carries a real name before the
// extension (template-composed tails like `}.jpg` reduce to just `.jpg`
// and cannot be verified at this level)
const basenameOf = (t) => t.split('/').pop();
const checkable = (t) => /^[\w\-]+[\w\-.]*\.\w+$/.test(basenameOf(t));
// strip scheme+host and leading ./ so absolute and relative forms compare
const normalize = (t) => t.replace(/^https?:\/\/[^/]+\//, '').replace(/^\.\//, '');

function assetTokens(text) {
  const out = [];
  for (const m of text.matchAll(ASSET_RE)) out.push(m[1]);
  return out;
}

// --- stage 2 helpers: ABAP VALUE-block table parsing -------------------------

// normalize a field/key name for matching: SupplierName == suppliername == supplier_name
const normName = (s) => s.toLowerCase().replace(/_/g, '');
// join `a` && `b` continuations and unescape doubled backticks
function abapString(raw) {
  const parts = [...raw.matchAll(/`((?:[^`]|``)*)`/g)].map((m) => m[1].replace(/``/g, '`'));
  return parts.join('');
}

// protect backtick string literals so paren scanning/masking never touches
// text INSIDE a literal ("(mono)" in a description is data, not nesting):
// returns { text, lits } with each literal replaced by \x00<n>\x00
function protectLiterals(src) {
  const lits = [];
  const text = src.replace(/`(?:[^`]|``)*`/g, (lit) => {
    lits.push(lit);
    return `\x00${lits.length - 1}\x00`;
  });
  return { text, lits };
}
const restoreLiterals = (s, lits) => s.replace(/\x00(\d+)\x00/g, (_, n) => lits[+n]);

// every VALUE #( … ) block in the source parsed into rows of {field: value}
// (string values only; rows = the block's depth-1 `( … )` groups; nested
// parens inside a row — nested tables/structures — are masked out). All
// scanning happens on the literal-protected text.
function parseValueBlocks(abap) {
  const { text, lits } = protectLiterals(abap);
  const blocks = [];
  for (const m of text.matchAll(/VALUE\s+#?\s*\(/g)) {
    const open = m.index + m[0].length - 1;
    // region of this VALUE( … ) on the protected text
    let depth = 0;
    let end = text.length;
    for (let i = open; i < text.length; i++) {
      if (text[i] === '(') depth++;
      else if (text[i] === ')' && --depth === 0) { end = i; break; }
    }
    const body = text.slice(open + 1, end);
    const rows = [];
    let d = 0;
    let start = -1;
    for (let i = 0; i < body.length; i++) {
      if (body[i] === '(') { if (d === 0) start = i; d++; }
      else if (body[i] === ')') { d--; if (d === 0 && start >= 0) rows.push(body.slice(start + 1, i)); }
    }
    if (rows.length < 2) continue;
    const parsed = [];
    for (const rowText of rows) {
      // mask nested paren groups (nested VALUE/structs) — literals are safe
      let masked = rowText;
      let prev;
      do { prev = masked; masked = masked.replace(/\([^()]*\)/g, ' '); } while (masked !== prev);
      const row = {};
      for (const p of masked.matchAll(/(\w+)\s*=\s*(\x00\d+\x00(?:\s*&&\s*\x00\d+\x00)*)/g)) {
        row[normName(p[1])] = abapString(restoreLiterals(p[2], lits));
      }
      parsed.push(row);
    }
    if (parsed.some((r) => Object.keys(r).length)) blocks.push(parsed);
  }
  return blocks;
}

// arrays of flat objects in a JSON doc (top level or one level down)
function mockArrays(doc, name) {
  const out = [];
  const take = (label, v) => {
    if (Array.isArray(v) && v.length >= 2 && v.every((r) => r && typeof r === 'object' && !Array.isArray(r))) {
      out.push({ name: label, rows: v });
    }
  };
  take(name, doc);
  if (doc && typeof doc === 'object' && !Array.isArray(doc)) {
    for (const [k, v] of Object.entries(doc)) {
      take(k, v);
      if (v && typeof v === 'object' && !Array.isArray(v)) for (const [k2, v2] of Object.entries(v)) take(`${k}/${k2}`, v2);
    }
  }

  return out;
}

let portsChecked = 0;
let skipped = 0;
for (const mf of fs.readdirSync(META).sort()) {
  if (!mf.endsWith('.json')) continue;
  const meta = JSON.parse(fs.readFileSync(path.join(META, mf), 'utf8'));
  const abapFile = path.join(ROOT, meta.file);
  if (!fs.existsSync(abapFile)) continue; // validate-meta reports this
  const abap = fs.readFileSync(abapFile, 'utf8');

  if (meta.data_fidelity?.skip) { skipped++; continue; }

  // --- the port's mock corpus: archived sample folder + referenced ui5/mock/
  const i = meta.sample.indexOf('.sample.');
  const lib = meta.sample.slice(0, i);
  const name = meta.sample.slice(i + '.sample.'.length);
  const sampleDir = path.join(UI5, lib, name);
  const corpusFiles = fs.existsSync(sampleDir) ? walk(sampleDir) : [];
  const corpusTexts = [];
  for (const f of corpusFiles) {
    if (TEXT_EXT.includes(path.extname(f).toLowerCase())) corpusTexts.push(fs.readFileSync(f, 'utf8'));
  }
  // shared demo-kit mocks the sample references — by file name (img.json) or
  // by a top-level collection key (a view binding `/ProductCollection` never
  // names products.json: the demo kit runner injects that default model, so
  // match the mock's own top-level keys against the archived sample texts)
  if (fs.existsSync(MOCK)) {
    for (const mock of fs.readdirSync(MOCK)) {
      if (!mock.endsWith('.json')) continue;
      const mockText = fs.readFileSync(path.join(MOCK, mock), 'utf8');
      let referenced = corpusTexts.some((t) => t.includes(mock));
      if (!referenced) {
        try {
          const keys = Object.keys(JSON.parse(mockText)).filter((k) => k.length >= 4);
          referenced = keys.some((k) => corpusTexts.some((t) => t.includes(k)));
        } catch { /* not an object mock */ }
      }
      if (referenced) corpusTexts.push(mockText);
    }
  }
  const corpusTokens = new Set();
  const corpusBasenames = new Set();
  for (const t of corpusTexts) {
    for (const tok of assetTokens(t)) {
      corpusTokens.add(normalize(tok));
      corpusBasenames.add(basenameOf(tok));
    }
  }
  // archived binary assets count by file name too
  for (const f of corpusFiles) corpusBasenames.add(path.basename(f));

  const declared = (meta.deviations || []).map((d) => d.what || '').join('\n');

  // --- check every asset literal in the port -------------------------------
  portsChecked++;
  const seen = new Set();
  for (const tok of assetTokens(abap)) {
    if (!checkable(tok)) continue;
    const base = basenameOf(tok);
    const key = normalize(tok);
    if (seen.has(key)) continue;
    seen.add(key);

    for (const h of BAD_HOSTS) {
      if (tok.includes(h)) err(`${meta.class}: asset on a non-OpenUI5 host (${h}) — use https://sdk.openui5.org: \`${tok}\``);
    }
    if (declared.includes(base)) continue; // declared deviation covers it
    if (!corpusBasenames.has(base)) {
      err(`${meta.class}: asset \`${base}\` appears nowhere in the sample's archived files/mocks (ui5/${lib}/${name}/) — wrong-neighbour copy? Fix the value or declare it in a deviation naming \`${base}\``);
      continue;
    }
    if (tok.includes('/')) {
      const ok = [...corpusTokens].some((c) =>
        c === key || c.endsWith(`/${key}`) || key.endsWith(`/${c}`));
      if (!ok) {
        err(`${meta.class}: asset path \`${tok}\` does not match any occurrence of \`${base}\` in the sample's archived files/mocks — path/folder differs`);
      }
    }
  }

  // --- stage 2: VALUE-block tables vs mock arrays ---------------------------
  const corpusDocs = [];
  for (const f of corpusFiles) {
    if (path.extname(f) !== '.json' || f.endsWith('manifest.json')) continue;
    try { corpusDocs.push({ name: path.basename(f, '.json'), doc: JSON.parse(fs.readFileSync(f, 'utf8')) }); } catch { /* not JSON */ }
  }
  // "no own JSON docs" must be decided BEFORE the loop below appends the
  // shared mocks — reading corpusDocs.length inside it made the fallback add
  // exactly one arbitrary mock (whichever came first in readdirSync order)
  const hadOwnDocs = corpusDocs.length > 0;
  if (fs.existsSync(MOCK)) {
    for (const mock of fs.readdirSync(MOCK)) {
      if (!mock.endsWith('.json')) continue;
      if (corpusTexts.some((t) => t.includes(mock)) || !hadOwnDocs) {
        try { corpusDocs.push({ name: path.basename(mock, '.json'), doc: JSON.parse(fs.readFileSync(path.join(MOCK, mock), 'utf8')) }); } catch { /* */ }
      }
    }
  }
  const arrays = [];
  const seenArr = new Set();
  for (const { name: dn, doc } of corpusDocs) {
    for (const a of mockArrays(doc, dn)) {
      if (seenArr.has(a.name)) continue;
      seenArr.add(a.name);
      arrays.push(a);
    }
  }
  const blocks = parseValueBlocks(abap);
  const declaredLc = declared.toLowerCase();
  /* A VALUE is specific enough to match loosely — "Notebook Basic 15" occurs in
   * a deviation only because somebody meant it. A bare FIELD NAME is not:
   * `text`, `name`, `title`, `icon` are ordinary English, so any deviation
   * containing one of them excused every mismatch in that field, across every
   * row. App 269 truncated feed.json row 1's Text from 1273 characters to 212
   * and data-fidelity reported 0 errors, because an unrelated deviation said
   * "the Slider and the width hint Text keep their original visibility rules".
   * (Same shape as the version-finding escape in view-gates, fixed the same
   * day.) So a field name counts as declared only in a form that IDENTIFIES it
   * as a field: backticked, or written as the ABAP component in upper case. */
  const isDeclaredValue = (...cands) => cands.some((c) => c && declaredLc.includes(String(c).toLowerCase()));
  const isDeclaredField = (f) => !!f && (declaredLc.includes('`' + String(f).toLowerCase() + '`')
    || new RegExp(`\\b${String(f).toUpperCase()}\\b`).test(declared));
  const isDeclared = (...cands) => {
    const f = cands[cands.length - 1];
    return isDeclaredValue(...cands.slice(0, -1)) || isDeclaredField(f);
  };
  // each ABAP table block is compared against its ONE best-matching mock
  // array — never against every array that shares field names (a sample may
  // carry its own modified products.json NEXT TO the shared mock, app 010).
  // Score: field overlap first, then exact row-count match, then source
  // order (sample-local docs come before the shared mocks in `arrays`).
  for (const block of blocks) {
    const fields = new Set(block.flatMap((r) => Object.keys(r)));
    let bestArr = null;
    let bestOverlap = null;
    let bestScore = -1;
    arrays.forEach((arr, idx) => {
      const keySet = new Set(arr.rows.flatMap((r) => Object.keys(r)).map(normName));
      const overlap = [...fields].filter((f) => keySet.has(f));
      if (overlap.length < 3) return;
      const score = overlap.length * 1000 + (block.length === arr.rows.length ? 100 : 0) + (arrays.length - idx);
      if (score > bestScore) { bestScore = score; bestArr = arr; bestOverlap = overlap; }
    });
    if (!bestArr) continue;
    const arr = bestArr;
    const overlap = bestOverlap;
    const keyByNorm = new Map();
    for (const r of arr.rows) for (const k of Object.keys(r)) if (!keyByNorm.has(normName(k))) keyByNorm.set(normName(k), k);

    // values compare equal modulo the sanctioned host-absolutization
    // (mock `test-resources/…` seeded as `https://sdk.openui5.org/test-resources/…`)
    const sameValue = (a, b) => a === b || normalize(a) === normalize(b);

    if (block.length === arr.rows.length) {
      // full inline — positional row/field string comparison
      block.forEach((row, i) => {
        for (const f of overlap) {
          const mv = arr.rows[i]?.[keyByNorm.get(f)];
          const av = row[f];
          if (typeof mv !== 'string' || av === undefined || av === '') continue;
          if (!sameValue(av, mv) && !isDeclared(av, mv, f)) {
            err(`${meta.class}: table row ${i + 1} field \`${f}\` = ${JSON.stringify(av)} but the mock ${arr.name} row has ${JSON.stringify(mv)} — data must stay verbatim (declare the field/value in a deviation if intentional)`);
          }
        }
      });
    } else if (block.length < arr.rows.length) {
      // subset inline (may be legitimate — the original may bind /Coll/0..n):
      // every seeded string value must at least EXIST among that field's mock
      // values, so invented / wrong-neighbour values (the 142 class) still fail
      const valuesByField = new Map(overlap.map((f) => [f,
        new Set(arr.rows.map((r) => r[keyByNorm.get(f)]).filter((v) => typeof v === 'string').map((v) => normalize(v)))]));
      block.forEach((row, i) => {
        for (const f of overlap) {
          const av = row[f];
          const set = valuesByField.get(f);
          if (av === undefined || av === '' || !set || set.size === 0) continue;
          if (!set.has(normalize(av)) && !isDeclared(av, f)) {
            err(`${meta.class}: table row ${i + 1} field \`${f}\` = ${JSON.stringify(av)} appears nowhere in the mock ${arr.name}'s ${keyByNorm.get(f)} values — invented/wrong-neighbour data (declare it in a deviation if intentional)`);
          }
        }
      });
    }
  }

  // --- optional value-coverage report (informational) ----------------------
  if (REPORT) {
    const missing = [];
    for (const f of corpusFiles) {
      if (path.extname(f) !== '.json' || f.endsWith('manifest.json')) continue;
      let doc;
      try { doc = JSON.parse(fs.readFileSync(f, 'utf8')); } catch { continue; }
      const vals = new Set();
      (function collect(v) {
        if (Array.isArray(v)) v.forEach(collect);
        else if (v && typeof v === 'object') Object.values(v).forEach(collect);
        else if (typeof v === 'string' && v.length >= 3 && !/[{}<>]/.test(v)) vals.add(v);
      })(doc);
      for (const v of vals) if (!abap.includes(v)) missing.push(v);
    }
    if (missing.length) {
      console.log(`REPORT ${meta.class}: ${missing.length} mock string value(s) not found in the ABAP source (fold/subset or drift — verify): ${missing.slice(0, 8).map((v) => JSON.stringify(v)).join(', ')}${missing.length > 8 ? ', …' : ''}`);
    }
  }
}

console.log(`data-fidelity: ${portsChecked} ports checked, ${skipped} skipped (declared), ${errors} error(s).`);
process.exit(errors ? 1 : 0);
