// client-side growing: the list starts at the threshold and the More
// trigger appends the next page — no backend wire at all
import { waitForCount } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const rows = page.locator('.sapMLIB.sapMSLI');
  await expect(rows.first(), 'the first list row').toBeVisibleEnabled();
  const before = await rows.count();
  if (before !== 4) throw new Error(`the growingThreshold should show 4 rows, got ${before}`);
  await page.locator('.sapMGrowingListTrigger').first().click();
  await waitForCount(page, '.sapMLIB.sapMSLI', 8, 'the More trigger did not append the next page');
};
