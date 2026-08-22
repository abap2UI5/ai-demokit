// the change wire validating in ABAP and writing the bound value state
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const input = page.locator('.sapMInputBaseInner').first();
  await expect(input, 'the ComboBox input').toBeVisibleEnabled();
  await input.click();
  await input.fill('Nowhereland');
  await input.press('Enter');
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.ComboBox' && c.getValueState() === 'Error'),
    'the change round-trip never set the bound Error value state for an unknown country');
};
