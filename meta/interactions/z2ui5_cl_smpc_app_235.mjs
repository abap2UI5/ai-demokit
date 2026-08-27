/*
 * app 235 — sap.m.FacetFilter (Simple)
 *
 * Same class of defect as app 022's leg, on the Simple type: the compound
 * binding_call filter lives on the LIVE items binding, not in the model, so a
 * REBUILT view starts unfiltered — while the two-way bound `selected` flags of
 * t_categories/t_suppliers are class state that survives. Before the fix the
 * FacetFilter came back reading "Accessories" over the full 123-row table
 * (measured 2026-08-26: 34 rows and one aFilter before the rebuild, 123 rows
 * and zero aFilters after).
 *
 * The rebuild is driven through the framework's own bookmark restore —
 * `?app_start=<class>#/z2ui5-xapp-state=<draft>`, the URL
 * cs_event-clipboard_app_state hands out. That request carries no frontend id,
 * so the backend takes factory_first_start -> db_load(draft), which sets
 * check_on_navigated( ) while check_on_init( ) stays false (the latch travels
 * in the loaded draft): exactly the `ELSEIF check_on_navigated( )` branch, and
 * the only way a port that never calls another app reaches view_display( ) a
 * second time.
 *
 * REMOVE the `IF filter_live IS NOT INITIAL. filter_issue( ). ENDIF.` from
 * view_display( ) and the last assertion fails.
 */
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

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

export default async (page) => {
  const origin = new URL(page.url()).origin;
  const before = await state(page);
  if (before.len !== 123) throw new Error(`expected the unfiltered mock's 123 products, got ${before.len}`);

  // type="Simple": each facet is its own button on the filter bar
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

  // the framework's bookmark restore -> check_on_navigated( ) -> view_display( )
  await boot(page, `${origin}/?app_start=z2ui5_cl_smpc_app_235#/z2ui5-xapp-state=${filtered.draft}`);
  const restored = await state(page);

  if (!restored.selected.includes('Accessories')) {
    throw new Error(`the restored draft lost the two-way bound facet selection (${JSON.stringify(restored.selected)}) — this leg can no longer see the asymmetry it guards`);
  }
  if (restored.len !== 34) {
    throw new Error(`the rebuilt view shows ${restored.len} products while the FacetFilter still reads ${JSON.stringify(restored.selected)} — view_display( ) did not re-issue the binding_call filter`);
  }
  if (!restored.filters) throw new Error('the rebuilt items binding carries no filter at all');
};
