// GridContainer audit fix: press toast composed from getMetadata().getName()
export default async (page, expect) => {
  const tile = page.locator('.sapMGT').first();
  await expect(tile, 'the first GenericTile').toBeVisibleEnabled();
  await tile.click();
  await expect(page.locator('.sapMMessageToast'), 'the metadata-name toast').toContainText('Press was fired on - sap.m.GenericTile');
};
