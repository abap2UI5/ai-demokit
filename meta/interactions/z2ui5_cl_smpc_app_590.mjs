// the six filler sections, the Employment form and the Focus action
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const secs = ui5All().filter((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageSection');
    return secs.length === 7 && secs[6].getTitle() === 'Employment';
  }, 'the seven sections never rendered');

  // the two ColumnElementData layoutData are what the form is about
  await waitForUi5(page, () => {
    const spans = ui5All().filter((c) => c.getMetadata().getName() === 'sap.ui.layout.form.ColumnElementData')
      .map((d) => `${d.getCellsSmall()}/${d.getCellsLarge()}`);
    return spans.join(',') === '2/1,3/2';
  }, 'the two ColumnElementData layoutData never reached the form');

  await waitForUi5(page, () => {
    const sel = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Select');
    return sel && sel.getItems().map((i) => i.getKey()).join(',') === 'England,Germany,USA';
  }, 'the Country select never got its three items');

  // the Focus action puts the caret in the Name field
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Focus').firePress();
  });
  await page.waitForFunction(
    () => document.activeElement && document.activeElement.id.includes('nameInput'),
    null, { timeout: 15000 },
  );
};
