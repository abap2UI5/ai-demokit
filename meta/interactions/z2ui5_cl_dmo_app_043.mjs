// LIVE_TEST closures 2026-08-04: the last three LIVE_TEST deviations that
// had no interaction yet — each drives exactly the wire its deviation names
export default async (page, expect) => {
  // the ACTIVE OverflowToolbar press round-trips, the backend flips the
  // two-way bound `expanded`, and the third panel opens — observable as the
  // expand arrow's aria-expanded flipping
  const arrow = page.locator('[id$="expandablePanel"] [aria-expanded]').first();
  await expect(arrow, 'the bound panel\'s expand arrow').toBeVisibleEnabled();
  const before = await arrow.getAttribute('aria-expanded');
  await page.getByText('Clickable Custom Toolbar with a header text', { exact: true }).first().click();
  await expect(page.locator(`[id$="expandablePanel"] [aria-expanded="${before === 'true' ? 'false' : 'true'}"]`).first(),
    'the two-way expanded binding flipped by the toolbar round-trip').toBeVisibleEnabled();
};
