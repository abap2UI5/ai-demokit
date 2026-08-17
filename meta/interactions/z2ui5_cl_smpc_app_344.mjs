// the breakpointChanged round-trip: the DynamicSideContent tells the backend
// which breakpoint it is on, and the backend answers by enabling the Toggle
// button - which is why the button is DISABLED on a wide viewport and the
// wire cannot be driven without resizing
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Toggle' }).first();
  await expect(btn, 'the Toggle button').toBeVisibleEnabled({ enabled: false }).catch(() => {});
  if (await btn.isEnabled()) throw new Error('the Toggle button is enabled on a wide viewport already');

  await page.setViewportSize({ width: 420, height: 900 });
  const deadline = Date.now() + 15000;
  while (!(await btn.isEnabled())) {
    if (Date.now() > deadline) throw new Error('breakpointChanged never enabled the Toggle button on S');
    await page.waitForTimeout(250);
  }
  // and the showSideContent wire the button drives
  await btn.click();
  await expect(page.locator('.sapMText,.sapMTitle').first(), 'the page after showSideContent').toBeVisibleEnabled();
};
