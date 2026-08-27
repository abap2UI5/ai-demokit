// prevent-default itemClose + MessageBox.confirm + bound-row removal
// (2026-07-30 audit fix), the tab NAME in the box and the row count after OK
// (2026-08-26), and the SALARY write-back the close round trip carries.
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

const REG = `Object.values(sap.ui.require('sap/ui/core/Element').registry.all())`;
const rows = (page) => page.evaluate((r) => {
  const tc = eval(r).find((c) => c.getMetadata().getName() === 'sap.m.TabContainer');
  const ins = eval(r).filter((c) => c.getMetadata().getName() === 'sap.m.Input' && c.getDomRef());
  return {
    model: tc.getModel().getProperty('/T_EMPLOYEES'),
    names: tc.getItems().map((i) => i.getName()),
    salaryId: (ins.find((c) => c.getBindingPath('value') === 'SALARY') || {}).sId,
    salary: (ins.find((c) => c.getBindingPath('value') === 'SALARY') || { getValue: () => null }).getValue(),
  };
}, REG);

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Input').length >= 3,
    'the selected tab never rendered its three Inputs');
  const start = await rows(page);
  if (start.model.length !== 4) throw new Error(`expected 4 employee rows, got ${start.model.length}`);

  /* ---- SALARY is a string, not a packed field ---------------------------
   * The original binds `{salary}` into a plain Input over a JSONModel, which
   * holds whatever the user types. While the port typed SALARY as `p LENGTH 8
   * DECIMALS 2` the write-back died in delta_apply_field's
   * `CATCH cx_root ##NO_HANDLER` ("skip just this cell"): an entry like
   * 1,455.22 was dropped with no error while the browser went on showing it.
   * Typing it and then taking the app's ONLY round trip (the tab close) is
   * what exposes that — this leg fails on the packed field. */
  const typed = '1,455.22';
  const salaryId = await page.evaluate((r) => eval(r)
    .filter((c) => c.getMetadata().getName() === 'sap.m.Input' && c.getDomRef())
    .find((c) => c.getBindingPath('value') === 'SALARY').getId(), REG);
  await page.locator(`#${salaryId}-inner`).fill(typed);
  await page.keyboard.press('Tab');

  // the only round trip the app has: close the LAST tab, so the edited row 0 survives
  const closes = page.locator('.sapMTSItemCloseBtnCnt button');
  await closes.last().waitFor({ state: 'attached', timeout: 10000 });
  await closes.last().click({ force: true });
  const dialog = page.locator('.sapMMessageBox');
  await expect(dialog, 'the close-confirm MessageBox').toContainText('Do you want to close the tab');
  // the NAME travels over the eBP wire — assert it, not just the static prefix
  await expect(dialog, 'the closed tab name in the MessageBox').toContainText(start.names[start.names.length - 1]);
  await page.getByRole('button', { name: 'OK', exact: true }).first().click();
  await expect(page.locator('.sapMMessageToast'), 'the closed toast').toContainText('Item closed:');

  // the transported index really removed THAT row
  await waitForUi5(page, () => {
    const tc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.TabContainer');
    return tc && tc.getItems().length === 3;
  }, 'OK never removed the tab row');
  const after = await rows(page);
  if (after.names.includes(start.names[start.names.length - 1])) {
    throw new Error(`the wrong row was removed — ${start.names[start.names.length - 1]} is still there`);
  }
  if (after.salary !== typed) {
    throw new Error(`the typed salary was discarded by the round trip: typed ${typed}, got ${after.salary}`);
  }
};
