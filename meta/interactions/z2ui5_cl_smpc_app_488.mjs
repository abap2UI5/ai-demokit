// the press wire marking exactly one row navigated in the backend
//
// NOTE: a click on `.sapMListTblRow` does not reach the item's own press
// handling in the unthemed harness (measured 2026-08-22: no row came back
// navigated). Fire the item's press through the registry, and address the
// BOUND rows only — the aggregation template sits in the registry too, which
// is what makes the row count 101 for 100 rendered rows.
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Table');
    return t && t.getItems().length === 100;
  }, 'the table never rendered its bound rows');
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const t = reg.find((c) => c.getMetadata().getName() === 'sap.m.Table');
    t.getItems()[0].firePress();
  });
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Table');
    return t && t.getItems().filter((i) => i.getNavigated()).length === 1;
  }, 'the press round-trip never marked exactly one row navigated');
};
