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
import { waitForUi5, ui5All, UI5_ALL_SRC, typeLive, revealInOverflow } from '../../scripts/lib-e2e.mjs';

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

  // (c) the per-keystroke filter round-trip. typeLive waits for the bound
  // value after EVERY character: this wire is lossy, not queued, and a fixed
  // delay only makes a dropped keystroke less likely — a 300ms one swallowed
  // the "a" here and made the backend filter on "Sles".
  const input = page.locator(`${FIELD} input`).first();
  await expect(input, 'the side navigation search field').toBeVisibleEnabled();
  await typeLive(page, input, 'Sales', 'sideNavigationSearchField');
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

  // (e) collapse resets the search; expanding again has to show the full tree.
  // The menu button lives in the ToolHeader's OWN overflow at this viewport —
  // measured: the control exists with no DOM at all until that popover opens —
  // so it is revealed before each press, and pressed rather than dispatched at.
  // Each press re-renders the ToolHeader, which re-decides what overflows, so
  // revealing once and holding the locator is not enough: reveal and press
  // together, and retry if the button went away between the two.
  const pressMenu = async () => {
    const menu = page.locator('[id$="menuToggleButton"]').first();
    for (let attempt = 0; attempt < 3; attempt++) {
      await revealInOverflow(page, menu);
      try {
        await menu.click({ timeout: 5000 });
        return;
      } catch {
        await page.waitForTimeout(800);
      }
    }
    throw new Error('the menu toggle button never became clickable in the ToolHeader overflow');
  };

  await pressMenu();
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.tnt.ToolPage');
    return !!t && t.getSideExpanded() === false;
  }, 'MENU_TOGGLE did not collapse the side navigation');
  await pressMenu();
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.tnt.ToolPage');
    return !!t && t.getSideExpanded() === true;
  }, 'the second MENU_TOGGLE press did not expand the side navigation again');
  if (await searchValue(page) !== '') throw new Error('collapsing did not reset the bound search value');
  await expect(side, 'the restored root item').toContainText('Home');
  await expect(side, 'the restored second group').toContainText('System & Administration');
};
