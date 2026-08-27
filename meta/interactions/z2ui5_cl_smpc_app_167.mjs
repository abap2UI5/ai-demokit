// ToolPage audit fix: itemPress toast with the real item text + the
// user-name popover (both 2026-07-30) — and that the page the roundtrip-free
// itemSelect navigated to SURVIVES a view rebuild
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

const UI5_ALL = 'const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());';

const state = (page) => page.evaluate(`(() => { ${UI5_ALL}
  const sn = ui5All().find((c) => c.getMetadata().getName() === 'sap.tnt.SideNavigation');
  const nav = ui5All().find((c) => c.getId().endsWith('pageContainer') && c.getCurrentPage);
  const cur = nav && nav.getCurrentPage();
  return {
    key: sn ? sn.getSelectedKey() : null,
    page: cur ? cur.getId() : null,
    draft: (window.z2ui5 && window.z2ui5.oResponse && window.z2ui5.oResponse.ID) || null,
  }; })()`);

async function boot(page, url) {
  // about:blank first: a goto that only changes the FRAGMENT is a same-document
  // navigation and does NOT reload, so the restore would never be requested
  await page.goto('about:blank');
  await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 60000 });
  await page.waitForFunction(() => window.sap && window.sap.ui && document.querySelectorAll('[data-sap-ui]').length > 3, { timeout: 90000 });
  await waitForUi5(page, () => {
    const nav = ui5All().find((c) => c.getId().endsWith('pageContainer') && c.getCurrentPage);
    return !!(nav && nav.getCurrentPage());
  }, 'the restored view never rebuilt its NavContainer');
}

export default async (page, expect) => {
  const item = page.getByText('Child Item 1', { exact: true }).first();
  await expect(item, 'the Child Item 1 nav entry').toBeVisibleEnabled();
  await item.click();
  await expect(page.locator('.sapMMessageToast'), 'the itemPress toast').toContainText('Fired itemPress, item: Child Item 1');
  // the same click's itemSelect is a roundtrip-free control_by_id 'to'
  await waitForUi5(page, () => {
    const nav = ui5All().find((c) => c.getId().endsWith('pageContainer') && c.getCurrentPage);
    return nav && /page1$/.test(nav.getCurrentPage().getId());
  }, 'the itemSelect control_by_id "to" never moved the NavContainer to page1');
  const user = page.getByRole('button', { name: 'Alan Smith', exact: true }).first();
  await user.click();
  await expect(page.locator('.sapMPopover'), 'the user popover').toContainText('Feedback');

  /*
   * The NavContainer's position is live control state: view_display( ) destroys
   * the MAIN slot and XMLView.create rebuilds it, so pageContainer comes back
   * on its initialPage="page2" — while `selectedkey`, two-way bound to the
   * SideNavigation's selectedKey, is class state that survives. itemSelect here
   * is roundtrip-free (the key resolves client-side), so the key only reaches
   * the backend on the NEXT event: the user-popover press above is that event,
   * and the draft it writes is what the restore reads back. Before the fix the
   * restored app highlighted page1 while the main area showed page2.
   *
   * The rebuild is driven through the framework's own bookmark restore —
   * `?app_start=<class>#/z2ui5-xapp-state=<draft>`, the URL
   * cs_event-clipboard_app_state hands out. That request carries no frontend
   * id, so the backend takes factory_first_start -> db_load(draft), which sets
   * check_on_navigated( ) while check_on_init( ) stays false: exactly the
   * `ELSEIF check_on_navigated( )` branch, and the only way a port that never
   * calls another app reaches view_display( ) a second time.
   *
   * BOTH halves are asserted — the surviving key and the re-issued position.
   * REMOVE the guarded re-issue from view_display( ) and the last assertion
   * fails.
   */
  const origin = new URL(page.url()).origin;
  const before = await state(page);
  if (before.key !== 'page1') throw new Error(`the itemSelect never wrote the bound selectedkey (got ${before.key})`);
  if (!before.draft) throw new Error('no draft id on the response — the restore URL cannot be built');

  await boot(page, `${origin}/?app_start=z2ui5_cl_smpc_app_167#/z2ui5-xapp-state=${before.draft}`);
  const restored = await state(page);

  if (restored.key !== 'page1') {
    throw new Error(`the restored draft lost the bound selectedkey (${restored.key}) — this leg can no longer see the asymmetry it guards`);
  }
  if (!/page1$/.test(restored.page || '')) {
    throw new Error(`the rebuilt view shows ${restored.page} while the SideNavigation still reads ${restored.key} — view_display( ) did not re-issue the NavContainer position`);
  }
};
