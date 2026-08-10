// two-way bound SideNavigation.expanded flipped on a round-trip
export default async (page, expect) => {
  const nav = page.locator('.sapTntSideNavigation').first();
  await expect(nav, 'the SideNavigation').toBeVisibleEnabled();
  const btn = page.getByRole('button', { name: 'Toggle Collapse/Expand', exact: true }).first();
  await btn.click();
  // expanded starts false (NotExpanded class present) and the round-trip
  // flips the bound property → the class must disappear
  await page.waitForFunction(
    () => {
      const el = document.querySelector('.sapTntSideNavigation');
      return el && !el.classList.contains('sapTntSideNavigationNotExpanded');
    },
    null,
    { timeout: 10000 },
  );
};
