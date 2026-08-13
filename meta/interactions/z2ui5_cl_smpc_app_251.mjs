// BusyDialog open + START_TIMER close chain (the 147 idiom on a dialog)
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Show Light Busy Dialog', exact: true }).first();
  await expect(btn, 'the busy-dialog button').toBeVisibleEnabled();
  await btn.click();
  // the dialog box measures empty headless - assert presence, not visibility
  await page.locator('.sapMBusyDialog').waitFor({ state: 'attached', timeout: 10000 });
  // the CLOSE_BUSY timer round-trip closes (detaches) it after ~3s
  await page.locator('.sapMBusyDialog').waitFor({ state: 'detached', timeout: 15000 });
};
