// the ViewSettingsDialog the Button opens, and the segmented button UI5 draws
// inside it
//
// NOTE: despite the sample's name there is no sap.m.SegmentedButton in either
// the view or the fragment — the segmented control is the VSD's OWN header,
// which UI5 renders only once the dialog is open. Asserting `.sapMSegB` on the
// initial page can never pass; it went unnoticed because the assertion used a
// matcher this harness does not have (`toBeVisible`), so it threw before it
// ran (found 2026-08-22, when the matcher was added).
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await expect(page.locator('button:has-text("Open View Settings Dialog")'), 'the opening Button')
    .toBeVisibleEnabled();
  await page.locator('button:has-text("Open View Settings Dialog")').first().click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.ViewSettingsDialog'),
    'the press never reached the ViewSettingsDialog (popup_display)');
  // the fragment's three tabs carry the sample's items
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.ViewSettingsItem').length >= 6,
    'the dialog rendered without its sort/group items');
  await waitForUi5(page, () => {
    const d = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.ViewSettingsDialog');
    return d && d.getSortItems().length === 3 && d.getGroupItems().length === 3
      && d.getFilterItems().length === 3;
  }, 'the dialog did not get all three sort, group and filter groups');
  // the sample's subject: the dialog's own segmented header
  await expect(page.locator('.sapMSegB'), 'the ViewSettingsDialog segmented header').toBeVisible();
};
