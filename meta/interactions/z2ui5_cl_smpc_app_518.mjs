// the feedback Dialog the active ObjectAttribute opens and its submit path
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await expect(page.locator('body'), 'the ObjectHeader record seeded at the model root').toContainText('Notebook Basic 15');
  await page.locator('.sapMObjectAttributeActive:has-text("Provide feedback")').first().click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Dialog'),
    'the active attribute never opened the feedback dialog (popup_display)');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.RatingIndicator'),
    'the feedback dialog rendered without its RatingIndicator');
  await page.locator('.sapMDialog button:has-text("Submit")').first().click();
  await expect(page.locator('.sapMMessageToast'), 'the submit toast').toContainText('Feedback sent.');
};
