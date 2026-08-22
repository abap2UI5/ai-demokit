// the categories start page, the begin-column swap and the two drill-downs
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const fcl = ui5All().find((c) => c.getMetadata().getName() === 'sap.f.FlexibleColumnLayout');
    return fcl && fcl.getLayout() === 'OneColumn';
  }, 'the flexible column layout never started on one column');
  // the begin column starts on the categories page
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getId().endsWith('categoriesTable'));
    return t && t.getItems().length === 16;
  }, 'the sixteen categories never reached the start page');
  // pressing a category swaps the begin column and opens the mid one
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const t = reg.find((c) => c.getId().endsWith('categoriesTable'));
    t.fireItemPress({ listItem: t.getItems()[4] });
  });
  await waitForUi5(page, () => {
    const fcl = ui5All().find((c) => c.getMetadata().getName() === 'sap.f.FlexibleColumnLayout');
    return fcl && fcl.getLayout() === 'TwoColumnsMidExpanded';
  }, 'pressing a category never opened the mid column');
  // the products page shows only the pressed category's rows (index 4 = Laptops)
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getId().endsWith('productsTable'));
    return t && t.getItems().length === 11;
  }, 'the products page never got the eleven Laptops rows');
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
