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
// The field is still empty at this point, so the filter argument evaluates to
// `[]` and clears instead of filtering: the dialog lists every purchase and
// both assertions below are unchanged by that chain.
//
// The gesture is taken through the CONTROL and repeated: a single
// focus()+press() is not proof that the key ever reached the Input, and this
// is by far the slowest port in the smoke (104 s cold against ~2 s for its
// neighbours — a uxap ObjectPageLayout over the whole mock), so the view can
// still be settling when the module starts.
//
// If the key still opens nothing, the control's own valueHelpRequest is fired
// as a last resort. That does NOT bypass the port: the handlers UI5 attached
// from the XML attribute are exactly what runs — only the KEY DELIVERY, the
// harness' half of the gesture, is skipped, and the line it prints says so.
// And if even that opens nothing, the throw carries what the page actually
// showed (handlers attached, focus, dialog state, frontend errors) instead of
// the bare "never showed text", so the next red run is a diagnosis rather than
// another hunt.
import { waitForCount, waitForUi5 } from '../../scripts/lib-e2e.mjs';

// the LIVE Input: the registry also holds the outgoing control of a re-render,
// and a detached node can neither take the focus nor a key press
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

// what the page saw when nothing opened — a key that never arrived, a handler
// that was never attached and a handler that ran and did nothing are three
// different defects and the message has to tell them apart
const DIAGNOSE = `(() => {
  const inp = ${LIVE_INPUT};
  const reg = inp && inp.mEventRegistry && inp.mEventRegistry.valueHelpRequest;
  const dlg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .find((c) => c.getMetadata().getName() === 'sap.m.SelectDialog');
  let errors;
  try { errors = (sap.ui.require('z2ui5/core/AppState').state.errors || []).map((e) => e.message).slice(-4); }
  catch (e) { errors = ['<AppState not reachable>']; }
  return {
    input: !!inp,
    valueHelpRequestHandlers: reg ? reg.length : 0,
    focused: !!inp && !!document.activeElement && inp.getDomRef().contains(document.activeElement),
    selectDialog: !!dlg,
    selectDialogOpen: !!(dlg && dlg.isOpen && dlg.isOpen()),
    frontendErrors: errors,
  };
})()`;

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Input'
      && !c.bIsDestroyed && c.getDomRef() && document.body.contains(c.getDomRef())),
    'the PurchaseID input did not render');

  const dialogUp = async () => (await page.locator('.sapMDialog').count()) > 0;

  let focused = false;
  for (let i = 0; i < 6 && !(await dialogUp()); i++) {
    if (i) await page.waitForTimeout(1000);
    focused = await page.evaluate(FOCUS_INPUT);
    if (focused) await page.keyboard.press('F4');
  }

  if (!(await dialogUp())) {
    console.log(`   233: six F4 presses opened nothing (input focused: ${focused}) — firing the control's own valueHelpRequest, which still runs the port's wire`);
    await page.evaluate(FIRE_VALUE_HELP);
    await page.waitForTimeout(500);
  }

  if (!(await dialogUp())) {
    throw new Error(`the valueHelpRequest chain opened no dialog — ${JSON.stringify(await page.evaluate(DIAGNOSE))}`);
  }

  await expect(page.locator('.sapMDialog'), 'the SelectDialog opened by control_by_id').toContainText('Purchases');
  await waitForCount(page, '.sapMDialog .sapMLIB', 1, 'the SelectDialog stayed empty');
};
