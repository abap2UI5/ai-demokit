// the wizard inside the DynamicPage, its branching, its validation - and the
// branch surviving a view rebuild
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.f.DynamicPage'),
    'the DynamicPage never rendered');
  await waitForUi5(page, () => {
    const w = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Wizard');
    return w && w.getEnableBranching() === true && w.getSteps().length === 8;
  }, 'the branching wizard never rendered its eight steps');
  // the first step shows the five seeded products and their total
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem').length >= 5,
    'the shopping cart step never rendered its products');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.ObjectHeader'
    && c.getTitle() === 'Total' && Number(c.getNumber()) > 0), 'calcTotal never reached the ObjectHeader');
  // the payment default the backend seeds reaches the SegmentedButton
  await waitForUi5(page, () => ui5All().some((c) => c.getId().endsWith('paymentMethodSelection')
    && c.getSelectedKey() === 'Credit Card'), 'the seeded payment default never reached the SegmentedButton');
  // the credit card step starts invalidated - the name is empty
  await waitForUi5(page, () => {
    const s = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.WizardStep' && c.getId().endsWith('CreditCardStep'));
    return s && s.getValidated() === false;
  }, 'the credit card step was validated with an empty name');

  // WizardStep._complete fires complete and then calls
  // Wizard._handleNextButtonPress in the SAME tick, so the branch target has to
  // stand BEFORE the press: PaymentTypeStep carries the seeded default as a
  // declared nextStep, and every payment choice re-sends it from ABAP
  await waitForUi5(page, () => {
    const s = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.WizardStep' && c.getId().endsWith('PaymentTypeStep'));
    return !!s && !!s.getNextStep() && s.getNextStep().endsWith('CreditCardStep') && s.getSubsequentSteps().length === 3;
  }, 'PaymentTypeStep lost its declared nextStep=CreditCardStep — the first Next press would throw');

  // ---- the branch has to SURVIVE a view rebuild, not only stand before the
  // first press. branch_payment( ) and branch_delivery( ) are re-issued from
  // view_display( ) since 2026-08-27: a rebuilt view resets both associations
  // to what the XML declares, so without them PaymentTypeStep falls back to
  // the static nextStep="CreditCardStep" whatever the user chose, and
  // BillingStep - which declares only subsequentSteps - comes back with NO
  // branch at all and Wizard._handleNextButtonPress throws "the wizard is in
  // branching mode, and no next step is defined".
  //
  // Bank Transfer is picked first on purpose: it makes the surviving branch
  // DIFFER from the XML declaration, so the assertion after the rebuild
  // cannot be satisfied by the declaration alone. The choice goes through the
  // SegmentedButtonItem's own internal button, which is what routes into
  // SegmentedButton._buttonPressed - that is the only path that both writes
  // the two-way bound selectedKey back into the model (setProperty ->
  // updateModelProperty) and fires selectionChange, so the round trip really
  // carries `selectedpayment`.
  const pickPayment = (key) => page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const sb = ui5All().find((c) => c.getId().endsWith('paymentMethodSelection'));
    if (!sb) return 'the payment SegmentedButton is not in the view';
    const item = sb.getItems().find((i) => i.getKey() === '${key}');
    if (!item || !item.oButton) return 'no payment item ${key}';
    item.oButton.firePress();
    return null;
  })()`);

  const pickErr = await pickPayment('Bank Transfer');
  if (pickErr) throw new Error(`choosing Bank Transfer: ${pickErr}`);
  await waitForUi5(page, () => {
    const s = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.WizardStep' && c.getId().endsWith('PaymentTypeStep'));
    return !!s && !!s.getNextStep() && s.getNextStep().endsWith('BankAccountStep');
  }, 'choosing Bank Transfer never re-pointed PaymentTypeStep at BankAccountStep');

  // come back to the app: the saved draft is restored through the app-state
  // hash, which carries no frontend id - so the backend takes
  // factory_first_start -> db_load(draft), check_on_navigated( ) is set while
  // check_on_init( ) stays false, and view_display( ) runs a SECOND time. That
  // is the only way a port calling no other app rebuilds its view.
  const draft = await page.evaluate(() => sap.ui.require('z2ui5/core/AppState').state.oResponse.ID);
  const origin = new URL(page.url()).origin;
  await page.goto('about:blank');
  await page.goto(`${origin}/?app_start=z2ui5_cl_smpc_app_560#/z2ui5-xapp-state=${draft}`,
    { waitUntil: 'domcontentloaded', timeout: 30000 });
  await waitForUi5(page, () => {
    const w = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Wizard');
    return !!w && !!w.getDomRef() && document.body.contains(w.getDomRef()) && w.getSteps().length === 8;
  }, 'the restored draft never rebuilt the branching wizard');

  // BillingStep declares no nextStep at all, so on the rebuilt view the
  // association is null until branch_delivery( ) lands - a state that never
  // resolves on its own, hence its own wait and its own sentence
  await waitForUi5(page, () => {
    const s = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.WizardStep' && c.getId().endsWith('BillingStep'));
    return !!s && !!s.getNextStep();
  }, 'the rebuilt BillingStep came back with no branch at all — view_display( ) did not re-issue branch_delivery( ), and the next press on it throws');
  await waitForUi5(page, () => {
    const s = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.WizardStep' && c.getId().endsWith('PaymentTypeStep'));
    return !!s && !!s.getNextStep();
  }, 'the rebuilt PaymentTypeStep has no branch at all');
  const rebuilt = await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const step = (id) => ui5All().find((c) => c.getMetadata().getName() === 'sap.m.WizardStep' && c.getId().endsWith(id));
    const p = step('PaymentTypeStep');
    const b = step('BillingStep');
    return { payment: p ? String(p.getNextStep()) : 'MISSING', billing: b ? String(b.getNextStep()) : 'MISSING' };
  })()`);
  if (!rebuilt.payment.endsWith('BankAccountStep')) {
    throw new Error(`the rebuilt PaymentTypeStep branches to ${rebuilt.payment} instead of the chosen Bank Transfer target BankAccountStep — view_display( ) did not re-issue branch_payment( )`);
  }
  if (!rebuilt.billing.endsWith('DeliveryTypeStep')) {
    throw new Error(`the rebuilt BillingStep branches to ${rebuilt.billing} instead of DeliveryTypeStep`);
  }

  // back to Credit Card for the press sequence below - the wizard is still on
  // its first step after the rebuild, so payment_passed is false and the
  // choice does not raise the discard MessageBox
  const backErr = await pickPayment('Credit Card');
  if (backErr) throw new Error(`choosing Credit Card again: ${backErr}`);
  await waitForUi5(page, () => {
    const s = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.WizardStep' && c.getId().endsWith('PaymentTypeStep'));
    return !!s && !!s.getNextStep() && s.getNextStep().endsWith('CreditCardStep');
  }, 'choosing Credit Card again never re-pointed PaymentTypeStep back at CreditCardStep');

  const pressNext = (suffix) => page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const step = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.WizardStep' && c.getId().endsWith('${suffix}'));
    if (!step) return 'no step ${suffix}';
    const btn = step.getAggregation('_nextButton');
    const dom = btn && btn.getDomRef();
    if (!dom || dom.classList.contains('sapMWizardNextButtonHidden')) return 'the Next button on ${suffix} is not displayed';
    try { btn.firePress(); return null; } catch (e) { return 'press threw: ' + e.message; }
  })()`);

  const contentsErr = await pressNext('ContentsStep');
  if (contentsErr) throw new Error(`Next on ContentsStep: ${contentsErr}`);
  await waitForUi5(page, () => {
    const w = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Wizard');
    return !!w && w.getProgressStep().getId().endsWith('PaymentTypeStep');
  }, 'the wizard never advanced from ContentsStep to PaymentTypeStep');

  // ONE press must reach the Credit Card branch — with the branch left to the
  // complete round trip this throws and the wizard stays put
  const branchErr = await pressNext('PaymentTypeStep');
  if (branchErr) throw new Error(`the FIRST Next press on PaymentTypeStep failed — ${branchErr}`);
  await waitForUi5(page, () => {
    const w = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Wizard');
    return !!w && w.getProgressStep().getId().endsWith('CreditCardStep');
  }, 'the FIRST Next press on PaymentTypeStep did not reach CreditCardStep — the branch was not set before the press');

  // arriving at BillingStep runs its activate wire, and that ABAP answer sends
  // the delivery branch long before the validation can show the Next button
  await waitForUi5(page, () => {
    const s = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.WizardStep' && c.getId().endsWith('BillingStep'));
    return !!s && s.getValidated() === false && s.getSubsequentSteps().length === 2;
  }, 'BillingStep did not start unvalidated with its two subsequent steps');
};
