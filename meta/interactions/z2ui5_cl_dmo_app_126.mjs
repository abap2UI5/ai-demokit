// FileUploader: the upload cycle reduced to client toasts
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Upload File', exact: true }).first();
  await expect(btn, 'the Upload File button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMMessageToast').last(), 'the upload-started client toast').toContainText('Uploading file to the local server');
};
