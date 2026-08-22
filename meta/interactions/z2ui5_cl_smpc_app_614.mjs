// the row-2 record on the full-screen ObjectHeader and the title-press popover
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const oh = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.ObjectHeader');
    return oh && oh.getTitle() === 'Notebook Basic 18' && oh.getNumberUnit() === 'EUR'
      && oh.getFullScreenOptimized() === true && oh.getResponsive() === true;
  }, 'the ObjectHeader never took the seeded /ProductCollection/2 record');
  await waitForUi5(page, () => {
    const oh = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.ObjectHeader');
    return oh && oh.getAttributes().length === 5 && oh.getStatuses().length === 1
      && oh.getMarkers().length === 2;
  }, 'the five attributes, the status and the two markers never rendered');
  // the Currency type formats the number without its measure (showMeasure false)
  await expect(page.locator('body'), 'the composed attribute texts').toContainText('28 x 19 x 2.5 cm');
  await waitForUi5(page, () => {
    const bar = ui5All().find((c) => c.getId().endsWith('itb1'));
    return bar && bar.getItems().length === 4 && bar.getUpperCase() === true;
  }, 'the headerContainer IconTabBar never rendered its four filters');
  // the title press opens the dependents popover anchored to the title
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const oh = reg.find((c) => c.getMetadata().getName() === 'sap.m.ObjectHeader');
    oh.fireTitlePress({ domRef: oh.getDomRef() });
  });
  await expect(page.locator('.sapMPopover'), 'the About popover opened by the title')
    .toContainText('... more content goes here');
};
