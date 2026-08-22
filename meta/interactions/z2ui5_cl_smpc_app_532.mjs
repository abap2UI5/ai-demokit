// the QuickView popover and the navOrigin page swap
//
// NOTE: the QuickView's `pages` aggregation is BOUND, so its template is a
// live Element in the registry too — a registry-wide count of QuickViewPage
// answers one too many (measured 2026-08-22: "", "SAP SE", "John Doe" for two
// real pages). Ask the QuickView for its own getPages().
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  // a DOM click on the button does not reach the control's press handling in
  // the unthemed harness (measured 2026-08-22: nothing opened) — fire it
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Open QuickView').firePress();
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.QuickView'),
    'the press never opened the QuickView (popover_display)');
  await expect(page.locator('body'), 'the bank page').toContainText('Johnny Cash');
  // page 2 boots EMPTY - onNavigate fills it from the clicked link
  // Page 2 does NOT boot empty, in the port or upstream: the pages binding is
  // templateShareable (as the sample's fragment writes it), so the row whose
  // title field is unset keeps the title the shared template last rendered —
  // measured 2026-08-22, both pages read "SAP SE" before the navigate. What
  // the wire has to prove is the SWAP, below.
  await waitForUi5(page, () => {
    const qv = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.QuickView');
    return qv && qv.getPages().length === 2
      && qv.getPages().map((p) => p.getPageId()).join(',') === 'bankPage,contactPage';
  }, 'the QuickView rendered without its two pages');
  await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const qv = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.QuickView');
    const link = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Link' && c.getText() === 'Johnny Cash');
    qv.fireEvent('navigate', { navOrigin: link });
  })()`);
  await waitForUi5(page, () => {
    const qv = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.QuickView');
    return qv && qv.getPages()[1].getTitle() === 'Johnny Cash';
  }, 'the navOrigin round-trip never filled the contact page');
};
