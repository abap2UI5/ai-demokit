// preserveHeaderStateOnScroll
export default async (page, expect) => {
  await expect(page.locator('.sapUxAPObjectPageLayout'), 'the preserved header content').toContainText('Cost Center');
  await expect(page.locator('.sapUiForm').first(), 'the inlined GoalsBlock form').toContainText('Mentor junior developers');
  // preserveHeaderStateOnScroll: the header content stays shown while the
  // page scrolls (without it the header snaps away)
  await page.evaluate(() => { const sc = document.querySelector('.sapUxAPObjectPageWrapper, .sapUxAPObjectPageLayout'); if (sc) sc.scrollTop = 1500; });
  await page.waitForTimeout(1000);
  await expect(page.getByText('Cost Center', { exact: true }).first(), 'the header content after scrolling').toBeVisibleEnabled();
};
