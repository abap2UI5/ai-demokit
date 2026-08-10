// check_prevent_default: with the checkbox set, a press round-trips but the
// eBP wire cancels the built-in selection (2026-07-30 rework)
export default async (page, expect) => {
  const cb = page.locator("[id*='preventDefaultCheckbox']").first();
  await expect(cb, 'the prevent-default checkbox').toBeVisibleEnabled();
  await cb.click();
  // the PREVENT_TOGGLE redraw re-bakes the press wires
  await page.waitForTimeout(1500);
  // The sample renders its NavigationList TWICE (the SideNavigation shows an
  // expanded and a collapsed copy), so "Building" exists twice as an
  // aggregation-template clone and a text click lands on whichever copy the
  // DOM offers first - which is why this used to fail with no toast at all.
  // Fire itemPress through the control API instead: that runs the port's
  // WIRE, which is the thing under test, and names the item unambiguously.
  const fired = await page.evaluate(() => {
    const all = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    // the wire sits on the ITEM's `press`, one per NavigationListItem
    const item = all.find((c) => c.getMetadata().getName() === 'sap.tnt.NavigationListItem'
      && c.getText && c.getText() === 'Building'
      && c.mEventRegistry && c.mEventRegistry.press);
    if (!item) return 'no Building item carries a press handler';
    item.firePress({ item, srcControl: item });
    return 'fired';
  });
  if (fired !== 'fired') throw new Error(`241: ${fired}`);
  await expect(page.locator('.sapMMessageToast'), 'the prevented-default toast').toContainText('Default was prevented');
};
