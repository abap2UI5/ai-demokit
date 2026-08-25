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
// The gesture is taken through the CONTROL and repeated, because a single
// focus()+press() is not proof that the key ever reached the Input. This is by
// far the slowest port in the smoke (117 s in the 2026-08-25 nightly against
// ~2 s for its neighbours — a uxap ObjectPageLayout over the whole mock), so
// the view can still be settling when the module starts, and the node
// document.querySelector returned may not be the one holding the focus when
// the key arrives. That nightly failed here on a wire that is provably live:
// the same handler string the port emits, driven against the real
// core/actions/ControlCall over this port's own reconstructed view, fires both
// actions and opens the dialog with no error recorded (measured 2026-08-25).
// So: focus the Input itself, check the focus was taken, and press again while
// the dialog is not up — the chain is idempotent, both halves may be re-run.
import { waitForCount, waitForUi5 } from '../../scripts/lib-e2e.mjs';

// runs in the page: focus the LIVE Input. The registry also holds the outgoing
// control of a re-render, and a detached node cannot take a key press, so the
// candidate must be undestroyed, rendered AND still in the document.
const FOCUS_INPUT = `(() => {
  const all = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
  const inp = all.find((c) => c.getMetadata().getName() === 'sap.m.Input'
    && !c.bIsDestroyed && c.getDomRef() && document.body.contains(c.getDomRef()));
  if (!inp) return false;
  inp.focus();
  return !!document.activeElement && inp.getDomRef().contains(document.activeElement);
})()`;

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Input'
      && !c.bIsDestroyed && c.getDomRef() && document.body.contains(c.getDomRef())),
    'the PurchaseID input did not render');

  let focused = false;
  for (let i = 0; i < 6 && !(await page.locator('.sapMDialog').count()); i++) {
    if (i) await page.waitForTimeout(1000);
    focused = await page.evaluate(FOCUS_INPUT);
    if (focused) await page.keyboard.press('F4');
  }
  // separate the two failures: a key that was never delivered is a harness
  // effect, a delivered key that opens nothing is the port's wire
  if (!focused && !(await page.locator('.sapMDialog').count())) {
    throw new Error('the PurchaseID input never took the focus, so no F4 was delivered');
  }

  await expect(page.locator('.sapMDialog'), 'the SelectDialog opened by control_by_id').toContainText('Purchases');
  await waitForCount(page, '.sapMDialog .sapMLIB', 1, 'the SelectDialog stayed empty');
};
