// the hyphenation expression over all five Texts, plus the Panel width slider
import { sliderDrivenWidth, waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

const hyphenated = () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Text' && c.getWrappingType() === 'Hyphenated').length;

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Text' && c.getWrappingType() === 'Hyphenated').length === 5,
    'the five Texts never rendered Hyphenated (seed abap_true)');
  // the SECOND Switch is the hyphenation one (the first is the disabled Wrapping switch)
  await page.locator('.sapMSwtCont').nth(1).click();
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Text' && c.getWrappingType() === 'Normal').length === 5,
    'the hyphenation Switch never reached all five Text.wrappingType expressions');
  await sliderDrivenWidth(page, 'sap.m.Panel');
};
