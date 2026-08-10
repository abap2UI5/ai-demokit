// GenericTile states: the press wire is a constant client toast, and a
// handler-less tile must stay silent
export default async (page, expect) => {
  const tiles = page.locator('.sapMGT');
  await expect(tiles.first(), 'the first tile').toBeVisibleEnabled();
  await expect(page.locator('body'), 'the tile headers').toContainText('Status Loaded - with press event');
  await tiles.nth(1).click();   // "Status Loaded - with press event"
  await expect(page.locator('.sapMMessageToast').last(), 'the client-composed press toast')
    .toContainText('The generic tile is pressed.');
};
