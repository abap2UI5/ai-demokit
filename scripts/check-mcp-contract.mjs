#!/usr/bin/env node
/*
 * check-mcp-contract — the files and shapes the mcp-server server consumes.
 *
 * The MCP server (github.com/abap2UI5/mcp-server) reaches into this checkout by
 * file path: it spawns scripts, reads the capability map and patches the
 * lint config. Those names are therefore a public API of this repo — this
 * check makes renaming one of them fail here, where the rename happens,
 * instead of surfacing as an ENOENT in someone's editor. Offline, runs as
 * part of `npm run gates`.
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath, pathToFileURL } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const fail = [];
const need = (rel, why) => {
  if (!fs.existsSync(path.join(ROOT, rel))) fail.push(`${rel} missing — ${why}`);
};

// spawned / read directly by mcp-server (lib/repos.mjs probe, server.mjs, lib/runtime.mjs)
need('scripts/e2e-build.mjs', 'mcp-server build_backend spawns it (and probes the checkout with it)');
need('scripts/scope-of.mjs', 'mcp-server scope_of spawns it');
need('scripts/generation-prompt.txt', 'mcp-server generation_rules reads it');
need('scripts/lib-smoke.mjs', 'mcp-server run_app imports the BENIGN noise contract from it');
need('web/ci/patch_open_abap_xml.mjs', 'mcp-server incremental build (and scripts/e2e-build.mjs) execute it');
need('abaplint.jsonc', 'mcp-server deploy_app derives its dev lint config from it');
need('CAPABILITIES.md', 'mcp-server capabilities parses it on every query');

// the CAPABILITIES.md table shape the mcp-server parser expects: 4-column rows
// whose status cell carries one of the legend marks
const caps = fs.readFileSync(path.join(ROOT, 'CAPABILITIES.md'), 'utf8');
const MARKS = ['\u{2705}', '\u{1F536}', '\u{1F9EA}', '\u{274C}'];
const rows = caps
  .split('\n')
  .filter((l) => /^\|/.test(l) && MARKS.some((m) => l.includes(m)))
  .filter((l) => l.split('|').length >= 5);
if (rows.length < 20) {
  fail.push(`CAPABILITIES.md: only ${rows.length} 4-column marked table rows found (expected 20+) — did the table shape change? mcp-server parses it`);
}

// lib-smoke must actually export the list run_app imports
const smoke = await import(pathToFileURL(path.join(ROOT, 'scripts', 'lib-smoke.mjs')).href);
if (!Array.isArray(smoke.BENIGN) || !smoke.BENIGN.length) {
  fail.push('scripts/lib-smoke.mjs: BENIGN export missing or empty — mcp-server run_app imports it');
}

if (fail.length) {
  console.error('check-mcp-contract: FAIL');
  for (const f of fail) console.error(`  - ${f}`);
  process.exit(1);
}
console.log(`check-mcp-contract: ok (${rows.length} capability rows)`);
