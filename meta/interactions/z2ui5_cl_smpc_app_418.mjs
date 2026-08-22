// the three roundtrip-free wires: wrapping toggle (shared two-way flag),
// wrappingType expression, Panel width percent expression
import { sliderDrivenWidth, waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Title' && c.getWrapping() === true),
    'the Title never rendered with wrapping on (seed abap_true)');
  // first Switch and Title.wrapping share one two-way bound flag
  await page.locator('.sapMSwtCont').first().click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Title' && c.getWrapping() === false),
    'the wrapping Switch never reached Title.wrapping (shared two-way flag)');
  // second Switch drives the wrappingType ternary expression
  await page.locator('.sapMSwtCont').nth(1).click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Title' && c.getWrappingType() === 'Hyphenated'),
    'the hyphenation Switch never reached Title.wrappingType (expression binding)');
  // one ArrowLeft on the slider moves the Panel width expression to 99%
  await sliderDrivenWidth(page, 'sap.m.Panel');
};
