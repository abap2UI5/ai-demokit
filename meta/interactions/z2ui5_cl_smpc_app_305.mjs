// CAL_SELECT: picking a day round-trips the expression-arg to the backend and
// comes back in the "Selected Date" Text; clicking the SAME day again clears
// the selection, which is the branch a single click would never reach
export default async (page, expect) => {
  const out = page.locator('.sapMText').filter({ hasText: /Date Selected|\d{4}-\d{2}-\d{2}/ }).first();
  await expect(out, 'the selected-date Text').toContainText('No Date Selected');

  const day = page.locator('.sapUiCalItem:not(.sapUiCalItemOtherMonth)').nth(9);
  await day.click();
  await expect(out, 'the selected-date Text after CAL_SELECT').notToContainText('No Date Selected');

  await page.locator('.sapUiCalItem:not(.sapUiCalItemOtherMonth)').nth(9).click();
  await expect(out, 'the selected-date Text after the second click on the same day')
    .toContainText('No Date Selected');
};
