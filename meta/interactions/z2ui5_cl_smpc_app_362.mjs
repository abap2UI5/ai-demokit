// Sorting: the column sort is vetoed on the client (check_prevent_default) and
// re-done by an ABAP SORT, so what has to be proven is the ORDER that comes
// back — plus the bound Column.sortOrder that draws the header indicator.
//
// The order is read off the first visible row's binding context rather than
// off a cell's rendered text: the cell is what a formatter produced, the
// context is what the server actually put at the head of the model. This port
// is also the one that used to die on `"" is of type string, expected
// sap.ui.core.SortOrder`, so the sortOrder values are asserted as such.
import { waitForUi5, ui5All, UI5_ALL_SRC } from '../../scripts/lib-e2e.mjs';

const head = async (page) => page.evaluate(`(() => { ${UI5_ALL_SRC}
  const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
  const rows = t ? t.getRows() : [];
  const ctx = rows.length ? rows[0].getBindingContext() : null;
  const order = {};
  (t ? t.getColumns() : []).forEach((c) => { order[c.getId().replace(/^.*[-_]/, '')] = c.getSortOrder(); });
  return { name: ctx ? ctx.getProperty('NAME') : null, category: ctx ? ctx.getProperty('CATEGORY') : null, order }; })()`);

export default async (page, expect) => {
  await expect(page.locator('body'), 'the Product Name column').toContainText('Product Name');

  // the port applies a NAME ascending sort on init, so the head of the model
  // is already the sorted one — not the first row of products.json
  const start = await head(page);
  if (start.name !== '10" Portable DVD player') {
    throw new Error(`the init sort did not reach the model (first row is "${start.name}")`);
  }

  // sort ascending across Categories AND Name
  await page.getByRole('button', { name: 'Sort ascending across Categories and Name' }).first().click();
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
    const rows = t ? t.getRows() : [];
    const ctx = rows.length ? rows[0].getBindingContext() : null;
    return !!ctx && ctx.getProperty('CATEGORY') === 'Accessories';
  }, 'the category+name sort did not put an Accessories row at the head of the model');
  const sorted = await head(page);
  const orders = Object.values(sorted.order);
  if (!orders.includes('Ascending')) {
    throw new Error(`no column carried the bound Ascending sortOrder after the sort (got ${JSON.stringify(sorted.order)})`);
  }

  // clearing re-seeds the model and resets every column to None
  await page.getByRole('button', { name: 'Clear all sortings' }).first().click();
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
    const rows = t ? t.getRows() : [];
    const ctx = rows.length ? rows[0].getBindingContext() : null;
    return !!ctx && ctx.getProperty('NAME') === 'Notebook Basic 15'
      && t.getColumns().every((c) => c.getSortOrder() === 'None');
  }, 'clearing the sortings did not restore the seeded order with every sortOrder back on None');
};
