// the read-only template, the editable one it swaps to, and the Cancel rollback
//
// NOTE: every sap.m.Input builds an INTERNAL sap.m.Table for its suggestion
// popup, so a bare find() for sap.m.Table can return one of those once the
// editable template has been shown. Address the app's own table by its id.
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getId().endsWith('idProductsTable'));
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
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getId().endsWith('idProductsTable'));
    if (!t || t.getItems().length !== 10) return false;
    const cells = t.getItems()[0].getCells().map((c) => c.getMetadata().getName());
    return !cells.includes('sap.m.Input');
  }, 'Cancel never returned to the read-only template');
};
