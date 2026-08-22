// the middle-aligned rows, their inputs and the backend-computed weight state
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Table');
    return t && t.getItems().length === 123;
  }, 'the table never rendered its 123 bound rows');
  // the sorter in the items binding really orders by Name
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Table');
    const first = t.getItems()[0].getCells()[0];
    return first.getTitle() === '10" Portable DVD player';
  }, 'the items sorter never ordered the rows by Name');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.ColumnListItem'
    && c.getVAlign() === 'Middle'), 'the rows are not middle-aligned');
  // the Quantity Input keeps its defaults, the two dangling bindings being dropped
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Input'
    && c.getType() === 'Text' && c.getFieldWidth() === '50%'),
    'the Quantity Input did not fall back to the defaults the original also renders');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.ObjectNumber'
    && ['Success', 'Warning', 'Error', 'None'].includes(c.getState())),
    'the backend-computed weight state never reached an ObjectNumber');
};
