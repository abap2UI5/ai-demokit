// MenuButton opens its Menu; item select toasts `{0} Pressed`
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'File', exact: true }).first();
  await expect(btn, 'the "File" MenuButton').toBeVisibleEnabled();
  await btn.click();
  const item = page.locator('.sapMMenuItem', { hasText: 'Save' }).first();
  await expect(item, 'the opened menu item').toBeVisibleEnabled();
  await item.click();
  await expect(page.locator('.sapMMessageToast'), 'the item-select client toast').toContainText('Action triggered on item: Save');
};
