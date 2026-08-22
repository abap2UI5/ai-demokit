// the wizard dialog, its footer switching on the step index and the cancel box
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await page.locator('button:has-text("Open Wizard in Dialog")').first().click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Wizard'),
    'the press never opened the wizard dialog (popup_display)');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.WizardStep').length === 5,
    'the wizard rendered without its five steps');
  // step 0: Next visible, Previous / Review / Finish not
  await waitForUi5(page, () => {
    const byText = (t) => ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === t);
    return byText('Next Step').getVisible() === true && byText('Previous Step').getVisible() === false
      && byText('Review').getVisible() === false && byText('Finish').getVisible() === false;
  }, 'the footer did not switch on the seeded step index 0');
  await page.locator('.sapMDialog button:has-text("Cancel")').first().click();
  await expect(page.locator('.sapMMessageBox'), 'the cancel message box').toContainText('Are you sure you want to cancel your report?');
};
