#!/usr/bin/env node
/*
 * Regenerates two docs: every official UI5 demo kit sample of every library,
 * marked with whether an abap2UI5 port exists.
 *   - api.md      coverage report (Javascript / ABAP / Link columns)
 *   - OVERVIEW.md same tables plus a rightmost System column that launches the
 *                 app in the abap2UI5 system
 *
 * Universe of samples : an OpenUI5 checkout (env OPENUI5_DIR, default ./openui5)
 *                       src/<lib>/test/<lib>/demokit/sample/<Name>/
 * Ported samples      : this repo's src/**\/*.clas.abap, each carrying
 *                       "! Rebuild of the UI5 demo kit sample: <url>.../sample/<lib>.sample.<Name>
 *
 * All table links are external (absolute). Env: OPENUI5_DIR, REPO, REF,
 * DEMOKIT, SYSTEM.
 *
 * Run:  OPENUI5_DIR=../openui5 node scripts/generate-coverage.mjs
 */

import fs from 'fs';
import path from 'path';

const ROOT = path.join(path.dirname(new URL(import.meta.url).pathname), '..');
const SRC = path.join(ROOT, 'src');
const OPENUI5_DIR = process.env.OPENUI5_DIR || path.join(ROOT, 'openui5');
const COVERAGE = path.join(ROOT, 'api.md');
const OVERVIEW = path.join(ROOT, 'OVERVIEW.md');

// link targets (overridable via env) — all links are external/absolute
const REPO = process.env.REPO || 'abap2UI5/api';   // owner/name
const REF = process.env.REF || 'main';             // branch the links resolve on
const GH = `https://github.com/${REPO}`;
const DEMOKIT = process.env.DEMOKIT || 'https://sapui5.hana.ondemand.com/sdk/#';
// abap2UI5 system that serves the apps — set SYSTEM to your deployment host
const SYSTEM = process.env.SYSTEM || 'https://your-system.example.com/sap/bc/z2ui5';
// live demo kit sample app (needs the entity the sample belongs to)
const demokitUrl = (entity, sampleId) => `${DEMOKIT}/entity/${entity}/sample/${sampleId}`;
// collected JS template folder under ui5/
const templateUrl = (lib, cls) => `${GH}/tree/${REF}/ui5/${lib}/${cls}`;
// generated abap2UI5 class file under src/
const abapUrl = (file) => `${GH}/blob/${REF}/${file.split(path.sep).join('/')}`;
// start the app in the abap2UI5 system
const systemUrl = (cls) => `${SYSTEM}?app_start=${cls.toUpperCase()}`;

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

// shared summary block (coverage per module)
function summaryLines() {
  const l = [];
  l.push(`Every official UI5 demo kit sample per library, marked ✅ ported / ❌ missing.`);
  l.push(`Overall **${totalPorted} / ${totalSamples}** (${pct(totalPorted, totalSamples)}).`);
  l.push('');
  l.push('## Coverage per module');
  l.push('');
  l.push('| Module | Samples | Ported | Coverage | |');
  l.push('|--------|--------:|-------:|---------:|---|');
  for (const s of summary) {
    l.push(`| \`${s.lib}\` | ${s.total} | ${s.ported} | ${pct(s.ported, s.total)} | ${bar(s.ported, s.total)} |`);
  }
  l.push(`| **Total** | **${totalSamples}** | **${totalPorted}** | **${pct(totalPorted, totalSamples)}** | ${bar(totalPorted, totalSamples)} |`);
  l.push('');
  return l;
}

// per-library detail tables; withSystem adds a rightmost launch-link column
function detailLines(withSystem) {
  const l = [];
  l.push('## Samples per module');
  l.push('');
  l.push('All links are external: **Javascript** → the collected UI5 template');
  l.push('(`ui5/` folder), **ABAP** → the generated class, **Link** → the live');
  l.push(withSystem
    ? 'demo kit sample app, **System** → starts the app in the abap2UI5 system.'
    : 'demo kit sample app.');
  l.push('');
  const head = withSystem ? '| | Javascript | ABAP | Link | System |' : '| | Javascript | ABAP | Link |';
  const sep = withSystem ? '|---|-----------|------|------|--------|' : '|---|-----------|------|------|';
  for (const { lib } of summary) {
    const entry = libs.find((e) => e.lib === lib);
    const p = entry.samples.filter((s) => s.port).length;
    l.push(`### \`${lib}\` — ${p}/${entry.samples.length} (${pct(p, entry.samples.length)})`);
    l.push('');
    l.push(head);
    l.push(sep);
    for (const s of entry.samples) {
      const js = s.port ? `[\`${s.name}\`](${templateUrl(lib, s.port.cls)})` : `\`${s.name}\``;
      const abap = s.port ? `[\`${s.port.cls}\`](${abapUrl(s.port.file)})` : '—';
      const link = s.entity ? `[demo kit ↗](${demokitUrl(s.entity, `${lib}.sample.${s.name}`)})` : '—';
      let row = `| ${s.port ? '✅' : '❌'} | ${js} | ${abap} | ${link} |`;
      if (withSystem) row += ` ${s.port ? `[start ▶](${systemUrl(s.port.cls)})` : '—'} |`;
      l.push(row);
    }
    l.push('');
  }
  return l;
}

const coverage = ['# abap2UI5 — UI5 demo kit sample coverage', '', ...summaryLines(), ...detailLines(false)];
fs.writeFileSync(COVERAGE, coverage.join('\n').trimEnd() + '\n');

const overview = [
  '# abap2UI5 — app overview',
  '',
  'Same as the [coverage](api.md) report, with a **System** column to launch each',
  'ported app directly in the abap2UI5 system.',
  '',
  ...summaryLines(),
  ...detailLines(true),
];
fs.writeFileSync(OVERVIEW, overview.join('\n').trimEnd() + '\n');

console.log(`api.md + OVERVIEW.md: ${totalPorted}/${totalSamples} ported across ${libs.length} libraries`);
