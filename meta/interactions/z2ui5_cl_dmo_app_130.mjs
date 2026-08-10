// server round-trip on a two-way bound control property (busy flips in ABAP)
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Toggle Busy State of Both Controls' }).first();
  await expect(btn, 'the busy-toggle button').toBeVisibleEnabled();
  await btn.click();
  // assert the busy STATE class on the bound control — the overlay div
  // itself has a zero-height box in the headless layout and never counts
  // as "visible" to playwright
  await expect(page.locator('.sapUiLocalBusy').first(), 'the bound control turning busy after the round-trip').toBeVisibleEnabled();
};
