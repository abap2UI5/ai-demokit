// the info-toolbar toggle over the shared bound flag, and one constant toast
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.OverflowToolbar' && c.getActive() === true && c.getVisible() === true),
    'the info toolbar never rendered visible');
  await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const b = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.ToggleButton' && c.getText() === 'Hide/Show InfoToolbar');
    b.setPressed(false);
  })()`);
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.OverflowToolbar' && c.getActive() === true && c.getVisible() === false),
    'the toggle never reached the info toolbar visibility (expression over the shared flag)');
};
