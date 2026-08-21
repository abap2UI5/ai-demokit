// Same nested-model claim as app 364, measured from the other starting state:
// this port carries numberOfExpandedLevels 1, so level 1 is already open on
// load and the assertion is that the level BELOW it is not — and that
// expanding a level-1 node reveals its own children. Asserting only "1.1 is
// visible" would pass on a flat list of the first two levels.
import { waitForUi5, ui5All, UI5_ALL_SRC, dispatchMouse } from '../../scripts/lib-e2e.mjs';

const descriptions = async (page) => page.evaluate(`(() => { ${UI5_ALL_SRC}
  const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.TreeTable');
  if (!t) return null;
  return t.getRows().map((r) => { const c = r.getBindingContext(); return c ? c.getProperty('DESCRIPTION') : null; })
    .filter((d) => d !== null && d !== undefined && d !== ''); })()`);

export default async (page, expect) => {
  await expect(page.locator('body'), 'the Description column').toContainText('Description');

  const start = await descriptions(page);
  if (!start) throw new Error('the TreeTable did not render');
  if (!(start.includes('1') && start.includes('1.1') && start.includes('1.2'))) {
    throw new Error(`numberOfExpandedLevels did not open the first level (rows carried ${JSON.stringify(start)})`);
  }
  if (start.includes('1.2.1')) throw new Error('the tree opened deeper than the one expanded level');

  // expanding a level-1 node reveals the level below it
  const idx = start.indexOf('1.2');
  await dispatchMouse(page.locator('.sapUiTableTreeIcon').nth(idx));
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.TreeTable');
    const d = t.getRows().map((r) => { const c = r.getBindingContext(); return c ? c.getProperty('DESCRIPTION') : null; });
    return d.includes('1.2.1') && d.includes('1.2.2');
  }, 'expanding the 1.2 node revealed no children — arrayNames did not nest below the expanded level');
};
