// the flexible column layout, the bound sections and the detail column
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const fcl = ui5All().find((c) => c.getMetadata().getName() === 'sap.f.FlexibleColumnLayout');
    return fcl && fcl.getLayout() === 'OneColumn';
  }, 'the flexible column layout never started on one column');
  // the sections come from the AGGREGATION: a bound aggregation's template is a
  // live Element too, so the registry holds one section more than the model has
  await waitForUi5(page, () => {
    const op = ui5All().find((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageLayout');
    return op && op.getSections().length === 12;
  }, 'the twelve bound sections never reached the object page');
  await waitForUi5(page, () => {
    const op = ui5All().find((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageLayout');
    return op.getSections()[0].getTitle() === 'Section 0';
  }, 'the section titles never came from the model');
  // the To Detail action opens the mid column, the close button shuts it again
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'To Detail').firePress();
  });
  await waitForUi5(page, () => {
    const fcl = ui5All().find((c) => c.getMetadata().getName() === 'sap.f.FlexibleColumnLayout');
    return fcl && fcl.getLayout() === 'TwoColumnsMidExpanded';
  }, 'To Detail never opened the mid column');
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getTooltip() === 'Close column').firePress();
  });
  await waitForUi5(page, () => {
    const fcl = ui5All().find((c) => c.getMetadata().getName() === 'sap.f.FlexibleColumnLayout');
    return fcl && fcl.getLayout() === 'OneColumn';
  }, 'the close button never closed the mid column');
};
