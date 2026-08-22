// the dialog, its two forms, and the message popover the Save button fills
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Button'
    && c.getText() === 'Open Dialog With Message Popover'), 'the opening button never rendered');
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button'
      && c.getText() === 'Open Dialog With Message Popover').firePress();
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Dialog'),
    'the dialog never opened');
  // eight personal forms plus the employment one come from the two bound VBoxes
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.ui.layout.form.SimpleForm').length >= 9,
    'the dialog opened without the bound forms');
  // the message button is invisible while the message model is empty
  await waitForUi5(page, () => ui5All().some((c) => c.getId().endsWith('messagePopoverBtn') && c.getVisible() === false),
    'the message button was visible with no messages');
  // Save injects the four demo issues and the button turns red with a count
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Save').firePress();
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getId().endsWith('messagePopoverBtn')
    && c.getVisible() === true && c.getType() === 'Negative' && c.getText() === '3'),
    'Save never produced the three errors the button should count');
};
