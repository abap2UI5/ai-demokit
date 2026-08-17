// eleven spliced JSON manifests, each rendering its own Card, and the
// control_by_id refresh wire behind "Start loading"
export default async (page, expect) => {
  const cards = page.locator('.sapFCard,.sapUiIntCard');
  const before = await cards.count();
  if (before !== 11) throw new Error(`${before} Cards rendered, not the eleven manifests`);

  const start = page.getByRole('button', { name: /Start loading/ }).first();
  await expect(start, 'the "Start loading" button').toBeVisibleEnabled();
  await start.click();
  await page.waitForTimeout(2000);
  // the refresh must not lose them - the wire re-reads each manifest by id
  if (await cards.count() !== 11) throw new Error('the refresh wire lost Cards');
};
