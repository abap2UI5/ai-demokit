// two things the offline gates cannot answer for a CSSGrid:
//   1. an EMPTY gridRowGap / gridColumnGap has to serialise acceptably for the
//      control's CSSSize properties - the two Inputs carry no value in the
//      original either, so the grid starts on gridGap alone
//   2. the Panel width expression binding follows the slider live
import { sliderDrivenWidth } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const gaps = page.locator('input.sapMInputBaseInner');
  await expect(gaps.first(), 'the gridGap Input').toBeVisibleEnabled();
  const values = await gaps.evaluateAll((n) => n.map((x) => x.value));
  if (values[1] !== '' || values[2] !== '') {
    throw new Error(`gridRowGap/gridColumnGap start filled (${JSON.stringify(values)}) - the original leaves them empty`);
  }
  // an empty CSSSize did not stop the grid rendering
  await expect(page.locator('[class*="sapUiLayoutCSSGrid"]').first(), 'the CSSGrid').toBeVisibleEnabled();

  await sliderDrivenWidth(page, 'sap.m.Panel');
};
