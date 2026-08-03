#!/usr/bin/env node
/*
 * Generates the in-system overview app src/z2ui5_cl_ai_app_overview.clas.*
 * — an abap2UI5 app that lists every ported sample as one row of a table with
 * columns: Module, Control (-> OpenUI5 API), Sample (name -> OpenUI5 repo
 * source, ↗ -> live OpenUI5 fullscreen sample), abap2UI5 (class name ->
 * generated class on GitHub, ↗ -> starts the app) and Note (green check when
 * live-verified; orange 1.71+ badge when the port keeps members newer than
 * UI5 1.71; hint button opens the deviations popup). Every link opens in
 * a NEW browser tab (target="_blank"; the ↗ start link uses ?app_start=).
 * Reads everything from the meta/ sidecars (the source of truth for sample,
 * entity, checked and deviations - the port classes carry no header).
 *
 * Run:  node scripts/generate-overview.mjs
 *       node scripts/generate-overview.mjs --update-entities
 *         (rebuilds ui5/openui5-entities.json from the installed @openui5
 *          sources - needs node_modules; see the oracle comment below)
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const SRC = path.join(ROOT, 'src');
const META = path.join(ROOT, 'meta');
const CLASS = 'z2ui5_cl_ai_app_overview';
const OUT_ABAP = path.join(SRC, `${CLASS}.clas.abap`);
const OUT_XML = path.join(SRC, `${CLASS}.clas.xml`);

function walk(dir, out = []) {
  for (const name of fs.readdirSync(dir)) {
    const full = path.join(dir, name);
    if (fs.statSync(full).isDirectory()) walk(full, out);
    else out.push(full);
  }
  return out;
}

// control availability from the sample-universe snapshot (same source as the
// coverage docs): the release a control appeared in + whether it is deprecated
const uni = JSON.parse(fs.readFileSync(path.join(ROOT, 'ui5', 'universe.json'), 'utf8'));
const uniMap = new Map();
for (const lib of uni.libs) for (const s of lib.samples) uniMap.set(`${lib.lib}|${s.name}`, s);

// OpenUI5 membership oracle — DETERMINISTIC, reads only committed data: a
// control/entity is in OpenUI5 if it is a known control (ui5/properties.json,
// the offline control catalog) OR listed in ui5/openui5-entities.json (the
// committed snapshot of OpenUI5 entities that have no properties.json entry:
// statics/helpers like MessageBox/MessageToast/URLHelper, the sap.ui.model
// types, CSS-class doc entities). Entities in neither are "not in OpenUI5"
// (demo-kit-only patterns). The snapshot exists so the ui5_only flags come out
// identical with and without node_modules — the previous filesystem probe of
// node_modules/@openui5 made the generated class differ between environments
// (6 vs 25 flags), so the meta_valid drift gate and the pre-commit hook
// disagreed depending on whether npm ci had run. When the @openui5 packages
// ARE installed, the snapshot is cross-checked against their sources and a
// stale snapshot fails the run; rebuild it with --update-entities.
const OPENUI5_CONTROLS = (() => {
  try { return JSON.parse(fs.readFileSync(path.join(ROOT, 'ui5', 'properties.json'), 'utf8')).controls || {}; }
  catch { return {}; }
})();
const ENTITIES_FILE = path.join(ROOT, 'ui5', 'openui5-entities.json');
const EXTRA_ENTITIES = new Set((() => {
  try { return JSON.parse(fs.readFileSync(ENTITIES_FILE, 'utf8')).entities || []; }
  catch { return []; }
})());
const OPENUI5_PKG = path.join(ROOT, 'node_modules', '@openui5');
const OPENUI5_LIBS = fs.existsSync(OPENUI5_PKG) ? fs.readdirSync(OPENUI5_PKG) : [];

// scope fallback (same as generate-coverage.mjs, pr/scope-since-from-source):
// the universe snapshot carries since:null for most controls, so fill the
// nulls from the control-level @since/@deprecated that the linter's generate-metadata.mjs
// parses out of the OpenUI5 sources — the overview's Since column and the
// deprecation strikethrough then match the authoritative scope verdict.
for (const s of uniMap.values()) {
  const c = s.entity && OPENUI5_CONTROLS[s.entity];
  if (!c) continue;
  if (!s.since && c.since) s.since = c.since;
  if (!s.deprecated && c.deprecated) s.deprecated = c.deprecated;
}
// per-library text (library.js + .library manifest) - catches OpenUI5 entities
// that have no own module: statics/helpers (sap.m.URLHelper, in library.js) and
// CSS-class doc entities (sap.ui.core.StandardMargins/ContainerPadding, in .library)
const libTextCache = {};
function libText(lib) {
  if (libTextCache[lib] !== undefined) return libTextCache[lib];
  const base = path.join(OPENUI5_PKG, lib, 'src', lib.replace(/\./g, '/'));
  let t = '';
  for (const f of ['library.js', '.library']) {
    try { t += fs.readFileSync(path.join(base, f), 'utf8'); } catch { /* absent */ }
  }
  return (libTextCache[lib] = t);
}
function inOpenUI5(entity) {
  return !!OPENUI5_CONTROLS[entity] || EXTRA_ENTITIES.has(entity);
}
// source probe — used ONLY to build/verify ui5/openui5-entities.json, never to
// decide a flag directly (that would reintroduce the environment dependence)
function probeOpenUI5(entity) {
  const rel = entity.replace(/\./g, '/') + '.js';
  const wordRe = new RegExp('\\b' + entity.split('.').pop() + '\\b');
  return OPENUI5_LIBS.some((lib) =>
    fs.existsSync(path.join(OPENUI5_PKG, lib, 'src', rel)) || wordRe.test(libText(lib)));
}

// The list holds only entities that ui5/properties.json does NOT carry, so an
// entry can also fall out because the property snapshot grew to cover it -
// "no longer needed here" does not mean OpenUI5 dropped the control.
// --update-entities rebuilds the snapshot from the installed @openui5 sources;
// a plain run with node_modules present cross-checks the snapshot instead and
// fails when it is stale, so the committed verdicts can never silently drift
// from the sources they were derived from.
{
  const metaEntities = new Set();
  for (const mf of fs.readdirSync(META)) {
    if (!mf.endsWith('.json')) continue;
    const e = JSON.parse(fs.readFileSync(path.join(META, mf), 'utf8')).entity;
    if (e) metaEntities.add(e);
  }
  const UPDATE_ENTITIES = process.argv.includes('--update-entities');
  if (UPDATE_ENTITIES && !OPENUI5_LIBS.length) {
    console.error('--update-entities needs the installed @openui5 packages (run npm ci first).');
    process.exit(1);
  }
  if (OPENUI5_LIBS.length) {
    const probed = [...metaEntities]
      .filter((e) => !OPENUI5_CONTROLS[e] && probeOpenUI5(e))
      .sort();
    if (UPDATE_ENTITIES) {
      const note =
        'OpenUI5 entities with no ui5/properties.json entry (statics/helpers, sap.ui.model ' +
        'types, CSS-class doc entities). Read by generate-overview.mjs so the ui5_only flag ' +
        'is deterministic without node_modules. Never hand-edit - rebuild with: ' +
        'node scripts/generate-overview.mjs --update-entities';
      fs.writeFileSync(ENTITIES_FILE, JSON.stringify({ note, entities: probed }, null, 2) + '\n');
      EXTRA_ENTITIES.clear();
      for (const e of probed) EXTRA_ENTITIES.add(e);
      console.log(`openui5-entities.json: ${probed.length} entities`);
    } else {
      const missing = probed.filter((e) => !EXTRA_ENTITIES.has(e));
      const gone = [...EXTRA_ENTITIES].filter((e) => metaEntities.has(e) && !probed.includes(e));
      if (missing.length || gone.length) {
        console.error(
          `ui5/openui5-entities.json is stale (missing: ${missing.join(', ') || '-'}; ` +
            `no longer needed here: ${gone.join(', ') || '-'}) - ` +
            'rebuild with: node scripts/generate-overview.mjs --update-entities'
        );
        process.exit(1);
      }
    }
  }
}
// compare dotted UI5 versions ("1.86" > "1.77"); '' (unknown / since forever) is lowest
const verCmp = (a, b) => {
  const pa = String(a).split('.').map(Number), pb = String(b).split('.').map(Number);
  for (let i = 0; i < Math.max(pa.length, pb.length); i++) {
    const d = (pa[i] || 0) - (pb[i] || 0);
    if (d) return d;
  }
  return 0;
};
const verMax = (a, b) => (!a ? b : !b ? a : verCmp(a, b) >= 0 ? a : b);

// collect ported apps: control (entity), module (library), sample name, class,
// and the repo-relative path of the generated class (for the ABAP GitHub link)
const apps = [];
const DEV_LABEL = { IMPROVISED: 'IMPROVISED', POST_171: 'POST-1.71', LIVE_TEST: 'LIVE-TEST', DROPPED_171: '1.71', SUBSET_DATA: 'SUBSET', NOTE: 'NOTE' };
for (const mf of fs.readdirSync(META)) {
  if (!mf.endsWith('.json')) continue;
  const m = JSON.parse(fs.readFileSync(path.join(META, mf), 'utf8'));
  const i = m.sample.indexOf('.sample.');
  if (i === -1) continue;
  const module = m.sample.slice(0, i);
  const name = m.sample.slice(i + '.sample.'.length);
  const u = uniMap.get(`${module}|${name}`) || {};
  const dep = u.deprecated || null;
  // the rating (1-5) is computed further down, once the audit flags are known.
  const devs = m.deviations || [];
  const nImpr = devs.filter((d) => d.type === 'IMPROVISED').length;
  const nDrop = devs.filter((d) => d.type === 'DROPPED_171').length;
  const nSub = devs.filter((d) => d.type === 'SUBSET_DATA').length;
  const nNote = devs.filter((d) => d.type === 'NOTE').length;
  const nLive = devs.filter((d) => d.type === 'LIVE_TEST').length;
  // the "Since" column shows the CONTROL's own since (next to Control). The
  // sample's required release is no longer a column of its own (dropped
  // 2026-07-29) but is still computed here: it drives the is_post171 flag behind
  // the Hide-newer-than-1.71 filter. It = the control since raised by any
  // post-1.71 member the port keeps (POST_171 deviations note "since X.YZ").
  const since = u.since || '';
  let release = since;
  // the highest version mentioned across ALL the port's POST_171 deviation texts
  // (every kept newer-than-1.71 member notes its @since). Take every X.Y(.Z)
  // token, not just "since X.Y" - the texts phrase it many ways
  // ("since UI5 1.84", "(since 1.97)", ">= 1.74", "OneByOne / TwoByOne (1.71)").
  for (const d of devs.filter((x) => x.type === 'POST_171')) {
    for (const mm of d.what.matchAll(/\b(\d+\.\d+(?:\.\d+)?)\b/g)) release = verMax(release, mm[1]);
  }
  // a since value is coloured orange when it is newer than UI5 1.71
  const overOneSeven = (v) => v !== '' && verCmp(v, '1.71') > 0;
  const ui5Only = !inOpenUI5(m.entity);
  const isDeprecated = !!dep;
  // "newer than 1.71 (2020)": the sample needs a release above 1.71 - either a
  // parsed release > 1.71, or (by definition) any kept POST_171 member, even when
  // its deviation text carries no explicit "since X.YZ"
  const nP171 = devs.filter((d) => d.type === 'POST_171').length;
  const isPost171 = nP171 > 0 || overOneSeven(release);
  // audit flags - which framework wiring the port actually uses, read straight
  // from its ABAP source. They no longer have a column of their own (the Audit
  // column was dropped 2026-07-29); they feed the Rating's test-priority term.
  // _event_client / follow_up_action t_arg is detected as a t_arg keyword before
  // the call's first ")" (val/view args carry no ")", so this is reliable here).
  // "literal binding" = a binding path written by name in clear text ({FIELD} or
  // {/Path}, or a path:'name' inside a { } template) instead of via client->_bind,
  // which is what breaks on a variable rename.
  const srcPath = path.join(ROOT, m.file);
  const src = fs.existsSync(srcPath) ? fs.readFileSync(srcPath, 'utf8') : '';
  const srcNoBind = src.replace(/\{\s*client->_bind[\s\S]*?\}/g, '');
  const useEc      = /_event_client\s*\(/.test(src);
  const useEcArg   = /_event_client\s*\([^)]*\bt_arg\b/.test(src);
  const useFua     = /follow_up_action\s*\(/.test(src);
  const useFuaArg  = /follow_up_action\s*\([^)]*\bt_arg\b/.test(src);
  const usePopup   = /popup_display\s*\(/.test(src);
  const usePopover = /popover_display\s*\(/.test(src);
  const useName    = /\{[A-Z][A-Z0-9_]*\}/.test(src)
                  || /\{\/[A-Za-z]/.test(src)
                  || /\bpath\s*:\s*'[A-Za-z/]/.test(srcNoBind);

  // rating (1-5): a "by feel" score for how much attention a port deserves -
  // NOT a strict deviation count. Four things push it up (all additive):
  //   * complexity    - a big view / rich interaction is simply more to get right
  //   * rework        - every non-1:1 substitution (IMPROVISED / DROPPED_171 /
  //                     SUBSET_DATA) or documented subtlety (NOTE) is something
  //                     we had to correct or reason about
  //   * discussed     - a port we reviewed together (it carries a `checked` block)
  //                     earned a closer look, so it weighs a little more
  //   * test-priority - pending LIVE_TESTs, roundtrip-free/runtime-only wiring,
  //                     popups/popovers and a needs-newer-than-1.71 render are all
  //                     reasons to re-verify it in a running system
  // A faithful, simple, untouched static port stays at 1; a large, reworked,
  // much-discussed, live-test-pending port reaches 5. Sort descending to surface
  // the ports worth a closer manual look. Kept in sync with STATUS.md / AGENTS.md.
  const loc = src ? src.split('\n').length : 0;
  const nInteract = (src.match(/_event(_client)?\s*\(|follow_up_action\s*\(/g) || []).length;
  const nControls = (src.match(/->\s*(open|leaf)\s*\(/g) || []).length;
  const discussed = !!m.checked;
  const cxComplexity =
      (loc > 220 ? 1 : loc > 120 ? 0.6 : loc > 60 ? 0.3 : 0) +
      (nInteract >= 8 ? 0.7 : nInteract >= 3 ? 0.4 : nInteract >= 1 ? 0.2 : 0) +
      (nControls > 45 ? 0.3 : 0);
  const cxRework = 1.0 * nImpr + 1.0 * nDrop + 0.5 * nSub + 0.3 * nNote;
  const cxDiscussed = discussed ? 0.5 : 0;
  const cxTest =
      0.6 * nLive +
      ((useEc || useFua) ? 0.4 : 0) +
      ((usePopup || usePopover) ? 0.3 : 0) +
      (isPost171 ? 0.3 : 0);
  const rawScore = cxComplexity + cxRework + cxDiscussed + cxTest;
  const score = Math.min(5, Math.max(1, Math.round(1 + rawScore)));
  const scoreDrivers = [];
  if (cxComplexity >= 0.5) scoreDrivers.push('complex');
  if (cxRework >= 1) scoreDrivers.push(`${nImpr + nDrop + nSub} reworked`);
  else if (nNote) scoreDrivers.push(`${nNote} noted`);
  if (discussed) scoreDrivers.push('reviewed');
  if (cxTest >= 0.6) scoreDrivers.push('live-test');
  const scoreTip = `Rating ${score} of 5 - how much attention this port deserves ` +
    `(complexity + rework + review + test-priority${scoreDrivers.length ? ': ' + scoreDrivers.join(', ') : ''}). ` +
    `1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`;

  apps.push({
    module,
    control: m.entity,
    name,
    cls: m.class,
    file: m.file,
    checked: m.checked ? `CHECKED (${m.checked.date}): ${m.checked.note}` : '',
    notes: (m.deviations || []).map((d) => `${DEV_LABEL[d.type] ?? d.type}: ${d.what}`).join(' // '),
    post171: (m.deviations || []).filter((d) => d.type === 'POST_171').map((d) => d.what).join(' // '),
    since,
    since_post171: overOneSeven(since),
    dep_text: dep ? `Deprecated since ${dep.since}: ${dep.text}` : '',
    score,
    score_tip: scoreTip,
    ui5_only: ui5Only,
    is_post171: isPost171,
    is_deprecated: isDeprecated,
  });
}
// order by module, then control, then sample name (case-insensitive)
apps.sort((a, b) =>
  a.module.toLowerCase().localeCompare(b.module.toLowerCase()) ||
  a.control.toLowerCase().localeCompare(b.control.toLowerCase()) ||
  a.name.toLowerCase().localeCompare(b.name.toLowerCase()));

// aligned VALUE #( ) rows — only the generation-time facts; the URLs are built
// at runtime in view_display (the abap2UI5 start URL needs the system origin)
const w = (k) => Math.max(...apps.map((a) => a[k].length));
const wm = w('module'), wc = w('control'), wn = w('name'), wl = w('cls'), wf = w('file');
// render a string as ABAP backtick literals, splitting long text to stay < 255 cols
const abapParts = (s) => {
  const q = (x) => '`' + x + '`';
  const esc = s.replace(/`/g, '``');
  if (esc.length <= 200) return [q(esc)];
  const parts = [];
  let rest = esc;
  while (rest.length > 200) {
    let cut = rest.lastIndexOf(' ', 200);
    if (cut < 100) cut = 200;
    // never split a doubled backtick escape across two literals: if an odd
    // number of consecutive backticks ends at the cut, shift the cut past the pair
    let bt = 0;
    while (bt < cut && rest[cut - 1 - bt] === '`') bt++;
    if (bt % 2 === 1) cut++;
    parts.push(rest.slice(0, cut));
    rest = rest.slice(cut);
  }
  if (rest) parts.push(rest);
  return parts.map(q);
};
// the &&-joined literal chain as it appears inside a VALUE #( ) row
const abapStr = (s) => abapParts(s).join(' &&\n                 ');

// --- statement-size budgets (see the catalog emission block below) ---
// every emitted statement stays well under ABAP's maximum permitted statement
// length, in characters and in tokens
const CHUNK_CHARS = 3000;   // max source characters per VALUE #( ) statement
const CHUNK_ROWS = 6;       // max catalog rows per VALUE #( ) statement
const HOIST_CHARS = 900;    // a single field value longer than this is hoisted
const ASSIGN_CHARS = 1200;  // max source characters per hoisted-text statement

// a text too long to sit inside its row: assigned to a local variable in one or
// more `lv_textN = [lv_textN &&] `…` && `…`.` statements, each of bounded size
const hoistStatements = (name, parts) => {
  const groups = [];
  for (const p of parts) {
    const last = groups[groups.length - 1];
    if (!last || last.chars + p.length > ASSIGN_CHARS) groups.push({ parts: [p], chars: p.length });
    else { last.parts.push(p); last.chars += p.length; }
  }
  const indent = ' '.repeat(7 + name.length);
  return groups.map((g, i) =>
    `    ${name} = ${i === 0 ? '' : `${name} && `}${g.parts.join(` &&\n${indent}`)}.`);
};

const rows = apps.map((a) => {
  const base =
    `      ( module = \`${a.module}\`${' '.repeat(wm - a.module.length)}` +
    ` control = \`${a.control}\`${' '.repeat(wc - a.control.length)}` +
    ` name = \`${a.name}\`${' '.repeat(wn - a.name.length)}` +
    ` class = \`${a.cls}\`${' '.repeat(wl - a.cls.length)}` +
    ` path = \`${a.file}\`${' '.repeat(wf - a.file.length)}`;
  const extras = [];
  // long texts do not fit into the row's own statement - hoist them into
  // preceding lv_textN assignments and reference the variable in the row
  const prelude = [];
  let hoisted = 0;
  const text = (v) => {
    const parts = abapParts(v);
    const inline = parts.join(' &&\n                 ');
    if (inline.length <= HOIST_CHARS) return inline;
    const name = `lv_text${++hoisted}`;
    prelude.push(...hoistStatements(name, parts));
    return name;
  };
  extras.push(`score = ${a.score}`);
  extras.push(`score_tip = ${text(a.score_tip)}`);
  if (a.since) extras.push(`since = \`${a.since}\``);
  if (a.since_post171) extras.push('since_post171 = abap_true');
  if (a.ui5_only) extras.push('ui5_only = abap_true');
  if (a.is_post171) extras.push('is_post171 = abap_true');
  if (a.is_deprecated) extras.push('is_deprecated = abap_true');
  if (a.dep_text) extras.push(`dep_text = ${text(a.dep_text)}`);
  if (a.checked) extras.push(`checked = ${text(a.checked)}`);
  if (a.notes) extras.push(`notes = ${text(a.notes)}`);
  if (a.post171) extras.push(`post171 = ${text(a.post171)}`);
  const row = extras.length ? `${base}\n        ${extras.join('\n        ')} )` : `${base} )`;
  return { row, prelude, hoisted };
});

// --- catalog emission: one VALUE #( ) per size-bounded chunk ---
// A single VALUE #( ) holding every catalog row blows ABAP's maximum permitted
// statement length (the rows carry long notes/score_tip literals, so 246 rows
// are ~400 kB of source). Splitting the rows into a fixed number of parts does
// not hold - the catalog keeps growing and each part grows with it - so chunk
// by the actual emitted size instead: start a new statement as soon as the
// current one would exceed CHUNK_CHARS or CHUNK_ROWS. The first statement
// builds result, every following one appends via VALUE #( BASE result ).
// A row whose texts were hoisted gets a statement of its own, right behind its
// lv_textN assignments - the variables are reused by every later row, so no
// second row may sit in the same statement.
const chunks = [];
let open = null;
for (const r of rows) {
  if (r.prelude.length) {
    open = null;
    chunks.push({ prelude: r.prelude, rows: [r.row] });
    continue;
  }
  if (!open || open.rows.length >= CHUNK_ROWS || open.chars + r.row.length > CHUNK_CHARS) {
    open = { prelude: [], rows: [r.row], chars: r.row.length };
    chunks.push(open);
  } else {
    open.rows.push(r.row);
    open.chars += r.row.length;
  }
}
const catalogStatements = chunks
  .map((c, i) =>
    [...c.prelude, `    result = VALUE #(${i === 0 ? '' : ' BASE result'}\n${c.rows.join('\n')} ).`].join('\n'))
  .join('\n\n');
// the hoist variables, declared once at the top of get_catalog (definitions_top)
const maxHoist = Math.max(0, ...rows.map((r) => r.hoisted));
const catalogDecl = Array.from({ length: maxHoist }, (_, i) => `    DATA lv_text${i + 1} TYPE string.`).join('\n');

// --- client-side (roundtrip-free) filter & sort, both via cs_event-binding_call
// wired through _event_client (see abap2UI5 z2ui5_if_client / FrontendAction.js):
// the value/direction is resolved on the frontend, the model stays untouched. ---
const ID_TABLE = 'idOverviewTable';
// a Contains filter on the FILTER blob column; valExpr is a client-resolved
// $-expression (the search field's newValue/query). Empty value clears it.
const filterCall = (valExpr) =>
  'client->_event_client( val = client->cs_event-binding_call' +
  ` t_arg = VALUE #( ( \`${ID_TABLE}\` ) ( \`items\` ) ( \`filter\` ) ( \`FILTER\` ) ( \`Contains\` ) ( \`${valExpr}\` ) ) )`;
// a Sorter on one column path; descending passes the string `X` (the framework
// reads this positional t_arg element as an abap_bool - X/space), ascending omits
// it. t_arg is a STRING_TABLE, so the element must be a string literal, not the
// char-typed abap_true (`abap_true` and a string row are incompatible under the
// strict ABAP syntax check).
const sortCall = (path, desc) =>
  'client->_event_client( val = client->cs_event-binding_call' +
  ` t_arg = VALUE #( ( \`${ID_TABLE}\` ) ( \`items\` ) ( \`sort\` ) ( \`${path}\` )${desc ? ' ( `X` )' : ''} ) )`;

// a sortable column: header label + ascending/descending sort icons (client-side)
const sortableColumn = (label, path) => `                        )->open( \`Column\`
                            )->open( \`HBox\`
                                )->a( n = \`alignItems\` v = \`Center\`

                                )->leaf( \`Text\`
                                    )->a( n = \`text\` v = \`${label}\`
                                )->leaf( \`core:Icon\`
                                    )->a( n = \`src\`     v = \`sap-icon://sort-ascending\`
                                    )->a( n = \`tooltip\` v = \`Sort by ${label} ascending\`
                                    )->a( n = \`class\`   v = \`sapUiTinyMarginBegin\`
                                    )->a( n = \`press\`   v = ${sortCall(path, false)}
                                )->leaf( \`core:Icon\`
                                    )->a( n = \`src\`     v = \`sap-icon://sort-descending\`
                                    )->a( n = \`tooltip\` v = \`Sort by ${label} descending\`
                                    )->a( n = \`press\`   v = ${sortCall(path, true)}

                            )->shut(
                        )->shut(`;
// a plain (non-sortable) column: header label only, plus optional Column attrs
const plainColumn = (label, attrs = []) => {
  const attrLines = attrs.map(([n, v]) => `                            )->a( n = \`${n}\` v = \`${v}\``).join('\n');
  const head = attrs.length
    ? `                        )->open( \`Column\`\n${attrLines}\n\n                            )->leaf( \`Text\``
    : `                        )->open( \`Column\`\n                            )->leaf( \`Text\``;
  return `${head}\n                                )->a( n = \`text\` v = \`${label}\`\n\n                        )->shut(`;
};
// column order (mirrored 1:1 by the cells below): Since sits after Control,
// Version + Open are the trailing non-sortable columns
const columnsBlock = [
  sortableColumn('Module', 'MODULE'),
  sortableColumn('Control', 'CTRL_NAME'),
  sortableColumn('Since', 'SINCE'),
  sortableColumn('Sample', 'NAME'),
  sortableColumn('abap2UI5', 'CLASS'),
  sortableColumn('Rating', 'SCORE'),
  plainColumn('Open', [['width', '9rem'], ['hAlign', 'Center']]),
].join('\n');

const abap = `"! Generated overview app - lists every abap2UI5 api sample app in a table.
"! The search field filters the table on the client (binding_call Contains, no
"! round-trip); its query is two-way bound (search_query), so it survives a
"! round-trip or an app state restore (draft) and view_display re-applies the
"! filter via follow_up_action.
"! The title carries the ported-app count in parentheses. The sortable Since
"! column (next to Control) shows the UI5 release the CONTROL appeared in (from
"! ui5/universe.json; blank when older than tracking / since forever). It is
"! coloured orange (ObjectStatus Warning) when newer than UI5 1.71; a deprecated
"! control's name is struck through (FormattedText htmlText, so the strikethrough
"! can vary per row). There is no per-SAMPLE Since column - whether a sample needs
"! a release newer than 1.71 is carried by the Hide-newer-than-1.71 filter and
"! spelled out in the Open column's info popover.
"! Three header checkboxes (default all on) filter the table
"! entirely on the client via each row's visible expression: Hide non-OpenUI5,
"! Hide newer than 1.71 (2020), Hide deprecated (the ui5_only flag behind the
"! first one has no column of its own - the badge column was dropped 2026-07-29).
"! A Shell switch toggles the
"! sap.m.Shell letterboxing (appWidthLimited), client-side. Navigation lives in
"! the trailing Open column, which carries three buttons, each anchored to its
"! own runtime id. The chain-link one opens the LINKS popover: four full-width
"! Transparent Buttons - Control API Reference, Sample Link, Sample Source Code,
"! abap2UI5 Source Code, each opening its target in a new tab through the
"! URLHELPER REDIRECT frontend action (a Button carries no href, and open_new_tab
"! is same-origin only). The second starts
"! this abap2UI5 app directly in a new tab (open_new_tab; the start URL is
"! same-origin, so it passes isValidRedirectURL) - the overview stays open in its
"! own tab. The trailing information one opens the INFO popover with the
"! port's generation notes - live-check status, the members that need a release
"! newer than 1.71, and the deviation list as a bullet list; it renders only on a
"! row that carries at least one of the three.
"! The Rating column is a 1-5 "by feel" score of
"! how much attention a port deserves (not coloured): app complexity, how heavily
"! it was reworked/corrected (IMPROVISED/DROPPED_171/SUBSET_DATA/NOTE), whether it
"! was reviewed/discussed (it carries a checked block), and how important a live
"! re-test is (pending LIVE_TESTs, roundtrip-free wiring, popups, needs-newer-UI5);
"! 1 = simple faithful 1:1, 5 = complex/reworked/worth a close look. Sort it
"! descending to surface the samples worth a closer manual look.
"! Both popovers are backend round-trips, but the row's press carries only its
"! CLASS: the generation notes, the live-check text and the four reference URLs
"! are looked up from the catalog in on_event, so they never enter the bound
"! model. Only bound columns are public state, which keeps the persisted draft
"! (and the model JSON of every render) small - the in-browser demo re-parses
"! that draft on every round-trip.
"! The search field above the table filters all rows by a
"! substring over the text columns (module, control, since, sample,
"! class) only, and each sortable column header carries ascending/
"! descending sort icons - both run entirely on the frontend
"! (cs_event-binding_call via _event_client, no server round-trip). Do not edit
"! by hand - regenerate with scripts/generate-overview.mjs
CLASS ${CLASS} DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the BOUND row - only what the table renders, sorts or filters on. Every
    " public attribute is part of the app state the framework persists as a
    " draft and re-parses on the next round-trip, so the heavy per-port text
    " (generation notes, live-check note, the four reference URLs) is
    " deliberately NOT here: it is looked up server-side from the catalog when
    " a popover asks for it (see on_event). Keeping it in the model made the
    " draft ~578 kB and every round-trip of the transpiled in-browser demo took
    " ~30 s in the XML parse (which is quadratic there); the split brings the
    " draft to ~199 kB and the round-trip to ~3-4 s on the same machine.
    TYPES:
      BEGIN OF ty_s_row,
        module    TYPE string,
        ctrl_name TYPE string,
        name      TYPE string,
        class     TYPE string,
        start_url TYPE string,
        has_check TYPE abap_bool,
        has_notes TYPE abap_bool,
        has_p171  TYPE abap_bool,
        since         TYPE string,
        since_post171 TYPE abap_bool,
        ui5_only      TYPE abap_bool,
        is_post171    TYPE abap_bool,
        is_deprecated TYPE abap_bool,
        dep_text  TYPE string,
        ctrl_html TYPE string,
        score       TYPE i,
        score_tip   TYPE string,
        filter    TYPE string,
      END OF ty_s_row.
    TYPES ty_t_row TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

    DATA t_app TYPE ty_t_row.
    " the search field's text (two-way, so it survives a round-trip and the
    " draft): the filter itself runs on the client, but only a value that is
    " part of the MODEL comes back when the app is restored. view_display
    " re-applies the filter for a non-initial query via follow_up_action.
    DATA search_query TYPE string.
    " sap.m.Shell letterboxing toggle (two-way, drives Shell appWidthLimited)
    DATA shell_on  TYPE abap_bool.
    " header filter checkboxes (two-way; each row's visible expression binding
    " hides it when the matching flag is set and the row carries that trait)
    DATA hide_non_ui5   TYPE abap_bool.
    DATA hide_post171   TYPE abap_bool.
    DATA hide_deprecated TYPE abap_bool.

  PROTECTED SECTION.
    " the full catalog row - the generated facts plus everything derived from
    " them. It lives only in local variables (get_catalog is a METHOD, never an
    " attribute), so none of it reaches the persisted app state.
    TYPES:
      BEGIN OF ty_s_app,
        module    TYPE string,
        control   TYPE string,
        ctrl_name TYPE string,
        name      TYPE string,
        class     TYPE string,
        path      TYPE string,
        api_url   TYPE string,
        js_url    TYPE string,
        ui5_url   TYPE string,
        abap_url  TYPE string,
        start_url TYPE string,
        checked   TYPE string,
        has_check TYPE abap_bool,
        notes     TYPE string,
        has_notes TYPE abap_bool,
        post171   TYPE string,
        has_p171  TYPE abap_bool,
        since         TYPE string,
        since_post171 TYPE abap_bool,
        ui5_only      TYPE abap_bool,
        is_post171    TYPE abap_bool,
        is_deprecated TYPE abap_bool,
        dep_text  TYPE string,
        ctrl_html TYPE string,
        score       TYPE i,
        score_tip   TYPE string,
        filter    TYPE string,
      END OF ty_s_app.
    TYPES ty_t_app TYPE STANDARD TABLE OF ty_s_app WITH EMPTY KEY.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS row_of
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE ty_s_app.
    METHODS derive
      CHANGING
        app TYPE ty_s_app.
    METHODS get_catalog
      RETURNING
        VALUE(result) TYPE ty_t_app.
    METHODS link_press
      IMPORTING
        url           TYPE string
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS ${CLASS} IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      " default filtering (all on) + Shell on, set once so later round-trips keep
      " whatever the user toggled (the flags are two-way bound)
      shell_on        = abap_true.
      hide_non_ui5    = abap_true.
      hide_post171    = abap_true.
      hide_deprecated = abap_true.
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN \`LINKS\`.
        " the four link buttons for the pressed row, opened in a popover
        " anchored to the button (arg 2). Only the row KEY travels through the
        " client (arg 1, \`\${CLASS}\`) - the URLs are rebuilt here from the
        " catalog, so they never sit in the bound model and never bloat the draft.
        DATA(ls_link) = row_of( client->get_event_arg( ) ).
        DATA(lv_api)  = ls_link-api_url.
        DATA(lv_js)   = ls_link-js_url.
        DATA(lv_ui5)  = ls_link-ui5_url.
        DATA(lv_abap) = ls_link-abap_url.

        DATA(links) = z2ui5_cl_ai_xml=>factory( ).
        DATA(box) = links->open( n = \`FragmentDefinition\` ns = \`core\`
            )->a( n = \`xmlns\`      v = \`sap.m\`
            )->a( n = \`xmlns:core\` v = \`sap.ui.core\`

            )->open( \`Popover\`
                )->a( n = \`title\`        v = \`Links\`
                )->a( n = \`placement\`    v = \`Auto\`
                )->a( n = \`contentWidth\` v = \`26rem\`

                )->open( \`VBox\`
                    )->a( n = \`class\` v = \`sapUiContentPadding\` ).

        " One full-width Transparent Button per target, stacked in the VBox. A
        " Button cannot carry an href, and cs_event-open_new_tab is same-origin
        " only (isValidRedirectURL), so the press goes through the URLHELPER
        " REDIRECT frontend action with { URL, NEW_WINDOW: true } - the same
        " new-tab behaviour a Link target="_blank" had, client-side and with no
        " round-trip. The URL is also the tooltip, so it stays readable/copyable.
        " The three OpenUI5 targets are empty for a ui5_only row (the control is
        " not in the OpenUI5 checkout), so each renders only when it resolves.
        IF lv_api IS NOT INITIAL.
          box->leaf( \`Button\`
              )->a( n = \`text\`    v = \`Control API Reference\`
              )->a( n = \`icon\`    v = \`sap-icon://document-text\`
              )->a( n = \`type\`    v = \`Transparent\`
              )->a( n = \`width\`   v = \`100%\`
              )->a( n = \`tooltip\` v = lv_api
              )->a( n = \`class\`   v = \`sapUiTinyMarginBottom\`
              )->a( n = \`press\`   v = link_press( lv_api ) ).
        ENDIF.
        IF lv_ui5 IS NOT INITIAL.
          box->leaf( \`Button\`
              )->a( n = \`text\`    v = \`Sample Link\`
              )->a( n = \`icon\`    v = \`sap-icon://sys-monitor\`
              )->a( n = \`type\`    v = \`Transparent\`
              )->a( n = \`width\`   v = \`100%\`
              )->a( n = \`tooltip\` v = lv_ui5
              )->a( n = \`class\`   v = \`sapUiTinyMarginBottom\`
              )->a( n = \`press\`   v = link_press( lv_ui5 ) ).
        ENDIF.
        IF lv_js IS NOT INITIAL.
          box->leaf( \`Button\`
              )->a( n = \`text\`    v = \`Sample Source Code\`
              )->a( n = \`icon\`    v = \`sap-icon://source-code\`
              )->a( n = \`type\`    v = \`Transparent\`
              )->a( n = \`width\`   v = \`100%\`
              )->a( n = \`tooltip\` v = lv_js
              )->a( n = \`class\`   v = \`sapUiTinyMarginBottom\`
              )->a( n = \`press\`   v = link_press( lv_js ) ).
        ENDIF.
        box->leaf( \`Button\`
            )->a( n = \`text\`    v = \`abap2UI5 Source Code\`
            )->a( n = \`icon\`    v = \`sap-icon://syntax\`
            )->a( n = \`type\`    v = \`Transparent\`
            )->a( n = \`width\`   v = \`100%\`
            )->a( n = \`tooltip\` v = lv_abap
            )->a( n = \`press\`   v = link_press( lv_abap ) ).

        " say why the reference links are missing rather than leaving a gap
        IF lv_api IS INITIAL.
          box->leaf( \`MessageStrip\`
              )->a( n = \`text\`      v = \`This control is in no OpenUI5 checkout, so this sample has no Control API Reference, Sample Link or Sample Source Code.\`
              )->a( n = \`type\`      v = \`Information\`
              )->a( n = \`showIcon\`  v = \`true\`
              )->a( n = \`class\`     v = \`sapUiSmallMarginTop\` ).
        ENDIF.

        client->popover_display( xml   = links->stringify( )
                                 by_id = client->get_event_arg( 2 ) ).

      WHEN \`INFO\`.
        " everything the generator knows ABOUT the port (as opposed to where it
        " points): the live-check status, the members that need a UI5 release
        " newer than 1.71, and the deviation notes. Own popover behind the info
        " button, anchored to it (arg 2); the button only renders on a row that
        " carries at least one of the three. Like LINKS, only the row key
        " travels (arg 1) - the texts are read from the catalog here.
        DATA(ls_info)    = row_of( client->get_event_arg( ) ).
        DATA(lv_checked) = ls_info-checked.
        DATA(lv_post171) = ls_info-post171.
        DATA(lv_notes)   = ls_info-notes.

        DATA(info) = z2ui5_cl_ai_xml=>factory( ).
        DATA(ibox) = info->open( n = \`FragmentDefinition\` ns = \`core\`
            )->a( n = \`xmlns\`      v = \`sap.m\`
            )->a( n = \`xmlns:core\` v = \`sap.ui.core\`

            )->open( \`Popover\`
                )->a( n = \`title\`        v = \`Generation notes\`
                )->a( n = \`placement\`    v = \`Auto\`
                )->a( n = \`contentWidth\` v = \`30rem\`

                )->open( \`VBox\`
                    )->a( n = \`class\` v = \`sapUiContentPadding\` ).

        IF lv_checked IS NOT INITIAL.
          ibox->leaf( \`ObjectStatus\`
              )->a( n = \`text\`  v = lv_checked
              )->a( n = \`state\` v = \`Success\` ).
        ENDIF.

        IF lv_post171 IS NOT INITIAL.
          ibox->leaf( \`ObjectStatus\`
              )->a( n = \`text\`  v = |Needs a UI5 release newer than 1.71: { lv_post171 }|
              )->a( n = \`state\` v = \`Warning\`
              )->a( n = \`class\` v = \`sapUiTinyMarginTop\` ).
        ENDIF.

        IF lv_notes IS NOT INITIAL.
          " render the notes as an HTML bullet list (FormattedText): each
          " \` // \`-separated bullet becomes one <li> with its leading LABEL
          " (NOTE / IMPROVISED / POST-1.71 / ...) in bold. The note text is
          " HTML-escaped first (it can contain <, >, & - e.g. id="x", a<b, or a
          " literal <strong> mention); the builder's xml_escape escapes it a
          " second time and UI5 un-escapes once, so FormattedText shows it verbatim.
          SPLIT lv_notes AT \` // \` INTO TABLE DATA(lt_line).
          DATA(lv_html) = \`<ul>\`.
          LOOP AT lt_line INTO DATA(lv_line).
            DATA(lv_esc) = lv_line.
            REPLACE ALL OCCURRENCES OF \`&\` IN lv_esc WITH \`&amp;\`.
            REPLACE ALL OCCURRENCES OF \`<\` IN lv_esc WITH \`&lt;\`.
            REPLACE ALL OCCURRENCES OF \`>\` IN lv_esc WITH \`&gt;\`.
            DATA(lv_col) = find( val = lv_esc sub = \`:\` ).
            IF lv_col > 0.
              lv_html = |{ lv_html }<li><strong>{ substring( val = lv_esc len = lv_col + 1 ) }</strong>{ substring( val = lv_esc off = lv_col + 1 ) }</li>|.
            ELSE.
              lv_html = |{ lv_html }<li>{ lv_esc }</li>|.
            ENDIF.
          ENDLOOP.
          lv_html = |{ lv_html }</ul>|.
          ibox->leaf( \`FormattedText\`
              )->a( n = \`htmlText\` v = lv_html ).
        ENDIF.

        client->popover_display( xml   = info->stringify( )
                                 by_id = client->get_event_arg( 2 ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD row_of.

    " the catalog row behind a pressed table row, by its class name (the only
    " thing the press event carries). READ TABLE, not a table expression: the
    " 702 downport turns \`tab[ … ]\` into a raise the transpiled runtime maps to
    " an uncatchable ASSERT.
    DATA(catalog) = get_catalog( ).
    READ TABLE catalog INTO result WITH KEY class = val.
    IF sy-subrc <> 0.
      CLEAR result.
      RETURN.
    ENDIF.

    derive( CHANGING app = result ).

  ENDMETHOD.


  METHOD view_display.

    DATA(catalog) = get_catalog( ).
    CLEAR t_app.
    LOOP AT catalog ASSIGNING FIELD-SYMBOL(<app>).

      derive( CHANGING app = <app> ).

      " only the columns the table renders, sorts or filters on go into the
      " bound model - the notes, the live-check text and the four URLs stay in
      " the catalog and are fetched per row in on_event (see ty_s_row)
      APPEND VALUE #( module        = <app>-module
                      ctrl_name     = <app>-ctrl_name
                      name          = <app>-name
                      class         = <app>-class
                      start_url     = <app>-start_url
                      has_check     = <app>-has_check
                      has_notes     = <app>-has_notes
                      has_p171      = <app>-has_p171
                      since         = <app>-since
                      since_post171 = <app>-since_post171
                      ui5_only      = <app>-ui5_only
                      is_post171    = <app>-is_post171
                      is_deprecated = <app>-is_deprecated
                      dep_text      = <app>-dep_text
                      ctrl_html     = <app>-ctrl_html
                      score         = <app>-score
                      score_tip     = <app>-score_tip
                      filter        = <app>-filter ) TO t_app.

    ENDLOOP.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = \`View\` ns = \`mvc\`
        )->a( n = \`xmlns\`      v = \`sap.m\`
        )->a( n = \`xmlns:mvc\`  v = \`sap.ui.core.mvc\`
        )->a( n = \`xmlns:core\` v = \`sap.ui.core\`

        )->open( \`Shell\`
            " Shell on/off = letterboxing (limited app width); two-way bound so the
            " header Switch toggles it live on the client
            )->a( n = \`appWidthLimited\` v = |\\{= !!\${ client->_bind( shell_on ) } \\}|
            )->open( \`Page\`
                )->a( n = \`title\`          v = |abap2UI5 Demo Kit (\{ lines( t_app ) \})|
                )->a( n = \`navButtonPress\` v = client->_event_nav_app_leave( )
                )->a( n = \`showNavButton\`  v = z2ui5_cl_ai_xml=>as_bool( client->check_app_prev_stack( ) )

                )->open( \`subHeader\`
                    )->open( \`OverflowToolbar\`
                        " client-side filter over the table: liveChange/search run
                        " a binding_call Contains filter via _event_client (no round-trip)
                        )->leaf( \`SearchField\`
                            )->a( n = \`placeholder\` v = \`Search the table - module, control, since, sample, class\`
                            )->a( n = \`width\`       v = \`24rem\`
                            " two-way bound so the typed query is part of the model and
                            " comes back with the app state (round-trip, draft restore);
                            " the filtering itself stays client-side (below)
                            )->a( n = \`value\`       v = client->_bind( search_query )
                            )->a( n = \`liveChange\`  v = ${filterCall('${$parameters>/newValue}')}
                            )->a( n = \`search\`      v = ${filterCall('${$parameters>/query}')}
                        " default-on filter checkboxes; each is two-way bound and the row
                        " visible expression reacts live (no round-trip)
                        )->leaf( \`CheckBox\`
                            )->a( n = \`text\`     v = \`Hide non-OpenUI5\`
                            )->a( n = \`selected\` v = client->_bind( hide_non_ui5 )
                            )->a( n = \`tooltip\`  v = \`Hide samples whose control is not part of OpenUI5\`
                        )->leaf( \`CheckBox\`
                            )->a( n = \`text\`     v = \`Hide newer than 1.71 (2020)\`
                            )->a( n = \`selected\` v = client->_bind( hide_post171 )
                            )->a( n = \`tooltip\`  v = \`Hide samples that need a UI5 release newer than 1.71\`
                        )->leaf( \`CheckBox\`
                            )->a( n = \`text\`     v = \`Hide deprecated\`
                            )->a( n = \`selected\` v = client->_bind( hide_deprecated )
                            )->a( n = \`tooltip\`  v = \`Hide samples whose control is deprecated\`
                        )->leaf( \`ToolbarSpacer\`
                        )->leaf( \`Label\`
                            )->a( n = \`text\` v = \`Shell\`
                        " Shell on/off = sap.m.Shell letterboxing (two-way, drives appWidthLimited)
                        )->leaf( \`Switch\`
                            )->a( n = \`state\`   v = client->_bind( shell_on )
                            )->a( n = \`tooltip\` v = \`Toggle the Shell letterboxing (limited app width)\`

                    )->shut(
                )->shut(

                )->open( \`Table\`
                    )->a( n = \`id\`      v = \`${ID_TABLE}\`
                    )->a( n = \`sticky\`  v = \`ColumnHeaders\`
                    )->a( n = \`items\`   v = client->_bind( t_app )

                    )->open( \`columns\`
${columnsBlock}
                    )->shut(

                    )->open( \`items\`
                        )->open( \`ColumnListItem\`
                            " header checkboxes filter the table entirely on the client: a
                            " row is hidden when a hide-flag (two-way bound model-root) is set
                            " AND the row carries that trait (UI5_ONLY / IS_POST171 /
                            " IS_DEPRECATED). Expression binding, re-evaluated live on toggle,
                            " no round-trip - like the Shell Switch.
                            )->a( n = \`visible\` v = |\\{= !(\${ client->_bind( hide_non_ui5 ) } && $\\{UI5_ONLY\\}) && !(\${ client->_bind( hide_post171 ) } && $\\{IS_POST171\\}) && !(\${ client->_bind( hide_deprecated ) } && $\\{IS_DEPRECATED\\}) \\}|
                            )->open( \`cells\`
                                )->leaf( \`Text\`
                                    )->a( n = \`text\` v = \`{MODULE}\`
                                " control name, struck through when deprecated (never
                                " coloured); FormattedText so the strikethrough can vary per row
                                )->leaf( \`FormattedText\`
                                    )->a( n = \`htmlText\` v = \`{CTRL_HTML}\`
                                    )->a( n = \`tooltip\`  v = \`{DEP_TEXT}\`
                                " Since: the release the control appeared in; coloured orange
                                " (Warning) when it is newer than UI5 1.71
                                )->leaf( \`ObjectStatus\`
                                    )->a( n = \`text\`    v = \`{SINCE}\`
                                    )->a( n = \`state\`   v = |\\{= $\\{SINCE_POST171\\} ? 'Warning' : 'None' \\}|
                                    )->a( n = \`tooltip\` v = \`{DEP_TEXT}\`
                                )->leaf( \`Text\`
                                    )->a( n = \`text\` v = \`{NAME}\`
                                )->leaf( \`Text\`
                                    )->a( n = \`text\` v = \`{CLASS}\`
                                " rating 1-5 (by feel): how much attention the port
                                " deserves - complexity, rework, review, test-priority
                                " (not coloured); tooltip lists the drivers
                                )->leaf( \`Text\`
                                    )->a( n = \`text\`    v = \`{SCORE} / 5\`
                                    )->a( n = \`tooltip\` v = \`{SCORE_TIP}\`

                                " Open column: three buttons, each anchored to its own runtime
                                " id (\$event.oSource.sId). First opens the links popover (the
                                " four reference targets); second launches the abap2UI5 app
                                " directly in a new tab (open_new_tab - the start URL is
                                " same-origin, so it passes isValidRedirectURL), leaving the
                                " overview open in its own tab; third opens the
                                " generation-notes popover - shown only on a row that HAS
                                " something to say (checked / post-1.71 / notes)
                                )->open( \`HBox\`
                                    )->leaf( \`Button\`
                                        )->a( n = \`icon\`    v = \`sap-icon://chain-link\`
                                        )->a( n = \`type\`    v = \`Transparent\`
                                        )->a( n = \`tooltip\` v = \`Links: Control API Reference, Sample Link, Sample Source Code, abap2UI5 Source Code\`
                                        " only the row KEY travels (the four URLs are rebuilt
                                        " server-side in on_event, so they stay out of the model
                                        " and out of the persisted draft), plus the button's own
                                        " runtime id as the popover anchor
                                        )->a( n = \`press\`   v = client->_event( val = \`LINKS\` t_arg = VALUE #(
                                            ( \`\${CLASS}\` ) ( \`\$event.oSource.sId\` ) ) )
                                    )->leaf( \`Button\`
                                        )->a( n = \`icon\`    v = \`sap-icon://action\`
                                        )->a( n = \`type\`    v = \`Transparent\`
                                        )->a( n = \`tooltip\` v = \`Start this abap2UI5 app in a new tab\`
                                        )->a( n = \`press\`   v = client->_event_client( val = client->cs_event-open_new_tab t_arg = VALUE #( ( \`\${START_URL}\` ) ) )
                                    )->leaf( \`Button\`
                                        )->a( n = \`icon\`    v = \`sap-icon://information\`
                                        )->a( n = \`type\`    v = \`Transparent\`
                                        )->a( n = \`tooltip\` v = \`Generation notes: how this port was built - live-check status, post-1.71 members, deviations\`
                                        " a backtick literal, not a |…| template: ABAP ends a string
                                        " template at the next |, so the expression binding's || would
                                        " close it mid-way. Nothing here needs interpolation anyway.
                                        )->a( n = \`visible\` v = \`{= \${HAS_CHECK} || \${HAS_P171} || \${HAS_NOTES} }\`
                                        )->a( n = \`press\`   v = client->_event( val = \`INFO\` t_arg = VALUE #(
                                            ( \`\${CLASS}\` ) ( \`\$event.oSource.sId\` ) ) )

                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut( ).

    client->view_display( view->stringify( ) ).

    " Re-apply the client-side table filter for a restored query. The filter is
    " a frontend-only binding operation (the model keeps all rows), so a rebuilt
    " view starts unfiltered - while the SearchField, being two-way bound, does
    " show the query again. follow_up_action runs the very same binding_call
    " after the view was rendered, so both are back in sync.
    IF search_query IS NOT INITIAL.
      client->follow_up_action( val   = client->cs_event-binding_call
                                t_arg = VALUE #( ( \`${ID_TABLE}\` ) ( \`items\` ) ( \`filter\` ) ( \`FILTER\` ) ( \`Contains\` ) ( search_query ) ) ).
    ENDIF.

  ENDMETHOD.


  METHOD derive.

    " everything a catalog row does not carry as a generated fact: the bare
    " control name, the four reference links, the start URL, the three
    " has-something flags, the control's display markup and the search blob.
    " Called per row when the table is built, and for the single row a popover
    " asks about (row_of) - so the links exist without living in the model.
    DATA(libpath) = replace( val = app-module
                             sub = \`.\`
                             with = \`/\`
                             occ = 0 ).

    " display only the bare control, without its namespace (sap.f.GridList -> GridList)
    DATA(dot) = find( val = app-control sub = \`.\` occ = -1 ).
    app-ctrl_name = COND #( WHEN dot >= 0 THEN substring( val = app-control off = dot + 1 ) ELSE app-control ).

    " the three reference links point into OpenUI5 - API reference, sample
    " source, live runner - so they only exist for a library OpenUI5 ships.
    " A ui5_only row (control not in the OpenUI5 checkout) has none of the
    " three there: leaving them built would hand out four links of which three
    " 404, and the commercial host is not an option (pattern-lint
    " commercial-ui5-host).
    " They stay empty and the popover renders only what resolves - the ABAP
    " class link is repository-local and always correct
    IF app-ui5_only = abap_false.
      app-api_url = |https://sdk.openui5.org/api/{ app-control }|.
      app-js_url  = |https://github.com/SAP/openui5/tree/master/src/{ app-module }| &&
                    |/test/{ libpath }/demokit/sample/{ app-name }|.
      app-ui5_url = |https://sdk.openui5.org/resources/sap/ui/documentation/sdk/index.html| &&
                    |?sap-ui-xx-sample-id={ app-module }.sample.{ app-name }| &&
                    |&sap-ui-xx-sample-lib={ app-module }|.
    ENDIF.
    app-abap_url  = |https://github.com/abap2UI5/ai-demokit/blob/main/{ app-path }|.
    app-start_url = |{ client->get( )-s_config-origin }{ client->get( )-s_config-pathname }| &&
                    |?app_start={ to_upper( app-class ) }|.
    app-has_check = xsdbool( app-checked IS NOT INITIAL ).
    app-has_notes = xsdbool( app-notes IS NOT INITIAL ).
    app-has_p171  = xsdbool( app-post171 IS NOT INITIAL ).

    " control name: struck through when the control is deprecated, otherwise
    " plain - never coloured (carried as FormattedText htmlText so the
    " strikethrough can vary per row); a plain control is rendered as-is
    app-ctrl_html = COND string(
        WHEN app-dep_text IS NOT INITIAL
        THEN |<span style="text-decoration:line-through">{ app-ctrl_name }</span>|
        ELSE app-ctrl_name ).

    " one blob per row, bound as the FILTER column that the table search's
    " client-side Contains filter (binding_call) matches against. Only the
    " VISIBLE text columns feed it - Module, Control (bare name), Since,
    " Sample, abap2UI5 (class) - so a query like "Date" no longer
    " matches hidden text buried in the notes/checked/post-1.71 fields
    app-filter = app-module && \` \` && app-ctrl_name && \` \` &&
                 app-since  && \` \` && app-name      && \` \` &&
                 app-class.

  ENDMETHOD.


  METHOD get_catalog.

    " A single VALUE #( ) holding every catalog row exceeds the maximum permitted
    " ABAP statement length, so the generator emits the catalog in size-bounded
    " chunks (a few rows each); every chunk after the first appends to the
    " previous ones via VALUE #( BASE result ). Texts too long to fit into their
    " own row are assigned to lv_textN just ahead of it - such a row is always
    " alone in its statement, because the next hoisting row reuses the variable.
${catalogDecl}

${catalogStatements}

  ENDMETHOD.


  METHOD link_press.

    " the press wire of the popover's four link buttons: open an EXTERNAL url in
    " a new tab, entirely on the client. cs_event-open_new_tab is same-origin
    " only (isValidRedirectURL) and three of the four targets live on
    " sdk.openui5.org / github.com, so the redirect goes through the URLHELPER
    " frontend action, whose REDIRECT takes a URL/NEW_WINDOW object-literal
    " t_arg - NEW_WINDOW true is what target="_blank" did on the former Links.
    result = client->_event_client( val   = client->cs_event-urlhelper
                                    t_arg = VALUE #( ( \`REDIRECT\` ) ( |\\{ URL: '{ url }', NEW_WINDOW: true \\}| ) ) ).

  ENDMETHOD.

ENDCLASS.
`;

const xml = `﻿<?xml version="1.0" encoding="utf-8"?>
<abapGit version="v1.0.0" serializer="LCL_OBJECT_CLAS" serializer_version="v1.0.0">
 <asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
  <asx:values>
   <VSEOCLASS>
    <CLSNAME>${CLASS.toUpperCase()}</CLSNAME>
    <LANGU>E</LANGU>
    <DESCRIPT>abap2UI5 - api overview</DESCRIPT>
    <STATE>1</STATE>
    <CLSCCINCL>X</CLSCCINCL>
    <FIXPT>X</FIXPT>
    <UNICODE>X</UNICODE>
   </VSEOCLASS>
  </asx:values>
 </asx:abap>
</abapGit>
`;

fs.writeFileSync(OUT_ABAP, abap);
fs.writeFileSync(OUT_XML, xml);
console.log(`${CLASS}: ${apps.length} apps across ${new Set(apps.map((a) => a.control)).size} controls`);
