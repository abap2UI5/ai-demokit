#!/usr/bin/env node
/*
 * e2e-changed — which ports a change touches.
 *
 * Nothing in the PR gate set ran a port in a BROWSER. The gates are static —
 * structural-diff compares trees, view_gates reconstructs a view and renders
 * it without a backend — so a batch merged on those alone and its first real
 * execution was the nightly, up to 24 hours later, in a run covering 623 apps
 * where one FAIL line is easy to attribute to the wrong change.
 *
 * The whole corpus cannot run per pull request (a ~19-minute transpile plus
 * ~4 s per port), but the ports a pull request actually TOUCHES can, and that
 * is almost always a handful. This maps a changed-file list to the classes
 * worth booting.
 *
 * Three inputs reach a port's live behaviour, and all three count:
 *   src/<cc>/<ll>/<class>.clas.abap   the port itself
 *   meta/<class>.json                 its sidecar (deviations gate nothing at
 *                                     runtime, but a status/skip change is a
 *                                     claim about the live behaviour)
 *   meta/interactions/<class>.mjs     the assertions that run against it
 *
 * A change to the FRAMEWORK PIN, the harness or the build reaches every port
 * at once, and there is no useful subset then: the answer is `all`, and the
 * caller decides whether to run the whole corpus or leave it to the nightly.
 * That is the same shape as abap-scope.mjs — unknown means run, never skip —
 * and it is deliberate: a subset that quietly misses the change it should have
 * caught is worse than no PR job at all.
 *
 *   node scripts/e2e-changed.mjs <file> [<file> …]
 *   node scripts/e2e-changed.mjs --from <a file with one path per line>
 *
 * `--from` is what CI uses, and not `xargs`: xargs SPLITS a long list across
 * several invocations, and a verdict computed per chunk is wrong in the one
 * direction that matters — the chunk holding `A2UI5_PIN` would print `all`
 * while the others printed class names, and the caller would take the union
 * as a subset.
 *
 * Prints one class per line, or the single word `all`. Always exits 0 — it
 * answers a question, it does not gate.
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const CLASS = /^(z2ui5_cl_smpc_app_\d+)$/;

/** Paths whose change reaches EVERY port's live behaviour. */
const CORPUS_WIDE = [
  /^A2UI5_PIN$/,
  /^package(-lock)?\.json$/,
  /^scripts\/e2e-build\.mjs$/,
  /^scripts\/e2e-smoke\.mjs$/,
  /^scripts\/lib-e2e\.mjs$/,
  /^scripts\/lib-smoke\.mjs$/,
  /^scripts\/lib-a2ui5\.mjs$/,
  /^scripts\/node-serve\.mjs$/,
  /^web\/ci\//,
  /^\.github\/workflows\/e2e-/,
];

/**
 * @param {string[]} files repo-relative changed paths
 * @returns {{ all: boolean, classes: string[], reason: string }}
 */
export function portsToRun(files) {
  const list = (files || []).map((f) => String(f).trim().split(path.sep).join('/')).filter(Boolean);

  const wide = list.find((f) => CORPUS_WIDE.some((re) => re.test(f)));
  if (wide) {
    return { all: true, classes: [], reason: `${wide} reaches every port — the subset would be a guess` };
  }

  const classes = new Set();
  for (const f of list) {
    let m = /^src\/(?:\d+\/\d+\/)?([a-z0-9_]+)\.clas\.(abap|xml)$/.exec(f);
    if (m && CLASS.test(m[1])) { classes.add(m[1]); continue; }
    m = /^meta\/([a-z0-9_]+)\.json$/.exec(f);
    if (m && CLASS.test(m[1])) { classes.add(m[1]); continue; }
    m = /^meta\/interactions\/([a-z0-9_]+)\.mjs$/.exec(f);
    if (m && CLASS.test(m[1])) { classes.add(m[1]); }
  }

  const sorted = [...classes].sort();
  return {
    all: false,
    classes: sorted,
    reason: sorted.length
      ? `${sorted.length} port(s) touched`
      : 'no port, sidecar or interaction module changed',
  };
}

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  const i = process.argv.indexOf('--from');
  const files = i === -1
    ? process.argv.slice(2)
    : fs.readFileSync(process.argv[i + 1], 'utf8').split('\n');
  const { all, classes } = portsToRun(files);
  console.log(all ? 'all' : classes.join('\n'));
}
