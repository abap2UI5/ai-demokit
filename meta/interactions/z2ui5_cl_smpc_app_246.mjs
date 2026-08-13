// FileUploader UPLOAD round-trip: empty value → 'Choose a file first'
// (2026-07-30 rework)
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Upload File', exact: true }).first();
  await expect(btn, 'the Upload File button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMMessageToast'), 'the empty-value toast').toContainText('Choose a file first');
};
