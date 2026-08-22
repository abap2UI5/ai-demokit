// the DynamicPage, the analytical table inside it and the card popover
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.f.DynamicPage'),
    'the DynamicPage never rendered');
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
    return t && t.getBinding('rows') && t.getBinding('rows').getLength() === 123;
  }, 'the analytical table never got its 123 bound rows');
  // the two ABAP-computed formatters have to reach the row templates
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.ObjectStatus'
    && ['Success', 'Error'].includes(c.getState())), 'the availability state never reached an ObjectStatus');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.ui.core.Icon'
    && ['sap-icon://accept', 'sap-icon://decline'].includes(c.getSrc())),
    'the availability icon never reached the icon column');
  // the DatePicker parses the ISO delivery date the backend seeds
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.DatePicker'
    && c.getDateValue() instanceof Date), 'the seeded delivery date never parsed into a Date');
  // the GenericTag opens the numeric card
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.GenericTag').firePress();
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.f.cards.NumericHeader'
    && c.getNumber() === '2.16'), 'the card popover never opened on the GenericTag');
};
