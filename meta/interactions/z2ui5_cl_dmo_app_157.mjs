// NumericContent press → the original's 'Fire press' toast
export default async (page, expect) => {
  const tile = page.locator('.sapMNC').first();
  await expect(tile, 'the first NumericContent').toBeVisibleEnabled();
  await tile.click();
  await expect(page.locator('.sapMMessageToast'), 'the press toast').toContainText('Fire press');
};
