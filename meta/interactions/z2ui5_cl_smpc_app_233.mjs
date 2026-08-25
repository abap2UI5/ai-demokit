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

  // the IllustratedMessage "no selection yet" state the port boots into — the
  // one thing on this screen that is rendered, bound and cheap to read
  await expect(page.locator('body'), 'the initial page state').toContainText('Enter purchase ID');
};
