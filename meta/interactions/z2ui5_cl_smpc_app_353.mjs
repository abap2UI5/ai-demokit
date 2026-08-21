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
import { waitForUi5, dispatchMouse, revealInOverflow } from '../../scripts/lib-e2e.mjs';

// the NAMES currently bound in one of the two tables, template rows excluded
// (an unbound template row sits in the Element registry next to the real ones
// and answers '' for every cell — the app-207 trap)
const namesIn = (page, id) => page.evaluate(`(() => {
  const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
  const t = ui5All().find((c) => c.getId().endsWith(${JSON.stringify(id)}));
  if (!t) return null;
  return t.getRows().filter((r) => r.getBindingContext()).map((r) => r.getCells()[0].getText()).filter(Boolean);
})()`);

// Two harness effects stack on this one gesture.
//
// The row selector cell HAS a layout box here (1264x20, measured) — the
// unthemed harness lets it span the whole row instead of the narrow column it
// occupies with a theme — but it sits in the absolutely positioned row-header
// layer UNDER the data cells, so every Playwright actionability check reports
// the pointer as intercepted and .click() dies in a 30s timeout that reads
// like a missing control. The dispatched mouse sequence is the same answer the
// zero-size-icon lesson gives, and sap.ui.table's pointer extension acts on
// the mousedown/mouseup pair, so the whole sequence is what selects.
//
// And selecting is a ROUND-TRIP (rowSelectionChange → SELECT_n) whose result
// the next press depends on: the move handler answers "Please select a row!"
// while selected_n is still 0. No bound value on the page shows that index, so
// there is nothing to wait for in the UI — but the round-trip itself is
// observable. Without this wait the click and the press raced and the move
// silently toasted instead.
const selectRow = async (page, tableId, index) => {
  const cells = page.locator(`[id$="${tableId}"] .sapUiTableRowSelectionCell`);
  const n = await cells.count();
  if (n <= index) throw new Error(`${tableId} rendered ${n} row selector cell(s), need index ${index}`);
  await Promise.all([
    page.waitForResponse((r) => r.request().method() === 'POST' && r.url().includes(':3000'), { timeout: 15000 }),
    dispatchMouse(cells.nth(index)),
  ]);
};

// The move buttons are ICON-ONLY, so the unthemed harness leaves them a
// zero-size box and .click() dies in the same 30s timeout — the icon lesson,
// one control further along. Their accessible name comes from the tooltip.
// Move up / Move down live in table 2's extension OverflowToolbar, which folds
// them into "Additional Options" at the smoke's viewport — so they are not on
// the page at all until that popover is opened (measured 2026-08-21: the
// locator simply found nothing). The two arrow buttons between the tables are
// plain VBox children and are already there.
const pressIcon = async (page, name) => {
  const b = page.getByRole('button', { name });
  if (!(await b.count())) await revealInOverflow(page, b);
  if (!(await b.count())) throw new Error(`no button named "${name}", on the page or in any overflow`);
  await dispatchMouse(b.first());
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
  await pressIcon(page, 'Move to selected');
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
  await pressIcon(page, 'Move to selected');
  await waitForUi5(page, () => {
    const ui5 = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const t = ui5.find((c) => c.getId().endsWith('table2'));
    return t && t.getRows().filter((r) => r.getBindingContext()).length === 2;
  }, 'the second move never reached the selected table');
  const before = await namesIn(page, 'table2');

  // Move up on the SECOND selected row: the two must swap, which is SELECT_2's
  // index driving the reorder rather than a fixed one
  await selectRow(page, 'table2', 1);
  await pressIcon(page, 'Move up');
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
