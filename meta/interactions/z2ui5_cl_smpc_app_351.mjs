// The Splitter whose contentAreas AND the option rows below it are bound to
// ONE table, so a row is the single source of truth for an area and its
// options. What replaced the DOM dump that used to sit here (it printed the
// buttons and passed no matter what the port did):
//
//   - Add / Remove really re-render the bound aggregation. Counted off the
//     Splitter's own getContentAreas(), not off the option rows: those are a
//     second binding against the same table, so counting them would pass even
//     if the aggregation never followed.
//   - a Min-Size typed into an option row reaches that area's
//     SplitterLayoutData.minSize as an INTEGER. This is the leg that proves
//     the option row and the layout data stay in sync — the LIVE_TEST asks it
//     about a splitter-bar DRAG, which cannot be done headless (the bar is a
//     zero-size box in the unthemed harness), but the drag and the Input write
//     into the same row, and only this direction is reachable. The port parses
//     the string in ABAP over the whole two-way returned table, so a number
//     arriving here means the round-trip and the parse both ran.
//   - Change Orientation flips a BOUND property instead of calling a setter,
//     which is the port's whole deviation from the original's imperative
//     btnChangeOrientation.
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

const SPLITTER = `ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.layout.Splitter')`;

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const s = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.layout.Splitter');
    return s && s.getContentAreas().length === 3;
  }, 'the Splitter did not start with the three declared content areas');

  const count = () => page.evaluate(`(() => { const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const s = ${SPLITTER}; return s ? s.getContentAreas().length : -1; })()`);

  await page.getByRole('button', { name: 'Add content area' }).click();
  await waitForUi5(page, () => {
    const s = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.layout.Splitter');
    return s && s.getContentAreas().length === 4;
  }, 'Add content area never grew the bound contentAreas aggregation');
  // the fourth area's own option row followed the same table
  await expect(page.locator('body'), 'the option row of the area just added').toContainText('ContentArea #4');

  await page.getByRole('button', { name: 'Remove content area' }).click();
  await waitForUi5(page, () => {
    const s = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.layout.Splitter');
    return s && s.getContentAreas().length === 3;
  }, 'Remove content area never shrank the bound contentAreas aggregation');
  if ((await count()) !== 3) throw new Error('the Splitter did not come back to three areas');

  // the option row and the layout data are the same row: a Min-Size typed here
  // must arrive on the FIRST area's SplitterLayoutData as the integer 250
  // (it starts at 0, so an unchanged value cannot be mistaken for a pass)
  const minSize = page.locator('.sapMInputBaseInner').nth(1);
  await expect(minSize, 'the first area\'s Min-Size Input').toHaveValue('0');
  await minSize.fill('250');
  await minSize.press('Enter');
  await waitForUi5(page, () => {
    const s = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.layout.Splitter');
    return s && s.getContentAreas()[0].getLayoutData().getMinSize() === 250;
  }, 'the typed Min-Size never reached the first area\'s SplitterLayoutData as a number');

  // orientation is a BOUND property here, so the flip travels through the model
  await page.getByRole('button', { name: 'Change Orientation' }).click();
  await waitForUi5(page, () => {
    const s = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.layout.Splitter');
    return s && s.getOrientation() === 'Vertical';
  }, 'Change Orientation never flipped the bound Splitter.orientation');

  // Invalidate is a plain round-trip: it must answer, and the areas must
  // survive it (the port drops the original's invalidate() call deliberately)
  await page.getByRole('button', { name: 'Invalidate Splitter' }).click();
  await page.waitForTimeout(1500);
  if ((await count()) !== 3) throw new Error('the Invalidate round-trip lost the content areas');
};
