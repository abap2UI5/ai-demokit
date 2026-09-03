#!/usr/bin/env node
/*
 * generate-derived — catalogue-derived.json, what the LINTER knows about each
 * port, beside what catalogue.json says the tree holds.
 *
 * Two questions this corpus is actually asked cannot be answered from the
 * sidecars, and so not from catalogue.json either:
 *
 *   "my system runs UI5 1.84 — which of these 636 ports will render on it?"
 *   "which ports use sap.m.Table at all, not just the one filed under it?"
 *
 * A port's `entity` is the ONE control the demo kit sample is about, so a port
 * that merely uses a Table inside a page about something else is invisible to
 * it; and the UI5 release a port needs is written nowhere — the POST_171
 * deviations name it in prose ("exists only since UI5 1.77"), which is a
 * sentence for a human, not a filter.
 *
 * Both come out of @abap2ui5/linter, which already reconstructs the view a
 * builder chain produces and resolves every control and member against the UI5
 * metadata snapshot — the same pass view-gates runs, render gate off (it needs
 * a browser and answers a different question: does the view load). It is asked
 * for two things it computes anyway:
 *
 *   stats.types            every control the port BUILDS, with occurrences
 *   `*-too-new` findings   every control/member/aggregation/enum value/icon
 *                          newer than the 1.71 floor, each carrying `since`
 *
 * The highest of those `since` values IS the port's minimum UI5 release, and
 * the floor itself when there are none. That is the same number view-gates
 * gates on and the sidecars declare in prose, derived rather than restated, so
 * this file cannot drift from the corpus.
 *
 * WHY IT IS A SECOND FILE. Everything a port carries that is committed fact —
 * title, summary, keywords, sample, entity, library, status, deviations — is
 * in catalogue.json already, and that file is generated offline and
 * dependency-free on purpose. Repeating those eight fields here would mean 636
 * ports written twice, two ~500 KB files diffing on every port PR, and a
 * second place for them to be wrong. So this one carries ONLY the derived
 * facts, keyed by `class`: a consumer joins the two on that key. They are
 * generated from one scan of one tree in one `npm run gates`, so they cannot
 * disagree about which ports exist.
 *
 * COMMITTED, unlike the apps.json that used to feed this repository's own
 * Pages site. That site is gone; the catalogue that replaced it is published
 * from the playground and builds its index at deploy time by fetching this
 * file, and raw.githubusercontent.com serves committed files only.
 *
 *   node scripts/generate-derived.mjs          write catalogue-derived.json
 *   node scripts/generate-derived.mjs --check  fail if it is stale (CI)
 *   node scripts/generate-derived.mjs --quiet  no per-port progress counter
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { checkAbapSource } from '@abap2ui5/linter';
import { walkFiles } from './lib/src-tree.mjs';
import { universe } from './lib/ui5-libs.mjs';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const OUT = path.join(ROOT, 'catalogue-derived.json');
const CHECK = process.argv.includes('--check');
/* Progress is a carriage-returned counter, which is a live line on a terminal
 * and 636 concatenated lines in a CI log. Off unless someone is watching. */
const QUIET = process.argv.includes('--quiet') || !process.stdout.isTTY;

/** The floor view-gates holds every port to — and the answer for a port that
 *  needs nothing newer. Keep it in step with view-gates.mjs MIN_UI5. */
const MIN_UI5 = '1.71';

/** The repository a consumer joins this against. */
const REPO = 'abap2UI5/samples-controls';
const REF = 'main';

/** Compare two dotted UI5 versions numerically ("1.9" < "1.71" < "1.120"). */
function cmpVersion(a, b) {
  const pa = String(a).split('.').map(Number);
  const pb = String(b).split('.').map(Number);
  for (let i = 0; i < Math.max(pa.length, pb.length); i++) {
    const d = (pa[i] || 0) - (pb[i] || 0);
    if (d) return d;
  }
  return 0;
}

/** "1.77.0" / "1.77" -> "1.77" — the minor is what a system is called by. */
const shortVersion = (v) => String(v).split('.').slice(0, 2).join('.');

const descriptions = JSON.parse(fs.readFileSync(path.join(ROOT, 'ui5', 'descriptions.json'), 'utf8'));
const demokit = descriptions.demokit || {};
const written = descriptions.written || {};

/* ---------------------------------------------------------------- collect */

const files = walkFiles(path.join(ROOT, 'src'), '.clas.abap');
const controlIds = new Map();          // control name -> index in `controls`
const idOf = (name) => {
  if (!controlIds.has(name)) controlIds.set(name, controlIds.size);
  return controlIds.get(name);
};

/* The in-system overview app implements z2ui5_if_app like every port, but it
 * rebuilds no demo kit original — it is the table that LISTS them. Same
 * exclusion as catalogue.json, and the reason is sharper here: it builds 25
 * control types, so left in it matched sap.m.Table, SearchField and half the
 * corpus' controls on every query. */
const OVERVIEW = 'z2ui5_cl_smpc_app_000';

const ports = [];
let failed = 0;

for (const file of files) {
  const source = fs.readFileSync(file, 'utf8');
  if (!/INTERFACES\s+z2ui5_if_app\s*\./i.test(source)) continue;

  const cls = path.basename(file, '.clas.abap');
  if (cls === OVERVIEW) continue;
  const rel = path.relative(ROOT, file).split(path.sep).join('/');
  const metaPath = path.join(ROOT, 'meta', `${cls}.json`);
  const meta = fs.existsSync(metaPath) ? JSON.parse(fs.readFileSync(metaPath, 'utf8')) : null;

  /* Both snapshot blocks: `demokit` is the docuindex snapshot, `written` the
   * hand-kept entries for the samples upstream leaves undocumented. */
  const docu = meta?.sample ? (demokit[meta.sample] || written[meta.sample]) : null;

  /* The linter pass. A class it cannot reconstruct still gets an entry — it
   * loses only the derived facts, which is better than dropping a port out of
   * the index over a parse, and `note` says what happened. */
  let types = {};
  let tooNew = [];
  let usesBuilder = false;
  let note = null;
  try {
    const r = checkAbapSource(source, { minUi5: MIN_UI5, render: false, file: rel });
    usesBuilder = !!r.usesBuilder;
    types = r.stats?.types || {};
    tooNew = r.findings
      .filter((f) => /-too-new$/.test(f.type) && f.since)
      .map((f) => ({
        type: f.type,
        name: [f.control, f.member, f.value].filter(Boolean).join('.') || f.type,
        since: shortVersion(f.since),
      }));
  } catch (err) {
    failed++;
    note = `linter: ${err.message}`;
  }

  /* The port's minimum UI5 release: the highest `since` the linter reported
   * above the floor, and the floor itself when it reported none. */
  const minUi5 = tooNew.reduce(
    (acc, f) => (cmpVersion(f.since, acc) > 0 ? f.since : acc),
    MIN_UI5,
  );

  const controls = Object.keys(types).sort();

  ports.push({
    /* The key a consumer joins catalogue.json on. */
    class: cls,
    /* The demo kit paragraph — the longest piece of real prose about the
     * sample, and the reason a free-text search finds a port by what it does
     * rather than only by what it is called. It is not in catalogue.json (that
     * file carries the tree's facts, and this is a snapshot of upstream's
     * prose), so it travels here. Tags stripped: a few carry <code> markup. */
    description: (docu?.description || '').replace(/<[^>]+>/g, '').trim(),
    minUi5,
    /* What made it that release — the tooltip behind the badge, so a filter
     * result can be argued with rather than only believed. */
    needs: tooNew.sort((a, b) => cmpVersion(b.since, a.since) || a.name.localeCompare(b.name)),
    /* Every control type the port BUILDS, as indices into the dictionary
     * below. Which LIBRARY each of those ships in is deliberately not
     * answered here: it is one UI5 taxonomy question, and answering it in
     * three sample repositories would be three copies of a prefix table that
     * drift. The consumer that needs it - the playground's catalogue, which
     * has to decide "does this render on the build I carry" anyway - owns the
     * mapping, beside the library list it is deciding against. */
    controls: controls.map(idOf),
    controlCount: Object.values(types).reduce((a, b) => a + b, 0),
    /* A port the linter could not reconstruct built nothing as far as this
     * file knows, and a consumer must not read that as "builds no controls". */
    ...(usesBuilder ? {} : { noChain: true }),
    ...(note ? { note } : {}),
  });

  if (!QUIET) process.stdout.write(`\rgenerate-derived: ${ports.length} ports`);
}

if (!QUIET) process.stdout.write('\n');

/* ------------------------------------------------------------------ write */

const controls = [...controlIds.keys()];
const releases = [...new Set(ports.map((p) => p.minUi5))].sort(cmpVersion);

const top = {
  note: 'Generated by scripts/generate-derived.mjs. What the linter knows about each port; '
    + 'the committed facts are in catalogue.json, joined on `class`. Do not hand-edit.',
  repo: REPO,
  ref: REF,
  catalogue: `https://raw.githubusercontent.com/${REPO}/${REF}/catalogue.json`,
  minUi5: MIN_UI5,
  ui5Snapshot: universe.release,
  releases,
  /* One dictionary, referenced by index from every port: the same 386 control
   * names would otherwise be repeated 636 times. */
  controls,
  counts: { ports: ports.length, controls: controls.length },
};

/* One line per port, so a port PR diffs as one changed line — the same reason
 * catalogue.json and SAMPLES.md are one row per port. */
const head = JSON.stringify(top, null, 2);
const body = ports
  .sort((a, b) => a.class.localeCompare(b.class))
  .map((p) => `    ${JSON.stringify(p)}`)
  .join(',\n');
const page = `${head.slice(0, -2)},\n  "ports": [\n${body}\n  ]\n}\n`;

if (CHECK) {
  const current = fs.existsSync(OUT) ? fs.readFileSync(OUT, 'utf8') : '';
  if (current !== page) {
    console.error('catalogue-derived.json is stale — run `npm run derived` and commit the result.');
    process.exit(1);
  }
  console.log(`catalogue-derived.json: current (${ports.length} ports)`);
} else {
  fs.writeFileSync(OUT, page);
  const size = (fs.statSync(OUT).size / 1024).toFixed(0);
  console.log(
    `catalogue-derived.json: ${ports.length} ports, ${controls.length} controls, `
    + `releases ${releases[0]}–${releases[releases.length - 1]} (${size} KB)`,
  );
}
if (failed) console.error(`generate-derived: ${failed} port(s) the linter could not reconstruct — see \`note\``);
