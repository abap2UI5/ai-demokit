// popover_display ResponsivePopover with custom footer
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Popover with Custom Footer', exact: true }).first();
  await expect(btn, 'the popover button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMPopover'), 'the ResponsivePopover').toContainText('OK');
  await expect(page.locator('.sapMPopover'), 'the bound product name').toContainText('Notebook Basic 15');
};
