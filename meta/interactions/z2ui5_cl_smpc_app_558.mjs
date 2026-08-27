// the table page, the open-selected flow and the TabContainer it fills
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

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
   * The NavContainer's position is live control state. TAB_ADD_NEW answers with
   * a full view_display( ), which destroys the MAIN slot — XMLView.create then
   * rebuilds navCon on its FIRST page, the product list, because this
   * NavContainer declares no initialPage. `selected_tab`, `save_visible` and
   * `cancel_visible` are class state and survive, so before the fix pressing +
   * on the tab bar created the tab, put the buttons into edit mode and dropped
   * the user back on the product list.
   *
   * This port needs no bookmark restore to reach the second view_display( ):
   * four of the five branches that call it (TAB_CANCEL, TAB_CLOSE,
   * CLOSE_TAB_CLOSED, TAB_ADD_NEW) are reachable only FROM tabContainerPage,
   * and TAB_ADD_NEW is one press away from where the leg already stands.
   *
   * BOTH halves are asserted: the three tabs and the Cancel button are the
   * surviving state, tabContainerPage is the re-issued position. Remove the
   * `IF nav_page IS NOT INITIAL AND nav_page <> 'table'.` block from
   * view_display( ) and the last assertion fails.
   */
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getId().endsWith('idTabContainer')).fireEvent('addNewButtonPress', {});
  });
  await waitForUi5(page, () => {
    const tc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.TabContainer');
    return tc && tc.getItems().length === 3;
  }, 'the add-new button never opened a third tab');
  // the surviving half: the new tab starts in edit mode, so Save/Cancel replace Edit
  await waitForUi5(page, () => ui5All().some((c) => c.getId().endsWith('idCancel') && c.getVisible() === true)
    && ui5All().some((c) => c.getId().endsWith('idEditItem') && c.getVisible() === false),
  'the new tab did not put the footer into edit mode');
  // the reset half: the rebuilt navCon must be BACK on the tab page, not on the table
  await waitForUi5(page, () => {
    const nav = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.NavContainer');
    return nav && /tabContainerPage$/.test(nav.getCurrentPage().getId());
  }, 'the rebuilt view dropped back to the product list while the footer still claims an open tab in edit mode — view_display( ) did not re-issue the navCon position');
};
