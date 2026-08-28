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
import { walkFiles } from './lib/src-tree.mjs';

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
  'property_gate',
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

/* the universe's own entity per sample, and the library an entity name sits in
 * — longest known library prefix wins, so sap.ui.model.type.Currency resolves
 * to sap.ui.model and not to sap.ui. */
const UNIVERSE = JSON.parse(fs.readFileSync(path.join(UI5, 'universe.json'), 'utf8'));
const UNIVERSE_ENTITY = new Map(
  UNIVERSE.libs.flatMap((l) => l.samples.map((s) => [`${l.lib}.sample.${s.name}`, s.entity])),
);
const KNOWN_LIBS = [...new Set([...UNIVERSE.libs.map((l) => l.lib), 'sap.ui.model', 'sap.ui.core'])];
const universeEntity = (sample) => UNIVERSE_ENTITY.get(sample) || null;
const entityLib = (e) => {
  let best = '';
  for (const l of KNOWN_LIBS) if ((e === l || e.startsWith(`${l}.`)) && l.length > best.length) best = l;
  return best || e.slice(0, e.lastIndexOf('.'));
};

let errors = 0;
const err = (m) => { console.log(`ERROR ${m}`); errors++; };
const liveTestClasses = [];
/** class -> its parsed sidecar, for the checks that run after the per-file loop. */
const metaByClass = new Map();

// port classes = every class in a library package src/<cc>/<ll>/ (the overview
// app sits directly under src/ and is not a port)
const ports = walkFiles(SRC)
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

  /* `checked` is REQUIRED, as `null` while the port is generated/reviewed
   * (AGENTS §5 documents exactly that shape). It was listed in KNOWN_KEYS and
   * validated when present, but never required — and 621 of 622 sidecars
   * carried it anyway, so the one that did not (app 308) read as "nobody has
   * decided" where every other file says "not live-checked yet". An absent
   * optional key and an explicit null are the same to a reader who knows the
   * schema and different to everyone else; making it required removes the
   * question. */
  for (const k of ['class', 'sample', 'entity', 'file', 'batch', 'audit', 'status', 'checked', 'deviations']) {
    if (m[k] === undefined) {
      err(`${sf}: missing field "${k}"`
        + (k === 'checked' ? ' — write `"checked": null` while the port is not live-verified (AGENTS §5)' : ''));
    }
  }
  /* Every string in a sidecar is ONE LINE. `generate-overview.mjs` bakes this
   * prose into ABAP backtick literals, and an ABAP string literal cannot span
   * lines: a newline in a `what` is emitted RAW, which produces a class that
   * does not parse and desyncs every downstream reader of that file — measured
   * 2026-08-28, when a two-paragraph deviation on app 109 made the linter read
   * a class name inside the broken literal as real code and `check:chains`
   * reported `non-released-api` on the generated overview, 350 lines away from
   * the sidecar that caused it. Zero of the 622 sidecars had one before, so
   * this is an invariant that held by luck until it did not. Paragraphs belong
   * in docs/history.md; a deviation is one sentence-stream. */
  {
    const scan = (v, at) => {
      if (typeof v === 'string') {
        const bad = /[\u0000-\u001f\u007f]/.exec(v);
        if (bad) {
          err(`${sf}: ${at} carries a control character (\\u${bad[0].charCodeAt(0).toString(16).padStart(4, '0')}) `
            + '— sidecar text is one line: it is baked into an ABAP string literal, which cannot span lines');
        }
      } else if (Array.isArray(v)) v.forEach((x, i) => scan(x, `${at}[${i}]`));
      else if (v && typeof v === 'object') for (const [k, x] of Object.entries(v)) scan(x, at ? `${at}.${k}` : k);
    };
    scan(m, '');
  }
  metaByClass.set(name, m);
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

  /* optional property_gate escape hatch - NARROWER than the three above,
   * because the property gate is the correctness one: it must name the finding
   * TYPES it covers, and view-gates fails the port if a named type does not
   * actually fire (the same stale-skip discipline). It exists for the case the
   * corpus keeps meeting - the UI5 metadata says one thing and the control's
   * own code does another (batch b47's columnmenu.Menu.items, batch b49's
   * ObjectPageLazyLoader in a blocks aggregation) - where satisfying the rule
   * would mean breaking the port. */
  if (m.property_gate !== undefined) {
    const pg = m.property_gate;
    if (typeof pg !== 'object' || pg === null || Array.isArray(pg)) {
      err(`${sf}: property_gate must be an object { skip: true, reason, types: [...] }`);
    } else {
      if (pg.skip !== true) err(`${sf}: property_gate.skip must be true when present (drop the field otherwise)`);
      if (!pg.reason || typeof pg.reason !== 'string') err(`${sf}: property_gate.reason must be a non-empty string`);
      if (!Array.isArray(pg.types) || !pg.types.length
          || pg.types.some((t) => typeof t !== 'string' || !t)) {
        err(`${sf}: property_gate.types must be a non-empty array of finding types - a blanket skip of the property gate is never allowed`);
      }
      for (const k of Object.keys(pg)) {
        if (!['skip', 'reason', 'types'].includes(k)) err(`${sf}: unknown property_gate field "${k}"`);
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
    /* the sidecar entity may be SHARPER than the universe's (the universe says
     * sap.ui.unified.ColorPicker where the sample is really the Popover), but
     * it may not name a different LIBRARY: generate-catalogue derives the
     * catalogue's library column from this field alone, so a foreign library
     * here files the port under a library it is not in, and nothing else
     * notices - app 143 carried "sap.f.DynamicPage" for a sap.tnt.InfoLabel
     * sample until 2026-08-23, listed under sap.f in catalogue.json while
     * api.md (which reads the universe) had it right. */
    const ue = universeEntity(m.sample);
    if (ue && m.entity && entityLib(m.entity) !== entityLib(ue)) {
      err(`${sf}: entity "${m.entity}" is in a different library than the universe's "${ue}" for ${m.sample} — a sharper entity is fine, a foreign library is not (it decides the catalogue's library column)`);
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
 *   - HARD: every module must be able to FAIL. A module that only reads the
 *     DOM and console.logs it passes whatever the port does, and the whole
 *     coverage bookkeeping then counts the port as verified: the LIVE_TEST gap
 *     below reads 0, the README lists it among the covered classes, and a
 *     green nightly says nothing about it. Three such recon scripts (301, 351,
 *     353) sat in here from the session that used them to learn the DOM and
 *     were never rewritten — found 2026-08-21, and cheap to detect, because a
 *     module that can fail always says so somewhere: `expect(`, a `throw`, a
 *     `waitFor…` (Playwright's own waits reject on timeout), or an import from
 *     lib-e2e, whose helpers all throw.
 *   - ADVISORY: interaction COVERAGE, reported over the port set and split by
 *     the status ladder.
 *     This advisory used to be based on the LIVE_TEST backlog — every port
 *     with an open LIVE_TEST deviation should have a module, that being the
 *     automated close path (STATUS.md). It was right while the backlog had
 *     122 entries and it became structurally DEAD when the backlog reached 0
 *     on 2026-08-26: the source list is empty, so the advisory reports
 *     nothing, forever, no matter how the real debt moves. What it was
 *     standing in for is still there — 289 of 622 ports (46%) have no
 *     meta/interactions/<class>.mjs — and it is worst exactly where a reader
 *     would least expect it, because the ladder and the coverage run in
 *     OPPOSITE directions: 42 of 59 `checked` ports and 192 of 355 `reviewed`
 *     ones have no module, against 55 of 208 `generated`. The rungs that
 *     claim the most verification carry the least automated proof of it, and
 *     a `checked` port is the one whose live check a code change silently
 *     invalidates (AGENTS §10).
 *     Still an ADVISORY, deliberately: 289 gaps cannot become a hard gate
 *     without failing every batch commit until they are closed, and the
 *     directory README is explicit that it is grown port by port. AGENTS does
 *     not argue for more — it asks for the debt to be visible. So the count is
 *     printed, per rung, and the LIVE_TEST view is kept as a second line for
 *     as long as the backlog is non-empty. */
const INTERACTIONS_DIR = path.join(META, 'interactions');
const OVERVIEW_CLASS = 'z2ui5_cl_smpc_app_000';
let interactionGaps = [];
{
  /* Not guarded on the directory EXISTING: an absent meta/interactions/ is
   * 100% coverage debt, which is the one state the advisory most has to say
   * out loud. Only the per-module checks below need the files. */
  const mods = fs.existsSync(INTERACTIONS_DIR)
    ? fs.readdirSync(INTERACTIONS_DIR).filter((f) => f.endsWith('.mjs')).map((f) => f.replace(/\.mjs$/, ''))
    : [];
  const validClasses = new Set([...sidecars.map((f) => f.replace(/\.json$/, '')), OVERVIEW_CLASS]);
  /* An escape hatch keyed on free prose must be UNAMBIGUOUS (STATUS.md, the
   * lesson two prior incidents wrote). `waitFor` was a bare substring test
   * over the module SOURCE, so the comment `// waitFor the popover` satisfied
   * it — a recon script with a sentence about waiting in it read as a test.
   * Dropping it costs nothing and was measured before the change: 0 of the
   * 334 modules rely on that branch, every one of them carries `expect(`, a
   * `throw` or a lib-e2e import. Playwright's own waits do reject on timeout,
   * but they reach this check through `waitForUi5` / `waitForCount`, which are
   * lib-e2e helpers, or through an `expect` — both of which stay listed. */
  const CAN_FAIL = /expect\(|throw\s|lib-e2e/;
  for (const c of mods) {
    if (!validClasses.has(c)) err(`meta/interactions/${c}.mjs matches no port sidecar (or the overview app) — orphan interaction module`);
    const src = fs.readFileSync(path.join(INTERACTIONS_DIR, `${c}.mjs`), 'utf8');
    if (!CAN_FAIL.test(src)) {
      err(`meta/interactions/${c}.mjs asserts nothing — it can never fail, so it counts as coverage the nightly does not actually provide. Assert what the port really does: expect(…), a throw, or a lib-e2e helper (waitForUi5 / waitForCount and friends all throw).`);
    }
  }
  const modSet = new Set(mods);
  /* the real debt: ports with no module at all, by status. A port is counted
   * on the rung its sidecar claims, which is what makes the split worth
   * printing — see the block comment above. */
  const byStatus = new Map(STATUS.map((s) => [s, { ports: 0, gaps: 0 }]));
  for (const cls of sidecarSet) {
    const meta = metaByClass.get(cls);
    const row = byStatus.get(meta?.status) ?? byStatus.get('generated');
    row.ports += 1;
    if (!modSet.has(cls)) { row.gaps += 1; interactionGaps.push(cls); }
  }
  interactionGaps.sort();
  const total = [...byStatus.values()].reduce((n, r) => n + r.ports, 0);
  if (interactionGaps.length) {
    const split = STATUS.map((st) => `${byStatus.get(st).gaps}/${byStatus.get(st).ports} ${st}`).join(' · ');
    console.log(`note: ${interactionGaps.length} of ${total} port(s) (${Math.round((interactionGaps.length / total) * 100)}%) have no meta/interactions/<class>.mjs — ${split}`
      + ' (advisory: the nightly e2e proves nothing about these beyond boot+render; the two rungs that claim verification carry the least of it)');
  }
  /* The LIVE_TEST view this advisory used to BE, kept while it can still say
   * something: a port carrying an open LIVE_TEST with no module has no
   * automated close path at all. The backlog is 0 today, so this line is
   * silent — which is the correct behaviour for a view of an empty list, and
   * the reason it must not be the only one. */
  const liveGaps = liveTestClasses.filter((c) => !modSet.has(c)).sort();
  if (liveGaps.length) {
    console.log(`note: ${liveGaps.length} of them carry an open LIVE_TEST deviation — the e2e close path cannot verify those at all (advisory)`);
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

console.log(`validate-meta: ${sidecars.length} sidecars, ${ports.length} ports, ${errors} error(s)${interactionGaps.length ? ` (${interactionGaps.length} port(s) with no e2e interaction module, advisory)` : ''}.`);
process.exit(errors ? 1 : 0);
