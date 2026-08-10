// ToggleButton → the `{N?true:false}` conditional placeholder toast
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Pressed', exact: true }).first();
  await expect(btn, 'the "Pressed" toggle button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMMessageToast'), 'the conditional-placeholder toast').toContainText('Unpressed');
};
