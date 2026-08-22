// the Attachment link raising the MessageBox.alert
export default async (page, expect) => {
  const link = page.getByRole('link', { name: 'Attachment' }).first();
  await expect(link, 'the Attachment link').toBeVisibleEnabled();
  await link.click();
  await expect(page.locator('.sapMDialog'), 'the alert').toContainText('Link was clicked!');
};
