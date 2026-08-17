// two wires, and the second is why this port carried a LIVE_TEST at all:
//   the layoutChange round-trip fills the "Current breakpoint" Text on a REAL
//   viewport change, and the Panel width expression follows the slider live
import { sliderDrivenWidth } from '../../scripts/lib-e2e.mjs';

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

  await sliderDrivenWidth(page, 'sap.m.Panel');
};
