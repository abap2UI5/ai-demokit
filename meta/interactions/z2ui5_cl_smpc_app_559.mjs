// the DynamicPage, the analytical table inside it and the card popover
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.f.DynamicPage'),
    'the DynamicPage never rendered');
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
    return t && t.getBinding('rows') && t.getBinding('rows').getLength() === 123;
  }, 'the analytical table never got its 123 bound rows');
  // rowMode="Auto" sizes the row count from the available height, and the
  // headless DynamicPage gives the table none - so only the column TEMPLATES
  // exist here and the per-cell values cannot be asserted. What can: the twelve
  // columns and the two ABAP-computed formatter fields reaching the model
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.ui.table.Column').length === 12,
    'the twelve columns never rendered');
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
    const row = t.getBinding('rows').getContexts(0, 1)[0].getObject();
    return ['Success', 'Error'].includes(row.AVAILABLESTATE)
      && ['sap-icon://accept', 'sap-icon://decline'].includes(row.AVAILABLEICON)
      && /^\d{4}-\d{2}-\d{2}$/.test(row.DELIVERYDATE);
  }, 'the backend-computed state, icon and delivery date never reached the rows');
  // the GenericTag opens the numeric card
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.GenericTag').firePress();
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.f.cards.NumericHeader'
    && c.getNumber() === '2.16'), 'the card popover never opened on the GenericTag');
};
