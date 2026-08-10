// GenericTag press → Card popover rebuilt from the sample fragment
// (2026-07-30 rework)
export default async (page, expect) => {
  const tag = page.locator('.sapMGenericTag').first();
  await expect(tag, 'the SR GenericTag').toBeVisibleEnabled();
  await tag.click();
  await expect(page.locator('.sapMPopover'), 'the Card popover').toContainText('Sales Revenue');
};
