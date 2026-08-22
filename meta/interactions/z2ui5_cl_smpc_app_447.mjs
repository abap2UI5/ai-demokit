// message_box_display with details (the text variant)
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Show Details - Text' }).first();
  await expect(btn, 'the first details button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMDialog'), 'the MessageBox').toContainText('Information');
};
