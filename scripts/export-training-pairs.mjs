#!/usr/bin/env node
/*
 * export-training-pairs — emit the corpus as supervised fine-tuning pairs.
 *
 * TRAINING.md: "The pair structure (sample files + capability context → ABAP +
 * typed deviations) is exactly the JSONL shape a supervised fine-tune would
 * need." This script materializes that shape so the option stays a command,
 * not a plan: one JSON line per port —
 *
 *   input : the sample's archived original files (ui5/<lib>/<Name>/**) plus
 *           the shared ui5/mock/*.json the sample references
 *   output: the port's ABAP class + its typed deviations (the sidecar)
 *
 * By default only `checked` ports are exported (live-verified pairs are the
 * only ones worth training on — TRAINING.md quality ladder); --all exports
 * every status (for counting/inspection). Hold-out samples (ui5/holdout.json)
 * are ALWAYS excluded — they measure the agent and must never train it.
 *
 * Run:  node scripts/export-training-pairs.mjs [--all] [--out pairs.jsonl]
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const META = path.join(ROOT, 'meta');
const UI5 = path.join(ROOT, 'ui5');
const MOCK = path.join(UI5, 'mock');
const ALL = process.argv.includes('--all');
const OUT = process.argv.includes('--out')
  ? process.argv[process.argv.indexOf('--out') + 1]
  : 'training-pairs.jsonl';

const TEXT_EXT = ['.json', '.xml', '.js', '.html', '.properties', '.css', '.ts'];

const holdout = fs.existsSync(path.join(UI5, 'holdout.json'))
  ? new Set(JSON.parse(fs.readFileSync(path.join(UI5, 'holdout.json'), 'utf8')).samples)
  : new Set();

function walk(dir, out = []) {
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) walk(p, out);
    else out.push(p);
  }
  return out;
}

const lines = [];
let skippedStatus = 0;
let skippedHoldout = 0;
for (const mf of fs.readdirSync(META).sort()) {
  if (!mf.endsWith('.json')) continue;
  const m = JSON.parse(fs.readFileSync(path.join(META, mf), 'utf8'));
  if (holdout.has(m.sample)) { skippedHoldout++; continue; }
  if (!ALL && m.status !== 'checked') { skippedStatus++; continue; }

  const i = m.sample.indexOf('.sample.');
  const lib = m.sample.slice(0, i);
  const name = m.sample.slice(i + '.sample.'.length);
  const sampleDir = path.join(UI5, lib, name);
  if (!fs.existsSync(sampleDir)) continue; // validate-meta reports this

  const input = {};
  for (const f of walk(sampleDir)) {
    if (!TEXT_EXT.includes(path.extname(f).toLowerCase())) continue;
    input[path.relative(UI5, f).split(path.sep).join('/')] = fs.readFileSync(f, 'utf8');
  }
  // shared mocks the sample references by file name (fold sources)
  if (fs.existsSync(MOCK)) {
    for (const mock of fs.readdirSync(MOCK)) {
      if (!mock.endsWith('.json')) continue;
      if (Object.values(input).some((t) => t.includes(mock))) {
        input[`mock/${mock}`] = fs.readFileSync(path.join(MOCK, mock), 'utf8');
      }
    }
  }

  lines.push(JSON.stringify({
    class: m.class,
    sample: m.sample,
    entity: m.entity,
    status: m.status,
    checked: m.checked || null,
    deviations: m.deviations || [],
    input,
    output: { abap: fs.readFileSync(path.join(ROOT, m.file), 'utf8') },
  }));
}

fs.writeFileSync(OUT, lines.join('\n') + (lines.length ? '\n' : ''));
console.log(`export-training-pairs: ${lines.length} pair(s) -> ${OUT}` +
  ` (${skippedStatus} skipped by status${ALL ? '' : ' — pass --all to include'}, ${skippedHoldout} hold-out excluded)`);
