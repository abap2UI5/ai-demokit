// GenericTag → Card popover fragment (the 170/238 class, 238's own wire)
export default async (page, expect) => {
  const tag = page.locator('.sapMGenericTag').first();
  await expect(tag, 'the GenericTag').toBeVisibleEnabled();
  await tag.click();
  // this popover's box measures empty headless (content overflows it), so
  // assert on the rendered text instead of playwright visibility
  await page.waitForFunction(
    () => document.querySelector('.sapMPopover')?.innerText.includes('Sales Revenue'),
    { timeout: 10000 },
  );
};
