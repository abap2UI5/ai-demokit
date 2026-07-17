#!/usr/bin/env node
/*
 * validate-meta — referential integrity for the per-port sidecars.
 *
 * meta/<class>.json is the SOURCE OF TRUTH for everything that used to live
 * in the ABAP Doc header (sample, entity, status, checked, deviations, audit)
 * — the port classes carry no header at all (enforced by pattern-lint). This
 * validator keeps the sidecars honest:
 *
 *   - schema: required fields, closed status/deviation-type vocabulary
 *   - referential: file exists, class matches, batch matches the path,
 *     the ui5/ template folder for the sample is archived
 *   - completeness: every port class has exactly one sidecar
 *
 * Run:  node scripts/validate-meta.mjs     (exit 1 on any error)
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const SRC = path.join(ROOT, 'src');
const META = path.join(ROOT, 'meta');
const UI5 = path.join(ROOT, 'ui5');

const STATUS = ['generated', 'reviewed', 'checked', 'golden'];
const DEV_TYPES = ['IMPROVISED', 'POST_171', 'DROPPED_171', 'LIVE_TEST', 'SUBSET_DATA', 'NOTE'];

let errors = 0;
const err = (m) => { console.log(`ERROR ${m}`); errors++; };

function walk(dir, out = []) {
  for (const name of fs.readdirSync(dir)) {
    const full = path.join(dir, name);
    if (fs.statSync(full).isDirectory()) walk(full, out);
    else out.push(full);
  }
  return out;
}

// port classes = every class in a batch subpackage src/<lib>/b<nn>/
const ports = walk(SRC)
  .filter((f) => f.endsWith('.clas.abap') && /src\/[^/]+\/b\d+\//.test(f.split(path.sep).join('/')))
  .map((f) => path.basename(f, '.clas.abap'));

const sidecars = fs.existsSync(META)
  ? fs.readdirSync(META).filter((f) => f.endsWith('.json'))
  : [];

for (const sf of sidecars.sort()) {
  const name = sf.replace(/\.json$/, '');
  let m;
  try { m = JSON.parse(fs.readFileSync(path.join(META, sf), 'utf8')); }
  catch (e) { err(`${sf}: invalid JSON — ${e.message}`); continue; }

  for (const k of ['class', 'sample', 'entity', 'file', 'batch', 'status', 'deviations']) {
    if (m[k] === undefined) err(`${sf}: missing field "${k}"`);
  }
  if (m.class && m.class !== name) err(`${sf}: class "${m.class}" does not match filename`);
  if (m.status && !STATUS.includes(m.status)) err(`${sf}: unknown status "${m.status}"`);
  if (['checked', 'golden'].includes(m.status) && !m.checked?.date) {
    err(`${sf}: status "${m.status}" requires a checked {date, note}`);
  }
  if (m.checked && !/^\d{4}-\d{2}-\d{2}$/.test(m.checked.date || '')) {
    err(`${sf}: checked.date must be YYYY-MM-DD`);
  }
  if (m.sample && !/^[\w.]+\.sample\.\w+$/.test(m.sample)) {
    err(`${sf}: sample "${m.sample}" is not <lib>.sample.<Name>`);
  }
  for (const d of m.deviations || []) {
    if (!DEV_TYPES.includes(d.type)) err(`${sf}: unknown deviation type "${d.type}"`);
    if (!d.what) err(`${sf}: deviation without "what" text`);
  }
  if (m.file) {
    const abs = path.join(ROOT, m.file);
    if (!fs.existsSync(abs)) err(`${sf}: file "${m.file}" does not exist`);
    else if (path.basename(abs, '.clas.abap') !== m.class) err(`${sf}: file does not match class`);
    const batch = m.file.match(/^src\/[^/]+\/(b\d+)\//)?.[1] ?? null;
    if (batch !== m.batch) err(`${sf}: batch "${m.batch}" does not match path ("${batch}")`);
  }
  if (m.sample) {
    const lib = m.sample.slice(0, m.sample.indexOf('.sample.'));
    const sname = m.sample.slice(m.sample.indexOf('.sample.') + '.sample.'.length);
    if (!fs.existsSync(path.join(UI5, lib, sname))) {
      err(`${sf}: template ui5/${lib}/${sname}/ is not archived`);
    }
  }
}

// completeness: every port has a sidecar, no orphan sidecars
const sidecarSet = new Set(sidecars.map((f) => f.replace(/\.json$/, '')));
for (const cls of ports) if (!sidecarSet.has(cls)) err(`port ${cls} has no meta/${cls}.json`);
const portSet = new Set(ports);
for (const cls of sidecarSet) if (!portSet.has(cls)) err(`meta/${cls}.json has no port class`);

console.log(`validate-meta: ${sidecars.length} sidecars, ${ports.length} ports, ${errors} error(s).`);
process.exit(errors ? 1 : 0);
