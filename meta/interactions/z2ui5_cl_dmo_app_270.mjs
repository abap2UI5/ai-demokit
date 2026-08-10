// the controller's jQuery panel width became an expression binding on the
// Slider value — moving the slider must resize the Panel with no round-trip
import { sliderDrivenWidth } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await expect(page.locator('body'), 'the nested grid boxes').toContainText('E Box');
  // the slider handle carries a zero-size box headless (unstyled), so it is
  // focused through the DOM and driven by keyboard — a real user gesture
  // that goes through the Slider's own key handling and the two-way binding
  await sliderDrivenWidth(page, 'sap.m.Panel');
};
