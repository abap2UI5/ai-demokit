// the state model drives the titles and modes, and the two header buttons
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  // two section titles and four subsection title/mode pairs, all from the model
  await waitForUi5(page, () => {
    const secs = ui5All().filter((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageSection');
    return secs.map((s) => s.getTitle()).join('|') === 'my first section|my second section';
  }, 'the two bound section titles never rendered');

  await waitForUi5(page, () => {
    const subs = ui5All().filter((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageSubSection');
    return subs.map((s) => `${s.getTitle()}:${s.getMode()}`).join('|')
      === 'general info:Collapsed|my detail info:Collapsed|compensation:Collapsed|compensation details:Expanded';
  }, 'the four bound subsection title/mode pairs never rendered');

  // the second header button dumps the state the backend owns
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button'
      && c.getIcon() === 'sap-icon://show').firePress();
  });
  await expect(page.locator('.sapMMessageToast').last(), 'the SHOW_STATE toast')
    .toContainText('ObjectPageLayout current state');

  // and the subsection action toasts round-trip-free
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button'
      && c.getIcon() === 'sap-icon://action').firePress();
  });
  await expect(page.locator('.sapMMessageToast').last(), 'the onActionPress toast')
    .toContainText('action pressed !');
};
