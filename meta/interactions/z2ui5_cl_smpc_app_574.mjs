// the counted title, the row actions, the search and the mode switch
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Table');
    return t && t.getItems().length === 123 && t.getItemActionCount() === 1;
  }, 'the table never rendered its 123 rows with one row action');
  // the counted title starts on the full row count and no selection
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.table.Title'
    && c.getTotalCount() === 123 && c.getSelectedCount() === 0),
    'the table title never got the seeded counts');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.ListItemAction').length > 0,
    'the rows never got their Delete action');
  // the search narrows the rows and the total count follows
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const sf = reg.find((c) => c.getId().endsWith('idSearchField'));
    sf.setValue('Notebook');
    sf.fireSearch({ query: 'Notebook' });
  });
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Table');
    const title = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.table.Title');
    return t.getItems().length < 123 && title.getTotalCount() === t.getItems().length;
  }, 'the search never narrowed the rows and the count with them');
  // the ComboBox key really reaches the table's multiSelectMode
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const cb = reg.find((c) => c.getId().endsWith('idComboBoxSuccess'));
    cb.setSelectedKey('ClearAll');
    cb.fireSelectionChange({ selectedItem: cb.getSelectedItem() });
  });
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Table');
    return t && t.getMultiSelectMode() === 'ClearAll';
  }, 'the multi-selection mode never reached the table');
};
