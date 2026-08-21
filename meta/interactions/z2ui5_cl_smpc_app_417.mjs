// The three wires of this port's deviation, ending with the one that needs a
// real resize:
//   (a) both press round-trips flipping the bound showSideContent, and the
//       bound visible flag of the open button following them,
//   (b) the SET_FOCUS follow-up — after opening, focus has to land on the
//       Close button (and after closing, back on the open button),
//   (c) the breakpointChanged transport: open_btn_visible is
//       `breakpoint = S OR show_side = false`, so the only state that tells a
//       working transport from a broken one is "side content OPEN at
//       breakpoint S" — the open button must come back while show_side stays
//       true. Asserting the resize with the side content closed would pass
//       even if currentBreakpoint never arrived.
// The open button is icon-only, so it is dispatched at rather than clicked.
import { waitForUi5, ui5All, UI5_ALL_SRC } from '../../scripts/lib-e2e.mjs';

const state = async (page) => page.evaluate(`(() => { ${UI5_ALL_SRC}
  const all = ui5All();
  const dsc = all.find((c) => c.getMetadata().getName() === 'sap.ui.layout.DynamicSideContent');
  const open = all.find((c) => c.getId().endsWith('openSideContentBtn'));
  return { side: dsc ? dsc.getShowSideContent() : null, openVisible: open ? open.getVisible() : null,
           focus: document.activeElement ? document.activeElement.id : '' }; })()`);

export default async (page, expect) => {
  await expect(page.locator('.sapUxAPObjectPageHeaderTitle'), 'the header identifier').toContainText('Denise Smith');
  const openBtn = page.locator('[id$="openSideContentBtn"]').first();
  const start = await state(page);
  if (start.side !== false) throw new Error('the side content did not start hidden');
  if (start.openVisible !== true) throw new Error('the open button did not start visible');

  // (a) + (b) open: side content shows, the open button hides, focus moves on
  await openBtn.dispatchEvent('click');
  await waitForUi5(page, () => {
    const all = ui5All();
    const dsc = all.find((c) => c.getMetadata().getName() === 'sap.ui.layout.DynamicSideContent');
    const open = all.find((c) => c.getId().endsWith('openSideContentBtn'));
    return !!dsc && dsc.getShowSideContent() === true && !!open && open.getVisible() === false;
  }, 'OPEN_SIDE_CONTENT did not reach the bound showSideContent / open-button visible flag');
  await expect(page.locator('body'), 'the side content').toContainText('My tasks');
  const opened = await state(page);
  if (!opened.focus.endsWith('closeSideContentBtn')) {
    throw new Error(`the SET_FOCUS follow-up did not focus the Close button (focus is on "${opened.focus}")`);
  }

  // (a) + (b) close again: the flags flip back and focus returns
  await page.getByRole('button', { name: 'Close', exact: true }).first().click();
  await waitForUi5(page, () => {
    const all = ui5All();
    const dsc = all.find((c) => c.getMetadata().getName() === 'sap.ui.layout.DynamicSideContent');
    const open = all.find((c) => c.getId().endsWith('openSideContentBtn'));
    return !!dsc && dsc.getShowSideContent() === false && !!open && open.getVisible() === true;
  }, 'CLOSE_SIDE_CONTENT did not flip the bound flags back');
  const closed = await state(page);
  if (!closed.focus.endsWith('openSideContentBtn')) {
    throw new Error(`the SET_FOCUS follow-up did not focus the open button (focus is on "${closed.focus}")`);
  }

  // (c) the breakpoint transport, measured where it alone decides the flag
  await openBtn.dispatchEvent('click');
  await waitForUi5(page, () => {
    const open = ui5All().find((c) => c.getId().endsWith('openSideContentBtn'));
    return !!open && open.getVisible() === false;
  }, 're-opening the side content did not hide the open button again');
  await page.setViewportSize({ width: 400, height: 900 });
  await waitForUi5(page, () => {
    const all = ui5All();
    const dsc = all.find((c) => c.getMetadata().getName() === 'sap.ui.layout.DynamicSideContent');
    const open = all.find((c) => c.getId().endsWith('openSideContentBtn'));
    return !!open && open.getVisible() === true && !!dsc && dsc.getShowSideContent() === true;
  }, 'the breakpointChanged round-trip did not transport "S" — the open button stayed hidden with the side content open');
};
