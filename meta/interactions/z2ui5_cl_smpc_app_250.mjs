// ColorPalettePopover: dependents-declared popup-mode control, openBy
// roundtrip-free (new port; the swatches render zero-height headless, so
// only the anchored open is asserted)
export default async (page, expect) => {
  const btn = page.locator('.sapMBtn').first();
  await expect(btn, 'the first action button').toBeVisibleEnabled();
  await btn.click();
  await page.waitForFunction(
    () => !!document.querySelector("[class*='ColorPalette']"),
    { timeout: 10000 },
  );
};
