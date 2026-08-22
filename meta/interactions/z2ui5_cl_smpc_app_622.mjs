// the ten-character name constraint, the e-mail check and the two Submit outcomes
//
// Two things measured 2026-08-22 shape this module:
//  - the Name field's binding carries a sap.ui.model.type.String with
//    minLength/maxLength constraints, and UI5 checks those in the BROWSER. It
//    paints the Error state itself and writes ITS OWN message ("Enter a value
//    with no more than 10 characters"), not the port's valueStateText.
//  - while such a client-side constraint is violated the framework sends NO
//    round trip at all (measured: one POST for the whole sequence, none for
//    the Submit press), so the backend's own two outcomes have to be driven
//    with a name the client accepts — the E-mail field carries no client type,
//    so its check is the backend's alone and is what separates them.
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

// Typed through the DOM and committed with Enter, never setValue+fireChange:
// the Name field carries a sap.ui.model.type.String, and the model is written
// by InputBase.onChange -> updateModelProperty (which runs the type). Firing
// the event directly leaves the CONTROL on the new value and the MODEL on the
// old one, so the round trip sent the old value and the field came back empty
// (measured 2026-08-22 — the harness' fill()-does-not-blur rule, one layer in).
const type = async (page, id, value) => {
  const inner = page.locator(`[id$="${id}-inner"]`).first();
  await inner.fill(value);
  await inner.press('Enter');
  await new Promise((r) => setTimeout(r, 1500));
};
const submit = () => {
  const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
  reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Submit').firePress();
};

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const n = ui5All().find((c) => c.getId().endsWith('nameInput'));
    const e = ui5All().find((c) => c.getId().endsWith('emailInput'));
    return n && e && n.getValueState() === 'None' && e.getValueState() === 'None'
      && e.getType() === 'Email';
  }, 'the two Inputs never came up on a clean value state');

  // The BACKEND's two outcomes first, on a form that never violated the client
  // constraint: once UI5 has rejected a value the field keeps its Error state
  // across the round trip and the next Submit is blocked, so the order matters.
  // A name the client accepts plus an address only the backend rejects:
  await type(page, 'nameInput', 'Ada');
  await type(page, 'emailInput', 'not-an-address');
  await page.evaluate(submit);
  await expect(page.locator('.sapMDialog'), 'the failed-validation MessageBox')
    .toContainText('A validation error has occurred. Complete your input first.');
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const dlg = reg.find((c) => c.getMetadata().getName() === 'sap.m.Dialog' && c.isOpen());
    dlg.getButtons()[0].firePress();
  });

  // and the success outcome
  await type(page, 'emailInput', 'ada@example.com');
  // no wait on the state here: the E-mail field has no change wire of its own
  // in the port (only `value` is bound), so email_state is rewritten by the
  // NEXT Submit, not by typing — which is the sample's own shape.
  await page.evaluate(submit);
  await expect(page.locator('.sapMMessageToast'), 'the submitted-form toast')
    .toContainText('The input is validated. Your form has been submitted.');

  // last, because it leaves the form in a state UI5 will not let go of: over
  // ten characters, UI5's own constraint check paints Error in the browser
  await type(page, 'nameInput', 'Maximiliane von Habsburg');
  await waitForUi5(page, () => {
    const n = ui5All().find((c) => c.getId().endsWith('nameInput'));
    return n && n.getValueState() === 'Error' && !!n.getValueStateText();
  }, 'a name over ten characters never painted the Error state');
};
