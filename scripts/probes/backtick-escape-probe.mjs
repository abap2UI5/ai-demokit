#!/usr/bin/env node
/*
 * backtick-escape-probe — find a text literal that MEANT an escape sequence
 * and printed two characters instead.
 *
 * An ABAP backtick literal is raw: `\n` inside it is a backslash followed by
 * an n, and nothing in the chain ever turns it into a line break. The client's
 * formatTemplate substitutes {N} placeholders and passes everything else
 * through, so a toast built as
 *
 *     `Color Selected: value - {0}, \n defaultAction - {1}`
 *
 * renders the backslash-n on screen where the original JS (a DOUBLE-quoted
 * string, where \n IS an escape, shown through .sapMMessageToast's
 * white-space: pre-line) shows a real second line.
 *
 * The working form is the STRING TEMPLATE, which does have escapes:
 *
 *     `Color Selected: value - {0},` && |\n| && ` defaultAction - {1}`
 *
 * Nothing else catches this. `chain_format` parses the chain, not the text;
 * `structural_diff` compares controls and attributes, not literal content;
 * `data_fidelity` compares seeded model values, and a toast text is neither.
 * It is invisible until somebody presses the button and reads the toast.
 *
 * Found by the review sweep of 2026-08-21 in app 250, then by grep in 008 and
 * 186 — and 186 carried it TWICE, one occurrence surviving the first fix,
 * which is why this is a probe now rather than a lesson.
 *
 * A hit is not automatically a defect: a sample that genuinely displays a
 * backslash (a regex, a path) is faithful. Declare that in a deviation.
 *
 *   node scripts/probes/backtick-escape-probe.mjs
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..', '..');
const META = path.join(ROOT, 'meta');

// A backtick literal on one line, with a backslash before a letter that is an
// escape in a STRING TEMPLATE — those are the ones that were meant as escapes.
// `\\` (a doubled backslash) is left alone: whoever wrote it meant a backslash.
const LITERAL_RE = /`[^`\n]*`/g;
const ESCAPE_RE = /(?<!\\)\\[nrt]/;

const metas = fs.readdirSync(META).filter((f) => f.endsWith('.json'))
  .map((f) => JSON.parse(fs.readFileSync(path.join(META, f), 'utf8')))
  // The overview app is prose ABOUT the ports and quotes these very literals
  // while explaining them; scanning it would report the documentation of the
  // defect as the defect.
  .filter((m) => /^z2ui5_cl_smpc_app_\d+$/.test(m.class || '') && m.class !== 'z2ui5_cl_smpc_app_000');

let hits = 0;
for (const m of metas) {
  const file = path.join(ROOT, m.file);
  if (!fs.existsSync(file)) continue;
  const lines = fs.readFileSync(file, 'utf8').split('\n');
  lines.forEach((line, i) => {
    if (line.trimStart().startsWith('"')) return; // an ABAP comment is prose
    for (const lit of line.match(LITERAL_RE) || []) {
      if (!ESCAPE_RE.test(lit)) continue;
      hits++;
      console.log(`${m.class}  ${path.relative(ROOT, file)}:${i + 1}`);
      console.log(`    ${lit.trim()}`);
    }
  });
}

console.log(`\nbacktick-escape: ${metas.length} ports scanned, ${hits} literal(s) carrying a backslash escape that never becomes one.`);
if (hits) {
  console.log('Split the literal and concatenate a string template for the escape:');
  console.log('  `left` && |\\n| && `right`   — |…| has escapes, `…` does not.');
  console.log('Or declare in the sidecar that the backslash is meant to be visible.');
}
