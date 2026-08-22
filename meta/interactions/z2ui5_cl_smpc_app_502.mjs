// the anchored popover and the row selection moving the header
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const selector = page.locator('.sapMObjStatusTitleSelector, .sapUiIcon').first();
  await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const oh = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.ObjectHeader');
    oh.fireTitleSelectorPress({ domRef: oh.getDomRef() });
  })()`);
  await expect(page.locator('.sapMPopover'), 'the anchored popover').toContainText('Select Product');
};
