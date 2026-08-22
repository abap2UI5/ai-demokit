// the four view types collapse to four sections, and the footer toggle
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const secs = ui5All().filter((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageSection');
    return secs.map((s) => s.getTitle()).join('|') === 'Typed View|JSON View|HTML View|XML View';
  }, 'the four view-type sections never rendered');

  // the typed view's own spelling and its Button are what tell it apart
  await expect(page.locator('.sapUiForm').first(), 'the typed view block')
    .toContainText('Evangelize the UI framework accross the company');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Button'
    && c.getText() === 'Hello from a typed view'), 'the typed view button never rendered');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Button'
    && c.getText() === 'Hello from JSON view'), 'the JSON view button never rendered');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Button'
    && c.getText() === 'Hello from HTML view'), 'the HTML view button never rendered');

  // the footer starts hidden and the third header action shows it
  await waitForUi5(page, () => {
    const opl = ui5All().find((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageLayout');
    return opl && opl.getShowFooter() === false;
  }, 'the footer did not start hidden');
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageHeaderActionButton'
      && c.getText() === 'Toggle Footer').firePress();
  });
  await waitForUi5(page, () => {
    const opl = ui5All().find((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageLayout');
    return opl && opl.getShowFooter() === true;
  }, 'TOGGLE_FOOTER never showed the footer');
};
