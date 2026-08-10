// ListItemTypes: every item's `type` follows ONE shared root field. The type
// Select sits in an OverflowToolbar whose popover is not drivable headless
// (its content is only instantiated on open and the Select keeps no .sapMSlt
// root there), so this asserts the regression that actually bit us: the
// template must bind the ABSOLUTE path /LISTTYPE — a relative {LISTTYPE}
// resolves against the row, leaves every item Inactive and kills the Select
// (fixed 2026-07-31, see the 207 sidecar). The click-through stays a human check.
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await expect(page.locator('.sapMList'), 'the product list').toContainText('Notebook Basic 15');
  const shape = await page.evaluate(() => {
    const El = sap.ui.require('sap/ui/core/Element');
    const items = Object.values(El.registry.all()).filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem');
    return { n: items.length, path: items[0] && items[0].getBindingPath('type') };
  });
  if (!shape.n) throw new Error('no StandardListItem rendered');
  if (shape.path !== '/LISTTYPE') throw new Error(`the item type must bind the absolute /LISTTYPE, got "${shape.path}"`);
  // …and the click-through IS drivable through the overflow popover
  // (2026-08-01) — picking a type must reach every item's `type`
  const more = page.getByRole('button', { name: 'Additional Options' }).first();
  await expect(more, 'the overflow button').toBeVisibleEnabled();
  await more.click();
  const sel = page.locator('.sapMPopover .sapMSlt').first();
  await expect(sel, 'the list-type Select in the overflow').toBeVisibleEnabled();
  await sel.click();
  await page.locator('.sapMSltPicker').getByText('Navigation', { exact: true }).first().click();
  await waitForUi5(page, () => {
    // the binding TEMPLATE is in the registry too and keeps the default
    // type (it has no binding context) — only the real rows count
    const rows = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem' && c.getBindingContext());
    return rows.length > 0 && rows.every((i) => i.getType() === 'Navigation');
  }, 'the picked list type never reached the items');
};
