#!/usr/bin/env node
/*
 * utc-date-shift-probe — find a date that is one day out west of Greenwich.
 *
 * `Formatter.DateCreateObject` is `new Date(s)`, and ECMA-262 gives that
 * function two different timezone rules depending on the shape of the string:
 *
 *   "2016-01-01"            date-ONLY  -> UTC midnight
 *   "2016-01-01T00:00:00"   date-TIME with no offset -> LOCAL midnight
 *
 * Every UI5 date control reads the LOCAL parts back —
 * `CalendarDate.fromLocalJSDate(oDate)` — so a date-only string arrives one day
 * early for anyone west of Greenwich and exactly right for everyone east of it.
 * `Formatter.DateAbapDateToDateObject` over the ABAP DATS form (`yyyymmdd`)
 * builds the Date from the parsed parts, which is local by construction, and
 * additionally answers `null` for a non-date — so it also retires the ternary
 * guard an optional endDate needs (an empty string through DateCreateObject is
 * an Invalid Date, which is truthy and takes the whole view down).
 *
 * Four ports had it on 2026-08-21, two of them `checked` — a human had watched
 * them run, which is precisely the trap: a date one day out looks exactly like
 * a date that is right, unless you know what it should say. App 017's own
 * label spelled the intended bounds out in words and the port contradicted it.
 * No gate sees any of this: `data_fidelity` compares the seeded STRING, which
 * is correct; the render gate asks whether the view loads, and it does.
 *
 * A hit means: this class uses DateCreateObject and also carries a date-only
 * value. Check whether that value reaches that formatter — a port may
 * legitimately hold date-only strings for a typed binding with a `source`
 * pattern, which parses locally and is fine (app 017 has twelve of those).
 *
 *   node scripts/probes/utc-date-shift-probe.mjs
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..', '..');
const META = path.join(ROOT, 'meta');

// a bare yyyy-mm-dd literal, and the sy-datum prefix that builds one
const DATE_ONLY = /`\d{4}-\d{2}-\d{2}`/;
const DATE_PREFIX = /\|\{ sy-datum\+0\(4\) \}-\{ sy-datum\+4\(2\) \}-\|/;

const metas = fs.readdirSync(META).filter((f) => /^z2ui5_cl_smpc_app_\d+\.json$/.test(f))
  .map((f) => JSON.parse(fs.readFileSync(path.join(META, f), 'utf8')));

let hits = 0, safe = 0;
for (const m of metas) {
  const file = path.join(ROOT, m.file);
  if (!fs.existsSync(file)) continue;
  const src = fs.readFileSync(file, 'utf8');
  // comments explain the trap; only real code counts
  const code = src.split('\n').filter((l) => !l.trimStart().startsWith('"')).join('\n');
  if (!code.includes('Formatter.DateCreateObject')) continue;

  const dateOnly = DATE_ONLY.test(code);
  const builtPrefix = DATE_PREFIX.test(code);
  if (!dateOnly && !builtPrefix) { safe++; continue; }
  hits++;
  console.log(`UTC-SHIFT ${m.class}  uses Formatter.DateCreateObject and carries a date-ONLY value`);
  console.log(`          ${builtPrefix ? 'built from sy-datum as yyyy-MM-dd' : 'as a yyyy-mm-dd literal'}` +
    ` — new Date( ) reads that as UTC midnight, the control reads LOCAL parts back (${m.sample})`);
  console.log(`          ${path.relative(ROOT, file)}`);
}

console.log(`\nutc-date-shift: ${metas.length} ports scanned, ${hits} carrying a date-only value into new Date( )`);
console.log(`                (${safe} more use DateCreateObject on a date-TIME, which ECMA-262 parses as LOCAL — those are fine)`);
if (hits) {
  console.log('Seed the ABAP DATS form (yyyymmdd) and read it with Formatter.DateAbapDateToDateObject,');
  console.log('which builds the Date from the parsed parts and answers null for a non-date.');
}
