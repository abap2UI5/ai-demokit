// element-bound single record: the folded row really resolves against the
// serialized default model (render-smoke only sees a mocked one)
export default async (page, expect) => {
  await expect(page.locator('body'), 'the element-bound product').toContainText('Notebook Professional 15');
  await expect(page.locator('body'), 'the bound description').toContainText('2,80 GHz quad core');
};
