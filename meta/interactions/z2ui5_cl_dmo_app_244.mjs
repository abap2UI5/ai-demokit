// DynamicPage.breakpointChange → bound Avatar displaySize + toast
// (2026-07-30 rework; needs UI5 >= 1.147)
export default async (page, expect) => {
  await page.setViewportSize({ width: 500, height: 800 });
  await expect(page.locator('.sapMMessageToast'), 'the media-range toast').toContainText('Media Range:');
};
