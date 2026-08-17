// a ComboBox FREE-TEXT entry (the original reads the change event's value, not
// a selected key) has to round-trip into the bound field and re-template the
// grid - typing a template UI5 does not offer in the list
export default async (page, expect) => {
  const box = page.locator('.sapMComboBox input.sapMInputBaseInner').first();
  await expect(box, 'the rows-template ComboBox').toBeVisibleEnabled();
  const before = await box.inputValue();

  await box.fill('2fr 1fr 1fr');
  await box.press('Enter');
  await page.waitForTimeout(1500);

  const after = await box.inputValue();
  if (after !== '2fr 1fr 1fr') throw new Error(`the free text came back as "${after}" (was "${before}")`);
  await expect(page.locator('[class*="sapUiLayoutCSSGrid"]').first(), 'the re-templated grid').toBeVisibleEnabled();
};
