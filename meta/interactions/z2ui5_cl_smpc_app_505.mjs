// the overlay on change and the supplier filter on the Filter button
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.Table' && c.getShowOverlay() === false),
    'the inlined table never rendered without the overlay');
  await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const cb = ui5All().find((c) => c.getId().endsWith('oComboBox'));
    // setSelectedKey writes the CONTROL; the bound field moves only when the
    // change event runs the wire, so both are needed
    cb.setSelectedKey('Titanium');
    cb.fireChange({ value: 'Titanium', selectedItem: cb.getSelectedItem() });
  })()`);
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.Table' && c.getShowOverlay() === true),
    'the change round-trip never switched the outdated overlay on');
};
