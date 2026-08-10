// three controller-built Dialogs with the shared product list; the two
// footer buttons close client-side (popup_close)
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Dialog with Fullscreen Toggle', exact: true }).first();
  await expect(btn, 'the plain-dialog button').toBeVisibleEnabled();
  await btn.click();
  const dlg = page.locator('.sapMDialog');
  await expect(dlg, 'the dialog title').toContainText('Available Products');
  await expect(dlg, 'the bound product list inside the dialog').toContainText('Notebook Basic 15');
  await dlg.getByRole('button', { name: 'Close', exact: true }).first().click();
  await expect(page.locator('.sapMDialog'), 'the dialog after popup_close').toHaveCountBelow(1);
};
