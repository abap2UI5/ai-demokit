// the shared two-way bound mode field: Select.selectedKey -> Tree.mode
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.Tree' && c.getMode() === 'MultiSelect'),
    'the Tree never rendered in the seeded MultiSelect mode');
  // the Select sits in the Tree's OverflowToolbar header and folds into the
  // overflow popover here, where a click on its list entry does not land - so
  // the selection is made on the control itself. setSelectedKey writes through
  // the TWO-WAY binding, which is exactly the wire this port replaces the
  // controller's setMode( ) with
  await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const s = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Select');
    s.setSelectedKey('SingleSelectLeft');
  })()`);
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.Tree' && c.getMode() === 'SingleSelectLeft'),
    'the Select never reached Tree.mode (shared two-way field)');
};
