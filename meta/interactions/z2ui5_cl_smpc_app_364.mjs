// The nested model plus arrayNames has to produce the same EXPANDABLE tree the
// OData tree binding produces upstream. A render assertion alone cannot show
// that: a flat list of the three roots renders identically to a collapsed
// tree. So the module expands a node and asserts the children the model hangs
// underneath it actually appear — that is what "tree binding" means here.
//
// The expand icon is an icon-font glyph with no layout box of its own in the
// unthemed harness (measured 0x17), so it cannot be clicked — and a lone
// dispatched 'click' is not enough either: the table's pointer extension acts
// on the mousedown/mouseup pair. dispatchMouse sends the whole sequence.
import { waitForUi5, ui5All, UI5_ALL_SRC, dispatchMouse } from '../../scripts/lib-e2e.mjs';

const descriptions = async (page) => page.evaluate(`(() => { ${UI5_ALL_SRC}
  const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.TreeTable');
  if (!t) return null;
  return t.getRows().map((r) => { const c = r.getBindingContext(); return c ? c.getProperty('DESCRIPTION') : null; })
    .filter((d) => d !== null && d !== undefined && d !== ''); })()`);

export default async (page, expect) => {
  await expect(page.locator('body'), 'the Description column').toContainText('Description');

  // with no numberOfExpandedLevels the tree opens collapsed on its three roots
  const roots = await descriptions(page);
  if (!roots) throw new Error('the TreeTable did not render');
  if (!(roots.includes('1') && roots.includes('2') && roots.includes('3'))) {
    throw new Error(`the three roots did not render (rows carried ${JSON.stringify(roots)})`);
  }
  if (roots.includes('1.1')) throw new Error('the tree rendered expanded — the collapsed roots are the starting state');

  // expanding the first root has to reveal the children the model nests in it
  await dispatchMouse(page.locator('.sapUiTableTreeIcon').first());
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.TreeTable');
    const d = t.getRows().map((r) => { const c = r.getBindingContext(); return c ? c.getProperty('DESCRIPTION') : null; });
    return d.includes('1.1') && d.includes('1.2');
  }, 'expanding the first root revealed no children — arrayNames did not build a tree');
};
