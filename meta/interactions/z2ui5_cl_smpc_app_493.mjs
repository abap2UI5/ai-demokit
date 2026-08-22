// the loadItems wire fetching the items only when the picker opens
//
// NOTE: 100, not the mock's 123 — a JSONModel's default sizeLimit instantiates
// 100 of the bound rows and neither the sample nor the port raises it.
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.ComboBox' && c.getItems().length === 0),
    'the ComboBox never rendered empty before the first loadItems');
  // the arrow is an icon-only element and measures 0x0 in the unthemed
  // harness, so it cannot be clicked — F4 on the focused field opens the same
  // picker through the control's own handling (the harness' icon rule)
  await page.locator('.sapMInputBaseInner').first().focus();
  await page.keyboard.press('F4');
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.ComboBox' && c.getItems().length === 100),
    'the loadItems round-trip never filled the bound items');
};
