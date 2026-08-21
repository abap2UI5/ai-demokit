// The five wires of this port's deviation, driven in an order that leaves
// each one measurable:
//   (a) ITEM_SELECT -> the NavContainer 'to' frontend action,
//   (b) the quickCreate popup,
//   (c) the LIVE_CHANGE filter round-trip over the bound group tables,
//   (d) the SEARCH announceSearchMatchCount frontend action,
//   (e) MENU_TOGGLE, which collapses the side nav AND resets the search.
//
// Two traps this module works around. The navigation item text is not where
// the .sapTntNLI box is clickable (the 302/303 lesson), so items are reached
// with getByText. And every negative assertion is scoped INSIDE the side
// navigation: hasText matches case-insensitive substrings, so a page-wide
// "Home is gone" would keep matching the NavContainer's own
// "This is the home page" and pass whatever the filter did.
import { waitForUi5, ui5All, UI5_ALL_SRC } from '../../scripts/lib-e2e.mjs';

const SIDE = '[id$="sideNavigation"]';
const FIELD = '[id$="sideNavigationSearchField"]';

const searchValue = async (page) => page.evaluate(`(() => { ${UI5_ALL_SRC}
  const f = ui5All().find((c) => c.getId().endsWith('sideNavigationSearchField'));
  return f ? f.getValue() : null; })()`);

export default async (page, expect) => {
  const side = page.locator(SIDE);
  await expect(side, 'the side navigation').toContainText('Business Operations');
  await expect(side, 'the second group').toContainText('System & Administration');

  // (a) itemSelect -> NavContainer 'to'
  await page.getByText('My Orders', { exact: true }).first().click();
  await expect(page.locator('body'), 'the orders page after the to-action').toContainText('This is my orders page');

  // (b) the quickCreate popup
  await page.getByText('Quick Create', { exact: true }).first().click();
  const dialog = page.locator('.sapMDialog');
  await expect(dialog, 'the Quick Create dialog').toContainText('Create New Navigation List Item.');
  await dialog.getByRole('button', { name: 'Cancel', exact: true }).first().click();
  await expect(page.locator('.sapMDialog:visible'), 'the dialog after Cancel').toHaveCountBelow(1);

  // (c) the per-keystroke filter round-trip. Typed with a delay: the wire
  // round-trips per keystroke and events fired mid-flight are dropped.
  const input = page.locator(`${FIELD} input`).first();
  await expect(input, 'the side navigation search field').toBeVisibleEnabled();
  await input.click();
  await input.pressSequentially('Sales', { delay: 300 });
  await expect(side, 'the matching parent kept by the filter').toContainText('Sales Reports');
  await expect(side, 'the non-matching sibling child').notToContainText('Customer reports');
  await expect(side, 'the non-matching root item').notToContainText('Home');
  await expect(side, 'the fully filtered-out second group').notToContainText('System & Administration');

  // (d) the announceSearchMatchCount follow-up writes the count into the
  // static area's polite aria-live node — and clears it again after 3s, so it
  // is polled straight after the round-trip rather than waited on.
  await input.press('Enter');
  const deadline = Date.now() + 10000;
  let announced = '';
  for (;;) {
    announced = await page.evaluate(() => {
      const n = document.querySelector('.sapUiInvisibleMessagePolite');
      return n ? n.textContent : '';
    });
    if (announced.includes('2 matches found')) break;
    if (Date.now() > deadline) {
      throw new Error(`announceSearchMatchCount did not announce the 2 matches (polite node carried "${announced}")`);
    }
    await new Promise((r) => setTimeout(r, 100));
  }

  // (e) collapse resets the search; expanding again has to show the full tree
  const menu = page.locator('[id$="menuToggleButton"]').first();
  await menu.dispatchEvent('click');
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.tnt.ToolPage');
    return !!t && t.getSideExpanded() === false;
  }, 'MENU_TOGGLE did not collapse the side navigation');
  await menu.dispatchEvent('click');
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.tnt.ToolPage');
    return !!t && t.getSideExpanded() === true;
  }, 'the second MENU_TOGGLE press did not expand the side navigation again');
  if (await searchValue(page) !== '') throw new Error('collapsing did not reset the bound search value');
  await expect(side, 'the restored root item').toContainText('Home');
  await expect(side, 'the restored second group').toContainText('System & Administration');
};
