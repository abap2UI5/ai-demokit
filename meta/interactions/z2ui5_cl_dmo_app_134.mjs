// ToolHeader logo Image press → static client toast
export default async (page, expect) => {
  const logo = page.locator("img[src*='SAP_Logo']").first();
  await expect(logo, 'the SAP logo image').toBeVisibleEnabled();
  await logo.click();
  await expect(page.locator('.sapMMessageToast'), 'the logo client toast').toContainText('Logo pressed!');
};
