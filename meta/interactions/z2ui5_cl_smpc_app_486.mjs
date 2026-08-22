// the anchored popover opened from the active ObjectHeader title
export default async (page, expect) => {
  const title = page.locator('.sapMOHTitle a, .sapMOHTitle').first();
  await expect(title, 'the active ObjectHeader title').toBeVisibleEnabled();
  await title.click();
  await expect(page.locator('.sapMPopover'), 'the anchored popover').toContainText('more content goes here');
};
