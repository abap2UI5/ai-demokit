// the List and the GridContainer, and one row dragged from the List into the grid
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem' && c.getDomRef()).length === 3,
    'the List never rendered its three rows');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.f.Card' && c.getDomRef()).length === 3,
    'the GridContainer never rendered its three cards');
  await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const grid = ui5All().find((c) => c.getMetadata().getName() === 'sap.f.GridContainer');
    const list = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.List');
    const cfg = grid.getDragDropConfig().find((c) => c.getMetadata().getName() === 'sap.f.dnd.GridDropInfo');
    cfg.fireEvent('drop', { draggedControl: list.getItems()[0], droppedControl: grid.getItems()[0], dropPosition: 'Before' });
  })()`);
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem' && c.getDomRef()).length === 2
    && ui5All().filter((c) => c.getMetadata().getName() === 'sap.f.Card' && c.getDomRef()).length === 4,
    'the row never moved from the List into the grid');
};
