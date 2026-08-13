// faked-event-value fixes (2026-08-01): the toast must carry the item's
// own id, not a constant
export default async (page, expect) => {
  const item = page.locator('.sapFGridListItem, .sapMLIB').first();
  await expect(item, 'the first grid list item').toBeVisibleEnabled();
  await item.click();
  await expect(page.locator('.sapMMessageToast').last(), 'the press toast naming the item id')
    .toContainText('Pressed item with ID');
};

// NOTE (2026-08-10, found during the per-file migration): the old INTERACTIONS
// map carried TWO `z2ui5_cl_smpc_app_133` keys — this one and the older one
// below. A JS object literal keeps the LAST duplicate key, so only the entry
// above ever ran; the migration preserves that runtime behavior, and the
// per-file layout makes the silent-shadowing class impossible from here on
// (one file per port). The shadowed entry is kept for the maintainer decision
// whether to merge its leg back in (it exercises a DIFFERENT wire —
// selectionChange → bound GridList.mode — which would extend, not replace,
// the check above):
//
//   // SegmentedButton selectionChange → server round-trip flips the bound
//   // GridList.mode (checkboxes appear only in MultiSelect mode)
//   async (page, expect) => {
//     const seg = page.getByText('MultiSelect', { exact: true }).first();
//     await expect(seg, 'the MultiSelect segment').toBeVisibleEnabled();
//     await seg.click();
//     await expect(page.locator('.sapMCb').first(), 'list checkboxes after the mode round-trip').toBeVisibleEnabled();
//   }
