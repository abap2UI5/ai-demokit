// the loadItems wire fetching the items only when the picker opens
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.ComboBox' && c.getItems().length === 0),
    'the ComboBox never rendered empty before the first loadItems');
  const arrow = page.locator('.sapMInputBaseIconContainer').first();
  await expect(arrow, 'the ComboBox arrow').toBeVisibleEnabled();
  await arrow.click();
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.ComboBox' && c.getItems().length > 100),
    'the loadItems round-trip never filled the bound items');
};
