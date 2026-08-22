// the suggest round-trip filling the bound suggestion items in the backend
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const input = page.locator('.sapMInputBaseInner').first();
  await expect(input, 'the product Input').toBeVisibleEnabled();
  await input.click();
  await input.press('N');
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .filter((c) => c.getMetadata().getName() === 'sap.ui.core.Item').length > 1,
    'the suggest round-trip never filled the bound suggestion items');
};
