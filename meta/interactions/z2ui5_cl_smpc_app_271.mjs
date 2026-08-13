// GridResponsiveLayout: the layoutChange round-trip names the active
// GridSettings aggregation, and the containerQuery expression binding
// follows the SegmentedButton with no round-trip of its own
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const tiles = await page.locator('.demoBox').count();
  if (tiles !== 12) throw new Error(`expected the sample's twelve grid tiles, got ${tiles}`);
  // a GridLayoutBase extends ManagedObject, NOT Element — it is in no
  // Element.registry, so the customLayout is read through its CSSGrid
  await page.locator('.sapMSegBBtn').first().click();   // the "true" segment
  await waitForUi5(page, () => {
    const g = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.layout.cssgrid.CSSGrid');
    return !!g && g.getCustomLayout() && g.getCustomLayout().getContainerQuery() === true;
  }, 'the SegmentedButton did not flip containerQuery through the expression binding');
  // with containerQuery on, shrinking the container fires layoutChange —
  // the one wire that does round-trip (its ${$parameters>/layout} is the
  // only source for the info Text)
  await page.setViewportSize({ width: 420, height: 900 });
  await expect(page.locator('body'), 'the layoutChange round-trip naming the active layout')
    .toContainText('Layout size is: layoutS');
};
