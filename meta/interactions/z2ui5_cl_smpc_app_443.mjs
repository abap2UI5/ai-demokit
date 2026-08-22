// the two two-way bound Text properties and the slider-driven Panel width
import { sliderDrivenWidth, waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Text' && c.getRenderWhitespace() === true),
    'the Text never rendered with renderWhitespace on (seed abap_true)');
  // the second Switch is the renderWhitespace one
  await page.locator('.sapMSwtCont').nth(1).click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Text' && c.getRenderWhitespace() === false),
    'the Switch never reached Text.renderWhitespace (shared two-way flag)');
  await sliderDrivenWidth(page, 'sap.m.Panel');
};
