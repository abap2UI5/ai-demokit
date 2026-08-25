// InitialPagePattern: F4 on the Input is the keyboard form of the
// valueHelpRequest (its value-help icon carries a zero-size box headless),
// and the SelectDialog is opened client-side by control_by_id. Picking a row
// and its confirm round-trip stay a human check: the dialog row has no layout
// box headless and neither a click nor a keyboard Enter reaches the
// SelectDialog's confirm (measured 2026-08-01).
//
// Since 2026-08-24 the wire is a CHAIN of two frontend actions — a
// binding_call `filter` built from the input value, then the control_by_id
// `open` — which is what the original's _filterAndOpenValueHelpDialog does.
// The field is still empty here, so the filter argument evaluates to `[]` and
// clears instead of filtering: the dialog lists every purchase.
//
// Two rules this leg had to learn, both of them "the readiness check was on
// the wrong thing" (app 108's lesson in the README):
//
//  1. Every step that decides whether to act AGAIN is a BOUNDED WAIT, never an
//     instantaneous read. A SelectDialog opens through sap.ui.core.Popup,
//     which shows its DOM asynchronously, so `.sapMDialog` is legitimately
//     absent for a moment after the key lands; deciding "not open yet" with a
//     zero-timeout count() re-took the focus off the OPENING dialog and called
//     open( ) on it again.
//  2. A failure says what the page showed. A red run on this leg has twice
//     turned out NOT to be the wire: the dialog opened, its title on screen,
//     and then the text assertion timed out — so the throw below carries the
//     handler count, the focus, the dialog state, the round-trips seen and the
//     frontend's own error log, and the "it HAD opened" branch says plainly
//     that whatever happened, it was not a dead wire.
//
// Measured 2026-08-25 on this machine: the wire itself is live under both the
// pinned framework and main tip (five green harness runs plus a full offline
// reproduction against the real core/actions/ControlCall). What stays flaky is
// the ENVIRONMENT for this one port — it boots in ~100 s against ~2 s for its
// neighbours, and the renderer has been observed dying outright mid-run
// ("Target page, context or browser has been closed"). See the still-open note
// in meta/interactions/README.md if this reddens the nightly again.
import { waitForCount } from '../../scripts/lib-e2e.mjs';

// the LIVE Input: the registry also holds the outgoing control of a re-render,
// and a detached node can neither take the focus nor a key press. The filter is
// on the control whose state IS the claim — the one that must be on screen to
// receive the gesture.
const LIVE_INPUT = `Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
  .find((c) => c.getMetadata().getName() === 'sap.m.Input'
    && !c.bIsDestroyed && c.getDomRef() && document.body.contains(c.getDomRef()))`;

const FOCUS_INPUT = `(() => {
  const inp = ${LIVE_INPUT};
  if (!inp) return false;
  inp.focus();
  return !!document.activeElement && inp.getDomRef().contains(document.activeElement);
})()`;

const FIRE_VALUE_HELP = `(() => {
  const inp = ${LIVE_INPUT};
  if (!inp) return false;
  inp.fireValueHelpRequest({ fromSuggestions: false });
  return true;
})()`;

// identity of the live MAIN view plus a count of the round-trips seen so far:
// a changed id is a view_display that rebuilt the app under us
const MAIN_VIEW = `Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
  .find((c) => c.getMetadata().getName() === 'sap.ui.core.mvc.XMLView' && !c.bIsDestroyed)`;

// what the page saw when nothing opened (or when it opened and vanished) — a
// key that never arrived, a handler that was never attached, a handler that ran
// and did nothing, and a view rebuilt under an open dialog are four different
// findings and the message has to tell them apart
const DIAGNOSE = `(() => {
  const inp = ${LIVE_INPUT};
  const reg = inp && inp.mEventRegistry && inp.mEventRegistry.valueHelpRequest;
  const dlg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .find((c) => c.getMetadata().getName() === 'sap.m.SelectDialog');
  let errors;
  const view = ${MAIN_VIEW};
  try { errors = (sap.ui.require('z2ui5/core/AppState').state.errors || []).map((e) => e.message).slice(-4); }
  catch (e) { errors = ['<AppState not reachable>']; }
  return {
    input: !!inp,
    valueHelpRequestHandlers: reg ? reg.length : 0,
    focused: !!inp && !!document.activeElement && inp.getDomRef().contains(document.activeElement),
    selectDialog: !!dlg,
    selectDialogOpen: !!(dlg && dlg.isOpen && dlg.isOpen()),
    dialogNodes: document.querySelectorAll('.sapMDialog').length,
    mainView: view ? view.getId() : null,
    frontendErrors: errors,
  };
})()`;

export default async (page, expect) => {
  // round-trips are counted from OUTSIDE the page: an interaction must never
  // patch the app it is there to prove
  let posts = 0;
  page.on('request', (r) => { if (r.method() === 'POST') posts++; });

  // readiness is a DOM wait, deliberately: a waitForFunction over
  // Element.registry.all() re-scans thousands of controls on every animation
  // frame, and on THIS view (the heaviest in the corpus) that pressure was
  // enough to take the renderer down mid-run - two of six batches died with
  // "Target page, context or browser has been closed" until this check stopped
  // polling the registry (measured 2026-08-25). The registry is still the way
  // the Input is resolved for the focus, but once per attempt, not per frame.
  await page.locator('.sapMInputBaseInner').first().waitFor({ state: 'visible', timeout: 20000 })
    .catch(() => { throw new Error('the PurchaseID input did not render'); });

  const dialogShown = (ms) => page.locator('.sapMDialog').filter({ hasText: 'Purchases' }).first()
    .waitFor({ state: 'visible', timeout: ms }).then(() => true).catch(() => false);

  let opened = false;
  let focused = false;
  for (let i = 0; i < 3 && !opened; i++) {
    focused = await page.evaluate(FOCUS_INPUT);
    if (focused) await page.keyboard.press('F4');
    opened = await dialogShown(5000);
  }

  if (!opened) {
    console.log(`   233: three F4 presses opened nothing (input focused: ${focused}) — firing the control's own valueHelpRequest, which still runs the port's wire`);
    await page.evaluate(FIRE_VALUE_HELP);
    opened = await dialogShown(5000);
  }

  // e2e-smoke truncates a failure to 160 characters, so the full picture goes
  // to the log (which the runner prints) and the throw keeps only the fields
  // that decide the verdict
  const report = async () => {
    const d = { ...(await page.evaluate(DIAGNOSE)), posts };
    console.log(`   233 diagnosis: ${JSON.stringify(d)}`);
    return `nodes=${d.dialogNodes} open=${d.selectDialogOpen} alive=${d.selectDialog} posts=${d.posts} hnd=${d.valueHelpRequestHandlers} err=${d.frontendErrors.length}`;
  };

  if (!opened) {
    throw new Error(`the valueHelpRequest chain opened no dialog — ${await report()}`);
  }

  try {
    await expect(page.locator('.sapMDialog'), 'the SelectDialog opened by control_by_id').toContainText('Purchases');
    await waitForCount(page, '.sapMDialog .sapMLIB', 1, 'the SelectDialog stayed empty');
  } catch (e) {
    // it HAD opened with its title on screen, so whatever this is, it is not a
    // dead wire — say what took it away
    throw new Error(`the dialog opened and then went away — ${await report()}`);
  }
};
