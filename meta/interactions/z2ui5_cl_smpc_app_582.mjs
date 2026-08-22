// the four GridLists, their item spans, the slider-driven width and a borderReached toast
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  // four GridLists with 4/4/5/5 items each (the template counts as one more)
  await waitForUi5(page, () => {
    const gl = ui5All().filter((c) => c.getMetadata().getName() === 'sap.f.GridList');
    if (gl.length !== 4) return false;
    const counts = gl.map((g) => g.getItems().length);
    return counts.join(',') === '4,4,5,5';
  }, 'the four GridLists never rendered with 4/4/5/5 items');

  // the spans are what make the items different sizes - one per list, in order
  await waitForUi5(page, () => {
    const gl = ui5All().filter((c) => c.getMetadata().getName() === 'sap.f.GridList');
    const spans = gl.map((g) => {
      const ld = g.getItems()[0].getLayoutData();
      return `${ld.getGridRow()}|${ld.getGridColumn()}`;
    });
    return spans.join(',') === 'span 2|span 2,span 1|span 3,span 2|span 3,span 3|span 2';
  }, 'the four GridItemLayoutData span pairs never reached the items');

  // the CSSGrid width is an expression over the slider value - 100% at start
  await waitForUi5(page, () => {
    const cg = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.layout.cssgrid.CSSGrid');
    const sl = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Slider');
    return cg && sl && sl.getValue() === 100 && cg.getWidth() === '100%';
  }, 'the container never took its width from the slider');

  // moving the slider re-evaluates the width in the browser, with no round trip
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const sl = reg.find((c) => c.getMetadata().getName() === 'sap.m.Slider');
    sl.setValue(60);
  });
  await waitForUi5(page, () => {
    const cg = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.layout.cssgrid.CSSGrid');
    return cg && cg.getWidth() === '60%';
  }, 'the container width never followed the slider');

  // borderReached on the first grid toasts that grid by name
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const g1 = reg.filter((c) => c.getMetadata().getName() === 'sap.f.GridList')
      .find((c) => c.getHeaderText() === 'GridList 1');
    g1.fireEvent('borderReached', { direction: 'Right', row: 0, column: 1 });
  });
  await page.waitForFunction(
    () => !!document.querySelector('.sapMMessageToast'),
    null, { timeout: 15000 },
  );
  const toast = await page.evaluate(() => document.querySelector('.sapMMessageToast').textContent);
  expect(toast).toContain('Reached border of GridList 1');
};
