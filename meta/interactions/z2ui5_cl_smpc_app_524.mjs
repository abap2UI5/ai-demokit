// the Delete mode wire - the deleted row leaves the bound table
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem' && c.getDomRef()).length > 0,
    'the product rows never rendered');
  await expect(page.locator('body'), 'the first row').toContainText('Notebook Basic 15');
  // the row's delete control renders as a plain sap.m.Button with the class
  // `sapMLIBIcon` (measured 2026-08-22 — there is no `.sapMLIBDel` here) and
  // is icon-only, so it has no box to click. Raise the list's own delete
  // event with the row it carries, which is what the wire listens to.
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const list = reg.find((c) => c.getMetadata().getName() === 'sap.m.List');
    list.fireDelete({ listItem: list.getItems()[0] });
  });
  await waitForUi5(page, () => !ui5All().some((c) => c.getMetadata().getName() === 'sap.m.StandardListItem'
    && c.getDomRef() && c.getTitle() === 'Notebook Basic 15'),
    'the deleted row never left the bound table');
};
