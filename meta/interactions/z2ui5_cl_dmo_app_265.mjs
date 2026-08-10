// per-row bound filter: each row's Select lists only its region's managers
export default async (page, expect) => {
  await expect(page.locator('.sapUiTable'), 'the customers table').toContainText('TechCorp Solutions');
  const select = page.locator('.sapMSlt').first();
  await expect(select, 'the first row Select').toBeVisibleEnabled();
  await select.click();
  const list = page.locator('.sapMSltPicker');
  await expect(list, 'the region-filtered manager list').toContainText('John Smith');
  await expect(list, 'the other regions are filtered out').notToContainText('Yuki Tanaka');
};
