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
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

const UI5_ALL = 'const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());';

const state = (page) => page.evaluate(`(() => { ${UI5_ALL}
  const nav = ui5All().find((c) => c.getId().endsWith('pageContainer') && c.getCurrentPage);
  const cur = nav && nav.getCurrentPage();
  return {
    page: cur ? cur.getId() : null,
    text: cur ? cur.$().text() : null,
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

  /*
   * The NavContainer's position is live control state — the same asymmetry the
   * popover check above guards, one level up. view_display( ) destroys the MAIN
   * slot and XMLView.create rebuilds it, so pageContainer comes back on its
   * initialPage="home", while TWO fields contradict that reset: `selectedkey`
   * (which the rebuilt SideNavigation reads back) and `page_text`, which
   * ITEM_SELECT writes onto the TARGET page and the home page does not even
   * bind. So before the fix the restored app showed the home lorem ipsum while
   * its own model said "Fired event to load page 7".
   *
   * The rebuild is driven through the framework's own bookmark restore —
   * `?app_start=<class>#/z2ui5-xapp-state=<draft>`, the URL
   * cs_event-clipboard_app_state hands out. That request carries no frontend
   * id, so the backend takes factory_first_start -> db_load(draft), which sets
   * check_on_navigated( ) while check_on_init( ) stays false: exactly the
   * `ELSEIF check_on_navigated( )` branch, and the only way a port that never
   * calls another app reaches view_display( ) a second time.
   *
   * BOTH halves are asserted — the surviving page_text and the re-issued
   * position. REMOVE the guarded re-issue from view_display( ) and the last
   * two assertions fail together.
   */
  const origin = new URL(page.url()).origin;
  const before = await state(page);
  if (!before.draft) throw new Error('no draft id on the response — the restore URL cannot be built');

  await boot(page, `${origin}/?app_start=z2ui5_cl_smpc_app_301#/z2ui5-xapp-state=${before.draft}`);
  const restored = await state(page);

  if (!/page7$/.test(restored.page || '')) {
    throw new Error(`the rebuilt view came back on ${restored.page} — view_display( ) did not re-issue the NavContainer position`);
  }
  if (!(restored.text || '').includes('Fired event to load page 7')) {
    throw new Error(`the restored page reads ${JSON.stringify(restored.text)} — the surviving page_text half of this leg is gone, so it can no longer see the asymmetry it guards`);
  }
};
