// KEYBOARD_SHORTCUT: Ctrl+S fires the backend SAVE command (2026-07-30)
export default async (page, expect) => {
  await page.locator('.sapMPanel').first().click();
  await page.keyboard.press('Control+s');
  await expect(page.locator('.sapMMessageToast'), 'the Ctrl+S command toast').toContainText('CTRL+S: save triggered on controller');

  // The scoped registration (2026-08-06): the sample's whole point is that a
  // CommandExecution in the Popover's dependents SHADOWS the page-level one
  // for the same Save command while the popover is open. Ctrl+S is
  // registered twice - unscoped -> SAVE, popover-scoped -> PSAVE - so
  // disabling the POPOVER's Save and pressing Ctrl+S with it open must go
  // silent, while the page-level command is still enabled.
  // the popover command's Switch is two-way bound to PSAVE_ENABLED; there is
  // no unique label to click, so it is located by its own binding path. The
  // written-back value rides along with the next event, which is the Ctrl+S
  // below - no extra round-trip needed to make it count.
  const flipped = await page.evaluate(() => {
    const all = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const sw = all.find((c) => c.getMetadata().getName() === 'sap.m.Switch'
      && (c.getBinding('state')?.getPath() || '').toUpperCase().endsWith('PSAVE_ENABLED'));
    if (!sw || !sw.getState()) return false;
    sw.setState(false);
    sw.fireChange({ state: false });
    return true;
  });
  if (!flipped) throw new Error('the popover Save switch (PSAVE_ENABLED) was not found or was already off');
  await page.waitForTimeout(1200);

  // TWO buttons are labelled "Open Popover": the first opens `popover`, the
  // SECOND opens `popoverCommand` - the one whose dependents hold the
  // shadowing CommandExecution in the original
  const open = page.getByRole('button', { name: /Open Popover/i }).nth(1);
  await expect(open, 'the popoverCommand button').toBeVisibleEnabled();
  await open.click();
  await page.locator('.sapMPopover').first().waitFor({ state: 'visible', timeout: 10000 });
  // the toast from the FIRST press must be gone before we judge the second
  await page.waitForTimeout(4000);
  await page.keyboard.press('Control+s');
  await page.waitForTimeout(1500);
  const toasts = await page.locator('.sapMMessageToast').count();
  if (toasts !== 0) {
    throw new Error('the popover-scoped Ctrl+S did not shadow the page command - a toast appeared although the popover command is disabled');
  }
};
