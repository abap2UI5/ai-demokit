// the two-column start, the supplier drill-down and the end column
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  // this sample starts on two columns with the first product already shown
  await waitForUi5(page, () => {
    const fcl = ui5All().find((c) => c.getMetadata().getName() === 'sap.f.FlexibleColumnLayout');
    return fcl && fcl.getLayout() === 'TwoColumnsMidExpanded';
  }, 'the flexible column layout never started on two columns');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Text'
    && c.getText() === 'HT-1000'), 'the first product was not bound into the mid column');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Title'
    && c.getText() === 'Products (123)'), 'the master title never got its total count');
  // pressing a product opens the mid column
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const t = reg.find((c) => c.getId().endsWith('productsTable'));
    t.fireItemPress({ listItem: t.getItems()[0] });
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Text'
    && /^HT-/.test(c.getText() || '')), 'pressing a product never bound the mid column');
  // and a supplier opens the end column
  await page.waitForTimeout(1500);
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const t = reg.find((c) => c.getId().endsWith('suppliersTable'));
    t.fireItemPress({ listItem: t.getItems()[0] });
  });
  await waitForUi5(page, () => {
    const fcl = ui5All().find((c) => c.getMetadata().getName() === 'sap.f.FlexibleColumnLayout');
    return fcl && fcl.getLayout() === 'ThreeColumnsMidExpanded';
  }, 'pressing a supplier never opened the end column');
};
