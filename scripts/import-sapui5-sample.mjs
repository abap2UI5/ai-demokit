#!/usr/bin/env node
/*
 * import-sapui5-sample — turn a downloaded SAPUI5 demo kit sample into the two
 * things a port needs: a template folder under SAPUI5_SRC and a row in
 * ui5/universe-sapui5.json. After it, `npm run scaffold <sample>` works exactly
 * as it does for an OpenUI5 sample (AGENTS §3).
 *
 *   node scripts/import-sapui5-sample.mjs <dir> [--entity sap.x.Y] [--dry-run]
 *
 * WHY a downloaded folder and not a fetch: SAPUI5 is not on GitHub and its npm
 * packages ship only `src/` (no demokit tree), so the sample sources exist in
 * exactly one place — the SDK web app on ui5.sap.com. Where that host is
 * reachable, mirroring it is a `curl` loop over the manifest's file list; where
 * it is not (an allow-listed sandbox), the SDK's own "Download Sample" button
 * produces the same files by hand. This importer takes it from there, so both
 * routes end in the identical, verifiable state.
 *
 *   Sample viewer  https://ui5.sap.com/resources/sap/ui/documentation/sdk/index.html
 *                    ?sap-ui-xx-sample-id=<lib>.sample.<Name>&sap-ui-xx-sample-lib=<lib>
 *   Raw sources    https://ui5.sap.com/test-resources/<lib path>/demokit/sample/<Name>/
 *   Library index  https://ui5.sap.com/test-resources/<lib path>/demokit/docuindex.json
 *
 * What it does, and refuses to guess at:
 *   - reads manifest.json for the sample id (sap.app.id) -> lib + name, and for
 *     the file list (sap.ui5.config.sample.files) — the same list AGENTS §4
 *     requires archiving, so a sample missing one of its files is refused here
 *     rather than half-ported later;
 *   - copies exactly those files (plus manifest.json / Component.js) into
 *     $SAPUI5_SRC/<lib>/<Name>/;
 *   - upserts the universe row, taking @since / @deprecated from the pinned
 *     @sapui5 packages through scope-of's verdict — never from the download,
 *     which carries no control metadata at all;
 *   - refuses a DEPRECATED control outright (AGENTS §1), the way scaffold.mjs
 *     does, so the row can never describe a sample that must not be ported.
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { isSapui5Lib, UNIVERSE_SAPUI5_PATH } from './lib-universe.mjs';
import { verdict } from './scope-of.mjs';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');

const argv = process.argv.slice(2);
const flags = {};
const positional = [];
for (let i = 0; i < argv.length; i++) {
  const a = argv[i];
  if (a === '--entity') flags.entity = argv[++i];
  else if (a === '--dry-run') flags.dryRun = true;
  else positional.push(a);
}
const srcDir = positional[0];
if (!srcDir) {
  console.error('usage: node scripts/import-sapui5-sample.mjs <downloaded sample dir> [--entity sap.x.Y] [--dry-run]');
  process.exit(2);
}
if (!fs.existsSync(srcDir)) {
  console.error(`not found: ${srcDir}`);
  process.exit(1);
}

// ---------- the manifest decides what this sample IS ----------
const manifestPath = path.join(srcDir, 'manifest.json');
if (!fs.existsSync(manifestPath)) {
  console.error(`no manifest.json in ${srcDir} — a demo kit sample download always contains one (unzip the SDK's "Download Sample" archive first).`);
  process.exit(1);
}
let manifest;
try {
  manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
} catch (e) {
  console.error(`manifest.json is not valid JSON: ${e.message}`);
  process.exit(1);
}
const sampleId = manifest['sap.app']?.id;
if (!sampleId || !sampleId.includes('.sample.')) {
  console.error(`manifest sap.app.id is "${sampleId || '(missing)'}" — expected <lib>.sample.<Name>.`);
  process.exit(1);
}
const lib = sampleId.slice(0, sampleId.indexOf('.sample.'));
const name = sampleId.slice(sampleId.indexOf('.sample.') + '.sample.'.length);
if (!isSapui5Lib(lib)) {
  console.error(`${lib} is an OpenUI5 library — import it from the checkout with scaffold.mjs (OPENUI5_SRC), not through this script.`);
  process.exit(1);
}

// ---------- the files the sample declares ----------
const declared = manifest['sap.ui5']?.config?.sample?.files || [];
const files = [...new Set(['manifest.json', 'Component.js', ...declared])]
  .filter((f) => fs.existsSync(path.join(srcDir, f)));
const missing = declared.filter((f) => !fs.existsSync(path.join(srcDir, f)));
if (missing.length) {
  console.error(`incomplete download — manifest lists files that are not here:\n  ${missing.join('\n  ')}`);
  console.error('AGENTS §4: everything the manifest lists must be archived, or fidelity cannot be verified offline.');
  process.exit(1);
}

// ---------- the control facts come from the packages, never the download ----
const entity = flags.entity || null;
if (!entity) {
  console.error(`pass --entity <control> — the download carries no control metadata, and the universe row needs the entity that owns the sample (it is what decides scope and where the port is filed).`);
  process.exit(1);
}
const v = verdict(entity);
if (v.reason.startsWith('UNRESOLVED')) {
  console.error(`cannot resolve ${entity} in the pinned @sapui5 packages — check the entity name, or add its library to package.json.`);
  process.exit(1);
}
if (!v.ok) {
  console.error(`refusing to import ${sampleId}: its control is out of scope — ${v.reason}`);
  console.error('AGENTS §1: a deprecated or post-1.71 control is never ported, whatever the flavour.');
  process.exit(1);
}

const SAPUI5_SRC = process.env.SAPUI5_SRC || path.join(ROOT, 'sapui5');
const targetDir = path.join(SAPUI5_SRC, lib, name);

console.log(`import ${sampleId}  (${entity} — ${v.reason})`);
console.log(`  template -> ${path.relative(ROOT, targetDir)}  (${files.length} file(s))`);
for (const f of files) console.log(`    + ${f}`);
console.log(`  universe row -> ${path.relative(ROOT, UNIVERSE_SAPUI5_PATH)}  (${lib} / ${name})`);
if (flags.dryRun) {
  console.log('\n(dry-run — nothing written)');
  process.exit(0);
}

// ---------- write the template ----------
for (const f of files) {
  const dst = path.join(targetDir, f);
  fs.mkdirSync(path.dirname(dst), { recursive: true });
  fs.copyFileSync(path.join(srcDir, f), dst);
}

// ---------- upsert the universe row ----------
const universe = fs.existsSync(UNIVERSE_SAPUI5_PATH)
  ? JSON.parse(fs.readFileSync(UNIVERSE_SAPUI5_PATH, 'utf8'))
  : {
    comment: 'The SAPUI5 half of the sample universe (AGENTS §3). Same shape as ui5/universe.json, kept in its own file because generate-coverage rebuilds that one wholesale from an OpenUI5 checkout. Rows are written by scripts/import-sapui5-sample.mjs; @since/@deprecated come from the pinned @sapui5 packages, not from the download.',
    release: null,
    libs: [],
  };
let libEntry = universe.libs.find((l) => l.lib === lib);
if (!libEntry) {
  libEntry = { lib, samples: [] };
  universe.libs.push(libEntry);
  universe.libs.sort((a, b) => a.lib.localeCompare(b.lib));
}
const row = { name, entity, since: v.since || null, deprecated: null };
const idx = libEntry.samples.findIndex((s) => s.name === name);
if (idx >= 0) libEntry.samples[idx] = row; else libEntry.samples.push(row);
libEntry.samples.sort((a, b) => a.name.localeCompare(b.name));
fs.writeFileSync(UNIVERSE_SAPUI5_PATH, JSON.stringify(universe, null, 1) + '\n');

console.log('\nnext:');
console.log(`  SAPUI5_SRC=${path.relative(ROOT, SAPUI5_SRC) || '.'} node scripts/scaffold.mjs ${sampleId}`);
