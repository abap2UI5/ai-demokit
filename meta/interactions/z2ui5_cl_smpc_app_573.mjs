// the supplier sort that makes the merged columns merge, and the two formatters
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Table');
    return t && t.getItems().length === 123;
  }, 'the table never rendered its 123 bound rows');
  // three columns merge duplicates, one of them through getNumber
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Column'
    && c.getMergeDuplicates() === true).length === 3, 'the three merging columns did not survive');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Column'
    && c.getMergeFunctionName() === 'getNumber'), 'the Weight column lost its merge function');
  // the sorter really groups the suppliers, which is what merging needs
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Table');
    const first = t.getItems()[0].getCells()[0].getText();
    const second = t.getItems()[1].getCells()[0].getText();
    return first === second && first === 'Alpha Printers';
  }, 'the SupplierName sorter never grouped the rows');
  // the backend-computed row type reaches ColumnListItem.type
  await waitForUi5(page, () => {
    const types = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.ColumnListItem').map((c) => c.getType());
    return types.includes('Navigation') && types.includes('Inactive');
  }, 'the price-driven row type never reached the rows');
};
