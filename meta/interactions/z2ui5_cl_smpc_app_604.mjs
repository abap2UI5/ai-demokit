// the carousel's bound options and the image-count rebuild
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const c = ui5All().find((x) => x.getMetadata().getName() === 'sap.m.Carousel');
    return c && c.getPages().length === 3 && c.getLoop() === true;
  }, 'the carousel never came up with three pages');

  // the six enum options are seeded, never empty
  await waitForUi5(page, () => {
    const c = ui5All().find((x) => x.getMetadata().getName() === 'sap.m.Carousel');
    return c && c.getArrowsPlacement() === 'Content'
      && c.getPageIndicatorPlacement() === 'Bottom'
      && c.getBackgroundDesign() === 'Translucent'
      && c.getPageIndicatorBackgroundDesign() === 'Solid'
      && c.getPageIndicatorBorderDesign() === 'Solid';
  }, 'the seeded enum options never reached the carousel');

  // the container width follows the slider without a round trip
  await waitForUi5(page, () => {
    const p = ui5All().find((x) => x.getMetadata().getName() === 'sap.m.Panel');
    return p && p.getWidth() === '100%' && p.getHeight() === '650px';
  }, 'the container never took its size from the slider');
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Slider').setValue(50);
  });
  await waitForUi5(page, () => {
    const p = ui5All().find((x) => x.getMetadata().getName() === 'sap.m.Panel');
    return p && p.getWidth() === '50%' && p.getHeight() === '325px';
  }, 'the container size never followed the slider');

  // the image count rebuilds the bound pages aggregation
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const inp = reg.filter((c) => c.getMetadata().getName() === 'sap.m.Input')
      .find((c) => c.getType() === 'Number');
    inp.setValue('5');
    inp.fireChange({ value: '5' });
  });
  await waitForUi5(page, () => {
    const c = ui5All().find((x) => x.getMetadata().getName() === 'sap.m.Carousel');
    return c && c.getPages().length === 5;
  }, 'NUM_IMAGES never rebuilt the pages');
};
