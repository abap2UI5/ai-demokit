#!/usr/bin/env node
/*
 * stale-impossibility-probe — find a deviation still declaring something the
 * framework has since learned to do.
 *
 * A deviation is written once and read forever, and abap2UI5 keeps growing.
 * The result is the most expensive kind of wrong text in this corpus: not a
 * typo, but a port that goes on doing LESS than the original because the note
 * beside it says it must. Nothing re-checks these claims — the gates read
 * deviations as declarations to be honoured, never as assertions to be tested.
 *
 * Five turned up on 2026-08-21 alone, and they had all been true when written:
 *   305  "removeSelectedDate takes a DateRange CONTROL no wire can address"
 *        — true of that method; abap2UI5 #2535 un-denied removeAllSelectedDates
 *   306  "check_prevent_default is baked in at RENDER time, so a condition per
 *        event cannot be expressed" — true of the BOOLEAN form only;
 *        prevent_default_expr evaluates per firing
 *   139  and 304 "addSelectedDate takes a DateRange CONTROL that no wire can
 *        construct" — true of the METHOD, and beside the point: selectedDates
 *        is a bindable AGGREGATION
 *   267  (an inline comment) "the Slider's jQuery width has no abap2UI5
 *        equivalent" — the `css` control method had reproduced it months
 *        earlier, and that port's own sidecar said so
 *
 * WHAT THIS CHECKS, and what it cannot: a deviation that claims impossibility
 * AND names a method the framework does not deny. An unlisted public method is
 * callable — the denylist only protects abap2UI5's own invariants (teardown,
 * reparenting, model/binding swaps, event-handler tampering, the render
 * lifecycle) — so naming a non-denied method next to "no wire can" is worth a
 * second look.
 *
 * It cannot decide the case, for two reasons, and both are the reader's job:
 *   - the ARGUMENTS may still be untransportable. castArgs handles
 *     string/int/bool/controlId/anchor; a method taking a Date or a control
 *     instance is callable and useless (app 151's focusDate, app 305's
 *     displayDate). Those claims are sound.
 *   - the method may be the one the port REPLACED rather than the one it
 *     cannot call (app 284 names setVisible/setText precisely because it binds
 *     them instead). Apps 563 and 564 are that same sentence written twice
 *     more — the MessageView-in-a-popover twins of 284 — so this shape is
 *     three of the current hits, not one. All three were re-read and cleared
 *     on 2026-08-23: the claim they carry applies only to navigateBack, which
 *     really is a method with no bindable twin and really is wired as a
 *     frontend action. Do not re-derive it a fourth time.
 * Expect roughly one true positive in three. Six lines are cheap to read; a
 * port quietly doing less than its original for a year is not.
 *
 * Deviations that already record a retired claim are skipped — the corpus does
 * correct itself, and re-reporting its own corrections would bury the rest.
 *
 *   node scripts/probes/stale-impossibility-probe.mjs
 *   node scripts/probes/stale-impossibility-probe.mjs --all   include settled ones
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..', '..');
const META = path.join(ROOT, 'meta');
const ALL = process.argv.includes('--all');

/* Kept in step with CONTROL_METHOD_DENY_EXACT / _PREFIXES in abap2UI5's
 * z2ui5_cl_ui5f_ctrlcall_js. If the framework's list moves, move this one —
 * a method that has become callable is exactly what this probe exists to
 * notice, and it cannot notice it from a stale copy. */
const DENY_EXACT = new Set(['destroy', 'exit', 'fireEvent', 'clone', 'applySettings',
  'setAggregation', 'addAggregation', 'insertAggregation', 'removeAggregation',
  'removeAllAggregation', 'destroyAggregation', 'setAssociation', 'addAssociation',
  'removeAssociation', 'removeAllAssociation', 'rerender', 'invalidate', 'setModel',
  'setParent']);
const DENY_PREFIX = ['bind', 'unbind', 'attach', 'detach', 'addDependent', 'placeAt', 'setBinding'];
const denied = (m) => DENY_EXACT.has(m) || DENY_PREFIX.some((p) => m.startsWith(p));

const CLAIM = /(cannot be|no abap2UI5 equivalent|not expressible|has no equivalent|no wire (?:can|exists)|cannot express|no bindable equivalent|which no wire|that no wire)/i;
/* A hit leaves the list in one of TWO ways, and both have to be recorded in
 * the sidecar where the claim lives, or the next reader re-derives it. The
 * first is the claim being RETIRED (the port now does the thing). The second
 * is the claim being re-read and found still TRUE - which was invisible until
 * 2026-08-23, so a sound claim stayed a hit forever and cost somebody the same
 * six lines every sweep. `re-verified <date>` in the deviation is that second
 * exit. It deliberately requires a DATE: a claim cannot be silenced without
 * somebody writing down when they last checked it, and a framework release can
 * make a re-verified claim stale again, at which point the date is what says
 * how old the check is. */
const SETTLED = /(the earlier claim|earlier rationale|is retired|was (?:too quick|wrong|half wrong)|called the earlier|corrected 20|since 20\d\d-\d\d-\d\d|reproduced since|is reproduced|re-verified 20\d\d-\d\d-\d\d)/i;
const METHOD = /\b([a-z][A-Za-z0-9]{3,})\(\s*\)?/g;

const metas = fs.readdirSync(META).filter((f) => /^z2ui5_cl_smpc_app_\d+\.json$/.test(f))
  .map((f) => JSON.parse(fs.readFileSync(path.join(META, f), 'utf8')));

let hits = 0, settled = 0;
for (const m of metas) {
  for (const d of m.deviations || []) {
    if (!CLAIM.test(d.what)) continue;
    if (SETTLED.test(d.what) && !ALL) { settled++; continue; }
    const names = new Set();
    for (const mm of d.what.matchAll(METHOD)) {
      const name = mm[1];
      // a getter is never the thing a port is blocked on
      if (!denied(name) && !/^(get|is|has)/.test(name)) names.add(name);
    }
    if (!names.size) continue;
    hits++;
    const claim = d.what.match(CLAIM)[0];
    console.log(`${m.class} [${m.status}] ${d.type} — claims "${claim}" and names ${[...names].join(', ')}`);
    console.log(`    none of those is on the framework's denylist. Check whether the ARGUMENTS can travel`);
    console.log(`    (string/int/bool/controlId/anchor), and whether an AGGREGATION would do instead. (${m.sample})`);
  }
}

console.log(`\nstale-impossibility: ${metas.length} ports scanned, ${hits} deviation(s) to re-read` +
  (ALL ? '' : `, ${settled} skipped as already-corrected (--all to include)`));
if (hits) console.log('A hit is a question, not a verdict — expect about one in three to be real.');
