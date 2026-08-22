// the three dialogs and the box they are meant to stay inside
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Button').length >= 3,
    'the three dialog buttons never rendered');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.HBox' && c.getId().endsWith('withinArea')),
    'the within-area box never rendered');
  // the default dialog: title, the product list, and an OK plus a Close button
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Dialog').firePress();
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Dialog'
    && c.getTitle() === 'Available Products'), 'the default dialog never opened');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem').length > 10,
    'the dialog opened without the bound product list');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'OK'),
    'the default dialog has no OK button');
};
