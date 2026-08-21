// The two wires of this port's deviation:
//   (a) MARK_CHANGES_PRESS — the header's changes marker opens the
//       ResponsivePopover anchored at $event.oSource.sId (the header itself),
//   (b) TOGGLE_HEADER_CONTENT — the 'Public Profile' action flips the two-way
//       bound showHeaderContent, which starts TRUE here, so the first press is
//       the one that has to make the header content collapse.
// Pressed twice, because a flag that latched off would pass a single click.
import { waitForUi5, ui5All, UI5_ALL_SRC, pressHeaderMarker } from '../../scripts/lib-e2e.mjs';

const readShowHeaderContent = async (page) => page.evaluate(`(() => { ${UI5_ALL_SRC}
  const l = ui5All().find((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageLayout');
  return l ? l.getShowHeaderContent() : null; })()`);

export default async (page, expect) => {
  await expect(page.locator('.sapUxAPObjectPageHeaderTitle'), 'the header identifier').toContainText('Denise Smith');

  // (a) the anchored unsaved-changes popover
  await pressHeaderMarker(page, 'changes');
  await expect(page.locator('.sapMPopover'), 'the unsaved-changes popover')
    .toContainText('Another user changes this [entity] without saving changes!');
  await page.keyboard.press('Escape');

  // (b) the bound showHeaderContent round-trip
  if (await readShowHeaderContent(page) !== true) {
    throw new Error('showHeaderContent did not start true — the header content must start expanded');
  }
  const btn = page.getByRole('button', { name: 'Public Profile', exact: true }).first();
  await expect(btn, 'the Public Profile header action').toBeVisibleEnabled();
  await btn.click();
  await waitForUi5(page, () => {
    const l = ui5All().find((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageLayout');
    return !!l && l.getShowHeaderContent() === false;
  }, 'TOGGLE_HEADER_CONTENT did not reach the bound showHeaderContent — the header content stayed expanded');
  await btn.click();
  await waitForUi5(page, () => {
    const l = ui5All().find((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageLayout');
    return !!l && l.getShowHeaderContent() === true;
  }, 'the second press did not expand the header content again — the flag latched off');
};
