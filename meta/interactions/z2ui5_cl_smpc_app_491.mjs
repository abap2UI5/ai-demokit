// the client-composed selectionChange toast over the two event parameters
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  // the arrow is an icon-only element and measures 0x0 in the unthemed
  // harness, so it cannot be clicked — F4 on the focused field opens the same
  // picker through the control's own handling (the harness' icon rule)
  await page.locator('.sapMInputBaseInner').first().focus();
  await page.keyboard.press('F4');
  const item = page.locator('.sapMLIB').first();
  await expect(item, 'the first picker entry').toBeVisibleEnabled();
  await item.click();
  // Both of the sample's toasts fire on one pick: the roundtrip-free
  // selectionChange one first, then selectionFinished when the picker closes,
  // which REPLACES it — so the last toast is the finished one. Assert that the
  // selection reached the control and that the closing toast names it.
  await waitForUi5(page, () => {
    const mcb = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.MultiComboBox');
    return mcb && mcb.getSelectedKeys().length === 1;
  }, 'the picked entry never reached the MultiComboBox selection');
  await expect(page.locator('.sapMMessageToast').last(), 'the selectionFinished toast')
    .toContainText("Event 'selectionFinished': [");
};
