// the ToggleButton pressed state rebuilds the view with the contextMenu subtree
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.Tree' && !c.getContextMenu()),
    'the Tree never rendered without a context menu (the toggle starts off)');
  // the toggle sits in the Tree's OverflowToolbar header and folds into the
  // overflow popover here - and the overflow trigger is itself a ToggleButton,
  // so a DOM locator cannot tell them apart. Press the real one through the
  // registry, with the pressed parameter the wire reads
  await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const b = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.ToggleButton'
      && c.getTooltip() === 'Enable / Disable Custom Context Menu');
    b.setPressed(true);
    b.firePress({ pressed: true });
  })()`);
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.Tree' && !!c.getContextMenu()),
    'the pressed toggle never brought back a view carrying the contextMenu subtree');
};
