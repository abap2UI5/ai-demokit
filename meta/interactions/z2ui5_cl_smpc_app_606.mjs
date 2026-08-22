// the tiles in both modes, the SlideTiles and one press toast
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  // five tiles twice (regular + LineMode) plus the link tile and four news tiles
  await waitForUi5(page, () => {
    const t = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.GenericTile');
    return t.length >= 10 && t.some((x) => x.getMode() === 'LineMode');
  }, 'the LineMode row never rendered');

  await waitForUi5(page, () => {
    const st = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.SlideTile');
    return st.length === 2 && st.every((s) => s.getTiles().length === 2);
  }, 'the two SlideTiles never got their two news tiles each');

  // the three states the mock sets are carried, and the absent ones seeded Loaded
  await waitForUi5(page, () => {
    const t = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.GenericTile'
      && !!c.getHeader());
    const states = new Set(t.map((x) => x.getState()));
    return states.has('Loading') && states.has('Failed') && states.has('Disabled')
      && states.has('Loaded');
  }, 'the four tile states never all appeared');

  // a tile press names the tile in the toast
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.filter((c) => c.getMetadata().getName() === 'sap.m.GenericTile')
      .find((c) => c.getHeader() === 'Business Decisions').firePress({ action: 'Press' });
  });
  await expect(page.locator('.sapMMessageToast').last(), 'the TILE_PRESS toast')
    .toContainText('The GenericTile "Business Decisions" has been pressed.');
};
