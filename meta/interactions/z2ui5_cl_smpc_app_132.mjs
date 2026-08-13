// two-way bound SideNavigation.expanded (tags variant) flipped on a round-trip
export default async (page, expect) => {
  const nav = page.locator('.sapTntSideNavigation').first();
  await expect(nav, 'the SideNavigation').toBeVisibleEnabled();
  await page.getByRole('button', { name: 'Toggle Collapse/Expand', exact: true }).first().click();
  // expanded starts true → the round-trip collapses it
  await page.waitForFunction(
    () => {
      const el = document.querySelector('.sapTntSideNavigation');
      return el && el.classList.contains('sapTntSideNavigationNotExpanded');
    },
    null,
    { timeout: 10000 },
  );
};
