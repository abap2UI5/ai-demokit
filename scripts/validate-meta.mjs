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
 *   - referential: file exists in a library package, class matches,
 *     the ui5/ template folder for the sample is archived
 *   - completeness: every port class has exactly one sidecar
 *
 * Run:  node scripts/validate-meta.mjs     (exit 1 on any error)
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { portPath, catFolder, libFolder, sampleLib, CAT_CTEXT, LIB_CTEXT } from './lib-packages.mjs';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const SRC = path.join(ROOT, 'src');
const META = path.join(ROOT, 'meta');
const UI5 = path.join(ROOT, 'ui5');

const STATUS = ['generated', 'reviewed', 'checked'];
const DEV_TYPES = ['IMPROVISED', 'POST_171', 'DROPPED_171', 'LIVE_TEST', 'SUBSET_DATA', 'NOTE'];

/* Every key a sidecar may carry. A typo'd escape hatch (`structural_dif`,
 * `render_smok`) used to be silently ignored — the gate then ran as if
 * nothing was declared, which reads as "covered" when it is not. */
const KNOWN_KEYS = new Set([
  'class', 'sample', 'entity', 'file', 'batch', 'audit', 'status', 'checked',
  'deviations', 'render_smoke', 'data_fidelity', 'structural_diff',
]);

/* Hold-out samples (TRAINING.md): regenerated from scratch to measure the
 * generator — a hold-out port must never be promoted to `checked`, or the
 * measurement would train on its own yardstick. Was prose-only until now. */
const HOLDOUT = new Set(
  JSON.parse(fs.readFileSync(path.join(UI5, 'holdout.json'), 'utf8')).samples,
);

/* The balanced ( … ) body starting at src[open] === '(' — string-aware, the
 * same contract as the linter's parenRegion (a paren inside a backtick
 * literal or |…| template never counts). */
function parenBody(src, open) {
  let depth = 0;
  let str = null;
  for (let i = open; i < src.length; i++) {
    const c = src[i];
    if (str === '`') { if (c === '`') str = null; continue; }
    if (str === '|') {
      if (c === '\\') { i++; continue; }
      if (c === '|') str = null;
      continue;
    }
    if (c === '`' || c === '|') { str = c; continue; }
    if (c === '(') depth++;
    else if (c === ')' && --depth === 0) return src.slice(open + 1, i);
  }
  return src.slice(open + 1);
}

/** audit.event_t_arg, derived: does the class pass t_arg in ANY client event
 *  wire (backend `_event`, frontend `_event_client` / `follow_up_action`)?
 *  The stored flags had drifted beyond repair — a 2026-08-04 sweep found 44
 *  sidecars contradicting every plausible reading — so the fact is now
 *  derived-checked like audit.frontend_action. */
function usesEventTArg(src) {
  const re = /client->(?:_event|_event_client|follow_up_action)\(/g;
  let m;
  while ((m = re.exec(src)) !== null) {
    if (/\bt_arg\s*=/.test(parenBody(src, m.index + m[0].length - 1))) return true;
  }
  return false;
}

let errors = 0;
const err = (m) => { console.log(`ERROR ${m}`); errors++; };
const liveTestClasses = [];

function walk(dir, out = []) {
  for (const name of fs.readdirSync(dir)) {
    const full = path.join(dir, name);
    if (fs.statSync(full).isDirectory()) walk(full, out);
    else out.push(full);
  }
  return out;
}

// port classes = every class in a library package src/<cc>/<ll>/ (the overview
// app sits directly under src/ and is not a port)
const ports = walk(SRC)
  .filter((f) => f.endsWith('.clas.abap') && /src\/\d+\/\d+\/[^/]+$/.test(f.split(path.sep).join('/')))
  .map((f) => path.basename(f, '.clas.abap'));

const sidecars = fs.existsSync(META)
  ? fs.readdirSync(META).filter((f) => f.endsWith('.json'))
  : [];

for (const sf of sidecars.sort()) {
  const name = sf.replace(/\.json$/, '');
  let m;
  try { m = JSON.parse(fs.readFileSync(path.join(META, sf), 'utf8')); }
  catch (e) { err(`${sf}: invalid JSON — ${e.message}`); continue; }

  for (const k of ['class', 'sample', 'entity', 'file', 'batch', 'audit', 'status', 'deviations']) {
    if (m[k] === undefined) err(`${sf}: missing field "${k}"`);
  }
  for (const k of Object.keys(m)) {
    if (!KNOWN_KEYS.has(k)) err(`${sf}: unknown field "${k}" (known: ${[...KNOWN_KEYS].join(', ')})`);
  }
  // audit is a structured object so its facts stay queryable (like deviations)
  if (m.audit !== undefined) {
    if (typeof m.audit !== 'object' || m.audit === null || Array.isArray(m.audit)) {
      err(`${sf}: audit must be an object { frontend_action, event_t_arg, note? }`);
    } else {
      for (const k of ['frontend_action', 'event_t_arg']) {
        if (typeof m.audit[k] !== 'boolean') err(`${sf}: audit.${k} must be a boolean`);
      }
      for (const k of Object.keys(m.audit)) {
        if (!['frontend_action', 'event_t_arg', 'note'].includes(k)) err(`${sf}: unknown audit field "${k}"`);
      }
      if (m.audit.note !== undefined && typeof m.audit.note !== 'string') {
        err(`${sf}: audit.note must be a string`);
      }
    }
  }
  // optional render_smoke escape hatch: { skip: true, reason: "…" } marks a
  // port the static reconstructor cannot rebuild (helper-method view building)
  if (m.render_smoke !== undefined) {
    const rs = m.render_smoke;
    if (typeof rs !== 'object' || rs === null || Array.isArray(rs)) {
      err(`${sf}: render_smoke must be an object { skip: true, reason }`);
    } else {
      if (rs.skip !== true) err(`${sf}: render_smoke.skip must be true when present (drop the field otherwise)`);
      if (!rs.reason || typeof rs.reason !== 'string') err(`${sf}: render_smoke.reason must be a non-empty string`);
      for (const k of Object.keys(rs)) {
        if (!['skip', 'reason'].includes(k)) err(`${sf}: unknown render_smoke field "${k}"`);
      }
    }
  }
  if (m.class && m.class !== name) err(`${sf}: class "${m.class}" does not match filename`);
  // optional data_fidelity escape hatch — same shape as render_smoke
  if (m.data_fidelity !== undefined) {
    const df = m.data_fidelity;
    if (typeof df !== 'object' || df === null || Array.isArray(df)) {
      err(`${sf}: data_fidelity must be an object { skip: true, reason }`);
    } else {
      if (df.skip !== true) err(`${sf}: data_fidelity.skip must be true when present (drop the field otherwise)`);
      if (!df.reason || typeof df.reason !== 'string') err(`${sf}: data_fidelity.reason must be a non-empty string`);
      for (const k of Object.keys(df)) {
        if (!['skip', 'reason'].includes(k)) err(`${sf}: unknown data_fidelity field "${k}"`);
      }
    }
  }

  // optional structural_diff escape hatch — same shape as render_smoke; its
  // staleness is verified per run by structural-diff.mjs, this only guards
  // the schema so a typo'd skip cannot be silently ignored
  if (m.structural_diff !== undefined) {
    const sd = m.structural_diff;
    if (typeof sd !== 'object' || sd === null || Array.isArray(sd)) {
      err(`${sf}: structural_diff must be an object { skip: true, reason }`);
    } else {
      if (sd.skip !== true) err(`${sf}: structural_diff.skip must be true when present (drop the field otherwise)`);
      if (!sd.reason || typeof sd.reason !== 'string') err(`${sf}: structural_diff.reason must be a non-empty string`);
      for (const k of Object.keys(sd)) {
        if (!['skip', 'reason'].includes(k)) err(`${sf}: unknown structural_diff field "${k}"`);
      }
    }
  }

  if (m.status && !STATUS.includes(m.status)) err(`${sf}: unknown status "${m.status}"`);
  if (m.status === 'checked' && m.sample && HOLDOUT.has(m.sample)) {
    err(`${sf}: hold-out sample "${m.sample}" must never be checked (TRAINING.md — the measurement would train on its own yardstick)`);
  }
  if (m.status === 'checked' && !m.checked?.date) {
    err(`${sf}: status "${m.status}" requires a checked {date, note}`);
  }
  if (m.checked && !/^\d{4}-\d{2}-\d{2}$/.test(m.checked.date || '')) {
    err(`${sf}: checked.date must be YYYY-MM-DD`);
  }
  // GROUP-nested samples (AGENTS §1, since 2026-07-26) are named
  // <Group>.<Child> after .sample. — the name part may carry dots
  if (m.sample && !/^[\w.]+\.sample\.\w+(\.\w+)*$/.test(m.sample)) {
    err(`${sf}: sample "${m.sample}" is not <lib>.sample.<Name>`);
  }
  for (const d of m.deviations || []) {
    if (!DEV_TYPES.includes(d.type)) err(`${sf}: unknown deviation type "${d.type}"`);
    // SUBSET_DATA retired 2026-07-22: ports must inline the full mock row set
    if (d.type === 'SUBSET_DATA') err(`${sf}: SUBSET_DATA is retired - inline the full mock row set instead`);
    if (!d.what) err(`${sf}: deviation without "what" text`);
  }
  if (m.class && (m.deviations || []).some((d) => d.type === 'LIVE_TEST')) liveTestClasses.push(m.class);
  if (m.file) {
    const abs = path.join(ROOT, m.file);
    if (!fs.existsSync(abs)) err(`${sf}: file "${m.file}" does not exist`);
    else if (path.basename(abs, '.clas.abap') !== m.class) err(`${sf}: file does not match class`);
    // ports live in src/<category>/<library>/ (AGENTS §3). Both levels are a
    // pure function of the sidecar — the category from entity library +
    // POST_171, the library from the entity's second-level namespace — so the
    // path is not just shape-checked, it is derived and compared. The batch is
    // NOT part of the path (the b<nn> subpackages were flattened away) and is
    // checked for shape only.
    if (!/^src\/\d+\/\d+\/[^/]+\.clas\.abap$/.test(m.file)) {
      err(`${sf}: file "${m.file}" is not in a library package src/<cc>/<ll>/`);
    } else {
      const want = portPath(m);
      if (!want) err(`${sf}: entity "${m.entity}" has no library package (extend LIB_FOLDER in scripts/lib-packages.mjs)`);
      else if (want !== m.file) err(`${sf}: file "${m.file}" must be "${want}" (${CAT_CTEXT[catFolder(m)]}, ${LIB_CTEXT[libFolder(sampleLib(m.sample))]})`);
    }
    if (!/^b\d+$/.test(m.batch || '')) err(`${sf}: batch "${m.batch}" is not a b<nn> batch id`);
    // audit.frontend_action must match the class — a 2026-08-03 sweep found
    // 24 drifted flags (both directions), so the fact is now derived-checked
    if (fs.existsSync(abs)) {
      const src = fs.readFileSync(abs, 'utf8');
      if (typeof m.audit?.frontend_action === 'boolean') {
        const uses = /_event_client\(|follow_up_action\(/.test(src);
        if (m.audit.frontend_action !== uses) {
          err(`${sf}: audit.frontend_action is ${m.audit.frontend_action} but the class ${uses ? 'DOES' : 'does NOT'} call _event_client/follow_up_action`);
        }
      }
      if (typeof m.audit?.event_t_arg === 'boolean') {
        const uses = usesEventTArg(src);
        if (m.audit.event_t_arg !== uses) {
          err(`${sf}: audit.event_t_arg is ${m.audit.event_t_arg} but the class ${uses ? 'DOES' : 'does NOT'} pass t_arg in an event wire`);
        }
      }
    }
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

/* e2e interaction modules — meta/interactions/<class>.mjs (see the README
 * there; loaded by scripts/e2e-smoke.mjs, keyed by filename).
 *   - HARD: every module must belong to a port sidecar (or the overview app)
 *     — an orphan module is a renamed/deleted port's leftover and would never
 *     run again.
 *   - ADVISORY: every port with an open LIVE_TEST deviation should have a
 *     module — that is the automated close path (STATUS.md). Not a hard gate
 *     yet: the newest batches ship their LIVE_TESTs before their interactions
 *     are written (61 gaps when this check was wired, 2026-08-10), so the
 *     count is reported to keep the debt visible instead of failing every
 *     batch commit. */
const INTERACTIONS_DIR = path.join(META, 'interactions');
const OVERVIEW_CLASS = 'z2ui5_cl_smpc_app_overview';
let interactionGaps = [];
if (fs.existsSync(INTERACTIONS_DIR)) {
  const mods = fs.readdirSync(INTERACTIONS_DIR)
    .filter((f) => f.endsWith('.mjs'))
    .map((f) => f.replace(/\.mjs$/, ''));
  const validClasses = new Set([...sidecars.map((f) => f.replace(/\.json$/, '')), OVERVIEW_CLASS]);
  for (const c of mods) {
    if (!validClasses.has(c)) err(`meta/interactions/${c}.mjs matches no port sidecar (or the overview app) — orphan interaction module`);
  }
  const modSet = new Set(mods);
  interactionGaps = liveTestClasses.filter((c) => !modSet.has(c)).sort();
  if (interactionGaps.length) {
    console.log(`note: ${interactionGaps.length} port(s) with an open LIVE_TEST deviation have no meta/interactions/<class>.mjs yet — the e2e close path cannot verify them (advisory; the newest batches' interaction debt)`);
  }
}

/* Gap-free numbering (regenerate-artefacts): deleting a port renumbers the
 * tail, so the sequence stays contiguous. KNOWN_GAPS carries the one historic
 * exception — 231 was deleted without renumbering the ~60 ports above it, and
 * renumbering them retroactively (class names, sidecars, e2e INTERACTIONS,
 * STATUS history) is a maintainer decision, not a gate side effect. Any NEW
 * gap fails. */
const KNOWN_GAPS = new Set([231]);
const nums = [...sidecarSet]
  .map((c) => Number(c.match(/app_(\d+)$/)?.[1]))
  .filter((n) => Number.isInteger(n))
  .sort((a, b) => a - b);
for (let n = 1; n <= (nums[nums.length - 1] ?? 0); n++) {
  if (!nums.includes(n) && !KNOWN_GAPS.has(n)) {
    err(`port numbering has a gap at ${String(n).padStart(3, '0')} — renumber the tail (gap-free numbering, regenerate-artefacts)`);
  }
}

console.log(`validate-meta: ${sidecars.length} sidecars, ${ports.length} ports, ${errors} error(s)${interactionGaps.length ? ` (${interactionGaps.length} LIVE_TEST interaction gap(s), advisory)` : ''}.`);
process.exit(errors ? 1 : 0);
