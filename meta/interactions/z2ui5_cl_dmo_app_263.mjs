// NavContainer.to via _event_client(control_by_id) + the navigate round-trip
export default async (page, expect) => {
  const item = page.getByText('To ObjectPage', { exact: true }).first();
  await expect(item, 'the navigating list item').toBeVisibleEnabled();
  await item.click();
  await expect(page.locator('.sapUxAPObjectPageLayout'), 'the ObjectPage on page 2').toContainText('Denise Smith');
  const back = page.locator('.sapMPageHeader .sapMBarLeft .sapMBtn').first();
  await expect(back, 'the nav-back button').toBeVisibleEnabled();
  await back.click();
  await expect(page.locator('.sapMPage'), 'page 1 after navigating back').toContainText('To ObjectPage');
};
