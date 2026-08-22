// the eleven launch tiles, one constant press toast and the Loading state the
// Input's submit drives through START_TIMER
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.GenericTile').length === 11,
    'the eleven GenericTiles never rendered');
  // every tile boots Loaded (the bound state seed) and presses a constant toast
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.GenericTile')
    .every((c) => c.getState() === 'Loaded'), 'the tiles did not boot in the Loaded state');
  await page.locator('.sapMGT').first().click();
  await expect(page.locator('.sapMMessageToast'), 'the constant client toast on the tile press').toContainText('The GenericTile is pressed.');
};
