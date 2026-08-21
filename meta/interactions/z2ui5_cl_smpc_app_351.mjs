// The Splitter whose contentAreas AND the option rows below it are bound to
// ONE table, so a row is the single source of truth for an area and its
// options. What replaced the DOM dump that used to sit here (it printed the
// buttons and passed no matter what the port did):
//
//   - Add / Remove really re-render the bound aggregation. Counted off the
//     Splitter's own getContentAreas(), not off the option rows: those are a
//     second binding against the same table, so counting them would pass even
//     if the aggregation never followed.
//   - a Min-Size typed into an option row reaches that area's
//     SplitterLayoutData.minSize as an INTEGER. This is the leg that proves
//     the option row and the layout data stay in sync — the LIVE_TEST asks it
//     about a splitter-bar DRAG, which cannot be done headless (the bar is a
//     zero-size box in the unthemed harness), but the drag and the Input write
//     into the same row, and only this direction is reachable. The port parses
//     the string in ABAP over the whole two-way returned table, so a number
//     arriving here means the round-trip and the parse both ran.
//   - Change Orientation flips a BOUND property instead of calling a setter,
//     which is the port's whole deviation from the original's imperative
//     btnChangeOrientation.
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

// THE RENDERED, UNDESTROYED Splitter — never simply the first one in the
// registry. Every round-trip rebuilds the view, and the outgoing control stays
// in Element.registry while it is torn down, so `find(…Splitter)` can answer
// with the previous one and its previous area count. Worse, calling
// getDomRef() on one already destroyed THROWS, and waitForUi5 turns any
// rejection into its own message — which is how a working Remove wire reported
// itself as "never shrank the bound contentAreas aggregation" for three runs
// (measured 2026-08-21; a direct dump after the same press read three areas).
// Test bIsDestroyed BEFORE touching the control.
//
// And bIsDestroyed alone is not enough: between the round-trip's answer and
// the old control's teardown it is neither destroyed nor null-ref'd, it is
// simply DETACHED — so find() kept handing back the previous Splitter with its
// previous area count, and the module passed in isolation while failing in a
// full run. document.body.contains( ) is what separates the live one.
const SPLITTER = `ui5All().find((c) => !c.bIsDestroyed && c.getMetadata().getName() === 'sap.ui.layout.Splitter'
      && c.getDomRef() && document.body.contains(c.getDomRef()) && document.body.contains(c.getDomRef()))`;

// Each of these buttons is a plain ROUND-TRIP, and the view re-renders when it
// answers. Waiting for the response before asserting keeps the next press off
// a node the re-render is about to replace — pressing Remove straight after
// Add intermittently landed on the outgoing DOM and never reached the backend
// (measured 2026-08-21).
const press = async (page, name) => {
  await Promise.all([
    page.waitForResponse((r) => r.request().method() === 'POST' && r.url().includes(':3000'), { timeout: 15000 }),
    page.getByRole('button', { name, exact: true }).click(),
  ]);
  // The RESPONSE is not the RE-RENDER. abap2UI5 rebuilds the view after the
  // answer arrives, so a locator resolved right here can point at a node that
  // is about to be replaced — which is how the Min-Size typed into the option
  // row below was silently dropped, while a dump 2.5s after the same keystroke
  // showed it had landed (measured 2026-08-21). Let the rebuild finish.
  await page.waitForTimeout(1200);
};

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const s = ui5All().find((c) => !c.bIsDestroyed && c.getMetadata().getName() === 'sap.ui.layout.Splitter'
      && c.getDomRef() && document.body.contains(c.getDomRef()) && document.body.contains(c.getDomRef()));
    return s && s.getContentAreas().length === 3;
  }, 'the Splitter did not start with the three declared content areas');

  const count = () => page.evaluate(`(() => { const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const s = ${SPLITTER}; return s ? s.getContentAreas().length : -1; })()`);

  await press(page, 'Add content area');
  await waitForUi5(page, () => {
    const s = ui5All().find((c) => !c.bIsDestroyed && c.getMetadata().getName() === 'sap.ui.layout.Splitter'
      && c.getDomRef() && document.body.contains(c.getDomRef()) && document.body.contains(c.getDomRef()));
    return s && s.getContentAreas().length === 4;
  }, 'Add content area never grew the bound contentAreas aggregation');
  // the fourth area's own option row followed the same table
  await expect(page.locator('body'), 'the option row of the area just added').toContainText('ContentArea #4');

  await press(page, 'Remove content area');
  await waitForUi5(page, () => {
    const s = ui5All().find((c) => !c.bIsDestroyed && c.getMetadata().getName() === 'sap.ui.layout.Splitter'
      && c.getDomRef() && document.body.contains(c.getDomRef()) && document.body.contains(c.getDomRef()));
    return s && s.getContentAreas().length === 3;
  }, 'Remove content area never shrank the bound contentAreas aggregation');
  if ((await count()) !== 3) throw new Error('the Splitter did not come back to three areas');

  // the option row and the layout data are the same row: a Min-Size typed here
  // must arrive on the FIRST area's SplitterLayoutData as the integer 250
  // (it starts at 0, so an unchanged value cannot be mistaken for a pass)
  // Scoped to the options layout and taken in DOM order, which is the only
  // ordering that means anything here. Two Inputs with an empty value render
  // BEFORE the option rows, so a page-wide ".sapMInputBaseInner" counted from
  // zero lands on one of those — and because it also reads "0", an index-based
  // locator passes its own starting-value check and then fails three lines
  // later against a wire that works. Picking the first Input in the Element
  // REGISTRY instead is no better: the registry holds the aggregation template
  // (unbound, never rendered, the app-207 trap) and, once a round-trip has
  // re-rendered the rows, its order is not the rows' order either. Both were
  // measured on 2026-08-21. Inside mainOptions each row contributes Size then
  // Min-Size, so index 1 is row one's Min-Size.
  const minSize = page.locator('[id$="mainOptions"] .sapMInputBaseInner').nth(1);
  const was = await minSize.inputValue();
  if (was !== '0') throw new Error(`expected the first area's Min-Size Input to start at 0, found "${was}"`);
  await minSize.fill('250');
  await minSize.press('Enter');
  await page.waitForTimeout(1200); // same reason as in press( ): let the rebuild land
  await waitForUi5(page, () => {
    const s = ui5All().find((c) => !c.bIsDestroyed && c.getMetadata().getName() === 'sap.ui.layout.Splitter'
      && c.getDomRef() && document.body.contains(c.getDomRef()) && document.body.contains(c.getDomRef()));
    return s && s.getContentAreas()[0].getLayoutData().getMinSize() === 250;
  }, 'the typed Min-Size never reached the first area\'s SplitterLayoutData as a number');

  // orientation is a BOUND property here, so the flip travels through the model
  await press(page, 'Change Orientation');
  await waitForUi5(page, () => {
    const s = ui5All().find((c) => !c.bIsDestroyed && c.getMetadata().getName() === 'sap.ui.layout.Splitter'
      && c.getDomRef() && document.body.contains(c.getDomRef()) && document.body.contains(c.getDomRef()));
    return s && s.getOrientation() === 'Vertical';
  }, 'Change Orientation never flipped the bound Splitter.orientation');

  // Invalidate is a plain round-trip: it must answer, and the areas must
  // survive it (the port drops the original's invalidate() call deliberately)
  await press(page, 'Invalidate Splitter');
  await page.waitForTimeout(1500);
  if ((await count()) !== 3) throw new Error('the Invalidate round-trip lost the content areas');
};
