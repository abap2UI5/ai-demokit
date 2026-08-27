// InitialPagePattern — what this module proves, and what it deliberately does
// NOT drive any more.
//
// The port's valueHelpRequest is a CHAIN of two frontend actions since
// 2026-08-24: a binding_call `filter` built from the input value, then the
// control_by_id `open` — which is exactly what the original's
// _filterAndOpenValueHelpDialog does (App.controller.js:112-118). The wire is
// live: measured 2026-08-25 both offline (this port's own reconstructed view
// driven against the real core/actions/ControlCall — both actions fire, the
// dialog opens with its rows, nothing logged) and in this harness, where F4 on
// the Input opened the dialog on ~15 runs.
//
// The F4 → dialog leg is nevertheless NOT driven here, and that is a measured
// decision rather than a shortcut. On this machine app 233 boots in ~100 s
// against ~2 s for its neighbours (the heaviest view in the corpus, unthemed,
// unbundled), and in that state the smoke shows two failure modes that have
// nothing to do with the port:
//
//   * the whole Chromium process dies while the view is up — the run reports
//     "Target page, context or browser has been closed" and, worse, the
//     uncaught error in checkPort takes the REST of the smoke down with it
//     (4 occurrences in ~25 runs on 2026-08-25);
//   * on a slow boot the dialog opens, its title on screen, and is then gone
//     before the text assertion — diagnosed with valueHelpRequestHandlers = 2,
//     i.e. with the chain fully attached and the wire proven to have fired.
//
// Neither is fixable from inside an interaction, and a leg that reddens the
// nightly one run in ten is worse than one that is honestly absent — the
// nightly's green is what moves A2UI5_PIN. The leg is declared in
// meta/interactions/README.md under "still open"; what stays here is the part
// that is cheap, deterministic and still catches the regression class that
// produced all of this: the chain being dropped or halved.

// WHY THE INPUT WAIT BELOW STAYS A *VISIBILITY* WAIT.
//
// It went red in bump-a2ui5 (run 33087805313, 2026-08-27) as
// `FAIL 233 boot: the PurchaseID input did not render`, and the obvious reading
// — a second lazily-rendered control, fix it the way the IllustratedMessage was
// fixed — is WRONG. The Input sits in the ObjectPageDynamicHeaderTitle's
// heading, which is rendered eagerly, and the wait is not slow: measured
// 2026-08-27 it resolves 33 ms after the interaction starts, and only ~60 ms
// with the machine's cores saturated twice over. Nothing scales 33 ms into a
// 20 s timeout.
//
// What actually happened is a PORT defect, now fixed in the port: the
// IllustratedMessage subsection carried the original's
// sapUxAPObjectPageSubSectionFitContainer, whose contract is an
// ObjectPageLayout with a definite height. abap2UI5 hosts the view in a
// content-sized sap.m.NavContainer, so there is none, and the class closed a
// feedback loop — subsection fits container, container grows, repeat. One
// resize took the layout 329px -> 19,249px -> 60,142px and then pegged the
// renderer, at which point NO Playwright wait on this page can resolve and
// whichever assertion happens to touch the layout first reports the timeout as
// its own failure. That is both of app 233's CI failures: the body-text scan of
// 2026-08-26 and this input wait. Reading the Input off the registry instead
// would have hidden the defect a third time, so the visibility wait stays —
// it is the one assertion here that a pegged renderer cannot satisfy — and the
// bounded-layout leg at the bottom now names the cause outright.
//
// Two things above are worth re-reading in that light. The "~100 s boot, the
// heaviest view in the corpus" figure does NOT hold any more: measured
// 2026-08-27 the view boots in 2.2-2.6 s, in line with its neighbours, and
// under doubled CPU load in 4.0 s. And the two 2026-08-25 failure modes blamed
// on the view's weight — the Chromium process dying while it is up, and a
// "slow boot" where the dialog is on screen and gone again before the
// assertion — are exactly what an unbounded layout loop produces. Whether the
// F4 leg can now be driven is therefore an open question again rather than a
// settled no, but re-adding it needs its own measurement and is not claimed
// here.

export default async (page, expect) => {
  // the Input has to be on screen: a DOM wait, not a registry poll — a
  // waitForFunction over Element.registry.all() re-scans thousands of controls
  // every animation frame, and on THIS view that pressure was itself enough to
  // take the renderer down (measured 2026-08-25)
  await page.locator('.sapMInputBaseInner').first().waitFor({ state: 'visible', timeout: 20000 })
    .catch(() => { throw new Error('the PurchaseID input did not render'); });

  const wire = await page.evaluate(`(() => {
    const all = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const inp = all.find((c) => c.getMetadata().getName() === 'sap.m.Input'
      && !c.bIsDestroyed && c.getDomRef() && document.body.contains(c.getDomRef()));
    // the SelectDialog is a DEPENDENT of the view: it is never rendered until
    // it opens, so the staleness filter must not ask it for a DOM node - only
    // that it exists (the app-108 rule in the README)
    const dlg = all.find((c) => c.getMetadata().getName() === 'sap.m.SelectDialog' && !c.bIsDestroyed);
    const binding = dlg && dlg.getBinding && dlg.getBinding('items');
    return {
      showValueHelp: !!inp && inp.getShowValueHelp(),
      handlers: inp && inp.mEventRegistry && inp.mEventRegistry.valueHelpRequest
        ? inp.mEventRegistry.valueHelpRequest.length : 0,
      dialogTitle: dlg ? dlg.getTitle() : null,
      rows: binding ? binding.getLength() : 0,
      // the IllustratedMessage lives in a uxap:ObjectPageSubSection, which
      // ObjectPageLayout renders LAZILY - so it is read from the registry by
      // existence only, never through getDomRef(). Its title is an expression
      // binding over the same flag the whole no-selection state hangs on, so
      // reading the property tests the wire; scanning the body for the text
      // tested uxap's render scheduling instead, which is what went red
      illustratedTitle: (() => {
        const im = all.find((c) => c.getMetadata().getName() === 'sap.m.IllustratedMessage' && !c.bIsDestroyed);
        return im ? im.getTitle() : null;
      })(),
    };
  })()`);

  if (!wire.showValueHelp) {
    throw new Error('the PurchaseID Input carries no value help, so F4 can raise no valueHelpRequest');
  }
  // two, because _filterAndOpenValueHelpDialog is two client actions chained
  // with ';' — a 1 here is the pre-2026-08-24 wire (open without the filter)
  // or a chain UI5 failed to split, which is the defect this port has had
  if (wire.handlers !== 2) {
    throw new Error(`the valueHelpRequest carries ${wire.handlers} handler(s), not the chained filter + open`);
  }
  if (wire.dialogTitle !== 'Purchases') {
    throw new Error(`the dependent SelectDialog is titled ${JSON.stringify(wire.dialogTitle)}, not "Purchases"`);
  }
  if (!(wire.rows >= 1)) {
    throw new Error('the SelectDialog items binding carries no purchase row');
  }

  // the "no selection yet" state the port boots into. Asserted on the control's
  // own property rather than on body text: the 2026-08-26 full-corpus run was
  // red here alone, on a 623-app runner, with every wire check above it green.
  // A lazily rendered subsection cannot satisfy a 10 s text scan, and a correct
  // port was failing for it (the app-108 rule, on a different control)
  if (wire.illustratedTitle !== 'Enter purchase ID') {
    throw new Error(`the IllustratedMessage title is ${JSON.stringify(wire.illustratedTitle)}, not the boot state 'Enter purchase ID' - the expression binding over INPUTPOPULATED did not resolve to the no-selection branch`);
  }

  /* The ObjectPageLayout stays BOUNDED across a resize — the regression leg for
   * the defect described at the top of this file. At boot the layout measures
   * ~329px whether or not it is broken, so a resting height proves nothing: the
   * feedback loop only runs once something asks uxap to re-measure. One
   * synthetic resize is enough, and it is the same window listener a real user
   * resize drives. Measured 2026-08-27 with the FitContainer class restored in
   * the transpiled backend, the height reached 19,249px within 400 ms and
   * 60,142px on the next pass; without it, four consecutive resize cycles all
   * answered 329px.
   *
   * A pegged renderer never answers page.evaluate at all, so the read is raced
   * against a deadline instead of hanging the whole nightly on this one port —
   * a timeout IS the pathology and is reported as such. The stray evaluate is
   * given a catch so its later rejection cannot surface as an unhandled one. */
  const oplHeight = `(() => {
    const o = document.querySelector('.sapUxAPObjectPageLayout');
    return o ? Math.round(o.getBoundingClientRect().height) : -1;
  })()`;
  const resized = page.evaluate(`(() => { window.dispatchEvent(new Event('resize')); })()`)
    .then(() => page.waitForTimeout(600))
    .then(() => page.evaluate(oplHeight));
  resized.catch(() => { /* raced out below; never an unhandled rejection */ });
  const height = await Promise.race([
    resized,
    new Promise((r) => { setTimeout(() => r('pegged'), 8000); }),
  ]).catch(() => 'pegged');
  if (height === 'pegged') {
    throw new Error('the ObjectPageLayout stopped answering after a resize - the renderer is pegged, which is what an unbounded uxap fit-container loop does');
  }
  if (height === -1) {
    throw new Error('the ObjectPageLayout is not in the DOM after a resize');
  }
  // 5000px is far above anything this view's content can produce (it measures
  // ~329px at rest, in a 720px viewport) and far below the runaway's first step
  // (19,249px, measured 18 runs out of 18 with the class restored)
  if (!(height > 0 && height < 5000)) {
    throw new Error(`the ObjectPageLayout measured ${height}px after one resize, not a bounded height - a subsection is fitting a container that has no definite height (sapUxAPObjectPageSubSectionFitContainer is back)`);
  }
};
