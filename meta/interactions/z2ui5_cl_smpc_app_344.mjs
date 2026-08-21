// Two wires, and the second one is why this module was rewritten.
//
// The breakpointChanged round-trip: the DynamicSideContent tells the backend
// which breakpoint it is on, and the backend answers by enabling the Toggle
// button — which is why the button is DISABLED on a wide viewport and the wire
// cannot be driven without resizing.
//
// Then the Toggle itself. Until 2026-08-21 this module clicked it and asserted
// that ".sapMText,.sapMTitle first is visible", which is true before the click
// and after it, and true whether the button does anything at all — so the
// nightly ran green over a Toggle that could not work: the port flipped a
// bound showSideContent, and DynamicSideContent.toggle( ) does not write that
// property. What tells a working toggle from a dead one is WHICH of the two
// titles is on screen: on breakpoint S the control shows one area at a time,
// so the toggle must bring the side content in and take the main content out.
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

// is the side content area currently the visible one? Read off the control's
// own rendered state rather than the text, because both titles exist in the
// DOM either way — only one of the two areas is displayed.
// _changeGridState hides a grid cell by adding the class `sapUiHidden`; it
// never touches inline display, which a first version of this read and which
// made the predicate answer "the side content is already visible" before any
// toggle (measured 2026-08-21: both cells report style.display '' at every
// breakpoint, while SCGridCell carries sapUiHidden on S until the toggle).
const sideShown = () => {
  const ui5 = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
  const d = ui5.find((c) => !c.bIsDestroyed
    && c.getMetadata().getName() === 'sap.ui.layout.DynamicSideContent' && c.getDomRef() && document.body.contains(c.getDomRef()));
  if (!d) return null;
  const side = d.getDomRef('SCGridCell');
  const main = d.getDomRef('MCGridCell');
  if (!side || !main) return null;
  return !side.classList.contains('sapUiHidden') && main.classList.contains('sapUiHidden');
};

export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Toggle' }).first();
  await expect(btn, 'the Toggle button').toBeVisibleEnabled().catch(() => {});
  if (await btn.isEnabled()) throw new Error('the Toggle button is enabled on a wide viewport already');

  await page.setViewportSize({ width: 420, height: 900 });
  const deadline = Date.now() + 15000;
  while (!(await btn.isEnabled())) {
    if (Date.now() > deadline) throw new Error('breakpointChanged never enabled the Toggle button on S');
    await page.waitForTimeout(250);
  }

  // On S the MAIN content is the one on screen to begin with. Asserted
  // directly, not through waitForUi5 — that waits for a predicate to become
  // TRUE, so passing sideShown here waits for the very state this line is
  // supposed to rule out, and its message then describes a failure the wait
  // could never produce.
  const before = await page.evaluate(`(${sideShown.toString()})()`);
  if (before !== false) throw new Error(`on breakpoint S the side content should start hidden, sideShown() = ${before}`);

  await btn.click();
  await waitForUi5(page, sideShown, 'the Toggle press never brought the side content on screen — '
    + 'the wire does not reach DynamicSideContent.toggle( )');

  // and back, which a latching flag would fail. The predicate is INLINED, not
  // a call to sideShown: waitForUi5 stringifies the function it is given and
  // runs it in the page, where nothing else from this module exists.
  await btn.click();
  await waitForUi5(page, () => {
    const ui5 = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const d = ui5.find((c) => !c.bIsDestroyed
      && c.getMetadata().getName() === 'sap.ui.layout.DynamicSideContent' && c.getDomRef() && document.body.contains(c.getDomRef()));
    const side = d && d.getDomRef('SCGridCell');
    const main = d && d.getDomRef('MCGridCell');
    return !!side && !!main
      && side.classList.contains('sapUiHidden') && !main.classList.contains('sapUiHidden');
  }, 'the second Toggle press never brought the main content back');
};
