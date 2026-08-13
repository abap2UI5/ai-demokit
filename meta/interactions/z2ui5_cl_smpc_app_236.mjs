// FeedInput action dialog → enablePostButton round-trip (whitelisted
// bool method, 2026-07-27) + server-side popup_destroy
export default async (page, expect) => {
  const action = page.locator("[id*='feedActionPlain'] button").first();
  await expect(action, 'the FeedInput action button').toBeVisibleEnabled();
  await action.click();
  await expect(page.locator('.sapMDialog'), 'the action dialog').toContainText('Choose an action.');
  await page.getByRole('button', { name: 'Enable Post Button', exact: true }).first().click();
  await page.locator('.sapMDialog').waitFor({ state: 'hidden', timeout: 10000 });
};
