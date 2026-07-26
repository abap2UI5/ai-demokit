#!/usr/bin/env node
/*
 * data-fidelity — seeded asset values must match the archived sample mocks.
 *
 * WHY: no other gate compares DATA. structural-diff ignores model values,
 * render-smoke mocks the model — so a port that seeds a wrong asset value
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
 * Value-level mock fidelity beyond assets (names, addresses, quantities)
 * stays with review + the periodic audit: --report prints, per port, the
 * mock string values that never appear in the ABAP source, as a scannable
 * audit worksheet — informational only, it does not fail the run.
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
