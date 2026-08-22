// the flexible column layout, its master table and the detail column
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const fcl = ui5All().find((c) => c.getMetadata().getName() === 'sap.f.FlexibleColumnLayout');
    return fcl && fcl.getLayout() === 'OneColumn';
  }, 'the flexible column layout never started on one column');
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getId().endsWith('productsTable'));
    return t && t.getItems().length > 0;
  }, 'the master table never rendered its rows');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Title'
    && c.getText() === 'Products (123)'), 'the master title never got its total count');
  // pressing a row folds that product into the detail column and opens it
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const t = reg.find((c) => c.getId().endsWith('productsTable'));
    t.getItems()[0].firePress();
  });
  await waitForUi5(page, () => {
    const fcl = ui5All().find((c) => c.getMetadata().getName() === 'sap.f.FlexibleColumnLayout');
    return fcl && fcl.getLayout() === 'TwoColumnsMidExpanded';
  }, 'pressing a row never opened the mid column');
  // the folded detail fields reach the object page's form
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Label' && c.getText() === 'Product ID')
    && ui5All().some((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageLayout'),
    'the detail column stayed empty');
  // the close button is only offered while a mid column is open
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.OverflowToolbarButton'
    && c.getTooltip() === 'Close column' && c.getVisible() === true),
    'the close-column button never appeared');
};
