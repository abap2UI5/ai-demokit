// the fixed-layout flag on the page table and on the dialog's own table
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Table');
    return t && t.getItems().length === 123 && t.getFixedLayout() === true;
  }, 'the table never rendered with its 123 rows and fixedLayout on');
  // un-checking the box has to reach the table's fixedLayout
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const cb = reg.find((c) => c.getMetadata().getName() === 'sap.m.CheckBox');
    cb.setSelected(false);
    cb.fireSelect({ selected: false });
  });
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Table');
    return t && t.getFixedLayout() === false;
  }, 'un-checking Fixed Layout never reached the table');
  // the dialog brings a second table with its own flag
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Open Dialog').firePress();
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Dialog'
    && c.getTitle() === 'Table Dialog'), 'the dialog never opened');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Table').length === 2,
    'the dialog opened without its own table');
};
