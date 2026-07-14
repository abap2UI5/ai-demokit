#!/usr/bin/env node
/*
 * Regenerates the coverage docs: every official UI5 demo kit sample of every
 * library, marked with whether an abap2UI5 port exists.
 *   - api.md    control-level detail: per library -> per control (entity) -> its
 *               samples (Javascript / ABAP / Link columns)
 *   - README.md per-module coverage summary (between the coverage markers)
 *
 * The in-system overview app (src/) is generated separately by
 * scripts/generate-overview.mjs.
 *
 * Universe of samples : an OpenUI5 checkout (env OPENUI5_DIR, default ./openui5)
 *                       src/<lib>/test/<lib>/demokit/sample/<Name>/
 * Ported samples      : this repo's src/**\/*.clas.abap, each carrying
 *                       "! Rebuild of the UI5 demo kit sample: <url>.../sample/<lib>.sample.<Name>
 *
 * All table links are external (absolute). Env: OPENUI5_DIR, REPO, REF, DEMOKIT.
 *
 * Run:  OPENUI5_DIR=../openui5 node scripts/generate-coverage.mjs
 */

import fs from 'fs';
import path from 'path';

const ROOT = path.join(path.dirname(new URL(import.meta.url).pathname), '..');
const SRC = path.join(ROOT, 'src');
const OPENUI5_DIR = process.env.OPENUI5_DIR || path.join(ROOT, 'openui5');
const COVERAGE = path.join(ROOT, 'api.md');
const README = path.join(ROOT, 'README.md');
const START = '<!-- coverage:start -->';
const END = '<!-- coverage:end -->';

// link targets (overridable via env) — all links are external/absolute
const REPO = process.env.REPO || 'abap2UI5/api';   // owner/name
const REF = process.env.REF || 'main';             // branch the links resolve on
const GH = `https://github.com/${REPO}`;
const DEMOKIT = process.env.DEMOKIT || 'https://sapui5.hana.ondemand.com/sdk/#';
// live demo kit sample app (needs the entity the sample belongs to)
const demokitUrl = (entity, sampleId) => `${DEMOKIT}/entity/${entity}/sample/${sampleId}`;
// UI5 API reference for a control (entity)
const apiUrl = (entity) => `${DEMOKIT}/api/${entity}`;
// collected JS template folder under ui5/
const templateUrl = (lib, cls) => `${GH}/tree/${REF}/ui5/${lib}/${cls}`;
// generated abap2UI5 class file under src/
const abapUrl = (file) => `${GH}/blob/${REF}/${file.split(path.sep).join('/')}`;

function walk(dir, out = []) {
  for (const name of fs.readdirSync(dir)) {
    const full = path.join(dir, name);
    if (fs.statSync(full).isDirectory()) walk(full, out);
    else out.push(full);
  }
  return out;
}

// --- 1. ported set: (lib, name) -> { cls, file, entity } ------------------
const ported = new Map(); // key `${lib}\t${name}` -> { cls, file, entity }
for (const f of walk(SRC)) {
  if (!f.endsWith('.clas.abap')) continue;
  const cls = path.basename(f, '.clas.abap');
  // ...#/entity/<entity>/sample/<lib>.sample.<Name>
  const m = fs.readFileSync(f, 'utf8')
    .match(/Rebuild of the UI5 demo kit sample:\s*\S*?(?:entity\/([^/\s]+)\/)?sample\/(\S+)/);
  if (!m) continue;
  const entity = m[1] || null;
  const id = m[2];                       // e.g. sap.m.sample.FacetFilterLight
  const i = id.indexOf('.sample.');
  if (i === -1) continue;
  const lib = id.slice(0, i);
  const name = id.slice(i + '.sample.'.length);
  ported.set(`${lib}\t${name}`, { cls, file: path.relative(ROOT, f), entity });
}

// --- 2. universe: all demo kit samples in the OpenUI5 checkout -------------
if (!fs.existsSync(OPENUI5_DIR)) {
  console.error(`OpenUI5 checkout not found at ${OPENUI5_DIR} (set OPENUI5_DIR).`);
  process.exit(1);
}

// sample id -> owning entity, parsed from each library's demokit docuindex.json
// (explored.entities[].samples[]). First entity that lists a sample wins.
function entityMap(demokitDir) {
  const map = new Map(); // sampleId -> entity
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

const libs = []; // { lib, samples: [{ name, port, entity }] }
for (const lib of fs.readdirSync(path.join(OPENUI5_DIR, 'src')).sort()) {
  const demokitDir = path.join(OPENUI5_DIR, 'src', lib, 'test', lib.replace(/\./g, '/'), 'demokit');
  const sampleDir = path.join(demokitDir, 'sample');
  if (!fs.existsSync(sampleDir)) continue;
  const entOf = entityMap(demokitDir);
  const samples = fs.readdirSync(sampleDir)
    .filter((n) => fs.statSync(path.join(sampleDir, n)).isDirectory())
    .sort((a, b) => a.toLowerCase().localeCompare(b.toLowerCase()))
    .map((name) => {
      const port = ported.get(`${lib}\t${name}`) || null;
      const entity = entOf.get(`${lib}.sample.${name}`) || (port && port.entity) || null;
      return { name, port, entity };
    });
  if (samples.length) libs.push({ lib, samples });
}

// --- 3. render ------------------------------------------------------------
const pct = (n, d) => (d === 0 ? '—' : `${((n / d) * 100).toFixed(1)} %`);
const bar = (n, d) => {
  if (d === 0) return '';
  const filled = Math.round((n / d) * 10);
  return '█'.repeat(filled) + '░'.repeat(10 - filled);
};

// summary — sort by coverage desc, then library name
const summary = libs
  .map((l) => {
    const p = l.samples.filter((s) => s.port).length;
    return { lib: l.lib, total: l.samples.length, ported: p };
  })
  .sort((a, b) => (b.ported / b.total) - (a.ported / a.total) || a.lib.localeCompare(b.lib));

let totalSamples = 0;
let totalPorted = 0;
for (const s of summary) { totalSamples += s.total; totalPorted += s.ported; }

// README block: overall figure + coverage-per-module summary table
function summaryLines() {
  const l = [];
  l.push(`Overall **${totalPorted} / ${totalSamples}** demo kit samples ported (${pct(totalPorted, totalSamples)}).`);
  l.push('');
  l.push('| Module | Samples | Ported | Coverage | |');
  l.push('|--------|--------:|-------:|---------:|---|');
  for (const s of summary) {
    l.push(`| \`${s.lib}\` | ${s.total} | ${s.ported} | ${pct(s.ported, s.total)} | ${bar(s.ported, s.total)} |`);
  }
  l.push(`| **Total** | **${totalSamples}** | **${totalPorted}** | **${pct(totalPorted, totalSamples)}** | ${bar(totalPorted, totalSamples)} |`);
  return l;
}

// api.md — one table per module (library); Control is a column.
function controlLines() {
  const l = [];
  l.push('One table per module, one row per UI5 demo kit sample. **Name** is the demo');
  l.push('kit control; **Javascript** links to the collected UI5 template (`ui5/`),');
  l.push('**API** to the control\'s UI5 API reference, **Demo** to the live demo kit');
  l.push('app, **ABAP** to the generated class (`—` = not ported yet). See the');
  l.push('[README](README.md#coverage) for the per-module summary.');
  l.push('');

  for (const { lib } of summary) {
    const entry = libs.find((e) => e.lib === lib);
    const lp = entry.samples.filter((s) => s.port).length;
    l.push(`## ${lib} — ${lp}/${entry.samples.length} (${pct(lp, entry.samples.length)})`);
    l.push('');
    l.push('| Name | Javascript | API | Demo | ABAP |');
    l.push('|------|-----------|-----|------|------|');

    // sort by control (entity), then sample name; entity-less rows last
    const rows = [...entry.samples].sort((a, b) =>
      (a.entity ? 0 : 1) - (b.entity ? 0 : 1) ||
      (a.entity || '').toLowerCase().localeCompare((b.entity || '').toLowerCase()) ||
      a.name.toLowerCase().localeCompare(b.name.toLowerCase()));
    for (const s of rows) {
      const name = s.entity || '—';
      const js = s.port ? `[${s.name}](${templateUrl(lib, s.port.cls)})` : s.name;
      const api = s.entity ? `[↗](${apiUrl(s.entity)})` : '—';
      const demo = s.entity ? `[↗](${demokitUrl(s.entity, `${lib}.sample.${s.name}`)})` : '—';
      const abap = s.port ? `[${s.port.cls}](${abapUrl(s.port.file)})` : '—';
      l.push(`| ${name} | ${js} | ${api} | ${demo} | ${abap} |`);
    }
    l.push('');
  }
  return l;
}

// api.md — module -> control detail
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

console.log(`api.md + README: ${totalPorted}/${totalSamples} ported across ${libs.length} libraries`);
