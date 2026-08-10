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
import {
  loadUniverseSnapshot, loadPropertiesControls, loadEntityOverrides,
  loadNonAppFamilies, loadUniverseExcludes, nonAppFamilyFor, sinceLeq171,
  enrichFromProperties as enrichSample,
} from './lib-universe.mjs';

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
const REPO = process.env.REPO || 'abap2UI5/ai-demokit';   // owner/name (this repo)
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
// the porting scope (AGENTS.md §1): a sample is IN SCOPE when its control
// existed by UI5 1.71 (empty since = older than tracking) and is not
// deprecated (legacy-free ready). Everything else is listed but not ported.
// (sinceLeq171 comes from lib-universe.mjs — one definition for every gate.)
// --- non-app sample families (maintainer decision 2026-07-31) --------------
// ui5/scope-nonapp.json lists families whose control is in scope by the 1.71
// rule but that are not app views at all — UI5's own test infrastructure
// (OPA5/gherkin/matchers), Component routing across several views, and the
// view-type / XML-templating / XMLComposite authoring demos. They are out of
// scope: listed in api.md, never offered by --backlog, never ported.
// scope-of.mjs applies the same list via the same lib-universe matcher; the
// two verdicts must stay identical (AGENTS §1).
const nonAppFamilies = loadNonAppFamilies();
// -> the matching family (with its reason) or null
const nonAppFamily = (lib, s) =>
  nonAppFamilyFor(nonAppFamilies, { lib, name: s.name, entity: s.entity });

// -> 'in' | 'deprecated' | 'newer' | 'nonapp' | 'unknown'. An entity containing
// '.sample.' is the sample id itself (demo apps without an owning control,
// e.g. AIIntegration) — no control metadata, so scope is unknown.
// Samples are enriched from ui5/properties.json BEFORE this runs (see
// enrichFromProperties below), so a null since/deprecated from the snapshot
// no longer silently passes controls newer than 1.71.
const scopeOf = (lib, s) =>
  !s.entity || s.entity.includes('.sample.') ? 'unknown'
    : s.deprecated ? 'deprecated' : !sinceLeq171(s.since) ? 'newer'
      : nonAppFamily(lib, s) ? 'nonapp' : 'in';

// --- scope fallback: control-level @since/@deprecated from the source scan --
// ui5/universe.json carries since:null for most controls (the fork checkout
// has no generated api.json), which made scopeOf blind — sinceLeq171(null)
// passed controls newer than 1.71 (sap.f.SidePanel @1.107 shipped as app 136
// that way). ui5/properties.json now carries each control's class-level
// @since/@deprecated parsed from the OpenUI5 sources (the linter's generate-metadata.mjs);
// fill the snapshot's nulls from it so the scope verdict matches
// scripts/scope-of.mjs offline.
const propsControls = loadPropertiesControls();
const enrichFromProperties = (s) => enrichSample(propsControls, s);

// --- curated universe fixups (both the build and the offline-load path) -----
// ui5/universe-excludes.json: demokit sample/ dirs that are not samples
// (shared helpers, test infra, group folders with nested samples).
// ui5/entity-overrides.json: sample id -> owning entity where the upstream
// docuindex has no mapping, so real samples get proper scope + API links.
const excludeSet = loadUniverseExcludes();
const entityOverrides = loadEntityOverrides();
function applyUniverseFixups(u) {
  return {
    ...u,
    libs: u.libs.map((e) => ({
      ...e,
      samples: e.samples
        .filter((s) => !excludeSet.has(`${e.lib}\t${s.name}`))
        .map((s) => (entityOverrides[`${e.lib}.sample.${s.name}`]
          ? { ...s, entity: entityOverrides[`${e.lib}.sample.${s.name}`] }
          : s)),
    })),
  };
}
// turn a JSDoc doclet into plain text: resolve {@link sym text} to its display
// text (or the symbol), collapse whitespace, trim.
const cleanDoc = (t) => String(t || '')
  .replace(/\{@link\s+([^}\s]+)(?:\s+([^}]+))?\}/g, (_, sym, disp) => (disp ? disp.trim() : sym))
  .replace(/\s+/g, ' ')
  .trim();
// the sample's source folder in the OpenUI5 repository. A GROUP-nested
// sample is named `<Group>.<Child>` (TreeTable.JSONTreeBinding) — its
// folder is sample/<Group>/<Child>
const sampleSrcUrl = (lib, name) =>
  `${OPENUI5}/tree/${OPENUI5_REF}/src/${lib}/test/${lib.replace(/\./g, '/')}/demokit/sample/${name.replace(/\./g, '/')}`;
// generated abap2UI5 class file under src/ (this repo)
const abapUrl = (file) => `${GH}/blob/${REF}/${file.split(path.sep).join('/')}`;

// Focus: only these UI5 libraries are in scope right now (AGENTS.md §1); the
// others are brought back in later. Set to null to cover every library again.
const FOCUS_LIBS = ['sap.m', 'sap.f', 'sap.ui.layout', 'sap.ui.core', 'sap.ui.unified', 'sap.ui.table', 'sap.uxap', 'sap.tnt', 'sap.ui.codeeditor', 'sap.ui.integration'];

// --- 1. ported set from the meta/ sidecars ---------------------------------
const ported = new Map(); // `${lib}\t${name}` -> { cls, file }
for (const mf of fs.readdirSync(META)) {
  if (!mf.endsWith('.json')) continue;
  const m = JSON.parse(fs.readFileSync(path.join(META, mf), 'utf8'));
  const i = m.sample.indexOf('.sample.');
  if (i === -1) continue;
  ported.set(`${m.sample.slice(0, i)}\t${m.sample.slice(i + '.sample.'.length)}`,
    { cls: m.class, file: m.file, post171: (m.deviations || []).some((d) => d.type === 'POST_171') });
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
    const isSampleDir = (p) =>
      fs.existsSync(path.join(p, 'Component.js')) || fs.existsSync(path.join(p, 'manifest.json'));
    const names = [];
    for (const n of fs.readdirSync(sampleDir)) {
      const dir = path.join(sampleDir, n);
      if (!fs.statSync(dir).isDirectory()) continue;
      if (entOf.has(`${lib}.sample.${n}`) || isSampleDir(dir)) {
        names.push(n);
        continue;
      }
      // GROUP folder (TreeTable, p13n, …): its subfolders are the real
      // samples — take a child ONLY when the docuindex lists it as an
      // official demo kit sample (test infra / shared helpers stay out)
      for (const c of fs.readdirSync(dir)) {
        if (!fs.statSync(path.join(dir, c)).isDirectory()) continue;
        if (entOf.has(`${lib}.sample.${n}.${c}`)) names.push(`${n}.${c}`);
      }
    }
    const samples = names
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
} else {
  universe = loadUniverseSnapshot();
  if (!universe) {
    console.error(`neither an OpenUI5 checkout (${OPENUI5_DIR}) nor ${path.relative(ROOT, SNAPSHOT)} found.`);
    process.exit(1);
  }
}

universe = applyUniverseFixups(universe);

const release = universe.release;
const libs = universe.libs.map((e) => ({
  lib: e.lib,
  samples: e.samples.map((s) => {
    const enriched = enrichFromProperties(s);
    return {
      ...enriched,
      port: ported.get(`${e.lib}\t${s.name}`) || null,
      scope: scopeOf(e.lib, enriched),
    };
  }),
}));

// a ported sample outside the scope is a rule violation — HARD gate since
// 2026-07-26: fail unless the sample carries a documented exception in
// ui5/scope-exceptions.json (a maintainer decision, never a silencer).
// 'unknown' scope (demo apps without an owning control) is not a violation.
const SCOPE_EXC_FILE = path.join(ROOT, 'ui5', 'scope-exceptions.json');
const scopeExceptions = new Map(
  (fs.existsSync(SCOPE_EXC_FILE)
    ? JSON.parse(fs.readFileSync(SCOPE_EXC_FILE, 'utf8')).exceptions || []
    : []).map((e) => [e.sample, e]));
let scopeErrors = 0;
for (const e of libs) {
  for (const s of e.samples) {
    if (!s.port || s.scope === 'in' || s.scope === 'unknown') continue;
    const sampleId = `${e.lib}.sample.${s.name}`;
    const exc = scopeExceptions.get(sampleId);
    if (exc) {
      console.warn(`note: ported sample ${sampleId} is out of scope (${s.scope}) — documented exception: ${exc.reason}`);
    } else {
      console.error(`ERROR: ported sample ${sampleId} is out of scope (${s.scope}) — out-of-scope samples are never ported (AGENTS §1); remove the port or add a maintainer-decided entry to ui5/scope-exceptions.json`);
      scopeErrors++;
    }
  }
}
// stale exceptions must not linger: an entry whose sample is no longer ported
// (or no longer out of scope) fails too, so the list can only shrink honestly.
// Each entry also PINS the scope facts the decision was made on ("decided":
// scope verdict + control @since + deprecation @since) — a universe/properties
// refresh that changes any of them invalidates the decision's rationale, so
// the gate fails until a maintainer re-decides (and re-pins) the entry.
const depSince = (d) => d == null ? null : typeof d === 'object' ? (d.since || 'yes') : String(d);
for (const [sampleId, exc] of scopeExceptions) {
  const hit = libs.flatMap((e) => e.samples.map((s) => ({ ...s, id: `${e.lib}.sample.${s.name}` })))
    .find((s) => s.id === sampleId);
  if (!hit || !hit.port || hit.scope === 'in' || hit.scope === 'unknown') {
    console.error(`ERROR: stale scope exception "${sampleId}" (${exc.class}) — the sample is ${!hit ? 'not in the universe' : !hit.port ? 'not ported' : 'in scope'}; remove the entry from ui5/scope-exceptions.json`);
    scopeErrors++;
    continue;
  }
  if (!exc.decided) {
    console.error(`ERROR: scope exception "${sampleId}" (${exc.class}) carries no "decided" facts — pin the decision's basis as { "scope", "since", "deprecated" } in ui5/scope-exceptions.json`);
    scopeErrors++;
    continue;
  }
  const cur = { scope: hit.scope, since: hit.since || null, deprecated: depSince(hit.deprecated) };
  const dec = { scope: exc.decided.scope ?? null, since: exc.decided.since ?? null, deprecated: exc.decided.deprecated ?? null };
  const changed = ['scope', 'since', 'deprecated'].filter((k) => cur[k] !== dec[k]);
  if (changed.length) {
    console.error(`ERROR: scope exception "${sampleId}" (${exc.class}) was decided on facts that have changed — ${changed.map((k) => `${k}: decided ${JSON.stringify(dec[k])}, now ${JSON.stringify(cur[k])}`).join('; ')}. Re-decide the entry (and re-pin "decided") in ui5/scope-exceptions.json`);
    scopeErrors++;
  }
}
if (scopeErrors) process.exit(1);

// --backlog: print the in-scope, unported samples (batch planning input).
// BREADTH-FIRST order: samples whose CONTROL has no port at all come first —
// one port per control maximizes gap discovery per port; near-duplicate
// samples of an already-covered control come after (AGENTS §1). Samples in
// the hold-out set (ui5/holdout.json, see TRAINING.md) are marked HOLDOUT and
// stay out of regular batch planning.
if (process.argv.includes('--backlog')) {
  const holdoutFile = path.join(ROOT, 'ui5', 'holdout.json');
  const holdout = fs.existsSync(holdoutFile)
    ? new Set(JSON.parse(fs.readFileSync(holdoutFile, 'utf8')).samples)
    : new Set();
  // ports per control — depth planning prefers thinly-covered controls
  const portsPerEntity = new Map();
  for (const e of libs) for (const s of e.samples) {
    if (s.port && s.entity) portsPerEntity.set(s.entity, (portsPerEntity.get(s.entity) || 0) + 1);
  }
  const rows = libs.flatMap((e) => e.samples
    .filter((s) => s.scope === 'in' && !s.port)
    .map((s) => ({
      lib: e.lib, entity: s.entity, name: s.name,
      covered: portsPerEntity.get(s.entity) || 0,
      holdout: holdout.has(`${e.lib}.sample.${s.name}`),
    })));
  // breadth first (uncovered controls), then DEPTH: ascending by how many
  // ports the control already has — a control with one port still yields
  // more new idioms than one with five (AGENTS §1 depth criteria)
  rows.sort((a, b) => (a.covered - b.covered)
    || a.entity.localeCompare(b.entity) || a.name.localeCompare(b.name));
  for (const r of rows) {
    console.log(`${r.lib}\t${r.entity}\t${r.name}\t${r.covered === 0 ? 'NEW-CONTROL' : `covered-control(${r.covered})`}${r.holdout ? '\tHOLDOUT' : ''}`);
  }
  const n = rows.filter((r) => r.covered === 0 && !r.holdout).length;
  console.log(`# ${rows.length} in-scope unported samples; ${n} on uncovered controls (plan these first, HOLDOUT excluded; then depth = lowest covered-control(n) first)`);
  process.exit(0);
}

// integrity: a port that matches no universe sample would silently vanish
// from the coverage — report it loudly instead. Every port in this repo rebuilds
// an OpenUI5 demo kit sample (AGENTS §3), so there is no legitimate reason for a
// port to sit outside the universe.
const matched = new Set(libs.flatMap((e) => e.samples.map((s) => `${e.lib}\t${s.name}`)));
for (const key of ported.keys()) {
  if (matched.has(key)) continue;
  const sampleId = key.replace('\t', '.sample.');
  console.warn(`WARNING: orphan port ${sampleId} — not in the sample universe (renamed/removed upstream, or outside FOCUS_LIBS?)`);
}

// --- 3. render --------------------------------------------------------------
const pct = (n, d) => (d === 0 ? '—' : `${((n / d) * 100).toFixed(1)} %`);
const bar = (n, d) => {
  if (d === 0) return '';
  // clamp: the coverage ratio must never leave [0,1] — an out-of-range value
  // used to crash the whole gate chain in String.repeat (RangeError) instead
  // of reporting the miscount it stands for
  const filled = Math.min(10, Math.max(0, Math.round((n / d) * 10)));
  return '█'.repeat(filled) + '░'.repeat(10 - filled);
};

// "Ported" counts IN-SCOPE ports only — a documented out-of-scope port
// (ui5/scope-exceptions.json) is not coverage of the in-scope backlog, and
// counting it as such made sap.ui.core read 19/20 while 18 of its ports were
// in scope (and 21/20 once the batch closed the gap).
const summary = libs
  .map((l) => ({
    lib: l.lib,
    total: l.samples.length,
    inScope: l.samples.filter((s) => s.scope === 'in').length,
    ported: l.samples.filter((s) => s.port && s.scope === 'in').length,
    portedOut: l.samples.filter((s) => s.port && s.scope !== 'in').length,
  }))
  .sort((a, b) => {
    // a lib with inScope 0 must sort deterministically, not on NaN
    const r = (s) => (s.inScope ? s.ported / s.inScope : -1);
    return (r(b) - r(a)) || a.lib.localeCompare(b.lib);
  });

let totalSamples = 0;
let totalInScope = 0;
let totalPorted = 0;
let totalPortedOut = 0;
const outBy = { deprecated: 0, newer: 0, nonapp: 0, unknown: 0 };
for (const s of summary) { totalSamples += s.total; totalInScope += s.inScope; totalPorted += s.ported; totalPortedOut += s.portedOut; }
for (const e of libs) for (const s of e.samples) if (s.scope !== 'in') outBy[s.scope]++;

// README block: overall figure + coverage-per-module summary table
function summaryLines() {
  const l = [];
  l.push(`Overall **${totalPorted} / ${totalInScope}** in-scope demo kit samples ported (${pct(totalPorted, totalInScope)}).`);
  l.push(`**In scope**: samples whose control exists since **UI5 1.71** and is **not deprecated** (legacy-free ready).`);
  l.push(`Out of scope: ${totalSamples - totalInScope} of ${totalSamples} samples — ${outBy.deprecated} on deprecated controls, ${outBy.newer} on controls newer than 1.71, ${outBy.nonapp} that are not app views (UI5 test infrastructure, Component routing, view-templating demos — see \`ui5/scope-nonapp.json\`), ${outBy.unknown} demo apps without an owning control.`);
  if (totalPortedOut) l.push(`Plus **${totalPortedOut}** ported samples outside that scope — maintainer-decided exceptions (\`ui5/scope-exceptions.json\`, listed in [STATUS.md](STATUS.md)); they are not counted as coverage of the in-scope backlog.`);
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
  l.push('(not legacy-free ready / not 1.71-compatible), or the sample is not an app');
  l.push('view at all (UI5 test infrastructure, Component routing, view-templating and');
  l.push('XMLComposite authoring demos — `ui5/scope-nonapp.json`) — these samples are');
  l.push('listed for completeness but are not ported. A **⁺** after the class marks ports');
  l.push('that keep members newer than UI5 1.71 for 1:1 fidelity (declared as');
  l.push('POST_171 in the sidecar) — they need a correspondingly recent UI5.');
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
      ? `[${s.port.cls}](${abapUrl(s.port.file)})${s.port.post171 ? ' **⁺**' : ''}`
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

// README — splice the generation prompt from its single source
// (scripts/generation-prompt.txt; the port-a-sample guide stays the authoritative long form)
const PROMPT_START = '<!-- prompt:start -->';
const PROMPT_END = '<!-- prompt:end -->';
const promptFile = path.join(ROOT, 'scripts', 'generation-prompt.txt');
if (!fs.existsSync(promptFile)) {
  console.error(`missing ${path.relative(ROOT, promptFile)} — the README prompt block is spliced from it.`);
  process.exit(1);
}
if (readme.includes(PROMPT_START) && readme.includes(PROMPT_END)) {
  const prompt = fs.readFileSync(promptFile, 'utf8');
  const pblock = `${PROMPT_START}\n\`\`\`\n${prompt.replace(/\n*$/, '\n')}\`\`\`\n${PROMPT_END}`;
  readme = readme.replace(new RegExp(`${PROMPT_START}[\\s\\S]*?${PROMPT_END}`), () => pblock);
} else {
  console.error(`README.md is missing the ${PROMPT_START} / ${PROMPT_END} markers.`);
  process.exit(1);
}
fs.writeFileSync(README, readme);

console.log(`api.md + README: ${totalPorted}/${totalInScope} in-scope samples ported across ${libs.length} libraries` +
  (release ? ` (metadata from OpenUI5 ${release})` : ' (no api.json — Since column blank)'));
