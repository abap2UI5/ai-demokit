// the ToggleButton round-trip that fills BOTH calendars' special dates and
// clears them again. The second press is the half a single click misses, and
// it is the half that was broken: clearing the table leaves the aggregation
// template to be evaluated with no row, `{SECONDARY_TYPE}` resolves to `` and
// the enum-typed property refuses it outright.
export default async (page, expect) => {
  const special = () => page.locator('[class*="sapUiCalItemType"]').count();
  const btn = page.getByRole('button', { name: 'Special Days' }).first();
  await expect(btn, 'the "Special Days" ToggleButton').toBeVisibleEnabled();

  if (await special() !== 0) throw new Error('special dates were marked before the toggle');
  await btn.click();
  await page.waitForTimeout(1000);
  if (await special() === 0) throw new Error('the toggle marked no special dates');

  await btn.click();
  await page.waitForTimeout(1000);
  if (await special() !== 0) throw new Error('the second press did not clear the special dates');
};
