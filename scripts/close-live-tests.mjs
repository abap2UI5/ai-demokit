#!/usr/bin/env node
/*
 * close-live-tests — turn verified LIVE_TEST deviations into NOTEs.
 *
 * A LIVE_TEST deviation says "this wire is not verified in a running app".
 * The nightly e2e (e2e-nightly.yaml) runs every port with its interaction
 * module (meta/interactions/<class>.mjs) — the moment that module drives
 * exactly the wire the deviation names
 * and stays green, the deviation is closable. Closing used to be manual
 * (STATUS.md kept a standing reminder); this script does the mechanical part
 * without the known trap: the deviation TEXT is kept VERBATIM (only prefixed),
 * because structural-diff and view-gates match their declared-skip/deviation
 * coverage on substrings of that text — rewriting it silently un-declares
 * whatever it covered (AGENTS §10).
 *
 *   node scripts/close-live-tests.mjs               list closure candidates
 *   node scripts/close-live-tests.mjs --close 043 096 149
 *                                                   close the named ports
 *
 * Only close ports whose interaction is GREEN in the latest nightly run (or a
 * local `node scripts/e2e-smoke.mjs --strict --only <nums>`): the script
 * rewrites sidecars, it does not run the browser itself. After closing, run
 * the offline gates — the STATUS/README counts regenerate via the pre-commit
 * hook.
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const META = path.join(ROOT, 'meta');

const argv = process.argv.slice(2);
const closeAt = argv.indexOf('--close');
const toClose = closeAt === -1 ? null : argv.slice(closeAt + 1).filter((a) => /^\d+$/.test(a));
if (closeAt !== -1 && !toClose.length) {
  console.error('usage: node scripts/close-live-tests.mjs [--close <num> [<num> …]]');
  process.exit(2);
}

// the interaction set — one module per port under meta/interactions/ (the
// same directory e2e-smoke.mjs loads); an entry is the precondition for
// closure (no interaction, nothing verified the wire)
const INTERACTIONS_DIR = path.join(ROOT, 'meta', 'interactions');
const interactions = new Set(fs.existsSync(INTERACTIONS_DIR)
  ? fs.readdirSync(INTERACTIONS_DIR).filter((f) => f.endsWith('.mjs')).map((f) => f.replace(/\.mjs$/, ''))
  : []);

const today = new Date().toISOString().slice(0, 10);
let closed = 0;
const candidates = [];

for (const f of fs.readdirSync(META).filter((f) => /app_\d+\.json$/.test(f)).sort()) {
  const p = path.join(META, f);
  const text = fs.readFileSync(p, 'utf8');
  const m = JSON.parse(text);
  const live = (m.deviations || []).filter((d) => d.type === 'LIVE_TEST');
  if (!live.length) continue;
  const num = m.class.replace('z2ui5_cl_smpc_app_', '');
  const hasInteraction = interactions.has(m.class);
  candidates.push({ num, cls: m.class, count: live.length, hasInteraction });

  if (!toClose || !toClose.includes(num)) continue;
  if (!hasInteraction) {
    console.error(`refusing to close ${m.class}: no meta/interactions/${m.class}.mjs — nothing ever verified the wire`);
    process.exitCode = 1;
    continue;
  }
  for (const d of m.deviations) {
    if (d.type !== 'LIVE_TEST') continue;
    d.type = 'NOTE';
    // APPEND, never prefix — the original wording stays verbatim either way (so
    // every substring a gate matches against keeps matching), but a prefix
    // leaves the entry reading "live-verified …: Unverified in a running
    // system: …", which says both things at once and is exactly what a reader
    // checking whether a wire is covered must not have to untangle. It stated
    // itself 23 times before this was fixed on 2026-08-21. The house form is
    // app 264's: what was unverified, then the verification.
    d.what = `${d.what} **e2e-verified ${today}** (nightly e2e interaction, meta/interactions/${m.class}.mjs).`;
  }
  fs.writeFileSync(p, JSON.stringify(m, null, 2) + '\n');
  closed++;
  console.log(`closed ${m.class}: ${live.length} LIVE_TEST -> NOTE`);
}

if (!toClose) {
  console.log('LIVE_TEST closure candidates (close only what the nightly ran GREEN):\n');
  for (const c of candidates) {
    console.log(`  ${c.hasInteraction ? 'ready  ' : 'BLOCKED'}  ${c.num}  ${c.count} LIVE_TEST deviation(s)${c.hasInteraction ? '' : ' — no meta/interactions module yet'}`);
  }
  console.log(`\n${candidates.length} port(s) carry LIVE_TEST; ${candidates.filter((c) => c.hasInteraction).length} have an interaction.`);
  console.log('Close with: node scripts/close-live-tests.mjs --close <num> [<num> …]');
} else {
  console.log(`\nclosed ${closed} port(s). Now run: node scripts/validate-meta.mjs && node scripts/pattern-lint.mjs`);
  console.log('(STATUS/README counts regenerate via the pre-commit hook.)');
}
