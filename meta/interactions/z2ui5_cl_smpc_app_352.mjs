/*
 * app 352 — sap.ui.table.sample.Aggregations
 *
 * Closes the LIVE_TEST: "whether the two-way bound FacetFilterItem selected
 * flags return with the listClose event and the server-side selection applies".
 *
 * The round-trip this drives is the one that used to answer HTTP 500
 * (`TABLE_INVALID_INDEX`, 2026-08-17): `filter_apply` deleted rows out from
 * under its own `LOOP AT`. So "the page did not crash" is genuinely new
 * information here — but it is not enough to close the deviation, which is a
 * claim about the SELECTION arriving, not about the request succeeding.
 *
 * Hence the assertion below compares the rows before and after. The category
 * matters: filtering to **Laptops** proves nothing, because the unfiltered
 * table already opens with `Notebook Basic 15/17/18` and the first page is
 * identical either way (measured — 10 rows before, the same 10 after).
 * `Accessories` changes the first row, which is the cheap way to see that the
 * selection travelled.
 */
export default async (page) => {
  const rows = async () =>
    (await page.locator('table tbody tr td:first-child').allInnerTexts())
      .map((s) => s.trim())
      .filter((s) => s && s !== 'Product Name');

  const before = await rows();
  if (!before.length) throw new Error('no product rows rendered before filtering');

  // open the Category facet list, select Accessories, close it -> listClose
  await page.getByRole('button', { name: 'Category', exact: true }).first().click();
  await page.waitForTimeout(1200);
  await page.locator('.sapMLIB', { hasText: 'Accessories' }).first().click();
  await page.waitForTimeout(600);
  await page.keyboard.press('Escape');
  await page.waitForTimeout(3000);

  const after = await rows();
  if (!after.length) throw new Error('the filtered table is empty — the selection dropped every row');
  if (after[0] === before[0]) {
    throw new Error(
      `listClose did not change the selection: first row is still ${JSON.stringify(before[0])}`,
    );
  }
  console.log(`  filtered ${JSON.stringify(before[0])} -> ${JSON.stringify(after[0])}`);
};
