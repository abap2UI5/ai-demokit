// the QuickView popover and the navOrigin page swap
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await page.locator('button:has-text("Open QuickView")').first().click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.QuickView'),
    'the press never opened the QuickView (popover_display)');
  await expect(page.locator('body'), 'the bank page').toContainText('Johnny Cash');
  // page 2 boots EMPTY - onNavigate fills it from the clicked link
  await waitForUi5(page, () => {
    const pages = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.QuickViewPage');
    return pages.length === 2 && !pages[1].getTitle();
  }, 'the contact page did not boot empty');
  await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const qv = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.QuickView');
    const link = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Link' && c.getText() === 'Johnny Cash');
    qv.fireEvent('navigate', { navOrigin: link });
  })()`);
  await waitForUi5(page, () => {
    const pages = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.QuickViewPage');
    return pages.length === 2 && pages[1].getTitle() === 'Johnny Cash';
  }, 'the navOrigin round-trip never filled the contact page');
};
