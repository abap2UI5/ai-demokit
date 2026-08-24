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
//   (b) selectionChange round-trips the bound GridList.mode — the header
//       text is composed in ABAP ("GridList with mode <key>"), so only a
//       completed round-trip can produce it, which is the load-bearing claim
//       of this port's "three static properties turned into two-way
//       bindings".
//
// The mode leg clicks SingleSelectLeft, NOT MultiSelect: the port loads in
// MultiSelect (mode is seeded there and bound to selectedKey), and
// SegmentedButton._buttonPressed returns early when the pressed button is
// already the selected one — so a click on MultiSelect fires no
// selectionChange at all. Until 2026-08-23 this file clicked exactly that,
// and both assertions were already true at page load: the leg passed without
// a round-trip ever happening.
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const item = page.locator('.sapFGridListItem, .sapMLIB').first();
  await expect(item, 'the first grid list item').toBeVisibleEnabled();
  await item.click();
  await expect(page.locator('.sapMMessageToast').last(), 'the press toast naming the item id')
    .toContainText('Pressed item with ID');

  const seg = page.getByText('SingleSelectLeft', { exact: true }).first();
  await expect(seg, 'the SingleSelectLeft segment').toBeVisibleEnabled();
  await seg.click();
  await waitForUi5(page, () => {
    const l = ui5All().find((c) => c.getMetadata().getName() === 'sap.f.GridList');
    return !!l && l.getMode() === 'SingleSelectLeft';
  }, 'the selectionChange round-trip did not reach the bound GridList.mode');
  await expect(page.locator('body'), 'the header text the backend composed for the new mode')
    .toContainText('GridList with mode SingleSelectLeft');
};
