// ColorPalette: the swatches have a zero-height box headless, so a colour
// is picked the keyboard way — focus the swatch, press Enter — and the
// client-composed toast carries ${$parameters>/value} and /defaultAction
export default async (page, expect) => {
  const sw = page.locator('.sapMColorPaletteSquare');
  if (!(await sw.count())) throw new Error('the ColorPalette rendered no swatches');
  await page.evaluate(() => document.querySelector('.sapMColorPaletteSquare').focus());
  await page.keyboard.press('Enter');
  await expect(page.locator('.sapMMessageToast').last(), 'the client-composed colorSelect toast')
    .toContainText('Color Selected: value - gold');
};
