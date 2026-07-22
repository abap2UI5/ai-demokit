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

// OpenUI5 membership oracle: a control/entity is in OpenUI5 if it is a known
// control (ui5/properties.json, the offline control catalog) OR has an OpenUI5
// source module in the installed @openui5 packages (catches helpers/statics like
// MessageBox/MessageToast/URLHelper that carry no @since members). Entities with
// neither (demo-kit-only patterns, CSS-class doc entities) are "not in OpenUI5".
// Resolved at generation time; the flags are baked into the generated class.
const OPENUI5_CONTROLS = (() => {
  try { return JSON.parse(fs.readFileSync(path.join(ROOT, 'ui5', 'properties.json'), 'utf8')).controls || {}; }
  catch { return {}; }
})();
const OPENUI5_PKG = path.join(ROOT, 'node_modules', '@openui5');
const OPENUI5_LIBS = fs.existsSync(OPENUI5_PKG) ? fs.readdirSync(OPENUI5_PKG) : [];
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
  if (OPENUI5_CONTROLS[entity]) return true;
  const rel = entity.replace(/\./g, '/') + '.js';
  const wordRe = new RegExp('\\b' + entity.split('.').pop() + '\\b');
  return OPENUI5_LIBS.some((lib) =>
    fs.existsSync(path.join(OPENUI5_PKG, lib, 'src', rel)) || wordRe.test(libText(lib)));
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
  // two "Since" columns: the control's own since (next to Control) and the
  // sample's required release (next to Sample). The sample release = the control
  // since raised by any post-1.71 member the port keeps (POST_171 deviations note
  // "since X.YZ"); it is only worth showing when it is HIGHER than the control's
  // own since (otherwise it just repeats it), so a same-or-lower value is blanked.
  const since = u.since || '';
  let release = since;
  // the sample's required release = the highest version mentioned across ALL its
  // POST_171 deviation texts (every kept newer-than-1.71 member notes its @since).
  // Take every X.Y(.Z) token, not just "since X.Y" - the texts phrase it many ways
  // ("since UI5 1.84", "(since 1.97)", ">= 1.74", "OneByOne / TwoByOne (1.71)").
  for (const d of devs.filter((x) => x.type === 'POST_171')) {
    for (const mm of d.what.matchAll(/\b(\d+\.\d+(?:\.\d+)?)\b/g)) release = verMax(release, mm[1]);
  }
  const releaseShown = (release !== '' && verCmp(release, since) > 0) ? release : '';
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
  // from its ABAP source (always shown as badges in the overview's Audit column).
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
  //   * discussed     - a port we reviewed together (a `checked` block, or golden)
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
  const discussed = !!m.checked || m.status === 'golden';
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
    golden: m.status === 'golden',
    since,
    since_post171: overOneSeven(since),
    dep_text: dep ? `Deprecated since ${dep.since}: ${dep.text}` : '',
    score,
    score_tip: scoreTip,
    release: releaseShown,
    release_post171: overOneSeven(releaseShown),
    ui5_only: ui5Only,
    is_post171: isPost171,
    is_deprecated: isDeprecated,
    use_ec: useEc,
    use_ec_arg: useEcArg,
    use_fua: useFua,
    use_fua_arg: useFuaArg,
    use_popup: usePopup,
    use_popover: usePopover,
    use_name: useName,
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
// render a string as an ABAP backtick literal, splitting long text with && to stay < 255 cols
const abapStr = (s) => {
  const q = (x) => '`' + x + '`';
  const esc = s.replace(/`/g, '``');
  if (esc.length <= 200) return q(esc);
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
  return parts.map(q).join(' &&\n                 ');
};
const rows = apps.map((a) => {
  const base =
    `      ( module = \`${a.module}\`${' '.repeat(wm - a.module.length)}` +
    ` control = \`${a.control}\`${' '.repeat(wc - a.control.length)}` +
    ` name = \`${a.name}\`${' '.repeat(wn - a.name.length)}` +
    ` class = \`${a.cls}\`${' '.repeat(wl - a.cls.length)}` +
    ` path = \`${a.file}\`${' '.repeat(wf - a.file.length)}`;
  const extras = [];
  extras.push(`score = ${a.score}`);
  extras.push(`score_tip = ${abapStr(a.score_tip)}`);
  if (a.golden) extras.push('golden = abap_true');
  if (a.since) extras.push(`since = \`${a.since}\``);
  if (a.since_post171) extras.push('since_post171 = abap_true');
  if (a.release) extras.push(`release = \`${a.release}\``);
  if (a.release_post171) extras.push('release_post171 = abap_true');
  if (a.ui5_only) extras.push('ui5_only = abap_true');
  if (a.is_post171) extras.push('is_post171 = abap_true');
  if (a.is_deprecated) extras.push('is_deprecated = abap_true');
  if (a.dep_text) extras.push(`dep_text = ${abapStr(a.dep_text)}`);
  if (a.checked) extras.push(`checked = ${abapStr(a.checked)}`);
  if (a.notes) extras.push(`notes = ${abapStr(a.notes)}`);
  if (a.post171) extras.push(`post171 = ${abapStr(a.post171)}`);
  if (a.use_ec) extras.push('use_ec = abap_true');
  if (a.use_ec_arg) extras.push('use_ec_arg = abap_true');
  if (a.use_fua) extras.push('use_fua = abap_true');
  if (a.use_fua_arg) extras.push('use_fua_arg = abap_true');
  if (a.use_popup) extras.push('use_popup = abap_true');
  if (a.use_popover) extras.push('use_popover = abap_true');
  if (a.use_name) extras.push('use_name = abap_true');
  return extras.length ? `${base}\n        ${extras.join('\n        ')} )` : `${base} )`;
});

// the Tree view's nested model is built in ABAP (build_tree) from the filtered
// app list, so the search filters the tree as well as the table.

// --- client-side (roundtrip-free) filter & sort, both via cs_event-binding_call
// wired through _event_client (see abap2UI5 z2ui5_if_client / FrontendAction.js):
// the value/direction is resolved on the frontend, the model stays untouched. ---
const ID_TABLE = 'idOverviewTable';
// a Contains filter on the FILTER blob column; valExpr is a client-resolved
// $-expression (the search field's newValue/query). Empty value clears it.
const filterCall = (valExpr) =>
  'client->_event_client( val = client->cs_event-binding_call' +
  ` t_arg = VALUE #( ( \`${ID_TABLE}\` ) ( \`items\` ) ( \`filter\` ) ( \`FILTER\` ) ( \`Contains\` ) ( \`${valExpr}\` ) ) )`;
// a Sorter on one column path; descending passes abap_true (the framework reads
// this positional t_arg element as an abap_bool - X/space), ascending omits it
const sortCall = (path, desc) =>
  'client->_event_client( val = client->cs_event-binding_call' +
  ` t_arg = VALUE #( ( \`${ID_TABLE}\` ) ( \`items\` ) ( \`sort\` ) ( \`${path}\` )${desc ? ' ( abap_true )' : ''} ) )`;

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
// Note + Open are the trailing non-sortable columns
const columnsBlock = [
  sortableColumn('Module', 'MODULE'),
  sortableColumn('Control', 'CTRL_NAME'),
  sortableColumn('Since', 'SINCE'),
  sortableColumn('Sample', 'NAME'),
  sortableColumn('Since', 'RELEASE'),
  sortableColumn('abap2UI5', 'CLASS'),
  plainColumn('Version', [['width', '6rem'], ['hAlign', 'Center']]),
  sortableColumn('Rating', 'SCORE'),
  plainColumn('Audit', [['width', '15rem']]),
  plainColumn('Open', [['width', '7rem'], ['hAlign', 'Center']]),
].join('\n');

const abap = `"! Generated overview app - lists every abap2UI5 api sample app in a table.
"! A Switch in the header toggles between the table and a module -> control ->
"! sample tree (sap.m.Tree, expanded by default) showing the same samples - both
"! views are bound and their visibility is an expression binding over the two-way
"! show_tree flag, so the toggle runs entirely on the client (no round-trip). The
"! search field filters the table on the client (binding_call Contains, no
"! round-trip); the tree is not filtered. Each tree leaf has the same jump
"! popover as the table's Open column.
"! The title carries the ported-app count in parentheses. There are two sortable
"! Since columns: the first (next to Control) shows the UI5 release the CONTROL
"! appeared in (from ui5/universe.json; blank when older than tracking / since
"! forever); the second (next to Sample) shows the direct release the whole SAMPLE
"! needs (control since raised by any kept post-1.71 member) and is shown only when
"! HIGHER than the control's own since. Both since values are coloured orange
"! (ObjectStatus Warning) when newer than UI5 1.71; a deprecated control's name is
"! struck through (FormattedText htmlText, so the strikethrough can vary per row).
"! The Version column badges rows whose control is not part of OpenUI5 with an
"! orange SAPUI5 status. Three header checkboxes (default all on) filter the table
"! entirely on the client via each row's visible expression: Hide non-OpenUI5,
"! Hide newer than 1.71 (2020), Hide deprecated. A Shell switch toggles the
"! sap.m.Shell letterboxing (appWidthLimited), a Tree view switch toggles table vs
"! tree - both client-side. Navigation lives in the trailing Open column, which
"! carries two buttons: the first opens an anchored popover with the four reference
"! links (OpenUI5 API, OpenUI5 source, live fullscreen sample, the generated ABAP
"! class on GitHub, each opening in a new tab) AND the port's generation info -
"! checked status, a post-1.71 note, and the generation notes; the second starts
"! this abap2UI5 app directly in a new tab (open_new_tab; the start URL is
"! same-origin). The same two buttons sit on every tree sample leaf (links only,
"! the tree model carries no info). The Rating column is a 1-5 "by feel" score of
"! how much attention a port deserves (not coloured): app complexity, how heavily
"! it was reworked/corrected (IMPROVISED/DROPPED_171/SUBSET_DATA/NOTE), whether it
"! was reviewed/discussed (a checked or golden port), and how important a live
"! re-test is (pending LIVE_TESTs, roundtrip-free wiring, popups, needs-newer-UI5);
"! 1 = simple faithful 1:1, 5 = complex/reworked/worth a close look. Sort it
"! descending to surface the samples worth a closer manual look. The Audit
"! column shows, always, one badge per framework-wiring fact the port uses (read
"! from its ABAP source): _event_client and its t_arg form, follow_up_action and
"! its t_arg form, whether it opens a Popup or Popover, and whether it binds a
"! path by literal name in clear text ({FIELD}/{/Path}) rather than via _bind.
"! The search field above the table filters all rows by a
"! substring over the text columns (module, control, since, sample, release,
"! class) only, and each sortable column header carries ascending/
"! descending sort icons - both run entirely on the frontend
"! (cs_event-binding_call via _event_client, no server round-trip). Do not edit
"! by hand - regenerate with scripts/generate-overview.mjs
CLASS ${CLASS} DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

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
        golden    TYPE abap_bool,
        since         TYPE string,
        since_post171 TYPE abap_bool,
        release       TYPE string,
        release_post171 TYPE abap_bool,
        ui5_only      TYPE abap_bool,
        is_post171    TYPE abap_bool,
        is_deprecated TYPE abap_bool,
        dep_text  TYPE string,
        ctrl_html TYPE string,
        score       TYPE i,
        score_tip   TYPE string,
        use_ec      TYPE abap_bool,
        use_ec_arg  TYPE abap_bool,
        use_fua     TYPE abap_bool,
        use_fua_arg TYPE abap_bool,
        use_popup   TYPE abap_bool,
        use_popover TYPE abap_bool,
        use_name    TYPE abap_bool,
        filter    TYPE string,
      END OF ty_s_app.
    TYPES ty_t_app TYPE STANDARD TABLE OF ty_s_app WITH EMPTY KEY.

    " nested tree model (module -> control -> sample); sap.m.Tree recurses on the
    " nodes tables. The sample leaves carry the same links as the table's Open column
    TYPES:
      BEGIN OF ty_s_sample,
        text      TYPE string,
        api_url   TYPE string,
        js_url    TYPE string,
        ui5_url   TYPE string,
        abap_url  TYPE string,
        start_url TYPE string,
        has_link  TYPE abap_bool,
      END OF ty_s_sample,
      BEGIN OF ty_s_control,
        text  TYPE string,
        nodes TYPE STANDARD TABLE OF ty_s_sample WITH EMPTY KEY,
      END OF ty_s_control,
      BEGIN OF ty_s_module,
        text  TYPE string,
        nodes TYPE STANDARD TABLE OF ty_s_control WITH EMPTY KEY,
      END OF ty_s_module.
    TYPES ty_t_tree TYPE STANDARD TABLE OF ty_s_module WITH EMPTY KEY.

    DATA t_app TYPE ty_t_app.
    DATA t_tree TYPE ty_t_tree.
    " table/tree toggle (drives the visible expression bindings)
    DATA show_tree TYPE abap_bool.
    " sap.m.Shell letterboxing toggle (two-way, drives Shell appWidthLimited)
    DATA shell_on  TYPE abap_bool.
    " header filter checkboxes (two-way; each row's visible expression binding
    " hides it when the matching flag is set and the row carries that trait)
    DATA hide_non_ui5   TYPE abap_bool.
    DATA hide_post171   TYPE abap_bool.
    DATA hide_deprecated TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS get_catalog
      RETURNING
        VALUE(result) TYPE ty_t_app.
    METHODS build_tree
      IMPORTING
        it_app        TYPE ty_t_app
      RETURNING
        VALUE(result) TYPE ty_t_tree.

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
        " the four reference links plus the port's generation info (checked /
        " post-1.71 / notes) for the pressed row; resolved client-side and passed
        " via t_arg, opened in a popover anchored to the pressed button (arg 8)
        DATA(lv_api)     = client->get_event_arg( ).
        DATA(lv_js)      = client->get_event_arg( 2 ).
        DATA(lv_ui5)     = client->get_event_arg( 3 ).
        DATA(lv_abap)    = client->get_event_arg( 4 ).
        DATA(lv_checked) = client->get_event_arg( 5 ).
        DATA(lv_post171) = client->get_event_arg( 6 ).
        DATA(lv_notes)   = client->get_event_arg( 7 ).

        DATA(links) = z2ui5_cl_ai_xml=>factory( ).
        DATA(box) = links->open( n = \`FragmentDefinition\` ns = \`core\`
            )->a( n = \`xmlns\`      v = \`sap.m\`
            )->a( n = \`xmlns:core\` v = \`sap.ui.core\`

            )->open( \`Popover\`
                )->a( n = \`title\`        v = \`Links & info\`
                )->a( n = \`placement\`    v = \`Auto\`
                )->a( n = \`contentWidth\` v = \`26rem\`

                )->open( \`VBox\`
                    )->a( n = \`class\` v = \`sapUiContentPadding\` ).

        box->leaf( \`Link\`
            )->a( n = \`text\`   v = \`Control - OpenUI5 API reference\`
            )->a( n = \`href\`   v = lv_api
            )->a( n = \`target\` v = \`_blank\`
            )->a( n = \`class\`  v = \`sapUiTinyMarginBottom\` ).
        box->leaf( \`Link\`
            )->a( n = \`text\`   v = \`Sample - OpenUI5 source\`
            )->a( n = \`href\`   v = lv_js
            )->a( n = \`target\` v = \`_blank\`
            )->a( n = \`class\`  v = \`sapUiTinyMarginBottom\` ).
        box->leaf( \`Link\`
            )->a( n = \`text\`   v = \`Sample - live fullscreen runner\`
            )->a( n = \`href\`   v = lv_ui5
            )->a( n = \`target\` v = \`_blank\`
            )->a( n = \`class\`  v = \`sapUiTinyMarginBottom\` ).
        box->leaf( \`Link\`
            )->a( n = \`text\`   v = \`abap2UI5 - class on GitHub\`
            )->a( n = \`href\`   v = lv_abap
            )->a( n = \`target\` v = \`_blank\` ).

        IF lv_checked IS NOT INITIAL.
          box->leaf( \`ObjectStatus\`
              )->a( n = \`text\`  v = lv_checked
              )->a( n = \`state\` v = \`Success\`
              )->a( n = \`class\` v = \`sapUiSmallMarginTop\` ).
        ENDIF.

        IF lv_post171 IS NOT INITIAL.
          box->leaf( \`ObjectStatus\`
              )->a( n = \`text\`  v = |Needs a UI5 release newer than 1.71: { lv_post171 }|
              )->a( n = \`state\` v = \`Warning\`
              )->a( n = \`class\` v = \`sapUiTinyMarginTop\` ).
        ENDIF.

        IF lv_notes IS NOT INITIAL.
          box->leaf( \`Title\`
              )->a( n = \`text\`  v = \`Generation notes\`
              )->a( n = \`level\` v = \`H5\`
              )->a( n = \`class\` v = \`sapUiSmallMarginTop\` ).
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
          box->leaf( \`FormattedText\`
              )->a( n = \`htmlText\` v = lv_html ).
        ENDIF.

        client->popover_display( xml   = links->stringify( )
                                 by_id = client->get_event_arg( 8 ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    " base url to launch an abap2UI5 app in a new browser tab
    DATA(start) = |{ client->get( )-s_config-origin }{ client->get( )-s_config-pathname }?app_start=|.

    t_app = get_catalog( ).
    LOOP AT t_app ASSIGNING FIELD-SYMBOL(<app>).

      DATA(libpath) = replace( val = <app>-module
                               sub = \`.\`
                               with = \`/\`
                               occ = 0 ).

      " display only the bare control, without its namespace (sap.f.GridList -> GridList)
      DATA(dot) = find( val = <app>-control sub = \`.\` occ = -1 ).
      <app>-ctrl_name = COND #( WHEN dot >= 0 THEN substring( val = <app>-control off = dot + 1 ) ELSE <app>-control ).

      <app>-api_url   = |https://sdk.openui5.org/api/{ <app>-control }|.
      <app>-js_url    = |https://github.com/SAP/openui5/tree/master/src/{ <app>-module }| &&
                        |/test/{ libpath }/demokit/sample/{ <app>-name }|.
      <app>-ui5_url   = |https://sdk.openui5.org/resources/sap/ui/documentation/sdk/index.html| &&
                        |?sap-ui-xx-sample-id={ <app>-module }.sample.{ <app>-name }| &&
                        |&sap-ui-xx-sample-lib={ <app>-module }|.
      <app>-abap_url  = |https://github.com/abap2UI5/api/blob/main/{ <app>-path }|.
      <app>-start_url = |{ start }{ to_upper( <app>-class ) }|.
      <app>-has_check = xsdbool( <app>-checked IS NOT INITIAL ).
      <app>-has_notes = xsdbool( <app>-notes IS NOT INITIAL ).
      <app>-has_p171  = xsdbool( <app>-post171 IS NOT INITIAL ).

      " control name: struck through when the control is deprecated, otherwise
      " plain - never coloured (carried as FormattedText htmlText so the
      " strikethrough can vary per row); a plain control is rendered as-is
      <app>-ctrl_html = COND string(
          WHEN <app>-dep_text IS NOT INITIAL
          THEN |<span style="text-decoration:line-through">{ <app>-ctrl_name }</span>|
          ELSE <app>-ctrl_name ).

      " one blob per row, bound as the FILTER column that the table search's
      " client-side Contains filter (binding_call) matches against. Only the
      " VISIBLE text columns feed it - Module, Control (bare name), Since,
      " Sample, Release, abap2UI5 (class) - so a query like "Date" no longer
      " matches hidden text buried in the notes/checked/post-1.71 fields
      <app>-filter = <app>-module && \` \` && <app>-ctrl_name && \` \` &&
                     <app>-since  && \` \` && <app>-name      && \` \` &&
                     <app>-release && \` \` && <app>-class.

    ENDLOOP.

    " the tree lists the full, unfiltered catalog (search filters only the table)
    t_tree = build_tree( t_app ).

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
                        " client-side filter over the table only: liveChange/search run
                        " a binding_call Contains filter via _event_client (no round-trip);
                        " the tree is intentionally left unfiltered
                        )->leaf( \`SearchField\`
                            )->a( n = \`placeholder\` v = \`Search the table - module, control, since, sample, class\`
                            )->a( n = \`width\`       v = \`24rem\`
                            " disabled while the tree is shown (search filters only the table)
                            )->a( n = \`enabled\`     v = |\\{= !\${ client->_bind( show_tree ) } \\}|
                            )->a( n = \`liveChange\`  v = ${filterCall('${$parameters>/newValue}')}
                            )->a( n = \`search\`      v = ${filterCall('${$parameters>/query}')}
                        " default-on filter checkboxes; each is two-way bound and the row
                        " visible expression reacts live (no round-trip). Disabled while the
                        " tree is shown (the filters act on the table only)
                        )->leaf( \`CheckBox\`
                            )->a( n = \`text\`     v = \`Hide non-OpenUI5\`
                            )->a( n = \`selected\` v = client->_bind( hide_non_ui5 )
                            )->a( n = \`enabled\`  v = |\\{= !\${ client->_bind( show_tree ) } \\}|
                            )->a( n = \`tooltip\`  v = \`Hide samples whose control is not part of OpenUI5\`
                        )->leaf( \`CheckBox\`
                            )->a( n = \`text\`     v = \`Hide newer than 1.71 (2020)\`
                            )->a( n = \`selected\` v = client->_bind( hide_post171 )
                            )->a( n = \`enabled\`  v = |\\{= !\${ client->_bind( show_tree ) } \\}|
                            )->a( n = \`tooltip\`  v = \`Hide samples that need a UI5 release newer than 1.71\`
                        )->leaf( \`CheckBox\`
                            )->a( n = \`text\`     v = \`Hide deprecated\`
                            )->a( n = \`selected\` v = client->_bind( hide_deprecated )
                            )->a( n = \`enabled\`  v = |\\{= !\${ client->_bind( show_tree ) } \\}|
                            )->a( n = \`tooltip\`  v = \`Hide samples whose control is deprecated\`
                        )->leaf( \`ToolbarSpacer\`
                        )->leaf( \`Label\`
                            )->a( n = \`text\` v = \`Shell\`
                        " Shell on/off = sap.m.Shell letterboxing (two-way, drives appWidthLimited)
                        )->leaf( \`Switch\`
                            )->a( n = \`state\`   v = client->_bind( shell_on )
                            )->a( n = \`tooltip\` v = \`Toggle the Shell letterboxing (limited app width)\`
                        )->leaf( \`Label\`
                            )->a( n = \`text\` v = \`Tree view\`
                        " Switch toggles table vs tree entirely on the client (two-way
                        " bound show_tree drives both views' visible expression bindings)
                        )->leaf( \`Switch\`
                            )->a( n = \`state\`   v = client->_bind( show_tree )
                            )->a( n = \`tooltip\` v = \`Switch between the table and a module -> control -> sample tree\`

                    )->shut(
                )->shut(

                )->open( \`Table\`
                    )->a( n = \`id\`      v = \`${ID_TABLE}\`
                    )->a( n = \`sticky\`  v = \`ColumnHeaders\`
                    )->a( n = \`visible\` v = |\\{= !\${ client->_bind( show_tree ) } \\}|
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
                            " no round-trip - like the tree/table Switch.
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
                                " second Since: the direct UI5 release the whole sample needs,
                                " shown only when higher than the control's own since; same
                                " orange-when-newer-than-1.71 colouring
                                )->leaf( \`ObjectStatus\`
                                    )->a( n = \`text\`  v = \`{RELEASE}\`
                                    )->a( n = \`state\` v = |\\{= $\\{RELEASE_POST171\\} ? 'Warning' : 'None' \\}|
                                )->leaf( \`Text\`
                                    )->a( n = \`text\` v = \`{CLASS}\`
                                " Version: the control does not exist in OpenUI5 (SAPUI5- /
                                " demo-kit-only); an orange SAPUI5 badge only on those rows
                                )->leaf( \`ObjectStatus\`
                                    )->a( n = \`text\`    v = \`SAPUI5\`
                                    )->a( n = \`state\`   v = \`Warning\`
                                    )->a( n = \`tooltip\` v = \`This control is not part of OpenUI5 - it cannot render on an OpenUI5 stack\`
                                    )->a( n = \`visible\` v = \`{UI5_ONLY}\`
                                " rating 1-5 (by feel): how much attention the port
                                " deserves - complexity, rework, review, test-priority
                                " (not coloured); tooltip lists the drivers
                                )->leaf( \`Text\`
                                    )->a( n = \`text\`    v = \`{SCORE} / 5\`
                                    )->a( n = \`tooltip\` v = \`{SCORE_TIP}\`

                                " audit column: one badge per framework-wiring fact the
                                " port uses (read from its ABAP source at generation time),
                                " always shown so the table shows at a glance which apps use
                                " _event_client / follow_up_action (and their t_arg form),
                                " open a Popup or Popover, or bind a path by literal name
                                )->open( \`HBox\`
                                    )->a( n = \`wrap\`       v = \`Wrap\`
                                    )->a( n = \`alignItems\` v = \`Center\`

                                    )->leaf( \`ObjectStatus\`
                                        )->a( n = \`text\`    v = \`_event_client\`
                                        )->a( n = \`state\`   v = \`Information\`
                                        )->a( n = \`tooltip\` v = \`Uses _event_client - a roundtrip-free client event wired directly in the view\`
                                        )->a( n = \`visible\` v = \`{USE_EC}\`
                                        )->a( n = \`class\`   v = \`sapUiTinyMarginEnd\`
                                    )->leaf( \`ObjectStatus\`
                                        )->a( n = \`text\`    v = \`_event_client t_arg\`
                                        )->a( n = \`state\`   v = \`Information\`
                                        )->a( n = \`tooltip\` v = \`Uses _event_client with t_arg (passes positional arguments to the client event)\`
                                        )->a( n = \`visible\` v = \`{USE_EC_ARG}\`
                                        )->a( n = \`class\`   v = \`sapUiTinyMarginEnd\`
                                    )->leaf( \`ObjectStatus\`
                                        )->a( n = \`text\`    v = \`follow_up_action\`
                                        )->a( n = \`state\`   v = \`Success\`
                                        )->a( n = \`tooltip\` v = \`Uses follow_up_action - a frontend action scheduled after the backend response\`
                                        )->a( n = \`visible\` v = \`{USE_FUA}\`
                                        )->a( n = \`class\`   v = \`sapUiTinyMarginEnd\`
                                    )->leaf( \`ObjectStatus\`
                                        )->a( n = \`text\`    v = \`follow_up_action t_arg\`
                                        )->a( n = \`state\`   v = \`Success\`
                                        )->a( n = \`tooltip\` v = \`Uses follow_up_action with t_arg (passes positional arguments to the follow-up action)\`
                                        )->a( n = \`visible\` v = \`{USE_FUA_ARG}\`
                                        )->a( n = \`class\`   v = \`sapUiTinyMarginEnd\`
                                    )->leaf( \`ObjectStatus\`
                                        )->a( n = \`text\`    v = \`Popup\`
                                        )->a( n = \`state\`   v = \`Warning\`
                                        )->a( n = \`tooltip\` v = \`Opens a Popup (popup_display)\`
                                        )->a( n = \`visible\` v = \`{USE_POPUP}\`
                                        )->a( n = \`class\`   v = \`sapUiTinyMarginEnd\`
                                    )->leaf( \`ObjectStatus\`
                                        )->a( n = \`text\`    v = \`Popover\`
                                        )->a( n = \`state\`   v = \`Warning\`
                                        )->a( n = \`tooltip\` v = \`Opens a Popover (popover_display)\`
                                        )->a( n = \`visible\` v = \`{USE_POPOVER}\`
                                        )->a( n = \`class\`   v = \`sapUiTinyMarginEnd\`
                                    )->leaf( \`ObjectStatus\`
                                        )->a( n = \`text\`    v = \`literal binding\`
                                        )->a( n = \`state\`   v = \`Error\`
                                        )->a( n = \`tooltip\` v = \`Binds a path by literal name in clear text ({FIELD} or {/Path}) instead of via client->_bind - breaks on a variable rename\`
                                        )->a( n = \`visible\` v = \`{USE_NAME}\`
                                        )->a( n = \`class\`   v = \`sapUiTinyMarginEnd\`

                                )->shut(
                                " Open column: two buttons. First opens an anchored popover with
                                " the reference links AND the port's generation info (checked,
                                " post-1.71, notes) - the pressed button's runtime id
                                " (\$event.oSource.sId) anchors it; second launches the abap2UI5
                                " app directly in a new tab (open_new_tab - the start URL is
                                " same-origin, so it passes isValidRedirectURL)
                                )->open( \`HBox\`
                                    )->leaf( \`Button\`
                                        )->a( n = \`icon\`    v = \`sap-icon://chain-link\`
                                        )->a( n = \`type\`    v = \`Transparent\`
                                        )->a( n = \`tooltip\` v = \`Reference links & info: OpenUI5 API, source, live sample, ABAP class, generation notes\`
                                        )->a( n = \`press\`   v = client->_event( val = \`LINKS\` t_arg = VALUE #(
                                            ( \`\${API_URL}\` ) ( \`\${JS_URL}\` ) ( \`\${UI5_URL}\` ) ( \`\${ABAP_URL}\` )
                                            ( \`\${CHECKED}\` ) ( \`\${POST171}\` ) ( \`\${NOTES}\` ) ( \`\$event.oSource.sId\` ) ) )
                                    )->leaf( \`Button\`
                                        )->a( n = \`icon\`    v = \`sap-icon://action\`
                                        )->a( n = \`type\`    v = \`Transparent\`
                                        )->a( n = \`tooltip\` v = \`Start this abap2UI5 app in a new tab\`
                                        )->a( n = \`press\`   v = client->_event_client( val = client->cs_event-open_new_tab t_arg = VALUE #( ( \`\${START_URL}\` ) ) )

                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(

                " tree view (module -> control -> sample) - shown instead of the
                " table when the header Switch is on (client-side visible binding);
                " numberOfExpandedLevels expands every level by default; sibling of
                " the Table under the Page (NOT nested in the Table's items)
                )->open( \`Tree\`
                        )->a( n = \`id\`      v = \`idOverviewTree\`
                        )->a( n = \`visible\` v = |\\{= \${ client->_bind( show_tree ) } \\}|
                        )->a( n = \`items\`   v = |\\{ path: '{ client->_bind( val = t_tree path = abap_true ) }', parameters: \\{ numberOfExpandedLevels: 10 \\} \\}|

                        " expand-all / collapse-all act on the tree by id, client-side
                        )->open( \`headerToolbar\`
                            )->open( \`Toolbar\`
                                )->leaf( \`Button\`
                                    )->a( n = \`text\`  v = \`Expand all\`
                                    )->a( n = \`icon\`  v = \`sap-icon://expand-group\`
                                    )->a( n = \`press\` v = client->_event_client( val = client->cs_event-control_by_id t_arg = VALUE #( ( \`idOverviewTree\` ) ( \`expandToLevel\` ) ( \`10\` ) ) )
                                )->leaf( \`Button\`
                                    )->a( n = \`text\`  v = \`Collapse all\`
                                    )->a( n = \`icon\`  v = \`sap-icon://collapse-group\`
                                    )->a( n = \`press\` v = client->_event_client( val = client->cs_event-control_by_id t_arg = VALUE #( ( \`idOverviewTree\` ) ( \`collapseAll\` ) ) )

                            )->shut(
                        )->shut(

                        )->open( \`CustomTreeItem\`
                            )->open( \`HBox\`
                                )->a( n = \`alignItems\` v = \`Center\`

                                )->leaf( \`Text\`
                                    )->a( n = \`text\` v = \`{TEXT}\`
                                " same two buttons as the table's Open column - only on sample
                                " leaves: the reference-links popover, then the direct app launch.
                                " The tree model carries no notes/checked, so the info args are
                                " empty (the popover then just shows the four links).
                                )->leaf( \`Button\`
                                    )->a( n = \`icon\`    v = \`sap-icon://chain-link\`
                                    )->a( n = \`type\`    v = \`Transparent\`
                                    )->a( n = \`tooltip\` v = \`Reference links: OpenUI5 API, source, live sample, ABAP class\`
                                    )->a( n = \`class\`   v = \`sapUiTinyMarginBegin\`
                                    )->a( n = \`visible\` v = \`{HAS_LINK}\`
                                    )->a( n = \`press\`   v = client->_event( val = \`LINKS\` t_arg = VALUE #( ( \`\${API_URL}\` ) ( \`\${JS_URL}\` ) ( \`\${UI5_URL}\` ) ( \`\${ABAP_URL}\` ) ( \`\` ) ( \`\` ) ( \`\` ) ( \`\$event.oSource.sId\` ) ) )
                                )->leaf( \`Button\`
                                    )->a( n = \`icon\`    v = \`sap-icon://action\`
                                    )->a( n = \`type\`    v = \`Transparent\`
                                    )->a( n = \`tooltip\` v = \`Start this abap2UI5 app in a new tab\`
                                    )->a( n = \`visible\` v = \`{HAS_LINK}\`
                                    )->a( n = \`press\`   v = client->_event_client( val = client->cs_event-open_new_tab t_arg = VALUE #( ( \`\${START_URL}\` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD get_catalog.

    result = VALUE #(
${rows.join('\n')} ).

  ENDMETHOD.


  METHOD build_tree.

    " group the (already module/control/sample-sorted) apps into the nested tree;
    " each sample leaf keeps the links so its popover can jump the same places
    LOOP AT it_app INTO DATA(ls_app).

      IF result IS INITIAL OR result[ lines( result ) ]-text <> ls_app-module.
        APPEND VALUE #( text = ls_app-module ) TO result.
      ENDIF.
      ASSIGN result[ lines( result ) ] TO FIELD-SYMBOL(<module>).

      IF <module>-nodes IS INITIAL OR <module>-nodes[ lines( <module>-nodes ) ]-text <> ls_app-ctrl_name.
        APPEND VALUE #( text = ls_app-ctrl_name ) TO <module>-nodes.
      ENDIF.
      ASSIGN <module>-nodes[ lines( <module>-nodes ) ] TO FIELD-SYMBOL(<control>).

      APPEND VALUE #( text      = |{ ls_app-name } - { ls_app-class }|
                      api_url   = ls_app-api_url
                      js_url    = ls_app-js_url
                      ui5_url   = ls_app-ui5_url
                      abap_url  = ls_app-abap_url
                      start_url = ls_app-start_url
                      has_link  = abap_true ) TO <control>-nodes.

    ENDLOOP.

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
