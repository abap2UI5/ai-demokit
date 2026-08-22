// the press wire marking exactly one row navigated in the backend
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const row = page.locator('.sapMListTblRow').first();
  await expect(row, 'the first table row').toBeVisibleEnabled();
  await row.click();
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .filter((c) => c.getMetadata().getName() === 'sap.m.ColumnListItem' && c.getNavigated()).length === 1,
    'the press round-trip never marked exactly one row navigated');
};
