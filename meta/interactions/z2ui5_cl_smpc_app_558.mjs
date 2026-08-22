// the table page, the open-selected flow and the TabContainer it fills
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

const select = async (page, index) => {
  await page.evaluate((i) => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const table = reg.find((c) => c.getId().endsWith('idProductsTable'));
    table.setSelectedItem(table.getItems()[i], true, true);
  }, index);
  // each selectionChange is a round trip, and the model that comes back carries
  // the flags - so the two rows have to be selected one after the other
  await waitForUi5(page, (n) => {
    const t = ui5All().find((c) => c.getId().endsWith('idProductsTable'));
    return t.getSelectedItems().length === n;
  }, `row ${index} never stayed selected`, index + 1);
};

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.ColumnListItem').length > 100,
    'the product table never rendered its 123 rows');
  // the footer button is invisible until something is selected
  await waitForUi5(page, () => ui5All().some((c) => c.getId().endsWith('idOpenSelected') && c.getVisible() === false),
    'the open-selected button was visible with no selection');
  await select(page, 0);
  await waitForUi5(page, () => ui5All().some((c) => c.getId().endsWith('idOpenSelected') && c.getVisible() === true),
    'selecting a row never revealed the open-selected button');
  await select(page, 1);
  // let the selection round trip settle: a press fired while one is in flight
  // is dropped, so the backend would still be on the first selection
  await page.waitForTimeout(1500);
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getId().endsWith('idOpenSelected')).firePress();
  });
  // one tab per selected row, each showing its Display header
  await waitForUi5(page, () => {
    const tc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.TabContainer');
    return tc && tc.getItems().length === 2;
  }, 'the two selected rows never became two tabs');
  await waitForUi5(page, () => {
    const nav = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.NavContainer');
    return nav && /tabContainerPage$/.test(nav.getCurrentPage().getId());
  }, 'the open-selected press never navigated to the tab page');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.ObjectHeader' && c.getVisible() === true),
    'a tab opened without its Display header');
  // the Edit form of a tab is hidden until that tab is modified
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.ui.layout.form.SimpleForm')
    .some((c) => c.getVisible() === false), 'the tab Edit form was not hidden while the tab is unmodified');
};
