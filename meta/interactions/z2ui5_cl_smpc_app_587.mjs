// the three section titles the anchor bar renders, numbers included
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await expect(page.locator('.sapUxAPObjectPageHeaderTitle'), 'the header identifier').toContainText('Denise Smith');

  // the numbers in the titles are the sample's point - the anchor bar just
  // renders the title it is given
  await waitForUi5(page, () => {
    const secs = ui5All().filter((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageSection');
    return secs.map((s) => s.getTitle()).join('|') === '2014 Goals Plan|Personal (2)|Employment (3)';
  }, 'the three section titles never rendered with their numbers');

  // TitleOnLeft is what this sample sets where app 401 leaves the default
  await waitForUi5(page, () => {
    const opl = ui5All().find((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageLayout');
    return opl && opl.getSubSectionLayout() === 'TitleOnLeft' && opl.getUpperCaseAnchorBar() === false;
  }, 'the ObjectPageLayout never took subSectionLayout TitleOnLeft');

  // the inlined blocks: the goals form is the first section's only block
  await expect(page.locator('.sapUiForm').first(), 'the inlined GoalsBlock form')
    .toContainText('Evangelize the UI framework across the company');
};
