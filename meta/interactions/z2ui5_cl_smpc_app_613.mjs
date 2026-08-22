// the two grouped MultiInputs and the grouping sorter that reaches both bindings
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const list = ui5All().find((c) => c.getId().endsWith('productMIWithList'));
    return list && list.getSuggestionItems().length === 123;
  }, 'the 123 core:Item suggestions never reached productMIWithList');
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getId().endsWith('productMIWithTable'));
    return t && t.getSuggestionRows().length === 123 && t.getSuggestionColumns().length === 4;
  }, 'the 123 suggestion rows and four columns never reached productMIWithTable');
  // the sorter of the binding-info is what builds the supplier groups — assert
  // it survived the trip as a real, descending, GROUPING sorter on both
  await waitForUi5(page, () => ['productMIWithList', 'productMIWithTable'].every((id) => {
    const mi = ui5All().find((c) => c.getId().endsWith(id));
    const b = mi && (mi.getBinding('suggestionItems') || mi.getBinding('suggestionRows'));
    const s = b && b.aSorters && b.aSorters[0];
    return s && s.sPath === 'SUPPLIERNAME' && s.bDescending === true && typeof s.fnGroup === 'function';
  }), 'the grouping sorter never reached the two suggestion bindings');
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getId().endsWith('productMIWithTable'));
    return t && t.getShowTableSuggestionValueHelp() === false && t.getShowValueHelp() === false;
  }, 'the tabular MultiInput kept a value help it should not have');
};
