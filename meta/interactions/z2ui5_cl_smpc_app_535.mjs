// the shopping-cart wizard, its calcTotal sum, the row delete and the payment
// branch on the FIRST Next press
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem').length > 0,
    'the cart rows never rendered');
  // both the wizard's cart and the review page bind the same five rows
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.ObjectHeader' && c.getNumber() === '5724'),
    'the calcTotal sum never reached the ObjectHeader');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.WizardStep').length === 8,
    'the eight wizard steps never rendered');
  // the Delete-mode list drops the row and the total is recomputed in ABAP
  await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const list = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.List' && c.getMode() === 'Delete');
    list.fireEvent('delete', { listItem: list.getItems()[0] });
  })()`);
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.ObjectHeader' && c.getNumber() === '4768'),
    'the total was not recomputed after the delete');

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
