// the ten grid items and the drag-and-drop reorder over the order table
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.f.GridContainer').length === 1,
    'the GridContainer never rendered');
  await waitForUi5(page, () => ui5All().find((c) => c.getMetadata().getName() === 'sap.f.GridContainer').getItems().length === 10,
    'the ten grid children never rendered');
  // the three rebuilt cards carry the manifests' own headers
  await expect(page.locator('body'), 'the rebuilt card headers').toContainText('Contacts');
  await expect(page.locator('body'), 'the rebuilt card headers').toContainText('Tasks');
  // the drop wire moves the first item behind the second
  await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const grid = ui5All().find((c) => c.getMetadata().getName() === 'sap.f.GridContainer');
    const cfg = grid.getDragDropConfig().find((c) => c.getMetadata().getName() === 'sap.f.dnd.GridDropInfo');
    cfg.fireEvent('drop', { draggedControl: grid.getItems()[0], droppedControl: grid.getItems()[1], dropPosition: 'After' });
  })()`);
  await waitForUi5(page, () => {
    const grid = ui5All().find((c) => c.getMetadata().getName() === 'sap.f.GridContainer');
    return grid.getItems()[0].getHeader && grid.getItems()[0].getHeader() === 'Manage Activity Master Data Type';
  }, 'the drop round-trip never reordered the grid items');
};
