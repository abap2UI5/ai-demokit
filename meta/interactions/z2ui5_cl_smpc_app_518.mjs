// the feedback Dialog the active ObjectAttribute opens and its submit path
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await expect(page.locator('body'), 'the ObjectHeader record seeded at the model root').toContainText('Notebook Basic 15');
  // a DOM click on the attribute does not reach the control's own press
  // handling in the unthemed harness — fire it through the registry
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.filter((c) => c.getMetadata().getName() === 'sap.m.ObjectAttribute')
      .find((c) => c.getActive() && /feedback/i.test(c.getText() || ''))
      .firePress();
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Dialog'),
    'the active attribute never opened the feedback dialog (popup_display)');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.RatingIndicator'),
    'the feedback dialog rendered without its RatingIndicator');
  await page.locator('.sapMDialog button:has-text("Submit")').first().click();
  await expect(page.locator('.sapMMessageToast'), 'the submit toast').toContainText('Feedback sent.');
};
