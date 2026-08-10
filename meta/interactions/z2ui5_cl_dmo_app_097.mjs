// SplitApp navigation driven from the backend (control_by_id to/toDetail/…)
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Go to Detail page2', exact: true }).first();
  await expect(btn, 'the detail-navigation button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMSplitApp'), 'the second detail page after the round-trip').toContainText('Detail Detail');
};
