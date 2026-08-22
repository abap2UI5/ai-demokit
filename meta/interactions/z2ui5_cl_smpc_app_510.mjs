// the value-help dialog and the picked title written back into the Input
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Input').fireValueHelpRequest();
  })()`);
  await expect(page.locator('.sapMDialog'), 'the value help dialog').toContainText('Products');
  const item = page.locator('.sapMSLI').first();
  await expect(item, 'the first product').toBeVisibleEnabled();
  await item.click();
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.Input' && (c.getValue() || '').length > 0),
    'the picked title never reached the Input value');
};
