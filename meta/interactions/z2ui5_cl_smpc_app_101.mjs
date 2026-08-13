// Wizard: the footer Cancel goes through a backend round-trip that opens a
// MessageBox (message_box_display with a YES/NO onclose action)
export default async (page, expect) => {
  await expect(page.locator('body'), 'the first wizard step').toContainText('Product Type');
  const cancel = page.getByRole('button', { name: 'Cancel', exact: true }).first();
  await expect(cancel, 'the wizard Cancel button').toBeVisibleEnabled();
  await cancel.click();
  await expect(page.locator('.sapMDialog'), 'the cancel MessageBox')
    .toContainText('Are you sure you want to cancel your report?');
};
