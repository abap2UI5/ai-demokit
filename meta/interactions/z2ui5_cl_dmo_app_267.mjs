// DynamicSideContent breakpointChanged round-trip: the footer Toggle button
// follows the transported breakpoint (the original enables it on S only).
// Shrinking the viewport into the S range is the only way to make the
// round-trip fire, so this drives the resize itself.
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await expect(page.locator('body'), 'main and side content side by side').toContainText('Side content');
  await page.setViewportSize({ width: 400, height: 900 });
  await waitForUi5(page, () => {
    const b = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Toggle');
    return !!(b && b.getEnabled());
  }, 'the Toggle button never became enabled — the breakpointChanged round-trip did not transport "S"');
};
