// MessagePopover toggle + the 2026-07-30 RELATIVE_ONLY URL policy: opening
// the popover renders the markup links and fires urlValidated → toast
export default async (page, expect) => {
  const btn = page.locator("[id*='messagePopoverBtn']").first();
  await expect(btn, 'the message-popover toggle button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMMsgPopover, .sapMPopover').first(), 'the toggled MessagePopover').toContainText('Error message');
};
