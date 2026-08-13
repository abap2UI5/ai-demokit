// roundtrip-free control_by_id openBy on a hidden picker (the app-016 idiom)
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Open Time Picker', exact: true }).first();
  await expect(btn, 'the openBy anchor button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMPopover'), 'the hidden TimePicker opened anchored').toContainText('');
};
