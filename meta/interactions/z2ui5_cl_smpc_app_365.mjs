// The two control_by_id wires — collapseAll, and expandToLevel with its
// numeric argument. The numeric argument is the interesting half: it is a
// listed CONTROL_METHODS entry, so the deviation is about whether the `1`
// actually reaches the method, and the only way to see that is the level the
// tree ends up on. Expand first, then collapse, so each button is measured
// against a state the other one produced.
import { waitForUi5, ui5All, UI5_ALL_SRC } from '../../scripts/lib-e2e.mjs';

const names = async (page) => page.evaluate(`(() => { ${UI5_ALL_SRC}
  const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.TreeTable');
  if (!t) return null;
  return t.getRows().map((r) => { const c = r.getBindingContext(); return c ? c.getProperty('NAME') : null; })
    .filter(Boolean); })()`);

export default async (page, expect) => {
  await expect(page.locator('body'), 'the toolbar title').toContainText('Clothing');
  const roots = await names(page);
  if (!roots) throw new Error('the TreeTable did not render');
  if (!roots.includes('Women')) throw new Error(`the roots did not render (rows carried ${JSON.stringify(roots)})`);

  // expandToLevel( 1 ) — one level down, so the roots' children appear
  await page.getByRole('button', { name: 'Expand first level', exact: true }).first().click();
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.TreeTable');
    const n = t.getRows().map((r) => { const c = r.getBindingContext(); return c ? c.getProperty('NAME') : null; });
    return n.includes('Jewelry') && n.includes('Handbags');
  }, 'expandToLevel did not open the first level — the numeric argument did not reach the method');

  // ...and only ONE level: the grandchildren stay closed
  const level1 = await names(page);
  if (level1.includes('Dresses')) {
    throw new Error('expandToLevel opened more than the one level its argument asked for');
  }

  await page.getByRole('button', { name: 'Collapse all', exact: true }).first().click();
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.TreeTable');
    const n = t.getRows().map((r) => { const c = r.getBindingContext(); return c ? c.getProperty('NAME') : null; });
    return n.includes('Women') && !n.includes('Jewelry');
  }, 'collapseAll did not close the tree back to its roots');
};
