// popup_display SelectDialog with the product mock
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Show Select Dialog', exact: true }).first();
  await expect(btn, 'the dialog button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMDialog'), 'the SelectDialog').toContainText('Select Product');
};
