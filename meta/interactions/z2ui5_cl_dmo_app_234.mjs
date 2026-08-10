// two-way bound FlexibleColumnLayout.layout flipped on a round-trip
export default async (page, expect) => {
  const item = page.locator('.sapMSLI, .sapMLIB').first();
  await expect(item, 'the first master list item').toBeVisibleEnabled();
  await item.click();
  // the LIST_PRESS round-trip switches to TwoColumnsBeginExpanded → the mid
  // column renders
  await page.waitForFunction(
    () => {
      const mid = document.querySelector('.sapFFCLColumnMid');
      return mid && mid.offsetWidth > 0;
    },
    null,
    { timeout: 10000 },
  );
};
