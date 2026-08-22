// the QuickView popover, its two pages and the avatar press
import { waitForUi5, ui5All, dispatchMouse } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await page.locator('button:has-text("Employee QuickView")').first().click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.QuickView'),
    'the press never opened the QuickView (popover_display)');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.QuickViewPage').length === 2,
    'the QuickView rendered without its two pages');
  await expect(page.locator('body'), 'the company page').toContainText('Founded in 1972');
  // the avatar press is the client-composed toast
  await dispatchMouse(page.locator('.sapFAvatar').first());
  await expect(page.locator('.sapMMessageToast'), 'the avatar toast').toContainText('Avatar was pressed');
};
