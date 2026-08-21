// RowAction: the bound rowActionCount has to follow each mode the Select
// picks, and the union template's per-item visible flags have to switch with
// it — that is the half of the deviation this harness can settle.
//
// The other half, the two-placeholder toast on a row-action PRESS, is not
// reachable here and this module deliberately does not pretend otherwise: the
// row actions never render at all in the smoke. Measured 2026-08-21 — the
// action cells hold nothing but their navIndicator div, in Navigation mode and
// in Multiple Actions mode alike, and calling `setRowActionCount(2)` plus
// `invalidate()` DIRECTLY on the table through its own API (bypassing the port
// entirely) still leaves every row without a `_rowAction`. That rules the port
// out as the cause. A gesture cannot be aimed at a control that is not there,
// so the toast leg stays with the human live run; see
// meta/interactions/README.md "still open".
import { waitForUi5, ui5All, UI5_ALL_SRC, revealInOverflow } from '../../scripts/lib-e2e.mjs';

const actionCount = async (page) => page.evaluate(`(() => { ${UI5_ALL_SRC}
  const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
  return t ? t.getRowActionCount() : null; })()`);

const pickMode = async (page, text) => {
  const sel = page.locator('[id$="select"]').first();
  await revealInOverflow(page, sel);
  await sel.click();
  await page.locator('.sapMSltPicker').getByText(text, { exact: true }).first().click();
};

export default async (page, expect) => {
  await expect(page.locator('body'), 'the seeded rows').toContainText('Notebook Basic 15');
  if (await actionCount(page) !== 1) throw new Error('the Navigation mode did not start with rowActionCount 1');

  // Only the COUNT is asserted per mode. The per-item visible flags cannot be
  // read here either: each item's `visible` is an expression over ${AVAILABLE},
  // a ROW property, and the only RowAction that exists is the binding TEMPLATE,
  // which carries no binding context — its getVisible() answers for no row at
  // all (measured 2026-08-21: the Navigation item still reads visible in the
  // Multiple Actions mode, where every row hides it). Same trap as app 207.
  await pickMode(page, 'Multiple Actions');
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
    return !!t && t.getRowActionCount() === 2;
  }, 'the Multiple Actions mode did not re-bind rowActionCount to 2');

  await pickMode(page, 'No Actions');
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
    return !!t && t.getRowActionCount() === 0;
  }, 'the No Actions mode did not re-bind rowActionCount to 0');
};
