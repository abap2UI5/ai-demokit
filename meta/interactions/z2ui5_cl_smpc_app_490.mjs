// the client-composed selectionChange toast over the two event parameters
export default async (page, expect) => {
  const arrow = page.locator('.sapMInputBaseIconContainer').first();
  await expect(arrow, 'the MultiComboBox arrow').toBeVisibleEnabled();
  await arrow.click();
  const item = page.locator('.sapMLIB').first();
  await expect(item, 'the first picker entry').toBeVisibleEnabled();
  await item.click();
  await expect(page.locator('.sapMMessageToast'), 'the selectionChange toast').toContainText("Event 'selectionChange': Selected");
};
