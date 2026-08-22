// the table page, the open-selected flow and the TabContainer it fills
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.ColumnListItem').length > 100,
    'the product table never rendered its 123 rows');
  // the footer button is invisible until something is selected
  await waitForUi5(page, () => ui5All().some((c) => c.getId().endsWith('idOpenSelected') && c.getVisible() === false),
    'the open-selected button was visible with no selection');
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const table = reg.find((c) => c.getId().endsWith('idProductsTable'));
    table.setSelectedItem(table.getItems()[0], true, true);
    table.setSelectedItem(table.getItems()[1], true, true);
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getId().endsWith('idOpenSelected') && c.getVisible() === true),
    'selecting rows never revealed the open-selected button');
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getId().endsWith('idOpenSelected')).firePress();
  });
  // one tab per selected row, each showing its Display header
  await waitForUi5(page, () => {
    const tc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.TabContainer');
    return tc && tc.getItems().length === 2;
  }, 'the two selected rows never became two tabs');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.ObjectHeader' && c.getVisible() === true),
    'a tab opened without its Display header');
  // the Edit form of a tab is hidden until that tab is modified
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.ui.layout.form.SimpleForm')
    .some((c) => c.getVisible() === false), 'the tab Edit form was not hidden while the tab is unmodified');
};
