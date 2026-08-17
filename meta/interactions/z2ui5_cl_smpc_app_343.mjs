// the per-cell context binding: a Select changes ITS OWN cell's colorSet, and
// the value has to round-trip into that row of the nested ABAP structure
// rather than into the first one
export default async (page, expect) => {
  const sel = page.locator('.sapMSlt').first();
  const other = page.locator('.sapMSlt').nth(2);
  await expect(sel, 'the first cell colour Select').toBeVisibleEnabled();
  const otherBefore = (await other.innerText()).trim();

  await sel.click();
  const item = page.locator('.sapMSelectListItem', { hasText: 'ColorSet6' }).first();
  await expect(item, 'the ColorSet6 entry').toBeVisibleEnabled();
  await item.click();
  await page.waitForTimeout(1500);

  const after = (await sel.innerText()).trim();
  if (!after.includes('ColorSet6')) throw new Error(`the pressed cell took "${after}", not ColorSet6`);
  /* The half that proves it is a per-CELL context and not one shared path:
   * every other Select has to be where it was. */
  const otherAfter = (await other.innerText()).trim();
  if (otherAfter !== otherBefore) {
    throw new Error(`a neighbouring cell moved too ("${otherBefore}" -> "${otherAfter}") - the binding is not per-cell`);
  }
};
