// the bound facet lists, their nested values, the confirm filter — and that the
// filter SURVIVES a view rebuild
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

const UI5_ALL = 'const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());';

const state = (page) => page.evaluate(`(() => { ${UI5_ALL}
  const t = ui5All().find((c) => c.getId().endsWith('idProductsTable'));
  const ff = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.FacetFilter');
  const b = t && t.getBinding('items');
  return {
    len: b ? b.getLength() : null,
    filters: b ? (b.aFilters || []).length : null,
    selected: ff ? [].concat(...ff.getLists().map((l) => l.getItems().filter((i) => i.getSelected()).map((i) => i.getText()))) : [],
    draft: (window.z2ui5 && window.z2ui5.oResponse && window.z2ui5.oResponse.ID) || null,
  }; })()`);

async function boot(page, url) {
  // about:blank first: a goto that only changes the FRAGMENT is a same-document
  // navigation and does NOT reload, so the restore would never be requested
  await page.goto('about:blank');
  await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 60000 });
  await page.waitForFunction(() => window.sap && window.sap.ui && document.querySelectorAll('[data-sap-ui]').length > 3, { timeout: 90000 });
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getId().endsWith('idProductsTable'));
    return !!(t && t.getBinding('items'));
  }, 'the product table never got its items binding back');
}

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

  /*
   * The compound binding_call filter lives on the LIVE items binding, not in
   * the model, so a REBUILT view starts unfiltered — while the two-way bound
   * `selected` flags on t_filters/t_filters_all are class state that survives.
   * Before the fix the FacetFilter came back reading "Accessories" over the
   * full 123-row table (measured 2026-08-26: 34 rows and one aFilter before
   * the rebuild, 123 rows and zero aFilters after).
   *
   * The rebuild is driven through the framework's own bookmark restore —
   * `?app_start=<class>#/z2ui5-xapp-state=<draft>`, the URL
   * cs_event-clipboard_app_state hands out. That request carries no frontend
   * id, so the backend takes factory_first_start -> db_load(draft), which sets
   * check_on_navigated( ) while check_on_init( ) stays false (the latch travels
   * in the loaded draft): exactly the `ELSEIF check_on_navigated( )` branch,
   * and the only way a port that never calls another app reaches
   * view_display( ) a second time.
   *
   * REMOVE the `IF filter_live IS NOT INITIAL. filter_issue( ). ENDIF.` from
   * view_display( ) and the last assertion fails — that is what makes this leg
   * worth its runtime.
   */
  const origin = new URL(page.url()).origin;
  const before = await state(page);
  if (before.len !== 123) throw new Error(`expected the unfiltered mock's 123 products, got ${before.len}`);

  await page.getByRole('button', { name: 'Category' }).first().click();
  await page.waitForTimeout(1800);
  await page.locator('.sapMPopover .sapMLIB, .sapMDialog .sapMLIB', { hasText: 'Accessories' }).first().click();
  await page.waitForTimeout(600);
  // closing the popover is what fires `confirm` -> apply_filter( )
  const ok = page.getByRole('button', { name: 'OK' });
  if (await ok.count()) await ok.first().click();
  else await page.keyboard.press('Escape');

  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getId().endsWith('idProductsTable'));
    const b = t && t.getBinding('items');
    return !!b && b.getLength() === 34;
  }, 'confirm never filtered the table down to the 34 Accessories products');
  const filtered = await state(page);
  if (!filtered.draft) throw new Error('no draft id on the response — the restore URL cannot be built');

  await boot(page, `${origin}/?app_start=z2ui5_cl_smpc_app_557#/z2ui5-xapp-state=${filtered.draft}`);
  const restored = await state(page);

  if (!restored.selected.includes('Accessories')) {
    throw new Error(`the restored draft lost the two-way bound facet selection (${JSON.stringify(restored.selected)}) — this leg can no longer see the asymmetry it guards`);
  }
  if (restored.len !== 34) {
    throw new Error(`the rebuilt view shows ${restored.len} products while the FacetFilter still reads ${JSON.stringify(restored.selected)} — view_display( ) did not re-issue the binding_call filter`);
  }
  if (!restored.filters) throw new Error('the rebuilt items binding carries no filter at all');
  await expect(page.locator('body'), 'the product table').toBeVisible();
};
