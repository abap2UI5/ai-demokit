// the Delete mode wire - the deleted row leaves the bound table
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem' && c.getDomRef()).length > 0,
    'the product rows never rendered');
  await expect(page.locator('body'), 'the first row').toContainText('Notebook Basic 15');
  await page.locator('.sapMLIBDel, .sapMListModeDelete .sapMLIBImgNav').first().click();
  await waitForUi5(page, () => !ui5All().some((c) => c.getMetadata().getName() === 'sap.m.StandardListItem'
    && c.getDomRef() && c.getTitle() === 'Notebook Basic 15'),
    'the deleted row never left the bound table');
};
