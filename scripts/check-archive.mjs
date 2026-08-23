#!/usr/bin/env node
/*
 * check-archive — every file a sample's manifest lists is actually archived.
 *
 * WHY: AGENTS.md section 4 says archive EVERYTHING the sample's manifest.json
 * lists under `sap.ui5 > config > sample > files`, "or fidelity cannot be
 * verified offline". Nothing checked it, and the failure mode is silent in the
 * worst way: a port is re-read against an archive that LOOKS complete, the
 * missing file is the one carrying the behaviour, and the re-read comes back
 * clean. `ui5/sap.ui.layout/GridAutoFlow/` was exactly that on 2026-08-23 —
 * its controller's only dependency, `RevealGrid/RevealGrid.js`, was absent
 * while the sidecar claimed "closing the AGENTS section 4 archive gap".
 *
 * Two scopes, deliberately not the same severity:
 *
 *   inside the sample folder   an ERROR. This is the sample's own material;
 *                              if it is missing, the archive is incomplete
 *                              and nobody can tell by looking.
 *   `../<Shared*>/...`         REPORTED, never an error. AGENTS section 4
 *                              carries an explicit exception for these: the
 *                              uxap manifests OVER-LIST, naming the whole
 *                              `../SharedBlocks/` set regardless of what the
 *                              view instantiates, and structural-diff resolves
 *                              manifest-listed `../<OtherSample>/*.view.xml`,
 *                              so archiving them would make it demand phantom
 *                              controls from correct ports. They are counted
 *                              here so the exception stays visible and its
 *                              size is known — not so someone backfills it.
 *
 * `scripts/archive-absent.json` allowlists files that are listed upstream but
 * genuinely not fetchable (binaries the corpus does not archive, manifest
 * entries the demo kit never served). Each entry carries a reason, and an
 * entry whose file DOES exist is an error — an allowlist that outlives its
 * gap is how the next one hides.
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const UI5 = path.join(ROOT, 'ui5');

let errors = 0;
const err = (m) => { console.error(`ERROR ${m}`); errors++; };

const allowFile = path.join(ROOT, 'scripts', 'archive-absent.json');
const allow = fs.existsSync(allowFile) ? JSON.parse(fs.readFileSync(allowFile, 'utf8')) : {};
for (const [k, reason] of Object.entries(allow)) {
  if (typeof reason !== 'string' || !reason.trim()) err(`archive-absent.json: ${k} carries no reason`);
}
const allowUsed = new Set();

const samples = [];
for (const lib of fs.readdirSync(UI5)) {
  const libDir = path.join(UI5, lib);
  if (!fs.statSync(libDir).isDirectory()) continue;
  for (const name of fs.readdirSync(libDir)) {
    const dir = path.join(libDir, name);
    if (!fs.statSync(dir).isDirectory()) continue;
    if (fs.existsSync(path.join(dir, 'manifest.json'))) samples.push([lib, name, dir]);
  }
}

let listed = 0;
const shared = new Map();   // relative path -> Set of samples referencing it

for (const [lib, name, dir] of samples) {
  let manifest;
  try {
    manifest = JSON.parse(fs.readFileSync(path.join(dir, 'manifest.json'), 'utf8'));
  } catch (e) {
    err(`ui5/${lib}/${name}/manifest.json is not parseable — ${e.message}`);
    continue;
  }
  const files = manifest?.['sap.ui5']?.config?.sample?.files;
  if (!Array.isArray(files)) continue;

  for (const rel of files) {
    listed++;
    const abs = path.resolve(dir, rel);
    if (fs.existsSync(abs)) continue;
    const key = path.relative(UI5, abs).split(path.sep).join('/');

    if (rel.startsWith('..')) {
      if (!shared.has(key)) shared.set(key, new Set());
      shared.get(key).add(`${lib}/${name}`);
      continue;
    }
    if (key in allow) { allowUsed.add(key); continue; }
    err(`ui5/${lib}/${name}/manifest.json lists ${rel}, which is not archived — fetch it or allowlist it in scripts/archive-absent.json with a reason`);
  }
}

for (const key of Object.keys(allow)) {
  if (allowUsed.has(key)) continue;
  const abs = path.join(UI5, key);
  err(fs.existsSync(abs)
    ? `archive-absent.json still allowlists ui5/${key}, which now exists — drop the entry`
    : `archive-absent.json allowlists ui5/${key}, which no manifest lists — drop the entry`);
}

let advisory = '';
if (shared.size) {
  const owners = new Set();
  for (const s of shared.values()) for (const o of s) owners.add(o);
  advisory = `, ${shared.size} cross-sample file(s) under ${[...new Set([...shared.keys()].map((k) => k.split('/').slice(0, 2).join('/')))].join(', ')} unarchived for ${owners.size} sample(s) (the AGENTS section 4 exception — deliberate, see the header)`;
}

if (errors) {
  console.log(`check-archive: ${errors} error(s).`);
  process.exit(1);
}
console.log(`check-archive: ${samples.length} archived sample(s), ${listed} manifest-listed file(s), 0 error(s)${advisory}.`);
