// the shopping-cart wizard, its calcTotal sum and the row delete
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem').length > 0,
    'the cart rows never rendered');
  // both the wizard's cart and the review page bind the same five rows
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.ObjectHeader' && c.getNumber() === '5724'),
    'the calcTotal sum never reached the ObjectHeader');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.WizardStep').length === 8,
    'the eight wizard steps never rendered');
  // the Delete-mode list drops the row and the total is recomputed in ABAP
  await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const list = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.List' && c.getMode() === 'Delete');
    list.fireEvent('delete', { listItem: list.getItems()[0] });
  })()`);
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.ObjectHeader' && c.getNumber() === '4768'),
    'the total was not recomputed after the delete');
};
