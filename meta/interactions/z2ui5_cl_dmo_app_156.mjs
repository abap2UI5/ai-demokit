// NumericContent press → static client toast
export default async (page, expect) => {
  const tile = page.locator('.sapMNC').first();
  await expect(tile, 'the first NumericContent').toBeVisibleEnabled();
  await tile.click();
  await expect(page.locator('.sapMMessageToast'), 'the press client toast').toContainText('The numeric content is pressed.');
};
