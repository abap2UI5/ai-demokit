#!/usr/bin/env node
/*
 * fetch-descriptions — snapshot the demo kit's own sentence about every sample.
 *
 * The UI5 demo kit shows each sample with a description underneath the title
 * ("This sample demonstrates different combinations of types, shapes, and
 * sizes of the Avatar."). That sentence is the best short text about a sample
 * that exists anywhere: SAP wrote it, it says what the sample DEMONSTRATES
 * rather than which controls it happens to contain, and it is what a reader of
 * the demo kit has already seen.
 *
 * It lives in the OpenUI5 sources, one file per library:
 *
 *   src/<lib>/test/<lib path>/demokit/docuindex.json
 *       -> explored.samples[] = { id, name, description }
 *
 * and it is NOT in the per-sample manifest.json - which is why archiving the
 * sample files under ui5/<lib>/<Sample>/ did not bring it along, and why every
 * port went without one until now.
 *
 * This script copies those entries into ui5/descriptions.json, and that
 * committed snapshot is what generate-summary.mjs reads. Two reasons for the
 * snapshot rather than reading an OpenUI5 checkout at generate time:
 *
 *   - a checkout of OpenUI5 is 43k files and nobody has one; a port batch and
 *     a CI run must both work without it
 *   - upstream text changes would otherwise silently rewrite hundreds of class
 *     files. As a snapshot, refreshing it is a diff somebody reads.
 *
 * ALL samples are snapshotted, not just the ported ones (the ui5/ archive
 * keeps only ported samples). ~120 kB, and it means the next port batch needs
 * no OpenUI5 checkout to get its summary line.
 *
 *   node scripts/fetch-descriptions.mjs --openui5 <path to an openui5 checkout>
 *
 * The `written` block in the output is NOT touched by this script: it holds
 * the handful of samples the demo kit does not describe (see generate-summary).
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { execFileSync } from 'child_process';
import { isSkippedDir } from './lib/src-tree.mjs';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const OUT = path.join(ROOT, 'ui5', 'descriptions.json');

const i = process.argv.indexOf('--openui5');
const CHECKOUT = i > -1 ? process.argv[i + 1] : null;
if (!CHECKOUT || !fs.existsSync(CHECKOUT)) {
  console.error('usage: node scripts/fetch-descriptions.mjs --openui5 <path to an openui5 checkout>');
  console.error('\n  git clone --depth 1 https://github.com/SAP/openui5 /tmp/openui5');
  process.exit(2);
}

/** every src/<lib>/test/**\/demokit/docuindex.json under the checkout */
function docuindexes(dir, out = []) {
  for (const name of fs.readdirSync(dir)) {
    const full = path.join(dir, name);
    if (isSkippedDir(name)) continue;
    if (fs.statSync(full).isDirectory()) {
      if (name === 'node_modules' || name === '.git') continue;
      docuindexes(full, out);
    } else if (name === 'docuindex.json' && path.basename(dir) === 'demokit') {
      out.push(full);
    }
  }
  return out;
}

const demokit = {};
const files = docuindexes(path.join(CHECKOUT, 'src')).sort();
for (const file of files) {
  let doc;
  try { doc = JSON.parse(fs.readFileSync(file, 'utf8')); } catch { continue; }
  for (const s of doc.explored?.samples || []) {
    if (!s.id) continue;
    demokit[s.id] = { name: s.name || '', description: s.description || '' };
  }
}

const previous = fs.existsSync(OUT) ? JSON.parse(fs.readFileSync(OUT, 'utf8')) : {};

const git = (...args) => execFileSync('git', ['-C', CHECKOUT, ...args], { encoding: 'utf8' }).trim();
const version = (() => {
  try { return JSON.parse(fs.readFileSync(path.join(CHECKOUT, 'package.json'), 'utf8')).version; }
  catch { return ''; }
})();

const out = {
  source: {
    repo: 'https://github.com/SAP/openui5',
    commit: git('rev-parse', 'HEAD'),
    committed: git('log', '-1', '--format=%cs'),
    version,
    from: 'src/*/test/**/demokit/docuindex.json -> explored.samples[]',
    libraries: files.length,
    licence: 'Apache-2.0 (OpenUI5). Held verbatim, like the sample sources under ui5/<lib>/<Sample>/.',
  },
  demokit: Object.fromEntries(Object.keys(demokit).sort().map((k) => [k, demokit[k]])),
  written: previous.written || {},
};

fs.writeFileSync(OUT, `${JSON.stringify(out, null, 2)}\n`);
console.log(`descriptions: ${Object.keys(demokit).length} sample(s) from ${files.length} librarie(s)`);
console.log(`  openui5 ${out.source.version} @ ${out.source.commit.slice(0, 12)} (${out.source.committed})`);
console.log(`  written (not from the demo kit): ${Object.keys(out.written).length}`);
console.log(`  -> ui5/descriptions.json`);
