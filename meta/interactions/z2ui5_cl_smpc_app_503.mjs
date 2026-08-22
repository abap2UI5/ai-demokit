// the tabular suggestions and the selected-key readout
export default async (page, expect) => {
  const input = page.locator('.sapMInputBaseInner').first();
  await expect(input, 'the product Input').toBeVisibleEnabled();
  await input.click();
  await input.press('N');
  await page.waitForTimeout(800);
  await expect(page.locator('.sapMSuggestionPopup, .sapMPopover'), 'the suggestion table').toContainText('Notebook');
};
