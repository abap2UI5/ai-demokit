export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Default', exact: true }).first();
  await expect(btn, 'a "Default" press button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMMessageToast'), 'the client-composed press toast').toContainText('Pressed');
};
