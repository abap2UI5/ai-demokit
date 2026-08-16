// CAL_SELECT across the two displayed months: the expression-arg round-trip
// fills the "Selected Date" Text, and "Select Today" is the second wire
export default async (page, expect) => {
  const out = page.locator('.sapMText').filter({ hasText: /Date Selected|\d{4}-\d{2}-\d{2}/ }).first();
  await expect(out, 'the selected-date Text').toContainText('No Date Selected');

  await page.locator('.sapUiCalItem:not(.sapUiCalItemOtherMonth)').nth(9).click();
  await expect(out, 'the selected-date Text after CAL_SELECT').notToContainText('No Date Selected');

  const today = page.getByRole('button', { name: 'Select Today' }).first();
  await expect(today, 'the "Select Today" button').toBeVisibleEnabled();
  await today.click();
  await expect(out, 'the selected-date Text after SELECT_TODAY').notToContainText('No Date Selected');
};
