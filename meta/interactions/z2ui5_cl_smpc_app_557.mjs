// the bound facet lists, their nested values, and the confirm filter
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  // lists="{/T_FILTERS}" has to produce the two groups of the stats model. The
  // lists come from the AGGREGATION: a bound aggregation's template is a live
  // Element too, so the registry holds one list (and one item) more
  await waitForUi5(page, () => {
    const ff = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.FacetFilter');
    return ff && ff.getLists().length === 2;
  }, 'the bound lists aggregation did not produce the two facet groups');
  await waitForUi5(page, () => {
    const ff = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.FacetFilter');
    const titles = ff.getLists().map((c) => c.getTitle());
    return titles.includes('Category') && titles.includes('SupplierName');
  }, 'the facet lists did not take their titles from the group type');
  // the nested VALUES table has to reach the items of each list
  await waitForUi5(page, () => {
    const ff = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.FacetFilter');
    const cat = ff.getLists().find((c) => c.getTitle() === 'Category');
    return cat && cat.getItems().length === 16;
  }, 'the nested values table never reached the Category list');
  await waitForUi5(page, () => {
    const ff = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.FacetFilter');
    const sup = ff.getLists().find((c) => c.getTitle() === 'SupplierName');
    return sup && sup.getItems().length === 12;
  }, 'the nested values table never reached the SupplierName list');
  // the appended demo table is there with the full product list
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.ColumnListItem').length > 100,
    'the appended demo table never rendered its rows');
};
