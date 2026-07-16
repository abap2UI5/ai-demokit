#!/usr/bin/env node
/*
 * Regenerates the coverage docs: every official UI5 demo kit sample of the
 * focused libraries, marked with whether an abap2UI5 port exists.
 *   - api.md    ONE flat table — one row per sample: Module · Control · Since ·
 *               Deprecated (since + replacement hint) · Sample (source + live
 *               links) · ABAP (ported class or —)
 *   - README.md per-module coverage summary (between the coverage markers)
 *
 * The in-system overview app (src/) is generated separately by
 * scripts/generate-overview.mjs.
 *
 * Universe of samples : ui5/universe.json — a snapshot of the demo kit sample
 *                       list + control metadata (entity, since, deprecation,
 *                       release). When an OpenUI5 checkout is present (env
 *                       OPENUI5_DIR, default ./openui5), the snapshot is
 *                       REBUILT from it (sample dirs + docuindex.json +
 *                       api.json from `grunt jsdoc:library-<lib>`, root
 *                       overridable via APIJSON_ROOT) and written back; without
 *                       a checkout the snapshot is read as-is, so the docs
 *                       regenerate fully offline.
 * Ported samples      : meta/<class>.json sidecars (the source of truth) —
 *                       matched to the universe by <lib>.sample.<Name>. Ports
 *                       that match no universe sample are reported as orphans.
 *
 * All table links are external (absolute) and point at OpenUI5 — the demo kit
 * (sdk.openui5.org) and the source repo (github.com/SAP/openui5); only the ABAP
 * column links back to this repo. Env: OPENUI5_DIR, APIJSON_ROOT, REPO, REF,
 * DEMOKIT, OPENUI5.
 *
 * Run:  node scripts/generate-coverage.mjs                     # offline, from the snapshot
 *       OPENUI5_DIR=../openui5 node scripts/generate-coverage.mjs   # refresh snapshot too
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const META = path.join(ROOT, 'meta');
const OPENUI5_DIR = process.env.OPENUI5_DIR || path.join(ROOT, 'openui5');
// root that holds the generated api.json files (one per library), i.e. the
// SDK build output of `grunt jsdoc:library-<lib>` in the OpenUI5 checkout.
const APIJSON_ROOT = process.env.APIJSON_ROOT ||
  path.join(OPENUI5_DIR, 'target', 'openui5-sdk', 'test-resources');
const SNAPSHOT = path.join(ROOT, 'ui5', 'universe.json');
const COVERAGE = path.join(ROOT, 'api.md');
const README = path.join(ROOT, 'README.md');
const START = '<!-- coverage:start -->';
const END = '<!-- coverage:end -->';

// link targets (overridable via env) — all links are external/absolute and
// point at OpenUI5: the demo kit (sdk.openui5.org) and the source repo (SAP/openui5)
const REPO = process.env.REPO || 'abap2UI5/api';   // owner/name (this repo)
const REF = process.env.REF || 'main';             // branch the ABAP links resolve on
const GH = `https://github.com/${REPO}`;
const DEMOKIT = process.env.DEMOKIT || 'https://sdk.openui5.org';   // OpenUI5 demo kit
const OPENUI5 = process.env.OPENUI5 || 'https://github.com/SAP/openui5';   // OpenUI5 repo
const OPENUI5_REF = process.env.OPENUI5_REF || 'master';
// live OpenUI5 demo kit sample app, opened fullscreen (the sample runner)
const fullscreenUrl = (lib, name) =>
  `${DEMOKIT}/resources/sap/ui/documentation/sdk/index.html?sap-ui-xx-sample-id=${lib}.sample.${name}&sap-ui-xx-sample-lib=${lib}`;
// OpenUI5 API reference for a control (entity)
const apiUrl = (entity) => `${DEMOKIT}/api/${entity}`;
// bare control name without its namespace (sap.f.GridList -> GridList)
const bareControl = (entity) => entity.slice(entity.lastIndexOf('.') + 1);
// the porting scope (§7 AGENTS.md): a sample is IN SCOPE when its control
// existed by UI5 1.71 (empty since = older than tracking) and is not
// deprecated (legacy-free ready). Everything else is listed but not ported.
const sinceLeq171 = (since) => {
  if (!since) return true;
  const m = String(since).match(/^(\d+)\.(\d+)/);
  return m ? (+m[1] < 1 || (+m[1] === 1 && +m[2] <= 71)) : false;
};
// -> 'in' | 'deprecated' | 'newer' | 'unknown'. An entity containing
// '.sample.' is the sample id itself (demo apps without an owning control,
// e.g. AIIntegration) — no control metadata, so scope is unknown.
const scopeOf = (s) =>
  !s.entity || s.entity.includes('.sample.') ? 'unknown'
    : s.deprecated ? 'deprecated' : sinceLeq171(s.since) ? 'in' : 'newer';
// turn a JSDoc doclet into plain text: resolve {@link sym text} to its display
// text (or the symbol), collapse whitespace, trim.
const cleanDoc = (t) => String(t || '')
  .replace(/\{@link\s+([^}\s]+)(?:\s+([^}]+))?\}/g, (_, sym, disp) => (disp ? disp.trim() : sym))
  .replace(/\s+/g, ' ')
  .trim();
// the sample's source folder in the OpenUI5 repository
const sampleSrcUrl = (lib, name) =>
  `${OPENUI5}/tree/${OPENUI5_REF}/src/${lib}/test/${lib.replace(/\./g, '/')}/demokit/sample/${name}`;
// generated abap2UI5 class file under src/ (this repo)
const abapUrl = (file) => `${GH}/blob/${REF}/${file.split(path.sep).join('/')}`;

// Focus: only these UI5 libraries are in scope right now (§7 AGENTS.md); the
// others are brought back in later. Set to null to cover every library again.
const FOCUS_LIBS = ['sap.m'];

// --- 1. ported set from the meta/ sidecars ---------------------------------
const ported = new Map(); // `${lib}\t${name}` -> { cls, file }
for (const mf of fs.readdirSync(META)) {
  if (!mf.endsWith('.json')) continue;
  const m = JSON.parse(fs.readFileSync(path.join(META, mf), 'utf8'));
  const i = m.sample.indexOf('.sample.');
  if (i === -1) continue;
  ported.set(`${m.sample.slice(0, i)}\t${m.sample.slice(i + '.sample.'.length)}`,
    { cls: m.class, file: m.file });
}

// --- 2. universe: from the OpenUI5 checkout (refreshing the snapshot), or
//        offline from ui5/universe.json --------------------------------------

// entity -> control metadata from the release's generated api.json (symbols[])
function loadApi(lib) {
  const p = path.join(APIJSON_ROOT, lib.replace(/\./g, '/'), 'designtime', 'api.json');
  const meta = new Map();
  if (!fs.existsSync(p)) return { version: null, meta };
  let doc;
  try { doc = JSON.parse(fs.readFileSync(p, 'utf8')); } catch { return { version: null, meta }; }
  for (const s of doc.symbols || []) {
    meta.set(s.name, {
      since: s.since || null,
      deprecated: s.deprecated
        ? { since: s.deprecated.since || null, text: cleanDoc(s.deprecated.text) }
        : null,
    });
  }
  return { version: doc.version || null, meta };
}

// sample id -> owning entity, parsed from each library's demokit docuindex.json
function entityMap(demokitDir) {
  const map = new Map();
  const p = path.join(demokitDir, 'docuindex.json');
  if (!fs.existsSync(p)) return map;
  let doc;
  try { doc = JSON.parse(fs.readFileSync(p, 'utf8')); } catch { return map; }
  const entities = (doc.explored && doc.explored.entities) || doc.entities || [];
  for (const e of entities) {
    for (const sid of e.samples || []) if (!map.has(sid)) map.set(sid, e.id);
  }
  return map;
}

let universe; // { release, libs: [{ lib, samples: [{ name, entity, since, deprecated }] }] }
if (fs.existsSync(OPENUI5_DIR)) {
  let release = null;
  const ulibs = [];
  for (const lib of fs.readdirSync(path.join(OPENUI5_DIR, 'src')).sort()) {
    if (FOCUS_LIBS && !FOCUS_LIBS.includes(lib)) continue;
    const demokitDir = path.join(OPENUI5_DIR, 'src', lib, 'test', lib.replace(/\./g, '/'), 'demokit');
    const sampleDir = path.join(demokitDir, 'sample');
    if (!fs.existsSync(sampleDir)) continue;
    const entOf = entityMap(demokitDir);
    const api = loadApi(lib);
    if (api.version && !release) release = api.version;
    const samples = fs.readdirSync(sampleDir)
      .filter((n) => fs.statSync(path.join(sampleDir, n)).isDirectory())
      .sort((a, b) => a.toLowerCase().localeCompare(b.toLowerCase()))
      .map((name) => {
        const entity = entOf.get(`${lib}.sample.${name}`) || null;
        const m = (entity && api.meta.get(entity)) || {};
        return { name, entity, since: m.since || null, deprecated: m.deprecated || null };
      });
    if (samples.length) ulibs.push({ lib, samples });
  }
  universe = { release, libs: ulibs };
  fs.writeFileSync(SNAPSHOT, JSON.stringify(universe, null, 1) + '\n');
  console.log(`universe snapshot refreshed from ${OPENUI5_DIR} -> ${path.relative(ROOT, SNAPSHOT)}`);
} else if (fs.existsSync(SNAPSHOT)) {
  universe = JSON.parse(fs.readFileSync(SNAPSHOT, 'utf8'));
} else {
  console.error(`neither an OpenUI5 checkout (${OPENUI5_DIR}) nor ${path.relative(ROOT, SNAPSHOT)} found.`);
  process.exit(1);
}

const release = universe.release;
const libs = universe.libs.map((e) => ({
  lib: e.lib,
  samples: e.samples.map((s) => ({
    ...s,
    port: ported.get(`${e.lib}\t${s.name}`) || null,
    scope: scopeOf(s),
  })),
}));

// a ported sample outside the scope is a rule violation — warn loudly
for (const e of libs) {
  for (const s of e.samples) {
    if (s.port && s.scope !== 'in') {
      console.warn(`WARNING: ported sample ${e.lib}.sample.${s.name} is out of scope (${s.scope})`);
    }
  }
}

// --backlog: print the in-scope, unported samples (batch planning input)
if (process.argv.includes('--backlog')) {
  for (const e of libs) {
    for (const s of e.samples) {
      if (s.scope === 'in' && !s.port) console.log(`${e.lib}\t${s.entity}\t${s.name}`);
    }
  }
  process.exit(0);
}

// integrity: a port that matches no universe sample would silently vanish
// from the coverage — report it loudly instead
const matched = new Set(libs.flatMap((e) => e.samples.map((s) => `${e.lib}\t${s.name}`)));
for (const key of ported.keys()) {
  if (!matched.has(key)) {
    console.warn(`WARNING: orphan port ${key.replace('\t', '.sample.')} — not in the sample universe (renamed/removed upstream, or outside FOCUS_LIBS?)`);
  }
}

// --- 3. render --------------------------------------------------------------
const pct = (n, d) => (d === 0 ? '—' : `${((n / d) * 100).toFixed(1)} %`);
const bar = (n, d) => {
  if (d === 0) return '';
  const filled = Math.round((n / d) * 10);
  return '█'.repeat(filled) + '░'.repeat(10 - filled);
};

const summary = libs
  .map((l) => ({
    lib: l.lib,
    total: l.samples.length,
    inScope: l.samples.filter((s) => s.scope === 'in').length,
    ported: l.samples.filter((s) => s.port).length,
  }))
  .sort((a, b) => (b.ported / b.inScope) - (a.ported / a.inScope) || a.lib.localeCompare(b.lib));

let totalSamples = 0;
let totalInScope = 0;
let totalPorted = 0;
const outBy = { deprecated: 0, newer: 0, unknown: 0 };
for (const s of summary) { totalSamples += s.total; totalInScope += s.inScope; totalPorted += s.ported; }
for (const e of libs) for (const s of e.samples) if (s.scope !== 'in') outBy[s.scope]++;

// README block: overall figure + coverage-per-module summary table
function summaryLines() {
  const l = [];
  l.push(`Overall **${totalPorted} / ${totalInScope}** in-scope demo kit samples ported (${pct(totalPorted, totalInScope)}).`);
  l.push(`**In scope**: samples whose control exists since **UI5 1.71** and is **not deprecated** (legacy-free ready).`);
  l.push(`Out of scope: ${totalSamples - totalInScope} of ${totalSamples} samples — ${outBy.deprecated} on deprecated controls, ${outBy.newer} on controls newer than 1.71, ${outBy.unknown} without control metadata.`);
  if (release) l.push(`Control metadata from OpenUI5 **${release}**.`);
  l.push('');
  l.push('| Module | Samples | In scope | Ported | Coverage | |');
  l.push('|--------|--------:|---------:|-------:|---------:|---|');
  for (const s of summary) {
    l.push(`| \`${s.lib}\` | ${s.total} | ${s.inScope} | ${s.ported} | ${pct(s.ported, s.inScope)} | ${bar(s.ported, s.inScope)} |`);
  }
  l.push(`| **Total** | **${totalSamples}** | **${totalInScope}** | **${totalPorted}** | **${pct(totalPorted, totalInScope)}** | ${bar(totalPorted, totalInScope)} |`);
  return l;
}

// api.md — ONE flat table, one row per sample, deprecation inline
function controlLines() {
  const l = [];
  l.push('One row per UI5 demo kit sample. **Control** links to the OpenUI5 API,');
  l.push('**Since** is the version the control was introduced, **Deprecated**');
  l.push('carries the deprecation version and the replacement hint from the');
  l.push('release\'s `api.json` (empty = not deprecated), **Sample** links the');
  l.push('source in the [OpenUI5 repository](https://github.com/SAP/openui5) and');
  l.push('its ↗ opens the live fullscreen sample, **ABAP** is the generated class.');
  l.push('`—` = in scope, not ported yet — those rows are the backlog.');
  l.push('`✗` = **out of scope**: the control is deprecated or newer than UI5 1.71');
  l.push('(not legacy-free ready / not 1.71-compatible) — these samples are listed');
  l.push('for completeness but are not ported.');
  l.push('See the [README](README.md#coverage) for the per-module coverage summary.');
  if (release) {
    l.push('');
    l.push(`_Control metadata (Since, deprecation) from the OpenUI5 **${release}** \`api.json\`._`);
  }
  l.push('');
  l.push('| Module | Control | Since | Deprecated | Sample | ABAP |');
  l.push('|--------|---------|:-----:|------------|--------|:----:|');

  // one row per sample, sorted module -> control -> sample name; samples
  // without a known control sort last within their module
  const rows = libs.flatMap((e) => e.samples.map((s) => ({ ...s, lib: e.lib })));
  rows.sort((a, b) =>
    a.lib.toLowerCase().localeCompare(b.lib.toLowerCase()) ||
    (a.entity ? 0 : 1) - (b.entity ? 0 : 1) ||
    (a.entity || '').toLowerCase().localeCompare((b.entity || '').toLowerCase()) ||
    a.name.toLowerCase().localeCompare(b.name.toLowerCase()));

  for (const s of rows) {
    const label = s.entity ? bareControl(s.entity) : null;
    const control = label
      ? `[${s.deprecated ? `~~${label}~~` : label}](${apiUrl(s.entity)})`
      : '—';
    const deprecated = s.deprecated
      ? `${s.deprecated.since || ''}${s.deprecated.text ? ` — ${s.deprecated.text.replace(/\|/g, '/')}` : ''}`.trim()
      : '';
    const sample = `[${s.name}](${sampleSrcUrl(s.lib, s.name)}) [↗](${fullscreenUrl(s.lib, s.name)})`;
    const abap = s.port
      ? `[${s.port.cls}](${abapUrl(s.port.file)})`
      : (s.scope === 'in' ? '—' : '✗');
    l.push(`| ${s.lib} | ${control} | ${s.since || ''} | ${deprecated} | ${sample} | ${abap} |`);
  }
  l.push('');
  return l;
}

const coverage = ['# abap2UI5 — sample coverage', '', ...controlLines()];
fs.writeFileSync(COVERAGE, coverage.join('\n').trimEnd() + '\n');

// README — splice the per-module summary between the coverage markers
let readme = fs.readFileSync(README, 'utf8');
if (!readme.includes(START) || !readme.includes(END)) {
  console.error(`README.md is missing the ${START} / ${END} markers.`);
  process.exit(1);
}
const block = `${START}\n\n${summaryLines().join('\n').trimEnd()}\n\n${END}`;
readme = readme.replace(new RegExp(`${START}[\\s\\S]*?${END}`), () => block);
fs.writeFileSync(README, readme);

console.log(`api.md + README: ${totalPorted}/${totalSamples} ported across ${libs.length} libraries` +
  (release ? ` (metadata from OpenUI5 ${release})` : ' (no api.json — Since column blank)'));
