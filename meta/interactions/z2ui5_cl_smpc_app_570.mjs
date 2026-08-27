// the read-only template, the editable one it swaps to, and the Cancel rollback
// — plus the PRICE_TEXT string mirror that keeps a typed price from being
// silently discarded (2026-08-26).
//
// NOTE: every sap.m.Input builds an INTERNAL sap.m.Table for its suggestion
// popup, so a bare find() for sap.m.Table can return one of those once the
// editable template has been shown. Address the app's own table by its id.
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

const REG = `Object.values(sap.ui.require('sap/ui/core/Element').registry.all())`;
export default async (page, expect) => {
  const fire = (id) => page.evaluate(([r, i]) => eval(r).find((c) => c.getId().endsWith(i)).firePress(), [REG, id]);
  const row0 = () => page.evaluate((r) => {
    const t = eval(r).find((c) => c.getId().endsWith('idProductsTable'));
    const it = t.getItems()[0];
    return {
      cells: it.getCells().map((c) => c.getMetadata().getName()),
      price: it.getBindingContext().getObject().PRICE,
      priceText: it.getBindingContext().getObject().PRICE_TEXT,
      priceId: it.getCells()[3].getId(),
    };
  }, REG);
  const editable = () => waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getId().endsWith('idProductsTable'));
    if (!t || !t.getItems().length) return false;
    const c = t.getItems()[0].getCells()[3];
    return c && c.getMetadata().getName() === 'sap.m.Input' && c.getDomRef();
  }, 'the editable template never appeared');
  const readOnly = (msg) => waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getId().endsWith('idProductsTable'));
    if (!t || !t.getItems().length) return false;
    return t.getItems()[0].getCells()[3].getMetadata().getName() === 'sap.m.ObjectNumber';
  }, msg);

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
  await fire('editButton');
  // edit mode: the cells are Inputs and the buttons swap
  await editable();
  await waitForUi5(page, () => ui5All().some((c) => c.getId().endsWith('editButton') && c.getVisible() === false)
    && ui5All().some((c) => c.getId().endsWith('cancelButton') && c.getVisible() === true),
    'the toolbar buttons never swapped for edit mode');
  await fire('cancelButton');
  await readOnly('Cancel never returned to the read-only template');

  /* ---- the string mirror ------------------------------------------------
   * PRICE is packed for the read-only Currency binding, so the editable cell
   * binds the PRICE_TEXT mirror. Before it existed the cell bound {PRICE} and
   * the write-back died in delta_apply_field's `CATCH cx_root ##NO_HANDLER`
   * ("skip just this cell"): a price the user typed as 1,250.00 was dropped
   * with no error, no toast and no valueState, and a cleared cell or a lone
   * `-` silently became 0.00. Both legs below fail on that old behaviour —
   * the first because Save exited edit mode and raised no toast, the second
   * because the mirror is what carries a good value home. */
  await fire('editButton');
  await editable();
  const bad = await row0();
  await page.locator(`#${bad.priceId}-inner`).fill('1,250.00');
  await page.keyboard.press('Tab');
  await fire('saveButton');
  await expect(page.locator('.sapMMessageToast'), 'the rejected-price toast').toContainText('Not a number');
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getId().endsWith('idProductsTable'));
    if (!t || !t.getItems().length) return false;
    return t.getItems()[0].getCells()[3].getMetadata().getName() === 'sap.m.Input';
  }, 'Save left edit mode although the typed price was not a number — the entry was discarded');
  const kept = await row0();
  if (Number(kept.price) !== Number(bad.price)) {
    throw new Error(`the rejected price changed the model: ${bad.price} -> ${kept.price}`);
  }
  if (!String(kept.priceText).includes(String(Math.trunc(Number(bad.price))))) {
    throw new Error(`the rejected cell was not restored from the packed price: ${kept.priceText}`);
  }

  // a value that DOES convert still goes home and reaches the Currency binding
  const good = await row0();
  await page.locator(`#${good.priceId}-inner`).fill('1250.00');
  await page.keyboard.press('Tab');
  await fire('saveButton');
  await readOnly('Save never returned to the read-only template for a valid price');
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getId().endsWith('idProductsTable'));
    if (!t || !t.getItems().length) return false;
    return Number(t.getItems()[0].getBindingContext().getObject().PRICE) === 1250;
  }, 'a valid typed price never reached the backend');
};
