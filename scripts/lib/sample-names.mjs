/* The demo kit's own name for a sample — "Action List Item", "Fullscreen –
 * two groups (vertical)" — read from the ui5/descriptions.json snapshot.
 *
 * Three generators title their entries with it (SAMPLES.md, catalogue.json,
 * the Pages apps.json), and until this helper each read the snapshot for
 * itself: two of them knew only the `demokit` block, so the two samples that
 * exist upstream UNDOCUMENTED (the snapshot's `written` block, Form480 and
 * SimpleForm480) fell back to the class DESCRIPT — whose first half is a
 * library name, which is exactly the vagueness the title field exists to
 * avoid. One function, so the three surfaces cannot disagree about what a
 * sample is called.
 *
 * The name is cleaned on the way out: the demo kit's docuindex carries
 * non-breaking spaces and trailing blanks in a handful of names
 * ("Fullscreen – with toolbar", "… long labels "), which are invisible
 * on the demo kit page and line noise in a JSON diff or a markdown row.
 * `\s` matches  , so one collapse covers both.
 */
import fs from 'fs';
import path from 'path';

/** Collapse all whitespace (non-breaking spaces included) to single spaces. */
const clean = (s) => String(s || '').replace(/\s+/g, ' ').trim();

/** A lookup `sample id -> demo kit name` over both snapshot blocks;
 *  returns `''` for a sample neither block names. */
export function sampleNames(root) {
  const file = path.join(root, 'ui5', 'descriptions.json');
  const { demokit = {}, written = {} } = JSON.parse(fs.readFileSync(file, 'utf8'));
  return (sample) => clean((demokit[sample] || written[sample] || {}).name);
}
