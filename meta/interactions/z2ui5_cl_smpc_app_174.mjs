// the controller's setAlternateRowColors / highlight toggling replaced by
// two-way bound ToggleButtons + an expression binding on RowSettings
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  // the toolbar controls all live in the OverflowToolbar's popover here —
  // open it first ("Additional Options"), then they ARE drivable (2026-08-01)
  const more = page.getByRole('button', { name: 'Additional Options' }).first();
  await expect(more, 'the overflow button').toBeVisibleEnabled();
  await more.click();
  const pop = page.locator('.sapMPopover');
  const alt = pop.getByText('Toggle Alternate Row Colors', { exact: true }).first();
  await expect(alt, 'the alternate-row-colors toggle in the overflow').toBeVisibleEnabled();
  await alt.click();
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
    return !!t && t.getAlternateRowColors() === true;
  }, 'the ToggleButton did not flip the Table alternateRowColors through the two-way binding');
  // highlights start ON (seeded true) — turning them off must feed the
  // expression binding on every RowSettings
  const hl = page.locator('.sapMPopover').getByText('Toggle Highlights', { exact: true }).first();
  await expect(hl, 'the highlights toggle in the overflow').toBeVisibleEnabled();
  await hl.click();
  await waitForUi5(page, () => {
    const rs = ui5All().filter((c) => c.getMetadata().getName() === 'sap.ui.table.RowSettings');
    return rs.length > 0 && rs.every((r) => r.getHighlight() === 'None');
  }, 'turning highlights off did not reach the RowSettings highlight expression binding');
  // the third toolbar control: the SelectionMode Select, also in the overflow
  const sel = page.locator('.sapMPopover .sapMSlt').first();
  await expect(sel, 'the SelectionMode Select in the overflow').toBeVisibleEnabled();
  await sel.click();
  await page.locator('.sapMSltPicker').getByText('Single', { exact: true }).first().click();
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
    return !!t && t.getSelectionMode() === 'Single';
  }, 'the Select did not flip the Table selectionMode through the two-way binding');
};
