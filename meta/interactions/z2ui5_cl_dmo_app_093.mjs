// prevent-default itemClose + MessageBox.confirm + bound-row removal
// (2026-07-30 audit fix)
export default async (page, expect) => {
  const close = page.locator('.sapMTSItemCloseBtnCnt button').first();
  await close.waitFor({ state: 'attached', timeout: 10000 });
  await close.click({ force: true });
  const dialog = page.locator('.sapMMessageBox');
  await expect(dialog, 'the close-confirm MessageBox').toContainText('Do you want to close the tab');
  await page.getByRole('button', { name: 'OK', exact: true }).first().click();
  await expect(page.locator('.sapMMessageToast'), 'the closed toast').toContainText('Item closed:');
};
