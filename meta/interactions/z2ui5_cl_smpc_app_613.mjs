// the two grouped MultiInputs and the grouping sorter that reaches both bindings
//
// NOTE on the counts: the binding holds all 123 mock rows, a JSONModel's
// default sizeLimit instantiates 100 of them, and the GROUPING sorter adds one
// separator per group on top — measured 100 sap.ui.core.Item + 11
// sap.ui.core.SeparatorItem. The separators are the point: they exist only
// because `group: true` survived into the binding, so they are asserted rather
// than counted around (2026-08-22).
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const list = ui5All().find((c) => c.getId().endsWith('productMIWithList'));
    if (!list) return false;
    const items = list.getSuggestionItems();
    const plain = items.filter((i) => i.getMetadata().getName() === 'sap.ui.core.Item').length;
    const seps = items.filter((i) => i.getMetadata().getName() === 'sap.ui.core.SeparatorItem').length;
    const b = list.getBinding('suggestionItems');
    return plain === 100 && seps > 1 && b && b.getLength() === 123;
  }, 'the grouped core:Item suggestions never reached productMIWithList');
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getId().endsWith('productMIWithTable'));
    if (!t) return false;
    const rows = t.getSuggestionRows();
    const plain = rows.filter((i) => i.getMetadata().getName() === 'sap.m.ColumnListItem').length;
    const b = t.getBinding('suggestionRows');
    return plain === 100 && rows.length > plain && t.getSuggestionColumns().length === 4
      && b && b.getLength() === 123;
  }, 'the grouped suggestion rows and four columns never reached productMIWithTable');
  // The separator/header items above are the assertion that the grouping
  // sorter survived — reading the binding's own `aSorters` internals was tried
  // and dropped: those field names are private to the UI5 version the harness
  // serves, and the rendered separators prove the same thing from the outside.
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getId().endsWith('productMIWithTable'));
    return t && t.getShowTableSuggestionValueHelp() === false && t.getShowValueHelp() === false;
  }, 'the tabular MultiInput kept a value help it should not have');
  // the conversion: productMIWithTable carries a z2ui5.cc.MultiInputExt
  // companion, and its tokenFromRow( ) builds the Token the sample's own
  // addValidator( ) builds - key = the Name cell, text = `key(price cell)`.
  // Asserted on a REAL bound suggestion row rather than through the popover:
  // this is the code path the conversion added, and it is deterministic.
  await waitForUi5(page, () => {
    const ext = ui5All().find((c) => c.getMetadata().getName() === 'z2ui5.cc.MultiInputExt');
    return ext && ext.getProperty('MultiInputId') === 'productMIWithTable'
      && ext.getProperty('TokenKeyCell') === 0 && ext.getProperty('TokenTextCells') === '3';
  }, 'the MultiInputExt companion never reached productMIWithTable');
  await waitForUi5(page, () => {
    const ext = ui5All().find((c) => c.getMetadata().getName() === 'z2ui5.cc.MultiInputExt');
    const t = ui5All().find((c) => c.getId().endsWith('productMIWithTable'));
    // the FIRST row under the descending SupplierName grouping, whichever it
    // is - read from the row itself so the assertion does not restate the sort
    const row = t.getSuggestionRows().find((r) => r.getMetadata().getName() === 'sap.m.ColumnListItem');
    const cells = row.getCells();
    const token = ext.tokenFromRow(row);
    return token && token.getKey() === cells[0].getText()
      && token.getText() === `${cells[0].getText()}(${cells[3].getText()})`;
  }, 'the companion did not build the sample\'s token from a suggestion row');
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getId().endsWith('productMIWithTable'));
    return t && t.getTokens().length === 0 && !t.getBinding('tokens');
  }, 'a tokens binding survived the conversion');
};
