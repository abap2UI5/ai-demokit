// the ShellBar over the three columns, and the two drill-downs
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const fcl = ui5All().find((c) => c.getMetadata().getName() === 'sap.f.FlexibleColumnLayout');
    return fcl && fcl.getLayout() === 'OneColumn';
  }, 'the flexible column layout never started on one column');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Title'
    && c.getText() === 'Products (123)'), 'the master title never got its total count');
  // the ShellBar is the page's custom header, and its back button only shows
  // while the end column is full screen
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.f.ShellBar'
    && c.getNotificationsNumber() === '2' && c.getShowNavButton() === false),
    'the ShellBar never rendered with its nav button hidden');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.MenuItem').length === 2,
    'the ShellBar menu never rendered its two items');
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
