#!/usr/bin/env node
/*
 * Regenerates the "Current state" block in STATUS.md between the
 * <!-- state:start --> / <!-- state:end --> markers — every countable fact
 * comes from meta/ (the source of truth) and ui5/universe.json, so the
 * point-in-time table can never drift from the corpus again (the drift the
 * old hand-maintained "Where the repo stands" table accumulated: it froze at
 * 109 ports / 67 sidecars while the corpus grew to 246).
 *
 * Wired like generate-overview/generate-coverage: the .githooks/pre-commit
 * hook regenerates + stages it on every commit, and the meta_valid CI job
 * fails a PR whose STATUS.md block is stale. The rest of STATUS.md (the open
 * findings backlog) stays hand-maintained; the journal lives in
 * STATUS-history.md.
 *
 * Run:  node scripts/generate-status.mjs
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import {
  loadUniverseSnapshot, withSapui5, loadPropertiesControls, loadEntityOverrides, sinceLeq171,
} from './lib-universe.mjs';
import { CAT_CTEXT, LIB_CTEXT } from './lib-packages.mjs';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const META = path.join(ROOT, 'meta');
const STATUS = path.join(ROOT, 'STATUS.md');
const START = '<!-- state:start -->';
const END = '<!-- state:end -->';

// --- collect the sidecars ----------------------------------------------------
const ports = [];
for (const mf of fs.readdirSync(META).sort()) {
  if (!mf.endsWith('.json')) continue;
  ports.push(JSON.parse(fs.readFileSync(path.join(META, mf), 'utf8')));
}

const statusCount = { generated: 0, reviewed: 0, checked: 0 };
const devCount = {};
const liveTestPorts = new Set();
const catCount = {}; // src/01 -> n  (UI5 flavour x release, AGENTS §3)
const libCount = {}; // sap.m -> n
let sdiffSkips = 0;
let rsmokeSkips = 0;
for (const p of ports) {
  statusCount[p.status] = (statusCount[p.status] || 0) + 1;
  for (const d of p.deviations || []) {
    devCount[d.type] = (devCount[d.type] || 0) + 1;
    if (d.type === 'LIVE_TEST') liveTestPorts.add(p.class);
  }
  const m = String(p.file || '').match(/^src\/(\d+)\/(\d+)\//);
  if (m) {
    catCount[`src/${m[1]}`] = (catCount[`src/${m[1]}`] || 0) + 1;
    const lib = LIB_CTEXT[m[2]] || `src/../${m[2]}`;
    libCount[lib] = (libCount[lib] || 0) + 1;
  }
  if (p.structural_diff?.skip) sdiffSkips++;
  if (p.render_smoke?.skip) rsmokeSkips++;
}

// --- scope verdict per ported sample (same fallback as generate-coverage,
//     via the shared lib-universe loaders) ------------------------------------
const uni = withSapui5(loadUniverseSnapshot());
if (!uni) { console.error('ui5/universe.json missing — the state block needs the sample-universe snapshot.'); process.exit(1); }
const props = loadPropertiesControls();
const overrides = loadEntityOverrides();
const uniMap = new Map();
for (const l of uni.libs) for (const s of l.samples) uniMap.set(`${l.lib}.sample.${s.name}`, s);
const outOfScope = [];
for (const p of ports) {
  const s = uniMap.get(p.sample);
  if (!s) continue;
  const entity = overrides[p.sample] || s.entity;
  const c = entity && props[entity];
  const since = s.since || c?.since || null;
  const deprecated = s.deprecated || c?.deprecated || null;
  if (deprecated) outOfScope.push(`${p.class} (${p.sample} — deprecated)`);
  else if (!sinceLeq171(since)) outOfScope.push(`${p.class} (${p.sample} — control @since ${since})`);
}

// --- render -------------------------------------------------------------------
const devLine = Object.keys(devCount).sort()
  .map((t) => `${devCount[t]} ${t}`)
  .join(' · ') || 'none';
const catLine = Object.keys(catCount).sort()
  .map((k) => `${k} ${CAT_CTEXT[k.slice(-2)]}: ${catCount[k]}`)
  .join(' · ');
const libLine = Object.keys(libCount).sort()
  .map((k) => `${k}: ${libCount[k]}`)
  .join(' · ');

const lines = [];
lines.push('| Aspect | State |');
lines.push('|---|---|');
lines.push(`| Ports | **${ports.length}** sidecars in \`meta/\` (${catLine}) |`);
lines.push(`| Per library | ${libLine} |`);
lines.push(`| Status ladder | ${statusCount.generated} \`generated\` · ${statusCount.reviewed} \`reviewed\` · ${statusCount.checked} \`checked\` (live-verified) |`);
lines.push(`| Deviations | ${devLine} |`);
lines.push(`| Open LIVE_TESTs | **${liveTestPorts.size} ports** carry at least one \`LIVE_TEST\` deviation — the automated close path is the e2e interaction harness (AGENTS §6 \`e2e_smoke\`) |`);
lines.push(`| Declared gate skips | ${sdiffSkips} structural-diff · ${rsmokeSkips} render-smoke (each re-verified per run — a stale skip FAILS) |`);
lines.push(`| Out-of-scope ported samples | ${outOfScope.length === 0 ? 'none' : outOfScope.map((s) => `\`${s}\``).join(' · ')}${outOfScope.length ? ' — all decided KEEP permanently 2026-07-30 (per-app rationale in ui5/scope-exceptions.json, revertible); the source-backed scope gate stays hard for NEW undecided entries' : ''} |`);
lines.push('');
lines.push('_Coverage per library (ported / in scope) is generated into the [README](README.md#coverage); one row per sample in [api.md](api.md)._');

let status = fs.readFileSync(STATUS, 'utf8');
if (!status.includes(START) || !status.includes(END)) {
  console.error(`STATUS.md is missing the ${START} / ${END} markers.`);
  process.exit(1);
}
status = status.replace(
  new RegExp(`${START}[\\s\\S]*?${END}`),
  () => `${START}\n\n${lines.join('\n')}\n\n${END}`);
fs.writeFileSync(STATUS, status);
console.log(`STATUS.md state block: ${ports.length} ports, ${liveTestPorts.size} with open LIVE_TESTs, ${outOfScope.length} out-of-scope`);
