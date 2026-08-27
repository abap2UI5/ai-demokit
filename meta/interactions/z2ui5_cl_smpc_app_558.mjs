// the table page, the open-selected flow, the TabContainer it fills — and that
// the tab page the user is ON survives a view rebuild
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

// eB DROPS an event fired while a round trip is in flight (View1.controller.js:
// `if (AppState.state.isBusy && !ignoreBusy) { BusyIndicator.show(0); return; }`)
// — the listener still runs, fireEvent still returns cleanly, and NOTHING goes
// out on the wire. A press this leg sends while the previous response is still
// on its way is therefore silently lost, and reads back as a dead control. So
// every press here waits for the frontend to go idle first.
const idle = (page) => waitForUi5(page, () => !(window.z2ui5 && window.z2ui5.isBusy),
  'a round trip never landed — the frontend stayed busy');

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
  await idle(page);
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
  await idle(page);

  /*
   * The + on the tab bar, clicked for real.
   *
   * It is the TabContainer's OWN add button — showAddNewButton renders it into
   * the control's TabStrip (class sapMTSAddNewTabBtn, tooltip "Add New Tab"),
   * and its press fires addNewButtonPress on the TabContainer, which the port
   * wires to TAB_ADD_NEW. NOT to be confused with the product table's
   * headerToolbar OverflowToolbarButton (sap-icon://add, tooltip "Add"), a
   * different handler (NEW_ITEM_ADD) on a different page.
   *
   * TAB_ADD_NEW appends a row to T_PRODUCTS and T_TABS, puts the footer into
   * edit mode and calls view_display( ). view_display( ) destroys the MAIN slot
   * and XMLView.create builds a fresh tree, so navCon comes back on its FIRST
   * page — the product list, this NavContainer declaring no initialPage — while
   * t_tabs, selected_tab, save_visible and cancel_visible survive as class
   * state. Before the fix, pressing + therefore created the tab and dropped the
   * user on the product list while the footer still claimed an open tab in edit
   * mode.
   *
   * ALL THREE halves are asserted, and each one fails on its own defect:
   *   - the third tab             — the press reached the backend at all
   *   - its key is ProductId-1    — it is TAB_ADD_NEW's own row (the backend
   *     counter that replaces the original's Math.random ProductId), not just
   *     any wire that happened to grow the aggregation
   *   - still on tabContainerPage — REMOVE the guarded nav_page re-issue from
   *     the end of view_display( ) and only this last one fails.
   *
   * The footer is NOT asserted here: the rebuilt TabContainer selects its FIRST
   * item, which round-trips TAB_SELECT for the unmodified tab and puts Edit back
   * on screen — the documented consequence of leaving the selection to the
   * control (deviation: selectedItem is an association to a runtime-generated
   * item id, so the backend cannot name the new tab).
   */
  const addBtn = page.locator('.sapMTSAddNewTabBtn');
  if (!(await addBtn.count())) throw new Error('showAddNewButton rendered no add button on the tab bar');
  await addBtn.first().click();

  await waitForUi5(page, () => {
    const tc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.TabContainer');
    return tc && tc.getItems().length === 3;
  }, 'the + on the tab bar never became a third tab — addNewButtonPress drove no round trip');
  await waitForUi5(page, () => {
    const tc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.TabContainer');
    return tc && tc.getItems()[2].getKey() === 'ProductId-1';
  }, 'the third tab is not the row TAB_ADD_NEW appends — its key is not the backend counter ProductId-1');
  await waitForUi5(page, () => {
    const nav = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.NavContainer');
    return nav && /tabContainerPage$/.test(nav.getCurrentPage().getId());
  }, 'the rebuilt view came back on the product list while three tabs are open — view_display( ) did not re-issue the navCon position');
};
