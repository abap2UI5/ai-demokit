// The two-table move demo. What replaced the DOM dump that used to sit here
// (it printed the buttons and passed whatever the port did):
//
// The LIVE_TEST asks three things. Two of them are reachable and are asserted
// below; the drag & drop legs are not, and the module says so rather than
// pretending — see the note at the bottom.
//
//   - the rowSelectionChange rowIndex really travels. Asserted on a SPECIFIC
//     row: selecting row 2 and pressing "Move to selected" must move
//     "Notebook Basic 17" and nothing else. A module that only counted rows
//     would pass on an off-by-one, which is the whole risk with an index that
//     is 0-based on the wire and 1-based in ABAP.
//   - MOVE_UP reorders inside the selected table, which is the SELECT_2 index
//     driving a second handler.
//
// sap.ui.table selects through the row SELECTOR cell, not the row: the table
// leaves selectionBehavior at its default RowSelector, so clicking a data cell
// selects nothing and the round-trip never fires.
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

// the NAMES currently bound in one of the two tables, template rows excluded
// (an unbound template row sits in the Element registry next to the real ones
// and answers '' for every cell — the app-207 trap)
const namesIn = (page, id) => page.evaluate(`(() => {
  const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
  const t = ui5All().find((c) => c.getId().endsWith(${JSON.stringify(id)}));
  if (!t) return null;
  return t.getRows().filter((r) => r.getBindingContext()).map((r) => r.getCells()[0].getText()).filter(Boolean);
})()`);

const selectRow = async (page, tableId, index) => {
  const rows = page.locator(`[id$="${tableId}"] .sapUiTableRowSelectionCell, [id$="${tableId}"] .sapUiTableRowHdr`);
  await rows.nth(index).click();
};

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const ui5 = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const t = ui5.find((c) => c.getId().endsWith('table1'));
    return t && t.getRows().some((r) => r.getBindingContext());
  }, 'the available-products table never bound its rows');
  await expect(page.locator('body'), 'the empty selected table').toContainText('Please drag-and-drop products here.');

  // row 2 of the available table -> the selected table, by name
  await selectRow(page, 'table1', 1);
  await page.getByRole('button', { name: 'Move to selected' }).click();
  await waitForUi5(page, () => {
    const ui5 = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const t = ui5.find((c) => c.getId().endsWith('table2'));
    return t && t.getRows().filter((r) => r.getBindingContext())
      .map((r) => r.getCells()[0].getText()).includes('Notebook Basic 17');
  }, 'the selected row index never reached MOVE_TO_2 — "Notebook Basic 17" did not arrive in the selected table');
  const avail = await namesIn(page, 'table1');
  if (avail.includes('Notebook Basic 17')) {
    throw new Error('the moved row is still in the available table — the wire copied instead of moving');
  }

  // a second row, so there is an order to change
  await selectRow(page, 'table1', 2);
  await page.getByRole('button', { name: 'Move to selected' }).click();
  await waitForUi5(page, () => {
    const ui5 = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const t = ui5.find((c) => c.getId().endsWith('table2'));
    return t && t.getRows().filter((r) => r.getBindingContext()).length === 2;
  }, 'the second move never reached the selected table');
  const before = await namesIn(page, 'table2');

  // Move up on the SECOND selected row: the two must swap, which is SELECT_2's
  // index driving the reorder rather than a fixed one
  await selectRow(page, 'table2', 1);
  await page.getByRole('button', { name: 'Move up' }).first().click();
  await waitForUi5(page, (want) => {
    const ui5 = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const t = ui5.find((c) => c.getId().endsWith('table2'));
    const now = t ? t.getRows().filter((r) => r.getBindingContext()).map((r) => r.getCells()[0].getText()) : [];
    return now.length === 2 && now[0] === want[1] && now[1] === want[0];
  }, `Move up never swapped the two selected rows (they were ${JSON.stringify(before)})`, before);
};

// NOT covered here, and deliberately: the four drag & drop wires (DROP_TO_1,
// DROP_TO_2 and the internal-vs-external expression that tells a reorder from
// a move). They ride on HTML5 drag & drop, which sap.ui.table drives through
// its own pointer extension; Playwright's dragTo synthesises a pointer
// sequence that never produces the dragstart/dragover/drop triple UI5 listens
// for, and dispatching the DataTransfer events by hand would be testing the
// harness rather than the port. Those legs stay with the human live run, which
// is why 353's LIVE_TEST stays open — the same call as 359's row actions.
