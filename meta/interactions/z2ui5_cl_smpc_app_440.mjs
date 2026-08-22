// the anchored menu toggle (control_by_id / toggleBy) and its endContent buttons
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Open Menu' }).first();
  await expect(btn, 'the menu trigger').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMMenu'), 'the menu opened by toggleBy').toContainText('Save');
};
