#!/usr/bin/env node
/*
 * absent-boolean-probe — find a boolean the port says FALSE where the sample
 * says nothing at all.
 *
 * A JSON model property that is not there is not the same as one set to false.
 * UI5 resolves an absent value to `undefined`, `validateProperty` falls back on
 * the control's own default, and a control whose default is `true` therefore
 * renders as if the sample had asked for true. An ABAP `abap_bool` has no
 * absent state: an unset field serialises as a real JSON `false` and OVERRIDES
 * that default, so the port renders the opposite of the sample.
 *
 * App 291 is the worked case (found by review 2026-08-21, invisible to every
 * gate): `sap.m.NotificationListBase.showCloseButton` defaults to true, the
 * mock gives its groupItems no `showCloseButton` key, and the port left the
 * field initial on those rows — so neither item rendered a close button, and
 * with it the port's only backend wire, ITEM_CLOSE, became unreachable: there
 * was nothing left to press. `structural_diff` compares attribute names and
 * saw the binding; `data_fidelity` compares seeded values and had no original
 * value to compare against; the render gate only asks whether the view loads.
 *
 * TWO signals have to coincide, and requiring both is what keeps this quiet:
 *
 *   1. the field is set on SOME rows of a VALUE #( ) table and not on others
 *      (a field nobody sets, or everybody sets, is a deliberate uniform state)
 *   2. it is bound to a control property whose UI5 default is TRUE
 *      (read out of the OpenUI5 sources — the metadata snapshot in
 *      ui5/properties.json carries types, not defaults)
 *
 * Signal 1 alone is ordinary data variation: `unread`, `active`, `modified`
 * genuinely differ per row and all default to false. Signal 2 alone is often
 * deliberate too — a Button that starts disabled because the original starts
 * it disabled. Together they mean the port is asserting a false the sample
 * never asserted.
 *
 * A hit is still a question, not a verdict: read the sample's mock and check
 * whether it really omits the key. If the port means it, declare it.
 *
 *   node scripts/probes/absent-boolean-probe.mjs
 *   node scripts/probes/absent-boolean-probe.mjs --loose   also list signal 1 alone
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..', '..');
const META = path.join(ROOT, 'meta');
const LOOSE = process.argv.includes('--loose');

// ---- boolean properties whose UI5 default is TRUE, read from the sources ----
const DEFAULT_TRUE = {};
const LIBS = path.join(ROOT, 'node_modules', '@openui5');
const PROP_RE = /(\w+)\s*:\s*\{\s*type\s*:\s*["']boolean["'][^}]*defaultValue\s*:\s*true/g;
if (fs.existsSync(LIBS)) {
  const walk = (d) => {
    for (const e of fs.readdirSync(d, { withFileTypes: true })) {
      const f = path.join(d, e.name);
      if (e.isDirectory()) walk(f);
      else if (e.name.endsWith('.js') && /^[A-Z]/.test(e.name)) {
        const txt = fs.readFileSync(f, 'utf8');
        const cls = (txt.match(/extend\(\s*["']([\w.]+)["']/) || [])[1];
        if (!cls) continue;
        for (const m of txt.matchAll(PROP_RE)) (DEFAULT_TRUE[cls] ||= new Set()).add(m[1]);
      }
    }
  };
  for (const lib of fs.readdirSync(LIBS)) {
    const src = path.join(LIBS, lib, 'src');
    if (fs.existsSync(src)) walk(src);
  }
}

/*
 * The source with COMMENTS and literal CONTENT blanked, offset for offset.
 *
 * The paren walk below counts `( … )` groups, and this corpus writes prose
 * next to its data: app 167's seed carries the comment "NavigationListItem
 * only fires itemSelect when getSelectable( ) is true", whose `( )` was
 * counted as a fifteenth row of a fourteen-row table - a row with none of the
 * fields set, which is exactly the shape this probe reports. Three false hits
 * from one sentence, and the remedy it printed ("seed abap_true on those
 * rows") would have changed correct data. A literal is blanked for the same
 * reason: a `(` inside a title is not a row either.
 */
function codeOnly(src) {
  let out = '';
  let str = null;
  let comment = false;
  for (let i = 0; i < src.length; i++) {
    const c = src[i];
    if (c === '\n') { out += c; comment = false; continue; }
    if (comment) { out += ' '; continue; }
    if (str) { out += c === str ? c : ' '; if (c === str) str = null; continue; }
    if (c === '"' || (c === '*' && (i === 0 || src[i - 1] === '\n'))) { comment = true; out += ' '; continue; }
    if (c === '`' || c === "'" || c === '|') { str = c; out += c; continue; }
    out += c;
  }
  return out;
}

// ---- the balanced body of a VALUE #( … ), and its top-level ( … ) rows ----
const balanced = (src, i) => {
  let d = 0;
  for (let j = i; j < src.length; j++) {
    if (src[j] === '(') d++;
    else if (src[j] === ')' && --d === 0) return src.slice(i + 1, j);
  }
  return '';
};
function topLevelRows(body) {
  const out = [];
  let d = 0, start = -1;
  for (let i = 0; i < body.length; i++) {
    if (body[i] === '(') { if (d === 0) start = i + 1; d++; }
    else if (body[i] === ')') { if (--d === 0 && start >= 0) { out.push(body.slice(start, i)); start = -1; } }
  }
  return out;
}

// ---- which control property, if any, each abap_bool field is bound to ----
function boundProps(src) {
  const ns = {};
  for (const m of src.matchAll(/n = `xmlns:(\w+)`\s+v = `([\w.]+)`/g)) ns[m[1]] = m[2];
  const dflt = (src.match(/n = `xmlns`\s+v = `([\w.]+)`/) || [])[1] || '';
  const map = {};
  let cur = null;
  for (const line of src.split('\n')) {
    let m = line.match(/\)->(?:ele|tag)\(\s*n = `(\w+)`\s+ns = `(\w+)`/);
    if (m) { cur = `${ns[m[2]] || m[2]}.${m[1]}`; continue; }
    m = line.match(/\)->(?:ele|tag)\(\s*`(\w+)`/);
    if (m) { cur = `${dflt}.${m[1]}`; continue; }
    m = line.match(/\)->a\(\s*n = `(\w+)`\s+v = (?:client->_bind\(\s*(\w+)\s*\)|`\{(\w+)\}`)/);
    if (m && cur) (map[(m[2] || m[3]).toLowerCase()] ||= []).push([cur, m[1]]);
  }
  return map;
}

// A property is usually declared on a BASE class, not on the control the view
// names: sap.m.NotificationListItem inherits showCloseButton (default true)
// from sap.m.NotificationListBase. Looking only at the named control misses
// exactly the case this probe exists for — app 291 — so walk the chain, using
// the parent links in the metadata snapshot.
const PARENT = (() => {
  const f = path.join(ROOT, 'ui5', 'properties.json');
  if (!fs.existsSync(f)) return {};
  const j = JSON.parse(fs.readFileSync(f, 'utf8')).controls || {};
  return Object.fromEntries(Object.entries(j).map(([k, v]) => [k, v.parent]));
})();
function defaultsTrue(cls, prop) {
  for (let c = cls, guard = 0; c && guard < 20; c = PARENT[c], guard++) {
    if (DEFAULT_TRUE[c]?.has(prop)) return true;
  }
  return false;
}

const metas = fs.readdirSync(META).filter((f) => f.endsWith('.json'))
  .map((f) => JSON.parse(fs.readFileSync(path.join(META, f), 'utf8')))
  .filter((m) => /^z2ui5_cl_smpc_app_\d+$/.test(m.class || '') && m.class !== 'z2ui5_cl_smpc_app_000');

let hits = 0, loose = 0;
for (const m of metas) {
  const file = path.join(ROOT, m.file);
  if (!fs.existsSync(file)) continue;
  const src = fs.readFileSync(file, 'utf8');
  const bools = new Set([...src.matchAll(/(\w+)\s+TYPE abap_bool/g)].map((x) => x[1].toLowerCase()));
  if (!bools.size) continue;
  const bound = boundProps(src);
  /* The seeds are read out of the blanked copy; `boundProps( )` above still
   * reads the source, because what it looks for IS the literals. */
  const code = codeOnly(src);

  for (const v of code.matchAll(/VALUE #\(/g)) {
    const body = balanced(code, v.index + 7);
    if (!body) continue;
    const rows = topLevelRows(body);
    if (rows.length < 2) continue;
    // an assignment BEFORE the first row is the VALUE base and applies to all
    const firstRow = body.indexOf('(');
    const base = firstRow < 0 ? body : body.slice(0, firstRow);

    for (const f of bools) {
      const re = new RegExp(`\\b${f}\\s*=`, 'i');
      if (re.test(base)) continue;
      const set = rows.filter((r) => re.test(r)).length;
      if (set === 0 || set === rows.length) continue;
      const line = code.slice(0, v.index).split('\n').length;   // same offsets as src
      const targets = (bound[f] || []).filter(([c, p]) => defaultsTrue(c, p));
      if (!targets.length) {
        loose++;
        if (LOOSE) console.log(`(loose)     ${m.class}  ${f}: set in ${set} of ${rows.length} rows — no bound property defaults to true  ${path.relative(ROOT, file)}:${line}`);
        continue;
      }
      hits++;
      const [c, p] = targets[0];
      console.log(`ABSENT-BOOL ${m.class}  ${f} is set on ${set} of ${rows.length} rows and binds ${c}.${p}, whose UI5 default is TRUE`);
      console.log(`            ${path.relative(ROOT, file)}:${line} — the ${rows.length - set} row(s) without it render FALSE, where an absent key would render true (${m.sample})`);
    }
  }
}

console.log(`\nabsent-boolean: ${metas.length} ports scanned, ${hits} field(s) asserting a false the sample may never have asserted`);
console.log(`                (${loose} more row-inconsistent boolean(s) bind no default-true property — ordinary data variation; --loose to list)`);
if (hits) {
  console.log('Read the sample mock: if it omits the key, seed abap_true on those rows. If the port means false, declare it.');
}
