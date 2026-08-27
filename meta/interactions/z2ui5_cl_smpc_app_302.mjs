// SideNavigation / IconTabHeader itemSelect -> the NavContainer 'to' frontend
// action, and that the page it lands on SURVIVES a view rebuild
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

const UI5_ALL = 'const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());';

const state = (page) => page.evaluate(`(() => { ${UI5_ALL}
  const th = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.IconTabHeader');
  const nav = ui5All().find((c) => c.getId().endsWith('pageContainer') && c.getCurrentPage);
  const cur = nav && nav.getCurrentPage();
  return {
    key: th ? th.getSelectedKey() : null,
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
  const main = page.locator('.sapTntToolPageMainContent');
  await expect(main, 'the ToolPage main content').notToContainText('Applications');
  await page.getByText('Applications', { exact: true }).first().click();
  await expect(main, 'the main content after the itemSelect').toContainText('Applications');

  /*
   * The NavContainer's position is live control state: view_display( ) destroys
   * the MAIN slot and XMLView.create rebuilds it, so pageContainer comes back
   * on its initialPage="page1" — while `selectedkey`, two-way bound to the
   * IconTabHeader's selectedKey, is class state that survives the round trip.
   * Before the fix the restored app read "page2" on the tab bar while the main
   * area showed the Home page.
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
   * Asserting only the reset half would pass on a port that never navigated.
   * REMOVE the guarded re-issue from view_display( ) and the last assertion
   * fails.
   */
  const origin = new URL(page.url()).origin;
  const before = await state(page);
  if (before.key !== 'page2') throw new Error(`the itemSelect round trip never carried selectedkey back (got ${before.key})`);
  if (!before.draft) throw new Error('no draft id on the response — the restore URL cannot be built');

  await boot(page, `${origin}/?app_start=z2ui5_cl_smpc_app_302#/z2ui5-xapp-state=${before.draft}`);
  const restored = await state(page);

  if (restored.key !== 'page2') {
    throw new Error(`the restored draft lost the bound selectedkey (${restored.key}) — this leg can no longer see the asymmetry it guards`);
  }
  if (!/page2$/.test(restored.page || '')) {
    throw new Error(`the rebuilt view shows ${restored.page} while the IconTabHeader still reads ${restored.key} — view_display( ) did not re-issue the NavContainer position`);
  }
};
