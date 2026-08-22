// the MessagePopover toggled against the MessagesIndicator over the bridged message
export default async (page, expect) => {
  const indicator = page.locator('.sapMBtn').filter({ hasText: '1' }).first();
  const btn = (await indicator.count()) ? indicator : page.locator('.sapMBtn').first();
  await expect(btn, 'the messages indicator').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMMsgPopover, .sapMPopover'), 'the message popover').toContainText('Something wrong happened');
};
