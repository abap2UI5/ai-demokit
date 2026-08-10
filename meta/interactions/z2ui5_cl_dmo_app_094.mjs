export default async (page, expect) => {
  const link = page.locator('.sapMListTbl a.sapMLnk').first();
  await expect(link, 'the first product-ID link').toBeVisibleEnabled();
  await link.click();
  await expect(page.locator('.sapMPopover'), 'the BIND_ELEMENT-bound popover').toContainText('Action');
};
