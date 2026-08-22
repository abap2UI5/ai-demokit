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
};
