// HeaderContainer: the NumericContent press raises a client toast
export default async (page, expect) => {
  const tile = page.locator('.sapMNC').first();
  await expect(tile, 'the first NumericContent tile').toBeVisibleEnabled();
  await tile.click();
  await expect(page.locator('.sapMMessageToast').last(), 'the tile-press client toast').toContainText('Fire press');
};
