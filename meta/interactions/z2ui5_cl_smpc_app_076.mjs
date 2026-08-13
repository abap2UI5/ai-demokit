// NotificationListItem footer button → static client toast
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Accept', exact: true }).first();
  await expect(btn, 'the "Accept" notification button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMMessageToast'), 'the accept client toast').toContainText('Accept Button Pressed');
};
