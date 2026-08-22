// the read-only template, the editable one it swaps to, and the Cancel rollback
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Table');
    return t && t.getItems().length === 10;
  }, 'the table never rendered its first growing page of 10 rows');
  // read-only first: ObjectIdentifiers in the cells, no Inputs
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.ObjectIdentifier')
    && !ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Input'),
    'the table did not start on the read-only template');
  await waitForUi5(page, () => ui5All().some((c) => c.getId().endsWith('saveButton') && c.getVisible() === false),
    'the Save button was visible outside edit mode');
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getId().endsWith('editButton')).firePress();
  });
  // edit mode: the cells are Inputs and the buttons swap
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Input').length > 0,
    'Edit never swapped in the editable template');
  await waitForUi5(page, () => ui5All().some((c) => c.getId().endsWith('editButton') && c.getVisible() === false)
    && ui5All().some((c) => c.getId().endsWith('cancelButton') && c.getVisible() === true),
    'the toolbar buttons never swapped for edit mode');
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getId().endsWith('cancelButton')).firePress();
  });
  await waitForUi5(page, () => !ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Input'),
    'Cancel never returned to the read-only template');
};
