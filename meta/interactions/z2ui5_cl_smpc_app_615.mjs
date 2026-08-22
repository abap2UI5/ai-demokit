// the row-3 record on the master/detail ObjectHeader, the eight-tab bar,
// the title-press popover and the title selector's MessageBox
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const oh = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.ObjectHeader');
    return oh && oh.getTitle() === 'Notebook Basic 19' && oh.getNumberUnit() === 'EUR'
      && oh.getFullScreenOptimized() === false && oh.getShowTitleSelector() === true;
  }, 'the ObjectHeader never took the seeded /ProductCollection/3 record');
  await expect(page.locator('body'), 'the composed attribute texts').toContainText('32 x 21 x 4 cm');
  await waitForUi5(page, () => {
    const bar = ui5All().find((c) => c.getId().endsWith('itb1'));
    return bar && bar.getItems().length === 8;
  }, 'the headerContainer IconTabBar never rendered its eight filters');
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const oh = reg.find((c) => c.getMetadata().getName() === 'sap.m.ObjectHeader');
    oh.fireTitlePress({ domRef: oh.getDomRef() });
  });
  await expect(page.locator('.sapMPopover'), 'the About popover opened by the title')
    .toContainText('... more content goes here');
  // the title selector arrow: one round trip closing on MessageBox.alert
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.ObjectHeader').fireTitleSelectorPress({});
  });
  await expect(page.locator('.sapMDialog'), 'the title selector MessageBox')
    .toContainText('Link was clicked!');
};
