// global BusyIndicator show(0) + START_TIMER hide chain (2026-07-30 rework)
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Show BusyIndicator', exact: true }).nth(1);
  await expect(btn, 'the zero-delay busy button').toBeVisibleEnabled();
  await btn.click();
  await page.waitForFunction(
    () => {
      const el = document.getElementById('sapUiBusyIndicator');
      return el && el.offsetParent !== null;
    },
    null,
    { timeout: 10000 },
  );
  // the HIDE_BUSY timer round-trip removes it again after ~4s
  await page.waitForFunction(
    () => {
      const el = document.getElementById('sapUiBusyIndicator');
      return !el || el.offsetParent === null;
    },
    null,
    { timeout: 15000 },
  );
};
