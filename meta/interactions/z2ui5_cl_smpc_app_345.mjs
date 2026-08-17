// the expression binding over the Slider value resizes its OWN wrapper live -
// no round-trip, so the width follows the slider continuously rather than per
// event the way the original's DOM write does. The wrapper here is the
// VerticalLayout around each grid, not a Panel.
import { sliderDrivenWidth } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await expect(page.locator('body'), 'the grid demo text')
    .toContainText('Use the sliders to resize the grids');
  // the handle carries a zero-size box headless, so it is focused through the
  // DOM and driven by keyboard - a real gesture through the Slider's own key
  // handling and the two-way binding (AGENTS §10)
  await sliderDrivenWidth(page, 'sap.ui.layout.VerticalLayout');
};
