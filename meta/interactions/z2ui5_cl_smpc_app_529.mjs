// the semantic action bar, the bound table and the footer toggle
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await expect(page.locator('body'), 'the title heading').toContainText('Products List');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.ColumnListItem' && c.getDomRef()).length > 0,
    'the product rows never rendered');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.f.semantic.SemanticPage' && c.getShowFooter() === true),
    'the semantic page did not boot with its footer shown');
  await page.locator('button:has-text("ToggleFooter")').first().click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.f.semantic.SemanticPage' && c.getShowFooter() === false),
    'the ToggleFooter press never reached showFooter');
};
