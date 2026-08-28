// Two legs.
//
// (1) The ICON_POOL registration. The port issues
// follow_up_action( control_global, ICON_POOL / registerFont ) from its init
// branch, which is what makes the Group2 tile's
// sap-icon://SAP-icons-TNT/application-service resolvable at all. The linter's
// render harness reconstructs the view and never executes a frontend action,
// so it cannot see this — the declared render_smoke.skip says so, and THIS is
// where the registration is actually proven.
//
// (2) The layoutChange round-trip: the grid tells the backend which breakpoint
// it is on, and the backend answers into the "Current breakpoint" Text.
// Nothing offline can see it — it only fires on a REAL viewport change.
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const IconPool = sap.ui.require('sap/ui/core/IconPool');
    if (!IconPool) return false;
    const info = IconPool.getIconInfo('sap-icon://SAP-icons-TNT/application-service');
    return !!(info && info.content);
  }, 'the ICON_POOL registerFont action never registered the SAP-icons-TNT collection');

  const label = page.locator('body');
  await expect(label, 'the breakpoint line').toContainText('Current breakpoint:');
  const read = async () => (await page.locator('body').innerText()).match(/Current breakpoint:\s*(\S+)/)?.[1] || '';
  const before = await read();

  await page.setViewportSize({ width: 420, height: 900 });
  const deadline = Date.now() + 15000;
  while (await read() === before) {
    if (Date.now() > deadline) throw new Error(`layoutChange never moved the breakpoint off "${before}"`);
    await page.waitForTimeout(250);
  }
};
