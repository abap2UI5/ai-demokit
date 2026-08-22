// the info-toolbar toggle over the shared bound flag, and one constant toast
//
// The page starts with the toolbar SHOWN and the button unpressed, as the
// original view does (it declares no pressed attribute); pressing the button
// hides it, because onToggleInfoToolbar sets visible = NOT pressed. The port
// seeded the flag the other way round until 2026-08-22.
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.OverflowToolbar' && c.getActive() === true && c.getVisible() === true),
    'the info toolbar never rendered visible');
  await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const b = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.ToggleButton' && c.getText() === 'Hide/Show InfoToolbar');
    b.setPressed(true);
    // setPressed alone changes the CONTROL, not the model: the wire is what
    // writes the shared flag, so the press has to be fired too
    b.firePress({ pressed: true });
    // setPressed alone changes the CONTROL, not the model: the wire is what
    // writes the shared flag, so the press has to be fired too
    b.firePress({ pressed: false });
  })()`);
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.OverflowToolbar' && c.getActive() === true && c.getVisible() === false),
    'the toggle never hid the info toolbar (expression over the shared flag)');
};
