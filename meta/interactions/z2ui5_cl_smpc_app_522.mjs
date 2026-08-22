// the growing list and the refresh Button that re-reads the rows
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem' && c.getDomRef()).length === 10,
    'the growingThreshold=10 first page never rendered');
  await expect(page.locator('body'), 'the first row').toContainText('Notebook Basic 15');
  await page.locator('button[title], .sapMTB button').last().click();
  // the refresh re-seeds the same ten rows - the list survives the round-trip
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem' && c.getDomRef()).length === 10,
    'the refresh round-trip did not bring the rows back');
};
