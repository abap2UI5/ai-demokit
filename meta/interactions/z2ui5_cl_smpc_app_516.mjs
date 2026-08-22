// the SegmentedButton row and the ViewSettingsDialog the Button opens
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await expect(page.locator('.sapMSegB'), 'the SegmentedButton row').toBeVisible();
  await page.locator('button:has-text("Open View Settings Dialog")').first().click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.ViewSettingsDialog'),
    'the press never reached the ViewSettingsDialog (popup_display)');
  // the fragment's three tabs carry the sample's items
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.ViewSettingsItem').length >= 6,
    'the dialog rendered without its sort/group items');
};
