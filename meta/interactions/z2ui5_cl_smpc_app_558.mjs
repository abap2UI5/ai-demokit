// the table page, the open-selected flow, the TabContainer it fills — and that
// the tab page the user is ON survives a view rebuild
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

const UI5_ALL = 'const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());';

const state = (page) => page.evaluate(`(() => { ${UI5_ALL}
  const tc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.TabContainer');
  const nav = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.NavContainer');
  const cur = nav && nav.getCurrentPage();
  return {
    tabs: tc ? tc.getItems().length : null,
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
    const nav = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.NavContainer');
    return !!(nav && nav.getCurrentPage());
  }, 'the restored view never rebuilt its NavContainer');
}

const select = async (page, index) => {
  await page.evaluate((i) => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const table = reg.find((c) => c.getId().endsWith('idProductsTable'));
    table.setSelectedItem(table.getItems()[i], true, true);
  }, index);
  // each selectionChange is a round trip, and the model that comes back carries
  // the flags - so the two rows have to be selected one after the other
  await waitForUi5(page, (n) => {
    const t = ui5All().find((c) => c.getId().endsWith('idProductsTable'));
    return t.getSelectedItems().length === n;
  }, `row ${index} never stayed selected`, index + 1);
};

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.ColumnListItem').length > 100,
    'the product table never rendered its 123 rows');
  // the footer button is invisible until something is selected
  await waitForUi5(page, () => ui5All().some((c) => c.getId().endsWith('idOpenSelected') && c.getVisible() === false),
    'the open-selected button was visible with no selection');
  await select(page, 0);
  await waitForUi5(page, () => ui5All().some((c) => c.getId().endsWith('idOpenSelected') && c.getVisible() === true),
    'selecting a row never revealed the open-selected button');
  await select(page, 1);
  // let the selection round trip settle: a press fired while one is in flight
  // is dropped, so the backend would still be on the first selection
  await page.waitForTimeout(1500);
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getId().endsWith('idOpenSelected')).firePress();
  });
  // one tab per selected row, each showing its Display header
  await waitForUi5(page, () => {
    const tc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.TabContainer');
    return tc && tc.getItems().length === 2;
  }, 'the two selected rows never became two tabs');
  await waitForUi5(page, () => {
    const nav = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.NavContainer');
    return nav && /tabContainerPage$/.test(nav.getCurrentPage().getId());
  }, 'the open-selected press never navigated to the tab page');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.ObjectHeader' && c.getVisible() === true),
    'a tab opened without its Display header');
  // the Edit form of a tab is hidden until that tab is modified
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.ui.layout.form.SimpleForm')
    .some((c) => c.getVisible() === false), 'the tab Edit form was not hidden while the tab is unmodified');

  /*
   * The NavContainer's position is live control state. view_display( ) destroys
   * the MAIN slot and XMLView.create rebuilds navCon on its FIRST page — the
   * product list, this NavContainer declaring no initialPage — while t_tabs,
   * selected_tab, save_visible and cancel_visible survive as class state. Four
   * of the five branches that call view_display( ) are reachable only FROM
   * tabContainerPage (TAB_CANCEL, TAB_CLOSE, CLOSE_TAB_CLOSED, TAB_ADD_NEW), so
   * before the fix pressing + on the tab bar created the tab and dropped the
   * user on the product list while the footer still claimed an open tab.
   *
   * The rebuild is driven through the framework's own bookmark restore —
   * `?app_start=<class>#/z2ui5-xapp-state=<draft>`, the URL
   * cs_event-clipboard_app_state hands out. That request carries no frontend
   * id, so the backend takes factory_first_start -> db_load(draft), which sets
   * check_on_navigated( ) while check_on_init( ) stays false: exactly the
   * `ELSEIF check_on_navigated( )` branch. It is used here rather than the tab
   * bar's + button because firing addNewButtonPress drove no round trip at all
   * in the headless harness (measured 2026-08-27 against a real backend: the
   * listener IS attached and the event fires, the TabContainer keeps its two
   * items and navCon never moves), and a leg that cannot drive the rebuild
   * proves nothing. The + button remains the path a human should re-check.
   *
   * BOTH halves are asserted — the two surviving tabs AND the re-issued
   * position. Asserting only the reset half would pass on a port that never
   * navigated. REMOVE the guarded nav_page re-issue from view_display( ) and
   * the last assertion fails.
   */
  const origin = new URL(page.url()).origin;
  const before = await state(page);
  if (before.tabs !== 2) throw new Error(`expected the two opened tabs before the rebuild, got ${before.tabs}`);
  if (!before.draft) throw new Error('no draft id on the response — the restore URL cannot be built');

  await boot(page, `${origin}/?app_start=z2ui5_cl_smpc_app_558#/z2ui5-xapp-state=${before.draft}`);
  await waitForUi5(page, () => {
    const tc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.TabContainer');
    return !!(tc && tc.getItems().length === 2);
  }, 'the restored draft lost the two open tabs — this leg can no longer see the asymmetry it guards');
  const restored = await state(page);

  if (!/tabContainerPage$/.test(restored.page || '')) {
    throw new Error(`the rebuilt view came back on ${restored.page} while ${restored.tabs} tabs are still open — view_display( ) did not re-issue the navCon position`);
  }
};
