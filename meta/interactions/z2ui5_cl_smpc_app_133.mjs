// Two wires, both of them now actually running.
//
// Until 2026-08-21 this file carried only the first leg: the old in-file
// INTERACTIONS map had TWO `z2ui5_cl_smpc_app_133` keys, a JS object literal
// keeps the LAST one, and the per-file migration preserved that runtime
// behaviour by leaving the shadowed leg as a comment "pending a merge
// decision". The sidecar meanwhile claimed the mode round-trip was
// e2e-verified, which nothing had ever exercised. The merge is that decision:
// the two legs test DIFFERENT wires, so the second extends the first.
//
//   (a) the press toast carries the item's own id, not a constant
//       (the faked-event-value fix of 2026-08-01),
//   (b) selectionChange round-trips the bound GridList.mode — checkboxes
//       appear only in MultiSelect, which is the load-bearing claim of this
//       port's "three static properties turned into two-way bindings".
//
// Pressed BEFORE the mode switch on purpose: in MultiSelect a click toggles
// the selection instead of firing press.
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const item = page.locator('.sapFGridListItem, .sapMLIB').first();
  await expect(item, 'the first grid list item').toBeVisibleEnabled();
  await item.click();
  await expect(page.locator('.sapMMessageToast').last(), 'the press toast naming the item id')
    .toContainText('Pressed item with ID');

  const seg = page.getByText('MultiSelect', { exact: true }).first();
  await expect(seg, 'the MultiSelect segment').toBeVisibleEnabled();
  await seg.click();
  await waitForUi5(page, () => {
    const l = ui5All().find((c) => c.getMetadata().getName() === 'sap.f.GridList');
    return !!l && l.getMode() === 'MultiSelect';
  }, 'the selectionChange round-trip did not reach the bound GridList.mode');
  await expect(page.locator('.sapMCb').first(), 'list checkboxes after the mode round-trip').toBeVisibleEnabled();
};
