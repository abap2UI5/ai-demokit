// the layoutChange round-trip: the grid tells the backend which breakpoint it
// is on, and the backend answers into the "Current breakpoint" Text. Nothing
// offline can see it - it only fires on a REAL viewport change.
export default async (page, expect) => {
  const label = page.locator('body');
  await expect(label, 'the breakpoint line').toContainText('Current breakpoint:');
  const read = async () => (await page.locator('body').innerText()).match(/Current breakpoint:\s*(\S+)/)?.[1] || '';
  const before = await read();

  await page.setViewportSize({ width: 420, height: 900 });
  const deadline = Date.now() + 15000;
  while (await read() === before) {
    if (Date.now() > deadline) throw new Error(`layoutChange never moved the breakpoint off "${before}"`);
    await page.waitForTimeout(250);
  }
};
