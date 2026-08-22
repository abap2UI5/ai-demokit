// the ten-character name constraint, the e-mail check and the two Submit outcomes
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

const setInput = (arg) => {
  const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
  const inp = reg.find((c) => c.getId().endsWith(arg.id));
  inp.setValue(arg.value);
  inp.fireChange({ value: arg.value });
};

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const n = ui5All().find((c) => c.getId().endsWith('nameInput'));
    const e = ui5All().find((c) => c.getId().endsWith('emailInput'));
    return n && e && n.getValueState() === 'None' && e.getValueState() === 'None'
      && e.getType() === 'Email';
  }, 'the two Inputs never came up on a clean value state');
  // over ten characters: the backend paints the Error state on the change wire
  await page.evaluate(setInput, { id: 'nameInput', value: 'Maximiliane von Habsburg' });
  await waitForUi5(page, () => {
    const n = ui5All().find((c) => c.getId().endsWith('nameInput'));
    return n && n.getValueState() === 'Error'
      && n.getValueStateText() === 'Name must not be empty. Maximum 10 characters.';
  }, 'a name over ten characters never painted the Error state');
  // Submit with a bad name and an empty e-mail: the MessageBox, not the toast
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Submit').firePress();
  });
  await expect(page.locator('.sapMDialog'), 'the failed-validation MessageBox')
    .toContainText('A validation error has occurred. Complete your input first.');
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const dlg = reg.find((c) => c.getMetadata().getName() === 'sap.m.Dialog' && c.isOpen());
    dlg.getButtons()[0].firePress();
  });
  // a name inside the bound constraint and a valid address clear both states
  await page.evaluate(setInput, { id: 'nameInput', value: 'Ada' });
  await page.evaluate(setInput, { id: 'emailInput', value: 'ada@example.com' });
  await waitForUi5(page, () => {
    const n = ui5All().find((c) => c.getId().endsWith('nameInput'));
    return n && n.getValueState() === 'None';
  }, 'a name inside the constraint never cleared the Error state');
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Submit').firePress();
  });
  await expect(page.locator('.sapMMessageToast'), 'the submitted-form toast')
    .toContainText('The input is validated. Your form has been submitted.');
};
