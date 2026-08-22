// the shared two-way flag: CheckBox.selected -> OverflowToolbar.enabled
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.OverflowToolbar' && c.getEnabled() === true),
    'the OverflowToolbar never rendered enabled (seed abap_true)');
  // the FIRST CheckBox is the one outside the toolbar (the toolbar carries its own)
  const box = page.locator('.sapMCb').first();
  await expect(box, 'the Enabled CheckBox').toBeVisibleEnabled();
  await box.click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.OverflowToolbar' && c.getEnabled() === false),
    'the CheckBox never reached OverflowToolbar.enabled (shared two-way flag)');
};
