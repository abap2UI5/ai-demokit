/*
 * app 354 — sap.ui.table.sample.Filtering
 *
 * This drives `filter_apply( )`, the method that used to delete rows out from
 * under its own `LOOP AT` (`DELETE t_products INDEX sy-tabix`, fixed
 * 2026-08-17). Every event in this port ends there — SEARCH, TOGGLE_AVAILABILITY,
 * COLUMN_FILTER, CLEAR_FILTERS — so the search field reaches the fixed code by
 * the shortest reliable route.
 *
 * It does NOT close this port's LIVE_TEST, and the distinction is the point.
 * That deviation is about the COLUMN filter: the `filter` event with
 * `check_prevent_default`, and whether `enableCellFilter` lets a cell filter
 * fire the same event. Reaching those means opening a `sap.ui.table` column
 * header menu and driving its filter input — fiddly, and a flaky pass on it
 * would be worse than an open deviation that says what is still unverified.
 * The search path below shares the handler but not the veto, so it cannot
 * stand in for it.
 */
export default async (page) => {
  const rows = async () =>
    (await page.locator('.sapUiTableCtrl tbody tr td:first-child').allInnerTexts())
      .map((s) => s.trim())
      .filter((s) => s && s !== 'Product Name');

  const before = await rows();
  if (!before.length) throw new Error('no table rows rendered before filtering');

  /* The toolbar overflows at the smoke's viewport, so the SearchField is not
   * on the page at all until the overflow popover is opened — the earlier
   * diagnostic run of this module saw exactly one button, "Additional
   * Options". Clicking it first is the difference between this passing and a
   * 30s locator timeout that reads like a broken port. */
  const overflow = page.getByRole('button', { name: /Additional Options/i }).first();
  if (await overflow.count()) {
    await overflow.click();
    await page.waitForTimeout(800);
  }

  const search = page.locator('input[type="search"], .sapMSF input').first();
  await search.click();
  await search.fill('Notebook');
  await page.keyboard.press('Enter');
  await page.waitForTimeout(3000);

  const after = await rows();
  const kept = after.filter(Boolean);
  if (!kept.length) throw new Error('the search returned no rows at all');
  if (JSON.stringify(after) === JSON.stringify(before)) {
    throw new Error('the search round-trip changed nothing — filter_apply did not run');
  }
  console.log(`  search 'Notebook': ${before.length} -> ${kept.length} row(s), first ${JSON.stringify(kept[0])}`);
};
