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
  // the To Detail action opens the mid column, the close button shuts it again.
  // The sample builds its semantic helper with maxColumnsCount: 1, and
  // getNextUIState(1) short-circuits to MidColumnFullScreen in that case
  // (FlexibleColumnLayoutSemanticHelper.js:338) - so the port's toDetail sets
  // MidColumnFullScreen, NOT TwoColumnsMidExpanded. Hiding the begin column is
  // the point: the return to OneColumn is then a begin-column resize from zero
  // width, which is the event the sample exists to demonstrate.
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'To Detail').firePress();
  });
  await waitForUi5(page, () => {
    const fcl = ui5All().find((c) => c.getMetadata().getName() === 'sap.f.FlexibleColumnLayout');
    return fcl && fcl.getLayout() === 'MidColumnFullScreen';
  }, 'To Detail never opened the mid column full screen');
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getTooltip() === 'Close column').firePress();
  });
  await waitForUi5(page, () => {
    const fcl = ui5All().find((c) => c.getMetadata().getName() === 'sap.f.FlexibleColumnLayout');
    return fcl && fcl.getLayout() === 'OneColumn';
  }, 'the close button never closed the mid column');
};
