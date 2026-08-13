// u:Currency over four inlined arrays: the real backend model must reach
// the control and be formatted with its currency (locale-independent parts
// only — the digit grouping is the browser's, not the port's)
export default async (page, expect) => {
  const lists = page.locator('.sapMList');
  await expect(lists.first(), 'the first currency list').toBeVisibleEnabled();
  await expect(page.locator('body'), 'the bound EUR row').toContainText('EUR');
  await expect(page.locator('body'), 'the bound JPY row').toContainText('JPY');
  const n = await page.locator('.sapUiUfdCurrency').count();
  if (n < 4) throw new Error(`expected the sample's Currency controls to render, got ${n}`);
};
