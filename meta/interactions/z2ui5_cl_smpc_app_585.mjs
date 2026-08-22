// the tool page, its side navigation and the page switch it drives
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

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
};
