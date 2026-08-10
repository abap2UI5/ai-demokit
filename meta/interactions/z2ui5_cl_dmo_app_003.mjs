// client-composed toast from ${$source>/text} on a Breadcrumbs Link
export default async (page, expect) => {
  // the headless layout collapses every breadcrumb link into the overflow
  // Select - open the picker and choose the link (fires the link press)
  const picker = page.locator('.sapMBreadcrumbs .sapMSlt').first();
  await expect(picker, 'the breadcrumbs overflow picker').toBeVisibleEnabled();
  await picker.click();
  const item = page.locator('.sapMSelectListItem', { hasText: 'Products' }).first();
  await expect(item, 'the "Products" picker entry').toBeVisibleEnabled();
  await item.click();
  await expect(page.locator('.sapMMessageToast'), 'the ${$source>/text} client toast').toContainText('Products has been activated');
};
