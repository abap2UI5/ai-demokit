// the tree, its ten nodes and one reparenting drop
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Tree');
    return t && t.getMode() === 'MultiSelect' && t.getItems().length >= 2;
  }, 'the tree never rendered in MultiSelect');

  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.StandardTreeItem'
    && c.getTitle() === 'Node1'), 'Node1 never rendered');

  // drop Node2 onto Node1: the backend reparents and the tree redraws
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const dnd = reg.find((c) => c.getMetadata().getName() === 'sap.ui.core.dnd.DragDropInfo');
    const items = reg.filter((c) => c.getMetadata().getName() === 'sap.m.StandardTreeItem');
    const dragged = items.find((i) => i.getTitle() === 'Node2');
    const dropped = items.find((i) => i.getTitle() === 'Node1');
    dnd.fireEvent('drop', { draggedControl: dragged, droppedControl: dropped });
  });
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Tree');
    // Node2 is no longer a root, so the tree has one root left
    return t && t.getBinding('items').getModel().getProperty('/T_NODES').length === 1;
  }, 'the drop never reparented Node2 under Node1');

  // onDragStart vetoes a drag that starts OUTSIDE the current selection, and
  // the condition is decided per firing by prevent_default_expr. UI5's
  // fireEvent returns false when a handler called preventDefault, so the veto
  // is read from the firing itself rather than from an internal flag.
  const dragStart = (title) => page.evaluate((t) => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const dnd = reg.find((c) => c.getMetadata().getName() === 'sap.ui.core.dnd.DragDropInfo');
    const item = reg.filter((c) => c.getMetadata().getName() === 'sap.m.StandardTreeItem')
      .find((i) => i.getTitle() === t);
    return dnd.fireEvent('dragStart', { target: item }, true) === false;
  }, title);
  const titles = await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const tree = reg.find((c) => c.getMetadata().getName() === 'sap.m.Tree');
    return tree.getItems().map((i) => i.getTitle());
  });
  // nothing selected yet: the sample lets every row start a drag
  expect(await dragStart(titles[0]), 'a drag with no selection was vetoed').toBe(false);
  // select the first row, then start a drag on a DIFFERENT one - vetoed
  await page.evaluate((t) => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const tree = reg.find((c) => c.getMetadata().getName() === 'sap.m.Tree');
    tree.setSelectedItem(tree.getItems().find((i) => i.getTitle() === t), true);
  }, titles[0]);
  expect(await dragStart(titles[1]), 'a drag outside the selection was NOT vetoed').toBe(true);
  // the selected row itself still drags
  expect(await dragStart(titles[0]), 'a drag on the selected row was vetoed').toBe(false);
};
