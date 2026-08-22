// the three columns, the two drill-downs and the column-distribution sizes
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const fcl = ui5All().find((c) => c.getMetadata().getName() === 'sap.f.FlexibleColumnLayout');
    return fcl && fcl.getLayout() === 'OneColumn';
  }, 'the flexible column layout never started on one column');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Title'
    && c.getText() === 'Products (123)'), 'the master title never got its total count');
  // the seeded column sizes reach the layout data
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.f.FlexibleColumnLayoutDataForDesktop'
    && c.getTwoColumnsMidExpanded() === '25/75/0'), 'the desktop column sizes never reached the layout data');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.f.FlexibleColumnLayoutDataForTablet'
    && c.getThreeColumnsMidExpanded() === '20/60/20'), 'the tablet column sizes never reached the layout data');
  // pressing a product opens the mid column
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const t = reg.find((c) => c.getId().endsWith('productsTable'));
    t.fireItemPress({ listItem: t.getItems()[0] });
  });
  await waitForUi5(page, () => {
    const fcl = ui5All().find((c) => c.getMetadata().getName() === 'sap.f.FlexibleColumnLayout');
    return fcl && fcl.getLayout() === 'TwoColumnsMidExpanded';
  }, 'pressing a product never opened the mid column');
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
