// the mass-edit DatePickers and the selection-driven Edit button
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.ColumnListItem').length > 0,
    'the product table never rendered its rows');
  // the Edit button starts disabled: nothing is selected yet
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Button'
    && c.getText() === 'Edit' && c.getEnabled() === false),
    'the Edit button was not disabled while no row is selected');
  // select the first row - the bound flag round-trips and the button opens up
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const table = reg.find((c) => c.getMetadata().getName() === 'sap.m.Table');
    table.setSelectedItem(table.getItems()[0], true, true);
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Button'
    && c.getText() === 'Edit' && c.getEnabled() === true),
    'selecting a row never enabled the Edit button');
};
