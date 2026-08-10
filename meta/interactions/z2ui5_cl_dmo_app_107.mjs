// semantic MultiSelectAction: ${$source>/pressed} → server-composed toast
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Multiple Selection', exact: true }).first();
  await expect(btn, 'the MultiSelectAction button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMMessageToast'), 'the toggle-state toast').toContainText('MultiSelect Pressed');
};
