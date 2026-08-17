// the CAL_SELECT interval round-trip: two clicks make a range, and both ends
// come back from the backend into their own Texts
export default async (page, expect) => {
  const from = page.locator('.sapMText').filter({ hasText: /Date Selected|\d{4}-\d{2}-\d{2}/ }).first();
  await expect(from, 'the "Selected From" Text').toContainText('No Date Selected');

  const days = page.locator('.sapUiCalItem:not(.sapUiCalItemOtherMonth)');
  await days.nth(9).click();
  await days.nth(13).click();
  await expect(from, 'the interval Texts after the second click').notToContainText('No Date Selected');
};
