// the client-composed change toast over the two item ids
export default async (page, expect) => {
  const picker = page.locator('.sapMSlt').first();
  await expect(picker, 'the Select').toBeVisibleEnabled();
  await picker.click();
  const item = page.locator('.sapMSelectListItem', { hasText: 'Comfort Easy' }).first();
  await expect(item, 'the "Comfort Easy" entry').toBeVisibleEnabled();
  await item.click();
  await expect(page.locator('.sapMMessageToast'), 'the change toast').toContainText('change event fired!');
};
