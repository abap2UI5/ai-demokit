// ObjectListItem press → `Pressed : {0}` client toast (markers variant)
export default async (page, expect) => {
  const item = page.locator('.sapMObjLItem').first();
  await expect(item, 'the first ObjectListItem').toBeVisibleEnabled();
  await item.click();
  await expect(page.locator('.sapMMessageToast'), 'the press client toast').toContainText('Pressed :');
};
