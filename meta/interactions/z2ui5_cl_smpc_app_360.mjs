// The two halves of the deviation: the paste event has to deliver the pasted
// data ARRAY to get_event_arg (the server echoes it back into the toast, so
// the pasted cells themselves are the assertion — a toast carrying only the
// prefix would mean the arg arrived empty), and the bound selectionMode has to
// reach the plugin with no round-trip.
//
// The paste is dispatched rather than typed: the table's own onpaste bails out
// when the focus sits in an input or textarea, and it reads the pasted cells
// off the native event's clipboardData, so the gesture has to be a real
// ClipboardEvent landing on the table itself.
import { waitForUi5, ui5All, UI5_ALL_SRC } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await expect(page.locator('body'), 'the seeded rows').toContainText('Notebook Basic 15');

  const pasted = await page.evaluate(`(() => { ${UI5_ALL_SRC}
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
    if (!t) return 'no table rendered';
    const dom = t.getDomRef();
    if (!dom) return 'the table has no DOM';
    if (document.activeElement && /^(input|textarea)$/i.test(document.activeElement.tagName)) document.activeElement.blur();
    const dt = new DataTransfer();
    dt.setData('text/plain', 'Pasted Name\\tPasted Id');
    dom.dispatchEvent(new ClipboardEvent('paste', { clipboardData: dt, bubbles: true, cancelable: true }));
    return ''; })()`);
  if (pasted) throw new Error(pasted);

  const toast = page.locator('.sapMMessageToast').last();
  await expect(toast, 'the paste toast').toContainText('Pasted Data (on Table Level):');
  await expect(toast, 'the pasted cells carried by the event arg').toContainText('Pasted Name');

  // the bound selectionMode, driven by a Select with no event of its own
  await page.locator('.sapMSlt').first().click();
  await page.locator('.sapMSltPicker').getByText('Single', { exact: true }).first().click();
  await waitForUi5(page, () => {
    const p = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.plugins.MultiSelectionPlugin');
    return !!p && p.getSelectionMode() === 'Single';
  }, 'the Select did not flip the plugin selectionMode through the binding');
};
