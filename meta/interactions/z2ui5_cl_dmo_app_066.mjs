// MessagePopover toggleBy (dependents-declared, message table bound)
export default async (page, expect) => {
  const btn = page.locator("[id*='messagePopoverBtn']").first();
  await expect(btn, 'the message-popover toggle button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMMsgPopover, .sapMPopover').first(), 'the toggled MessagePopover').toContainText('Error');
};
