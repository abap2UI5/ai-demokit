// the two rank-filtered tables and the moves between them
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Table').length === 2,
    'the available and selected tables never both rendered');
  // everything starts at rank 0, so the Available table holds it all
  await waitForUi5(page, () => {
    const avail = ui5All().find((c) => c.getId().endsWith('availableTable'));
    const sel = ui5All().find((c) => c.getId().endsWith('selectedTable'));
    return avail.getItems().length === 10 && sel.getItems().length === 0;
  }, 'the rank filters did not put every product in the Available table');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.ui.core.dnd.DragInfo').length === 2,
    'the drag configuration never reached both tables');
  // select a row and move it across
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const avail = reg.find((c) => c.getId().endsWith('availableTable'));
    avail.setSelectedItem(avail.getItems()[0], true, true);
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getTooltip() === 'Move to selected').firePress();
  });
  await waitForUi5(page, () => {
    const sel = ui5All().find((c) => c.getId().endsWith('selectedTable'));
    return sel && sel.getItems().length === 1;
  }, 'the move never re-ranked the row into the Selected table');
};
