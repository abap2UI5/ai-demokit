// the ShellBar's product switcher and the popover it opens
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.f.ShellBar'
    && c.getShowProductSwitcher() === true), 'the ShellBar never rendered with its product switcher');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Avatar'
    && c.getInitials() === 'UI'), 'the profile avatar never rendered');
  // the switcher press opens the popover, anchored on the button it ships
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const sb = reg.find((c) => c.getMetadata().getName() === 'sap.f.ShellBar');
    sb.fireEvent('productSwitcherPressed', { button: sb._oProductSwitcher || sb });
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.ResponsivePopover'),
    'the product-switch press never opened the popover');
  await waitForUi5(page, () => {
    const ps = ui5All().find((c) => c.getMetadata().getName() === 'sap.f.ProductSwitch');
    return ps && ps.getItems().length === 14;
  }, 'the fourteen product-switch items never reached the popover');
};
