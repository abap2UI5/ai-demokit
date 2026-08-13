export default async (page, expect) => {
  await expect(page.locator('body'), 'the element-bound product').toContainText('Notebook Basic 15');
  await expect(page.locator('body'), 'the bound supplier').toContainText('Very Best Screens');
};
