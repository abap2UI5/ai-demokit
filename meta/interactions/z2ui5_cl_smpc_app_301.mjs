// The ShellBar-anchored side navigation. What replaced the DOM dump that used
// to sit here (it printed the buttons and passed whatever the port did):
//
//   - menuButtonPressed opens the popover ANCHORED to the menu button, which is
//     a round-trip: the backend builds the fragment and answers with a
//     popover_display carrying the button id the event transported.
//   - itemSelect navigates the NavContainer through a control_by_id 'to'
//     follow-up AND writes the bound page text. Asserted on a specific item, so
//     an off-by-one in the key would fail: "Sales Order" is key page7, and the
//     port composes its text by stripping "page" from the key.
//   - the selected key SURVIVES the popover being rebuilt. The original loads
//     its fragment once and keeps it; this port rebuilds it per open, so a
//     literal selectedKey would silently reset the highlight to Home after
//     every navigation — the defect found by review on 2026-08-21 and fixed by
//     binding it. Reopening the popover and reading the SideNavigation back is
//     the only thing that can tell the two apart.
//   - the quick-create popup, which the original builds imperatively.
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

// The ShellBar's menu button carries no sapFShellBar… class here — the
// harness serves the UI5 sources without themes, so it renders as a plain
// button with a generated id (__button1) and the accessible name "Menu".
// Locating it by class matched nothing and died in a 30s timeout that reads
// like a missing control (measured 2026-08-21).
const openSideNav = async (page) => {
  await page.getByRole('button', { name: 'Menu', exact: true }).first().click();
  await waitForUi5(page, () => {
    const ui5 = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const p = ui5.find((c) => c.getId().endsWith('respPopover'));
    return p && p.isOpen();
  }, 'menuButtonPressed never opened the anchored side-navigation popover');
};

export default async (page, expect) => {
  await expect(page.locator('body'), 'the ShellBar title').toContainText('Product Name');

  await openSideNav(page);
  await expect(page.locator('body'), 'the navigation list inside the popover').toContainText('Business Areas for selected user role');

  // "Sales Order" is key page7 — the NavContainer must land on that page and
  // the bound Text must name it
  await page.getByText('Sales Order', { exact: true }).first().click();
  await waitForUi5(page, () => {
    const ui5 = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const nav = ui5.find((c) => c.getId().endsWith('pageContainer') && c.getCurrentPage);
    return nav && nav.getCurrentPage() && nav.getCurrentPage().getId().endsWith('page7');
  }, 'the itemSelect control_by_id "to" never moved the NavContainer to page7');
  await expect(page.locator('body'), 'the page text the round-trip wrote').toContainText('Fired event to load page 7');

  // reopen: the highlight must still be on the item just selected. A literal
  // selectedKey in the rebuilt fragment would read "home" here.
  await openSideNav(page);
  await waitForUi5(page, () => {
    const ui5 = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const sn = ui5.find((c) => c.getMetadata().getName() === 'sap.tnt.SideNavigation');
    return sn && sn.getSelectedKey() === 'page7';
  }, 'the selected key reset when the popover was rebuilt — selectedKey is not bound');

  // the quick-create dialog the original builds imperatively
  await page.getByText('Create', { exact: true }).first().click();
  await expect(page.locator('.sapMDialog'), 'the quick-create dialog').toContainText('Create New Navigation List Item');
};
