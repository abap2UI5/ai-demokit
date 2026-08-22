// the edit-mode toggle, the veto it bakes into beforeNavigate, and the dialog
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const secs = ui5All().filter((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageSection');
    return secs.map((s) => s.getTitle()).join('|')
      === '2014 Goals Plan|Personal|Employment|Connections';
  }, 'the four sections never rendered');

  // Edit flips the mode and says so
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Edit').firePress();
  });
  await expect(page.locator('.sapMMessageToast').last(), 'the EDIT toast').toContainText('Edit mode enabled');

  // in edit mode the redrawn beforeNavigate wire vetoes, so a tab press raises
  // the dialog instead of navigating
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const opl = reg.find((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageLayout');
    const emp = reg.filter((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageSection')
      .find((s) => s.getTitle() === 'Employment');
    opl.fireEvent('beforeNavigate', { section: emp });
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Dialog'
    && c.getTitle() === 'Unsaved changes'), 'the veto never raised the confirm dialog');

  // OK closes it and lets the navigation through
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'OK').firePress();
  });
  await waitForUi5(page, () => !ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Dialog'),
    'the OK press never closed the dialog');
};
