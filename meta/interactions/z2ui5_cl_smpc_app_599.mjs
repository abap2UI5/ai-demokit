// the 10x86 matrix and the two toggles that write the bound layout properties
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const secs = ui5All().filter((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageSection');
    return secs.length === 10
      && secs.map((s) => s.getTitle()).join('|')
        === '2 blocks|3 blocks|4 blocks|5 blocks|6 blocks|All default|All 1|All 2|All 3|All 4';
  }, 'the ten sections never rendered');

  await waitForUi5(page, () => {
    const subs = ui5All().filter((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageSubSection');
    return subs.length === 86;
  }, 'the 86 subsections never rendered');

  // both layout properties start where the ConfigModel seeds them
  await waitForUi5(page, () => {
    const opl = ui5All().find((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageLayout');
    return opl && opl.getSubSectionLayout() === 'TitleOnTop'
      && opl.getUseTwoColumnsForLargeScreen() === false;
  }, 'the two bound layout properties did not start at their seeded values');

  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.ToggleButton'
      && c.getText() === 'Use Title on the Left').firePress();
  });
  await waitForUi5(page, () => {
    const opl = ui5All().find((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageLayout');
    return opl && opl.getSubSectionLayout() === 'TitleOnLeft';
  }, 'TOGGLE_TITLE never switched subSectionLayout');

  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.ToggleButton'
      && c.getText() === 'Use Two Columns Mode').firePress();
  });
  await waitForUi5(page, () => {
    const opl = ui5All().find((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageLayout');
    return opl && opl.getUseTwoColumnsForLargeScreen() === true;
  }, 'TOGGLE_TWO_COLUMNS never switched useTwoColumnsForLargeScreen');
};
