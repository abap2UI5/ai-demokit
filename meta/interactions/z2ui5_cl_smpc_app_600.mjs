// the tree, its nodes, the drag-start veto and one reparenting drop
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Tree');
    return t && t.getMode() === 'MultiSelect' && t.getItems().length >= 2;
  }, 'the tree never rendered in MultiSelect');

  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.StandardTreeItem'
    && c.getTitle() === 'Node1'), 'Node1 never rendered');

  // onDragStart vetoes a drag that starts on a row OUTSIDE the current
  // selection, and the condition is decided per firing by prevent_default_expr.
  // UI5's fireEvent(..., bAllowPreventDefault) returns false when a handler
  // called preventDefault, so the veto is read from the firing itself rather
  // than from an internal flag.
  //
  // This runs BEFORE the drop: the drop reparents Node2 under Node1, and a
  // collapsed Node1 leaves the tree with a single item - the second title then
  // resolves to undefined and the firing carries no target at all, which reads
  // as "not vetoed" and blames the app for the test's own ordering.
  const dragStart = (title) => page.evaluate((t) => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const dnd = reg.find((c) => c.getMetadata().getName() === 'sap.ui.core.dnd.DragDropInfo');
    const tree = reg.find((c) => c.getMetadata().getName() === 'sap.m.Tree');
    const item = tree.getItems().find((i) => i.getTitle() === t);
    if (!item) throw new Error(`no tree item titled ${t}`);
    return dnd.fireEvent('dragStart', { target: item }, true) === false;
  }, title);
  // e2e-smoke's `expect` wraps a LOCATOR (toBeVisible/toContainText/...) - it
  // carries no value assertion, so the boolean is checked here directly
  const veto = async (title, want, msg) => {
    const got = await dragStart(title);
    if (got !== want) throw new Error(`${msg} (vetoed=${got})`);
  };
  const titles = await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const tree = reg.find((c) => c.getMetadata().getName() === 'sap.m.Tree');
    return tree.getItems().map((i) => i.getTitle());
  });
  // nothing selected yet: the sample lets every row start a drag
  await veto(titles[0], false, 'a drag with no selection was vetoed');
  // select the first row, then start a drag on a DIFFERENT one - vetoed
  await page.evaluate((t) => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const tree = reg.find((c) => c.getMetadata().getName() === 'sap.m.Tree');
    tree.setSelectedItem(tree.getItems().find((i) => i.getTitle() === t), true);
  }, titles[0]);
  await veto(titles[1], true, 'a drag outside the selection was NOT vetoed');
  // the selected row itself still drags
  await veto(titles[0], false, 'a drag on the selected row was vetoed');

  // Each veto probe is a real round trip - the wire fires DRAG_START whether or
  // not the default was prevented. An event dispatched while one is still in
  // flight is swallowed, which is why the drop below silently did nothing when
  // it followed the probes directly. Wait for the round trips to land: the
  // global BusyIndicator element is shown for the whole request and hidden
  // again when the response is applied.
  await page.waitForFunction(() => {
    const b = document.getElementById('sapUiBusyIndicator');
    return !b || getComputedStyle(b).visibility === 'hidden';
  }, null, { timeout: 15000 });

  // and the drop still reparents: Node2 onto Node1, the backend moves the node
  // and the tree redraws with one root left
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
    return t && t.getBinding('items').getModel().getProperty('/T_NODES').length === 1;
  }, 'the drop never reparented Node2 under Node1');
};
