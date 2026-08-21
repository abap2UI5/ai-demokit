// Eleven spliced JSON manifests, each rendering its own Card, and the
// control_by_id refresh wire behind "Start loading".
//
// The button has TWO branches and they are not the same wire: the first press
// publishes the manifests through the model (model_init), and only a LATER
// press reaches the loop that calls refresh( ) on each Card as a frontend
// action. Until 2026-08-21 this module pressed once and then re-counted the
// cards, so the refresh loop was never executed at all — while the sidecar
// deviation it closed claimed "the control_by_id refresh wire on the second
// press" had been live-verified. Press twice.
export default async (page, expect) => {
  const cards = page.locator('.sapFCard,.sapUiIntCard');
  const before = await cards.count();
  if (before !== 11) throw new Error(`${before} Cards rendered, not the eleven manifests`);

  const start = page.getByRole('button', { name: /Start loading/ }).first();
  await expect(start, 'the "Start loading" button').toBeVisibleEnabled();

  // first press: the manifests reach the Cards through the model
  await start.click();
  await page.waitForTimeout(2000);
  if ((await cards.count()) !== 11) throw new Error('the manifest publish lost Cards');

  // second press: the branch that fires eleven control_by_id refresh actions.
  // A refresh that failed would surface as a Card torn down or a page error —
  // the harness fails the port on an uncaught exception, so reaching this
  // point with eleven Cards still bound is what the wire has to produce.
  await start.click();
  await page.waitForTimeout(2500);
  const after = await cards.count();
  if (after !== 11) throw new Error(`the refresh wire left ${after} Cards, not eleven`);
};
