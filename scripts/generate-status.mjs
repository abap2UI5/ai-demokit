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
const libCount = {}; // src/01 -> n
let sdiffSkips = 0;
let rsmokeSkips = 0;
for (const p of ports) {
  statusCount[p.status] = (statusCount[p.status] || 0) + 1;
  for (const d of p.deviations || []) {
    devCount[d.type] = (devCount[d.type] || 0) + 1;
    if (d.type === 'LIVE_TEST') liveTestPorts.add(p.class);
  }
  const m = String(p.file || '').match(/^src\/(\d+)\//);
  if (m) libCount[`src/${m[1]}`] = (libCount[`src/${m[1]}`] || 0) + 1;
  if (p.structural_diff?.skip) sdiffSkips++;
  if (p.render_smoke?.skip) rsmokeSkips++;
}

// --- scope verdict per ported sample (same fallback as generate-coverage) ----
const uni = JSON.parse(fs.readFileSync(path.join(ROOT, 'ui5', 'universe.json'), 'utf8'));
const props = JSON.parse(fs.readFileSync(path.join(ROOT, 'ui5', 'properties.json'), 'utf8')).controls || {};
const overrides = fs.existsSync(path.join(ROOT, 'ui5', 'entity-overrides.json'))
  ? JSON.parse(fs.readFileSync(path.join(ROOT, 'ui5', 'entity-overrides.json'), 'utf8')).overrides || {}
  : {};
const uniMap = new Map();
for (const l of uni.libs) for (const s of l.samples) uniMap.set(`${l.lib}.sample.${s.name}`, s);
const sinceLeq171 = (since) => {
  if (!since) return true;
  const m = String(since).match(/^(\d+)\.(\d+)/);
  return m ? (+m[1] < 1 || (+m[1] === 1 && +m[2] <= 71)) : false;
};
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
const libLine = Object.keys(libCount).sort()
  .map((k) => `${k}: ${libCount[k]}`)
  .join(' · ');

const lines = [];
lines.push('| Aspect | State |');
lines.push('|---|---|');
lines.push(`| Ports | **${ports.length}** sidecars in \`meta/\` (${libLine}) |`);
lines.push(`| Status ladder | ${statusCount.generated} \`generated\` · ${statusCount.reviewed} \`reviewed\` · ${statusCount.checked} \`checked\` (live-verified) |`);
lines.push(`| Deviations | ${devLine} |`);
lines.push(`| Open LIVE_TESTs | **${liveTestPorts.size} ports** carry at least one \`LIVE_TEST\` deviation — the automated close path is the e2e interaction harness (AGENTS §6 \`e2e_smoke\`) |`);
lines.push(`| Declared gate skips | ${sdiffSkips} structural-diff · ${rsmokeSkips} render-smoke (each re-verified per run — a stale skip FAILS) |`);
lines.push(`| Out-of-scope ported samples | ${outOfScope.length === 0 ? 'none' : outOfScope.map((s) => `\`${s}\``).join(' · ')}${outOfScope.length ? ' — standing debt pending a maintainer decision (drop vs documented exception), surfaced by the source-backed scope gate (pr/scope-since-from-source)' : ''} |`);
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
