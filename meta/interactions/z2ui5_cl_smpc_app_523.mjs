// the MultiSelect product table, the CellSelector dependent and the three flags
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.plugins.CellSelector'),
    'the CellSelector dependent never reached the table');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.ColumnListItem' && c.getDomRef()).length > 0,
    'the product rows never rendered');
  // the two seeded flags reach their CheckBox, the third boots unchecked
  await waitForUi5(page, () => {
    const sel = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.CheckBox' && c.getText()).map((c) => [c.getText(), c.getSelected()]);
    return sel.length === 3 && sel.every(([t, s]) => (t === 'Sparse' ? s === false : s === true));
  }, 'the three copy flags never reached their CheckBoxes');
};
