// MultiSelectionPlugin: the three bound plugin properties have to reach the
// plugin with NO round-trip (that is the deviation's first half — the Select
// and the ToggleButton carry no event at all, they only write the model), and
// the selectionChange expression argument has to report the selected count
// (its second half: the count is computed on the client from
// getSelectedIndices().length and travels as an event arg).
//
// Every toolbar control here lives in the OverflowToolbar's "Additional
// Options" popover at the smoke's viewport (measured: input1 has no DOM at
// all until it is opened), so each toolbar step opens it first. The overflow
// MOVES the real controls, ids and all, so the locators stay the same.
import { waitForUi5, ui5All, UI5_ALL_SRC, revealInOverflow } from '../../scripts/lib-e2e.mjs';

const readPlugin = async (page) => page.evaluate(`(() => { ${UI5_ALL_SRC}
  const p = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.plugins.MultiSelectionPlugin');
  return p ? { limit: p.getLimit(), mode: p.getSelectionMode(), header: p.getShowHeaderSelector() } : null; })()`);

export default async (page, expect) => {
  await expect(page.locator('body'), 'the seeded rows').toContainText('Notebook Basic 15');

  // the bound plugin configuration, as seeded
  const seeded = await readPlugin(page);
  if (!seeded) throw new Error('the MultiSelectionPlugin did not render');
  if (seeded.limit !== 20) throw new Error(`the bound limit did not reach the plugin (got ${seeded.limit}, expected 20)`);
  if (seeded.mode !== 'MultiToggle') throw new Error(`the bound selectionMode did not reach the plugin (got ${seeded.mode})`);
  if (seeded.header !== true) throw new Error('the bound showHeaderSelector did not reach the plugin');

  // the limit round-trip, which answers with a toast and re-binds the plugin
  const input = page.locator('[id$="input1"] input').first();
  await revealInOverflow(page, input);
  await expect(input, 'the limit input').toBeVisibleEnabled();
  await input.fill('5');
  await input.press('Enter');
  await expect(page.locator('.sapMMessageToast').last(), 'the limit toast').toContainText('Limit set to 5');
  await waitForUi5(page, () => {
    const p = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.plugins.MultiSelectionPlugin');
    return !!p && p.getLimit() === 5;
  }, 'the changed limit did not reach the plugin through the binding');

  // selecting a row reports the count through the expression argument
  await page.locator('.sapUiTableRowSelectionCell').first().click();
  await expect(page.locator('.sapMMessageToast').last(), 'the selectionChange toast').toContainText('1 row(s) selected.');

  // the selectionMode Select, again with no event of its own. The limit
  // round-trip re-rendered the toolbar, so the overflow has to be reopened.
  const modeSelect = page.locator('[id$="select1"]').first();
  await revealInOverflow(page, modeSelect);
  await modeSelect.click();
  await page.locator('.sapMSltPicker').getByText('Single', { exact: true }).first().click();
  await waitForUi5(page, () => {
    const p = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.plugins.MultiSelectionPlugin');
    return !!p && p.getSelectionMode() === 'Single';
  }, 'the Select did not flip the plugin selectionMode through the binding');
};
