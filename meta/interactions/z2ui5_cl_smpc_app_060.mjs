export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Open Menu', exact: true }).first();
  await expect(btn, 'the "Open Menu" anchor button').toBeVisibleEnabled();
  await btn.click();
  const item = page.getByText('Hide Existing Sites', { exact: true }).first();
  await expect(item, 'the anchored-open menu (toggleBy)').toBeVisibleEnabled();
  await item.click();
  await expect(page.locator('.sapMMessageToast'), 'the item-selected client toast').toContainText('Action triggered on item: Hide Existing Sites');
  // selecting a NESTED item: the toast carries the item's own text, NOT the
  // sample controller's ancestor breadcrumb — sap.m.Menu re-parents items
  // through MenuWrapper/Popover, so upstream's `while (item instanceof
  // MenuItem) getParent()` loop breaks there too (measured 2026-07-31, see
  // CAPABILITIES "menu breadcrumb"); this leg guards that boundary
  await btn.click();
  const parent = page.getByText('Create New Site', { exact: true }).first();
  await expect(parent, 'the nesting menu item').toBeVisibleEnabled();
  await parent.click();
  const child = page.getByText('Official Store', { exact: true }).first();
  await expect(child, 'the submenu item').toBeVisibleEnabled();
  await child.click();
  await expect(page.locator('.sapMMessageToast').last(), 'the nested-item toast (leaf text)').toContainText('Action triggered on item: Official Store');
};
