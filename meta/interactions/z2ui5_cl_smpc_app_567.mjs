// the two tables whose columns come from a bound array, and the Strict switch
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Table').length === 2,
    'the two tables never rendered');
  // three columns per table, from the bound arrays
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Column').length === 6,
    'the bound columns aggregations did not produce three columns per table');
  // the clone array gives the first table an auto column, the other keeps 30%
  await waitForUi5(page, () => {
    const widths = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Column').map((c) => c.getWidth());
    return widths.includes('auto') && widths.includes('30%');
  }, 'the clone and columns arrays did not reach their tables');
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getId().endsWith('table'));
    return t && t.getItems().length === 3 && t.getFixedLayout() === true;
  }, 'the first table never rendered its three rows with the default layout');
  // checking Strict Layout has to turn fixedLayout into the string
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const cb = reg.find((c) => c.getMetadata().getName() === 'sap.m.CheckBox');
    cb.setSelected(true);
    cb.fireSelect({ selected: true });
  });
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getId().endsWith('table'));
    return t && t.getFixedLayout() === 'Strict';
  }, 'the Strict Layout box never reached the table');
};
