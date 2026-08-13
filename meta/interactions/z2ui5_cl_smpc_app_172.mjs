// SideNavigation.expanded two-way bound, flipped on a round-trip (starts
// collapsed = icons only), plus the itemSelect client toast
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Toggle Collapse/Expand', exact: true }).first();
  await expect(btn, 'the collapse/expand button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('body'), 'the expanded side navigation').toContainText('Office 01');
  await page.getByText('Office 01', { exact: true }).first().click();
  await expect(page.locator('.sapMMessageToast').last(), 'the itemSelect client toast').toContainText('Item selected: Office 01');
};
