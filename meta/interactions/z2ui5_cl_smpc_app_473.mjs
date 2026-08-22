// the suggest wire re-filtering the suggestionItems binding through binding_call
export default async (page, expect) => {
  const input = page.locator('.sapMInputBaseInner').first();
  await expect(input, 'the product Input').toBeVisibleEnabled();
  await input.click();
  await input.press('N');
  await page.waitForTimeout(900);
  // the suggestion popup shows only the filtered (StartsWith 'N') products
  await expect(page.locator('.sapMSuggestionPopup, .sapMPopover'), 'the suggestion list').toContainText('Notebook');
};
