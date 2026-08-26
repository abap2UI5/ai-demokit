// ButtonWithBadge: BadgeCustomData.value and StepInput.value share one
// two-way field - the badge follows the stepper client-side - and the accepted
// min/max reach the Button through setBadgeMinValue/setBadgeMaxValue.
//
// The second half is the leg that only a REBUILT view can fail: badgeMinValue
// and badgeMaxValue are no properties (badgeStyle is the only badge property
// sap.m.Button declares), they live in the private _badgeMinValue/
// _badgeMaxValue that Button.init resets to 1/9999 - so a control call alone
// does not survive a new Button, while the bound badgemin/badgemax do. The
// draft is restored through the app-state hash, which is the framework's
// "come back to this app" path (check_on_navigated -> view_display), and the
// hidden badge has to stay hidden: current 2 is below the restored minimum 5.
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

const badgeOf = (page) => page.evaluate(
  () => document.querySelector('.sapMBadgeIndicator')?.getAttribute('data-badge') ?? null,
);
const enter = async (page, suffix, value) => {
  const input = page.locator(`[id$="${suffix}"] input`).first();
  await input.click();
  await input.fill(value);
  await page.keyboard.press('Enter');
};

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

  // MIN_CHANGE accepts 5 and pushes it to the Button: the badge value 2 now
  // sits below the minimum, so Button.badgeValueFormatter hides the indicator
  await enter(page, 'MinInput', '5');
  await page.waitForFunction(() => !document.querySelector('.sapMBadgeIndicator'), { timeout: 10000 })
    .catch(() => { throw new Error('MIN_CHANGE did not reach setBadgeMinValue - the badge stayed visible below the minimum'); });
  await enter(page, 'MaxInput', '50');
  await waitForUi5(page, () => {
    const btn = ui5All().find((c) => c.getId().endsWith('BadgedButton'));
    return !!btn && Number(btn._badgeMaxValue) === 50;
  }, 'MAX_CHANGE did not reach setBadgeMaxValue');

  // come back to the app: the saved draft is restored through the app-state
  // hash, so the backend takes the check_on_navigated path and rebuilds the view
  const draft = await page.evaluate(() => sap.ui.require('z2ui5/core/AppState').state.oResponse.ID);
  await page.goto('about:blank');
  await page.goto(`http://localhost:3000/?app_start=z2ui5_cl_smpc_app_249#/z2ui5-xapp-state=${draft}`,
    { waitUntil: 'domcontentloaded', timeout: 30000 });
  await waitForUi5(page, () => {
    const btn = ui5All().find((c) => c.getId().endsWith('BadgedButton'));
    const min = ui5All().find((c) => c.getId().endsWith('MinInput'));
    return !!btn && !!btn.getDomRef() && !!min && min.getValue() === '5';
  }, 'the restored draft never rebuilt the view with the accepted minimum');
  await expect(page.locator('[id$="MaxInput"] input'), 'the restored maximum').toBeVisible();

  const bounds = await page.evaluate(`(() => {
    const all = Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const btn = all.find((c) => c.getId().endsWith('BadgedButton'));
    return { min: Number(btn._badgeMinValue), max: Number(btn._badgeMaxValue) };
  })()`);
  if (bounds.min !== 5 || bounds.max !== 50) {
    throw new Error(`the rebuilt Button lost the accepted badge bounds (min ${bounds.min}, max ${bounds.max} - expected 5/50)`);
  }
  if (await badgeOf(page) !== null) {
    throw new Error('the badge came back on the rebuilt Button although the value is below the accepted minimum');
  }
};
