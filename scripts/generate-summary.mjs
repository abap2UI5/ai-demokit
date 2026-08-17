#!/usr/bin/env node
/*
 * generate-summary — give every port the sentence the demo kit says about it.
 *
 * `" @keywords` answers "which words find this port". `" @summary` answers the
 * next question - "is this the one I want" - and until now nothing in the
 * repository answered it. The class DESCRIPT tries: it is
 *
 *   sap.m.Breadcrumbs - breadcrumb trail with separator
 *
 * cut at 60 characters because that is all abapGit's short text holds, which
 * on many ports means cut mid-sentence ("An ActionListItem can be used like a").
 *
 * The full sentence exists and SAP wrote it - it is what the demo kit prints
 * under the sample title - and it says what the sample DEMONSTRATES, which no
 * amount of reading the ABAP recovers. It was simply not in this repository:
 * it lives in the OpenUI5 sources in `demokit/docuindex.json`, not in the
 * per-sample `manifest.json` that the ui5/ archive copies. So this is a fetch,
 * not an authorship exercise: `scripts/fetch-descriptions.mjs` snapshots those
 * entries into ui5/descriptions.json and this script writes them onto the
 * classes. Nothing here is invented.
 *
 * Where a port's summary comes from, in order:
 *
 *   1. ui5/descriptions.json `demokit`   the demo kit's own description of the
 *                                        sample named in meta/<class>.json.
 *                                        414 of 431 ports.
 *   2. ui5/descriptions.json `written`   the handful the demo kit does not
 *                                        describe - two shared "base" pages
 *                                        that are not samples of their own,
 *                                        one sample whose upstream description
 *                                        is empty. Each carries a `why`.
 *   3. derived, for the SAPUI5-only      src/03 holds controls that ship with
 *      collection (src/03)               SAPUI5 and not with OpenUI5: no demo
 *                                        kit original, no 1:1 port, no meta
 *                                        sidecar. Their line is composed from
 *                                        the entity in their own ABAP Doc.
 *
 * A port that fits none of the three is a FAILURE, not a silent skip - it means
 * a new sample arrived that upstream does not describe, and somebody has to add
 * a `written` entry (with a `why`) rather than let the gap pass unnoticed.
 *
 * One line, because a `"` comment is one line and abaplint holds lines to 255
 * characters. 62 of the 793 upstream descriptions are longer than that - 29 of
 * them on ported samples - and those are cut back to the last sentence that
 * still fits, see `fit`.
 *
 *   node scripts/generate-summary.mjs          write the lines
 *   node scripts/generate-summary.mjs --check  fail if a line is missing or
 *                                              out of date (CI runs this)
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const CHECK = process.argv.includes('--check');

/* abaplint holds a line to 255 characters (abaplint.jsonc `line_length`), and
 * `" @summary ` is 11 of them. */
const BUDGET = 255 - '" @summary '.length;

/* The generated overview app is owned by generate-overview.mjs, which writes
 * its whole header - including its own @keywords/@summary. Rewriting it here
 * would make the two generators fight over the same file: whichever ran last
 * would win and the other's drift gate would go red. */
const GENERATED = 'z2ui5_cl_smpc_app_000';

/** Demo kit prose -> one ABAP comment line: no markup, no exotic characters. */
function clean(text) {
  return String(text || '')
    .replace(/<[^>]+>/g, '')                       // <code>Toolbar</code> -> Toolbar
    .replace(/&(amp|lt|gt|quot|#39|nbsp);/g, (m) => (
      { '&amp;': '&', '&lt;': '<', '&gt;': '>', '&quot;': '"', '&#39;': "'", '&nbsp;': ' ' }[m]))
    /* The demo kit texts carry typographic characters - non-breaking spaces,
     * curly quotes, en dashes. ABAP source is UTF-8 and would hold them, but
     * a non-breaking space in a comment is invisible and unsearchable: a
     * reader typing a normal space never matches it. Fold them to ASCII. */
    .replace(/[   ]/g, ' ')
    .replace(/[‘’]/g, "'")
    .replace(/[“”]/g, '"')
    .replace(/[–—]/g, '-')
    .replace(/…/g, '...')
    .replace(/\s+/g, ' ')
    .trim();
}

/* Fit to one line: cut at the last sentence that fits.
 *
 * 62 of the 793 upstream descriptions are longer than a line holds, 29 of them
 * on samples this repository ports - the demo kit renders a paragraph, not a
 * subtitle. Cutting at a sentence rather than at a word is what keeps the line
 * readable: every one of the 29 lands between 93 and 244 characters and ends
 * with a full stop, and the sentence that gets kept is the one that says what
 * the sample is ("The initial page floorplan allows the user to navigate to a
 * single object to view or edit it.") - the rest was detail.
 *
 * The floor exists for a text whose only early full stop is an abbreviation
 * ("Fig. 1 shows ...") - there, a sentence cut would leave a stub, and half a
 * line ending in `...` is better than four words. Nothing in today's 793 hits
 * it; it is there so a future refresh cannot silently produce a stub. */
const FLOOR = 60;

function fit(text, budget = BUDGET) {
  if (text.length <= budget) return text;
  const head = text.slice(0, budget);
  const sentence = head.search(/[.!?](?=[^.!?]*$)/);   // last sentence end that fits
  if (sentence >= FLOOR) return head.slice(0, sentence + 1);
  const word = head.slice(0, budget - 3).lastIndexOf(' ');
  return `${head.slice(0, word)}...`;
}

const walk = (dir, out = []) => {
  for (const name of fs.readdirSync(dir)) {
    const full = path.join(dir, name);
    if (fs.statSync(full).isDirectory()) walk(full, out);
    else if (full.endsWith('.clas.abap')) out.push(full);
  }
  return out;
};

const DESCRIPTIONS = path.join(ROOT, 'ui5', 'descriptions.json');
if (!fs.existsSync(DESCRIPTIONS)) {
  console.error('ui5/descriptions.json missing — the summary line comes from that snapshot.');
  console.error('Rebuild it: node scripts/fetch-descriptions.mjs --openui5 <checkout>');
  process.exit(1);
}
const { demokit = {}, written = {} } = JSON.parse(fs.readFileSync(DESCRIPTIONS, 'utf8'));

const problems = [];
const from = { demokit: 0, written: 0, derived: 0 };
let write = 0;
let already = 0;

for (const file of walk(path.join(ROOT, 'src'))) {
  const cls = path.basename(file, '.clas.abap');
  if (cls === GENERATED) continue;
  const source = fs.readFileSync(file, 'utf8');
  if (!/INTERFACES\s+z2ui5_if_app\s*\./i.test(source)) continue;

  const metaPath = path.join(ROOT, 'meta', `${cls}.json`);
  const meta = fs.existsSync(metaPath) ? JSON.parse(fs.readFileSync(metaPath, 'utf8')) : null;

  let text = '';
  if (meta?.sample && clean(demokit[meta.sample]?.description)) {
    text = clean(demokit[meta.sample].description);
    from.demokit += 1;
  } else if (meta?.sample && written[meta.sample]?.description) {
    text = clean(written[meta.sample].description);
    from.written += 1;
  } else if (!meta) {
    /* The SAPUI5-only collection: no upstream sample, so no upstream sentence.
     * Its own ABAP Doc names the control - `"! <p class="shorttext">sap.gantt -
     * GanttChartWithTable</p>` - and that plus the one fact that matters about
     * these classes (they are orientation, not a port) is the whole summary. */
    const short = /shorttext">([^<]+)</.exec(source);
    const m = short && /^\s*([\w.]+)\s+-\s+(.+?)\s*$/.exec(short[1]);
    if (m) {
      text = `${m[1]}.${m[2]} expressed in abap2UI5 - a SAPUI5-only control, so the demo kit original is outside OpenUI5 and this is orientation rather than a 1:1 port.`;
      from.derived += 1;
    }
  }

  if (!text) {
    problems.push(meta?.sample
      ? `${cls}: nothing describes ${meta.sample}\n`
        + '      not in ui5/descriptions.json `demokit` (upstream may have dropped it, or the\n'
        + '      description is empty) — add a `written` entry with a `why`, or refresh the\n'
        + '      snapshot: node scripts/fetch-descriptions.mjs --openui5 <checkout>'
      : `${cls}: no meta sidecar and no shorttext to derive a summary from`);
    continue;
  }

  const line = `" @summary ${fit(text)}`;
  const have = (source.match(/^" @summary .*$/m) || [null])[0];

  if (have === line) { already += 1; continue; }
  if (CHECK) {
    problems.push(have
      ? `${cls}: the @summary line is out of date — run \`npm run summary\``
      : `${cls}: no \`" @summary\` line — run \`npm run summary\``);
    continue;
  }
  /* Under the keywords line when there is one, so the two search lines stay
   * together and in the same order as in abap2UI5/samples-stack. */
  fs.writeFileSync(file, have
    ? source.replace(/^" @summary .*$/m, line)
    : (/^" @keywords .*$/m.test(source)
      ? source.replace(/^(" @keywords .*)$/m, `$1\n${line}`)
      : `${line}\n${source}`));
  write += 1;
}

console.log(CHECK
  ? `summary: ${already} port(s) carry the sentence the snapshot holds`
  : `summary: ${write} written, ${already} already current`);
console.log(`  ${from.demokit} from the demo kit, ${from.written} written by hand (with a reason), ${from.derived} derived (SAPUI5-only)`);

if (problems.length) {
  console.error(`\n${problems.length} problem(s):`);
  for (const p of problems.slice(0, 10)) console.error(`  ${p}`);
  if (problems.length > 10) console.error(`  … and ${problems.length - 10} more`);
  console.error('\nThe sentence is the demo kit\'s, snapshotted in ui5/descriptions.json.');
  console.error('It is not written here — refresh the snapshot or record why it cannot be.');
  process.exit(1);
}
