// the QuickView popover, its two pages and the avatar press
//
// NOTE: the QuickView's `pages` aggregation is BOUND, so its template is a
// live Element in the registry too — a registry-wide count of QuickViewPage
// answers one too many (measured 2026-08-22: "", "SAP SE", "John Doe" for two
// real pages). Ask the QuickView for its own getPages().
import { waitForUi5, ui5All, dispatchMouse } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  // a DOM click on the button does not reach the control's press handling in
  // the unthemed harness (measured 2026-08-22: nothing opened) — fire it
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Employee QuickView').firePress();
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.QuickView'),
    'the press never opened the QuickView (popover_display)');
  await waitForUi5(page, () => {
    const qv = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.QuickView');
    return qv && qv.getPages().length === 2;
  }, 'the QuickView rendered without its two pages');
  await expect(page.locator('body'), 'the company page').toContainText('Founded in 1972');
  // the avatar press is the client-composed toast
  await dispatchMouse(page.locator('.sapFAvatar').first());
  await expect(page.locator('.sapMMessageToast'), 'the avatar toast').toContainText('Avatar was pressed');
};
