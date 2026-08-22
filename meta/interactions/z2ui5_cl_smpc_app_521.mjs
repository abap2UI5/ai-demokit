// the value-help SelectDialog and the picked title landing in the Input
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await page.locator('.sapMInputValHelp .sapMInputValHelpInner, .sapMInputValueHelpIcon').first().click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.SelectDialog'),
    'the valueHelpRequest never opened the SelectDialog (popup_display)');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem' && c.getDomRef()).length > 0,
    'the SelectDialog rendered without its product rows');
  await page.locator('.sapMDialog .sapMSLI').first().click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Input' && c.getValue() === 'Notebook Basic 15'),
    'the picked title never reached the Input (onValueHelpClose)');
};
