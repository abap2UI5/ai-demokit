// the shopping-cart wizard, its total and the row delete
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem' && c.getDomRef()).length === 5,
    'the five cart rows never rendered');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.ObjectHeader' && c.getNumber() === '5724.00'),
    'the calcTotal sum never reached the ObjectHeader');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.WizardStep').length === 8,
    'the eight wizard steps never rendered');
  await page.locator('.sapMLIBDel, .sapMListModeDelete .sapMLIBImgNav').first().click();
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem' && c.getDomRef()).length === 4,
    'the delete round-trip never removed the row');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.ObjectHeader' && c.getNumber() === '4768.00'),
    'the total was not recomputed after the delete');
};
