// The port's focus follow-ups are SET_FOCUS, not a control_by_id `focus`: the
// button they aim at is INVISIBLE when the action runs (its `visible` is bound
// to show_cookie_details, which the same roundtrip flips), so a bare
// control.focus() finds no DOM node and returns silently - the original moves
// the focus through its _focusButton helper, which is "focus now if rendered,
// else once it is", exactly what SET_FOCUS does.
// The leg drives the transition where the wire alone decides the outcome:
// Set Preferences -> the details appear and the focus has to be on Save
// Preferences. The other two SET_FOCUS calls are deliberately not asserted
// (see the sidecar): they land and are then overridden by UI5 itself - the
// dialog's own initial focus on open, the footer OverflowToolbar's focus
// restore after Cancel - and the original loses them the same way.
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

const focusId = (page) => page.evaluate(() => (document.activeElement ? document.activeElement.id : ''));

export default async (page, expect) => {
  await page.getByRole('button', { name: 'Open Cookie Settings Dialog' }).first().click();
  await expect(page.locator('.sapMDialog'), 'the cookie settings dialog').toBeVisible();
  await expect(page.locator('.sapMDialog'), 'the dialog preview text').toContainText('SAP Web Analytics');

  // SHOW_COOKIE_DETAILS: the detail list appears and the focus follows it
  await page.locator('.sapMDialog button', { hasText: 'Set Preferences' }).first().click();
  await waitForUi5(page, () => {
    const save = ui5All().find((c) => c.getId().endsWith('actionSavePreferences'));
    return !!save && save.getVisible() === true && !!save.getDomRef();
  }, 'Set Preferences never made the Save Preferences action visible');
  await expect(page.locator('.sapMDialog'), 'the cookie detail list').toContainText('Required Cookies');

  const active = await focusId(page);
  if (!active.endsWith('actionSavePreferences')) {
    throw new Error(`the SET_FOCUS follow-up did not focus Save Preferences (focus is on "${active}")`);
  }

  // CANCEL_PRESS with the details shown navigates back to the preview instead
  // of closing - the dialog stays open and the preview actions come back
  await page.locator('.sapMDialog button', { hasText: 'Cancel' }).first().click();
  await waitForUi5(page, () => {
    const set = ui5All().find((c) => c.getId().endsWith('actionSetPreferences'));
    return !!set && set.getVisible() === true && !!set.getDomRef();
  }, 'Cancel did not navigate back to the preview');
  await expect(page.locator('.sapMDialog'), 'the dialog after Cancel').toBeVisible();
};
