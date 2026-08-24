/*
 * app 361 — sap.ui.table.sample.Selection
 *
 * Closes the LIVE_TEST's first and third claims: that `rowSelectionChange`
 * delivers the selected index array as JSON to `get_event_arg`, and that the
 * `control_by_id` clearSelection wire works. It selects a row, asks the app to
 * report the indices, and then clears.
 *
 * Two things cost a run each and are worth stating:
 *
 * - the three buttons live in the toolbar's OVERFLOW at the smoke's viewport
 *   ("Additional Options"), and the popover CLOSES on each press, so it has to
 *   be reopened before every one of them;
 * - selectionBehavior is RowSelector, so clicking the ROW does nothing: only
 *   the selector column selects, and its cell is `.sapUiTableRowSelectionCell`
 *   (a separate `.sapUiTableRowHdrScr` container, not a child of the row).
 *   Clicking the row instead gets you "no item selected" from the app, which
 *   reads like the wire being broken rather than like a missed click.
 *
 * The second claim — that the two bound Selects drive selectionMode and
 * selectionBehavior without a round-trip — is verified by the DOM rather than
 * by pressing anything: the table element carries `sapUiTableSelModeMultiToggle`,
 * which is the bound value rendered.
 *
 * Two rows, not one (2026-08-24). On 2026-08-21 the wire was rewritten from
 * `${$parameters>/rowIndices}` to `${$source>}.getSelectedIndices()`, because
 * the event parameter reports the rows whose selection CHANGED, not the rows
 * currently selected. This module selected exactly one row, which is the single
 * case where the two coincide — so it went on passing across the rewrite and
 * neither of the cases that motivated it was ever exercised. Select a second
 * row (expect two indices) and then deselect both (expect the empty report).
 */
export default async (page) => {
  const openOverflow = async () => {
    const ov = page.getByRole('button', { name: /Additional Options/i }).first();
    if (await ov.count()) { await ov.click(); await page.waitForTimeout(700); }
  };
  const press = async (name) => {
    await openOverflow();
    await page.getByRole('button', { name, exact: true }).first().click();
    await page.waitForTimeout(2500);
  };
  const toasts = async () =>
    (await page.locator('.sapMMessageToast').allInnerTexts()).map((s) => s.trim()).filter(Boolean);

  // the bound selectionMode reached the control: it is rendered as a class
  const mode = await page.evaluate(() => document.querySelector('.sapUiTable')?.className || '');
  if (!/sapUiTableSelModeMultiToggle/.test(mode)) {
    throw new Error(`bound selectionMode did not reach the table: ${mode}`);
  }

  const cells = page.locator('.sapUiTableRowSelectionCell');
  await cells.nth(0).click();
  await page.waitForTimeout(1500);
  // MultiToggle: a second plain click ADDS the row rather than replacing it
  await cells.nth(1).click();
  await page.waitForTimeout(1500);

  await press('show indices of selected items');
  const reported = await toasts();
  if (!reported.length) throw new Error('no toast after "show indices of selected items"');
  // the app composes the toast from the index array it received
  if (!/\d/.test(reported.join(' '))) {
    throw new Error(`the index array did not arrive: ${JSON.stringify(reported)}`);
  }
  const last = reported[reported.length - 1];
  // the discriminating half: BOTH selected rows have to be in the report. The
  // changed-rows parameter would have carried only the second one.
  if (!/0/.test(last) || !/1/.test(last)) {
    throw new Error(`only part of the selection was reported: ${JSON.stringify(last)}`);
  }
  console.log(`  indices: ${JSON.stringify(last)}`);

  await press('clear selection');
  const selected = await page.locator('.sapUiTableRowSel').count();
  if (selected > 0) throw new Error(`clearSelection left ${selected} row(s) selected`);
};
