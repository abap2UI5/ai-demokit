// InitialPagePattern: F4 on the Input is the keyboard form of the
// valueHelpRequest (its icon carries a zero-size box headless), and the
// SelectDialog is opened client-side by control_by_id. Picking a row and
// its confirm round-trip stay a human check: the dialog row has no layout
// box headless and neither a click nor a keyboard Enter reaches the
// SelectDialog's confirm (measured 2026-08-01).
import { waitForCount } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const inp = page.locator('.sapMInputBaseInner').first();
  if (!(await inp.count())) throw new Error('the PurchaseID input did not render');
  await page.evaluate(() => document.querySelector('.sapMInputBaseInner').focus());
  await page.keyboard.press('F4');
  await expect(page.locator('.sapMDialog'), 'the SelectDialog opened by control_by_id').toContainText('Purchases');
  await waitForCount(page, '.sapMDialog .sapMLIB', 1, 'the SelectDialog stayed empty');
};
