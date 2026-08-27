// the tool page, its side navigation, the page switch it drives — and that the
// page switch SURVIVES a view rebuild
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
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.tnt.ToolPage'
    && c.getSideExpanded() === true), 'the tool page never rendered with its side expanded');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.f.ShellBar'
    && c.getNotificationsNumber() === '2'), 'the ShellBar never rendered');
  // the two bound navigation lists come from the model
  await waitForUi5(page, () => {
    const lists = ui5All().filter((c) => c.getMetadata().getName() === 'sap.tnt.NavigationList');
    const sizes = lists.map((l) => l.getItems().length).sort();
    return sizes.length === 2 && sizes[0] === 3 && sizes[1] === 4;
  }, 'the four navigation roots and three fixed items never reached their lists');
  // the menu button toggles the side
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.f.ShellBar').fireEvent('menuButtonPressed', {});
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.tnt.ToolPage'
    && c.getSideExpanded() === false), 'the menu button never collapsed the side');
  // selecting a child navigates the NavContainer to that page
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const sn = reg.find((c) => c.getMetadata().getName() === 'sap.tnt.SideNavigation');
    const root = sn.getItem().getItems()[0];
    sn.fireItemSelect({ item: root.getItems()[0] });
  });
  await waitForUi5(page, () => {
    const nav = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.NavContainer');
    return nav && /page1$/.test(nav.getCurrentPage().getId());
  }, 'the item select never moved the NavContainer to page1');

  /*
   * The NavContainer's position is live control state: view_display( ) destroys
   * the MAIN slot and XMLView.create rebuilds it, so pageContainer comes back
   * on its initialPage="page2" — while `selected_key`, two-way bound to the
   * SideNavigation's selectedKey AND written by the ITEM_SELECT branch, is
   * class state that survives. Before the fix the restored app highlighted
   * page1 in the side navigation while the main area showed page2, which is the
   * opposite of what the sidecar used to claim ("the SideNavigation's
   * selectedKey is bound to the same field, which is what keeps the highlight
   * in step" — corrected in the same change).
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
  if (before.key !== 'page1') throw new Error(`the itemSelect round trip never wrote selected_key (got ${before.key})`);
  if (!before.draft) throw new Error('no draft id on the response — the restore URL cannot be built');

  await boot(page, `${origin}/?app_start=z2ui5_cl_smpc_app_585#/z2ui5-xapp-state=${before.draft}`);
  const restored = await state(page);

  if (restored.key !== 'page1') {
    throw new Error(`the restored draft lost the bound selected_key (${restored.key}) — this leg can no longer see the asymmetry it guards`);
  }
  if (!/page1$/.test(restored.page || '')) {
    throw new Error(`the rebuilt view shows ${restored.page} while the SideNavigation still reads ${restored.key} — view_display( ) did not re-issue the NavContainer position`);
  }
};
