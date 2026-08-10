export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Approve', exact: true }).first();
  await expect(btn, 'the "Approve" dialog button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMDialog'), 'the popup_display Dialog').toContainText('Do you want to submit this order?');
};
