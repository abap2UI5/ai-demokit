// the wizard inside the DynamicPage, its branching and its validation
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
