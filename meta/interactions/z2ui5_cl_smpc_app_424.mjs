// the shared two-way flag (CheckBox.selected -> OverflowToolbar.active) and the
// client-composed constant toast on the toolbar press
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  // the toolbar boots active (the flag is seeded abap_true)
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.OverflowToolbar' && c.getActive() === true),
    'the OverflowToolbar never rendered active (seed abap_true)');
  // pressing the active toolbar fires the client-composed toast
  await page.locator('.sapMTB').first().click();
  await expect(page.locator('.sapMMessageToast'), 'the constant client toast on the toolbar press').toContainText('OverflowToolbar is clicked');
  // unchecking the box has to reach OverflowToolbar.active through the shared flag
  await page.locator('.sapMCb').first().click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.OverflowToolbar' && c.getActive() === false),
    'the CheckBox never reached OverflowToolbar.active (shared two-way flag)');
};
