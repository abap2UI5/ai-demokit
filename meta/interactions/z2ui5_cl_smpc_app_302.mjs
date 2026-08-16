// SideNavigation itemSelect -> the NavContainer 'to' frontend action: the
// selected item's page is what the main area shows afterwards, without a
// round-trip of its own
export default async (page, expect) => {
  const main = page.locator('.sapTntToolPageMainContent');
  await expect(main, 'the ToolPage main content').notToContainText('Applications');
  await page.getByText('Applications', { exact: true }).first().click();
  await expect(main, 'the main content after the itemSelect').toContainText('Applications');
};
