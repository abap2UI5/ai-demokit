// the per-cell context binding: a Select changes ITS OWN cell's colorSet, and
// the value has to round-trip into that row of the nested ABAP structure
// rather than into the first one.
//
// Until 2026-08-24 this module picked ColorSet6 - which model_init already
// seeds into EVERY cell - so both halves were vacuous: the pressed Select was
// asserted to hold the value it started with (true even with no binding at all,
// since SelectList sets the pressed item locally), and the neighbour was
// asserted unchanged when nothing had asked it to change. Pick a value no cell
// holds, so the assertion can only pass if the write really landed.
export default async (page, expect) => {
  const sel = page.locator('.sapMSlt').first();
  const other = page.locator('.sapMSlt').nth(2);
  await expect(sel, 'the first cell colour Select').toBeVisibleEnabled();

  const before = (await sel.innerText()).trim();
  if (!before.includes('ColorSet6')) throw new Error(`cell 1 started on "${before}", not the seeded ColorSet6`);
  const otherBefore = (await other.innerText()).trim();
  if (!otherBefore.includes('ColorSet6')) throw new Error(`cell 2 started on "${otherBefore}", not the seeded ColorSet6`);

  await sel.click();
  const item = page.locator('.sapMSelectListItem', { hasText: 'ColorSet3' }).first();
  await expect(item, 'the ColorSet3 entry').toBeVisibleEnabled();
  await item.click();
  await page.waitForTimeout(1500);

  // the pressed cell MOVED, to a value no cell was seeded with
  const after = (await sel.innerText()).trim();
  if (!after.includes('ColorSet3')) throw new Error(`the pressed cell took "${after}", not ColorSet3`);
  /* The half that proves it is a per-CELL context and not one shared path:
   * every other Select has to be where it was. */
  const otherAfter = (await other.innerText()).trim();
  if (otherAfter !== otherBefore) {
    throw new Error(`a neighbouring cell moved too ("${otherBefore}" -> "${otherAfter}") - the binding is not per-cell`);
  }
};
