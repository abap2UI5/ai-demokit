// ToolPage audit fix: itemPress toast with the real item text + the
// user-name popover (both 2026-07-30)
export default async (page, expect) => {
  const item = page.getByText('Child Item 1', { exact: true }).first();
  await expect(item, 'the Child Item 1 nav entry').toBeVisibleEnabled();
  await item.click();
  await expect(page.locator('.sapMMessageToast'), 'the itemPress toast').toContainText('Fired itemPress, item: Child Item 1');
  const user = page.getByRole('button', { name: 'Alan Smith', exact: true }).first();
  await user.click();
  await expect(page.locator('.sapMPopover'), 'the user popover').toContainText('Feedback');
};
