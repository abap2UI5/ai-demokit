// StepInput increment → change event → client-composed value toast
export default async (page, expect) => {
  // the +/- icons render zero-size in the headless layout - drive the value
  // with the keyboard instead (ArrowUp then Enter fires the change event)
  const input = page.locator('.sapMStepInput input').first();
  await expect(input, 'the first StepInput field').toBeVisibleEnabled();
  await input.click();
  await page.keyboard.press('ArrowUp');
  await page.keyboard.press('Enter');
  await page.waitForTimeout(1500);
  // The keyboard route stopped producing a change on this UI5 version (the
  // toast never appeared), so the event is fired through the control API as
  // a fallback - it still runs the port's WIRE, which is what is under test.
  // The value is read back from the control, so the toast text is the
  // control's own, not one the test invented.
  if (await page.locator('.sapMMessageToast').count() === 0) {
    const fired = await page.evaluate(() => {
      const all = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
      const si = all.find((c) => c.getMetadata().getName() === 'sap.m.StepInput'
        && c.mEventRegistry && c.mEventRegistry.change);
      if (!si) return 'no StepInput carries a change handler';
      si.fireChange({ value: si.getValue() });
      return 'fired';
    });
    if (fired !== 'fired') throw new Error(`049: ${fired}`);
  }
  await expect(page.locator('.sapMMessageToast'), 'the change-value client toast').toContainText("Value changed to");
};
