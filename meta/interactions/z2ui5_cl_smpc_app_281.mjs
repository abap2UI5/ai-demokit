// selectionChange transports changedItem.getText() + the selected flag into
// the backend, which composes the toast. The selectionFinish leg is NOT
// armed: it only fires when the picker CLOSES, and headless neither F4 nor
// Escape reaches the picker once focus sits in the item list, an outside
// click does not dismiss it, and getPicker() is null on the registry
// instance (measured 2026-08-02). That leg is live-verified instead.
import { waitForCount } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const inp = page.locator('.sapMMultiComboBox input, .sapMInputBaseInner').first();
  await expect(inp, 'the MultiComboBox input').toBeVisibleEnabled();
  // the F4 open is timing-sensitive — retry until the picker lists items
  for (let i = 0; i < 5; i++) {
    await inp.click();
    await page.keyboard.press('F4');
    await new Promise((r) => setTimeout(r, 1000));
    if (await page.locator('.sapMPopover li').count()) break;
  }
  await waitForCount(page, '.sapMPopover li', 1, 'the MultiComboBox picker stayed empty');
  await page.locator('.sapMPopover li').first().click();
  await expect(page.locator('.sapMMessageToast').last(), 'the selectionChange toast')
    .toContainText("Event 'selectionChange': Selected '");
};
