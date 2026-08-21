// The OData sample rebuilt on a seeded 115-row model. Neither of the two
// events answers with a toast, so what proves them is the model itself: both
// re-run model_init, so after each round-trip the binding must still carry all
// 115 rows and the first one must be back at the head of the model. The row
// count is also the deviation's first half — that the sample's threshold /
// scrollThreshold settings render the full model rather than a first page.
import { waitForUi5, ui5All, UI5_ALL_SRC } from '../../scripts/lib-e2e.mjs';

const rowCount = async (page) => page.evaluate(`(() => { ${UI5_ALL_SRC}
  const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
  const b = t && t.getBinding('rows');
  return b ? b.getLength() : null; })()`);

export default async (page, expect) => {
  await expect(page.locator('body'), 'the first seeded row').toContainText('Flyer');
  await expect(page.locator('body'), 'the Product Name column').toContainText('Product Name');
  if (await rowCount(page) !== 115) throw new Error(`the model did not render all 115 rows (got ${await rowCount(page)})`);

  // MODEL_REFRESH — re-seeds the model; the rows have to come back
  const refresh = page.getByRole('button', { name: 'Reinitialize Model' }).first();
  await expect(refresh, 'the Reinitialize Model button').toBeVisibleEnabled();
  await refresh.click();
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
    const b = t && t.getBinding('rows');
    return !!b && b.getLength() === 115;
  }, 'the refresh round-trip did not re-read the 115 rows');
  await expect(page.locator('body'), 'the first row after the refresh').toContainText('Flyer');

  // OPERATION_MODE — the SegmentedButton round-trips and keeps its selection
  await page.locator('[id$="operationMode"]').getByText('Client', { exact: true }).first().click();
  await waitForUi5(page, () => {
    const s = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.SegmentedButton'
      && c.getId().endsWith('operationMode'));
    return !!s && s.getSelectedKey() === 'Client';
  }, 'the operation-mode round-trip did not keep the selected key');
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
    const b = t && t.getBinding('rows');
    return !!b && b.getLength() === 115;
  }, 'the operation-mode round-trip did not re-read the rows');
};
