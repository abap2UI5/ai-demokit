// TOGGLE_EXPAND: the round-trip that collapses and re-expands the side
// navigation - the port drives it through the bound `expanded` flag rather
// than the original's setExpanded call
export default async (page, expect) => {
  const nav = page.locator('[class*="sapTntSideNavigation"]').first();
  await expect(nav, 'the side navigation').toBeVisibleEnabled();
  const collapsed = async () => ((await nav.getAttribute('class')) || '').includes('NotExpanded');

  const before = await collapsed();
  await page.getByRole('button', { name: /Toggle/ }).first().click();
  await page.waitForTimeout(800);
  if (await collapsed() === before) {
    throw new Error(`TOGGLE_EXPAND: the side navigation stayed ${before ? 'collapsed' : 'expanded'}`);
  }
  // and back, so the flag round-trips in both directions rather than latching
  await page.getByRole('button', { name: /Toggle/ }).first().click();
  await page.waitForTimeout(800);
  if (await collapsed() !== before) throw new Error('TOGGLE_EXPAND: the second toggle did not return');
};
