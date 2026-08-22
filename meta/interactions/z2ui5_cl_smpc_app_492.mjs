// the ToggleButton pressed state rebuilds the view with the contextMenu subtree
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.List' && !c.getContextMenu()),
    'the List never rendered without a context menu (the toggle starts off)');
  // the toggle folds into the header OverflowToolbar, whose own trigger is a
  // ToggleButton too - press the real one through the registry
  await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const b = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.ToggleButton'
      && c.getTooltip() === 'Enable / Disable Custom Context Menu');
    b.setPressed(true);
    b.firePress({ pressed: true });
  })()`);
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.List' && !!c.getContextMenu()),
    'the pressed toggle never brought back a view carrying the contextMenu subtree');
};
