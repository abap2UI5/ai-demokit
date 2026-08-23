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
};
