// ButtonWithBadge: BadgeCustomData.value and StepInput.value share one
// two-way field - the badge follows the stepper client-side (new port)
export default async (page, expect) => {
  const badge = page.locator('.sapMBadgeIndicator').first();
  await badge.waitFor({ state: 'attached', timeout: 10000 });
  // the badge value lives in the data-badge attribute (CSS content)
  await page.waitForFunction(
    () => document.querySelector('.sapMBadgeIndicator')?.getAttribute('data-badge') === '1',
    { timeout: 10000 },
  );
  const input = page.locator('.sapMStepInput input').first();
  await input.click();
  await page.keyboard.press('ArrowUp');
  await page.keyboard.press('Enter');
  await page.waitForFunction(
    () => document.querySelector('.sapMBadgeIndicator')?.getAttribute('data-badge') === '2',
    { timeout: 10000 },
  );
};
