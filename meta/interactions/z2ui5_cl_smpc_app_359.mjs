// RowAction: the bound rowActionCount plus the per-item visible flags have to
// reproduce each mode's row actions, and the client-composed toast has to fill
// BOTH of its placeholders — the item (by text, falling back to its type) and
// the product id read off the row's binding context. A one-placeholder check
// would pass on a toast that lost the row.
import { waitForUi5, ui5All, UI5_ALL_SRC } from '../../scripts/lib-e2e.mjs';

const actionCount = async (page) => page.evaluate(`(() => { ${UI5_ALL_SRC}
  const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
  return t ? t.getRowActionCount() : null; })()`);

const pickMode = async (page, text) => {
  await page.locator('[id$="select"]').first().click();
  await page.locator('.sapMSltPicker').getByText(text, { exact: true }).first().click();
};

export default async (page, expect) => {
  await expect(page.locator('body'), 'the seeded rows').toContainText('Notebook Basic 15');
  if (await actionCount(page) !== 1) throw new Error('the Navigation mode did not start with rowActionCount 1');

  // the two-placeholder toast — Navigation has no text, so the wire falls back
  // to its TYPE, and the id comes off the first row's binding context
  await page.locator('.sapUiTableRowActionCell button').first().click();
  await expect(page.locator('.sapMMessageToast').last(), 'the row-action toast')
    .toContainText('Item Navigation pressed for product with id HT-1000');

  // each mode re-binds rowActionCount
  await pickMode(page, 'Multiple Actions');
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
    return !!t && t.getRowActionCount() === 2;
  }, 'the Multiple Actions mode did not re-bind rowActionCount to 2');
  await expect(page.locator('body'), 'a custom row action of the Multi mode').toContainText('Attachment');

  await pickMode(page, 'No Actions');
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
    return !!t && t.getRowActionCount() === 0;
  }, 'the No Actions mode did not re-bind rowActionCount to 0');
};
