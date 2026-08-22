// the four column header menus and the state their entries drive
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Table');
        // 100, not 123: a JSONModel's default sizeLimit is 100 and neither the
    // sample nor the port raises it, so the original renders 100 rows too
    return t && t.getItems().length === 100;
  }, 'the table never rendered its bound rows');
  // four of the five columns carry a header menu
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.table.columnmenu.Menu').length === 4,
    'the four column menus never rendered');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Column'
    && c.getHeaderMenu()).length === 4, 'the headerMenu association did not reach four columns');
  await waitForUi5(page, () => ui5All().some((c) => c.getId().endsWith('product') && c.getSortIndicator() === 'None'),
    'the Product column did not start without a sort indicator');
  // the price quick action sorts and moves the indicator to that column
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Sort Ascending').firePress();
  });
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Table');
    const first = t.getItems()[0].getCells()[0];
    return first.getTitle() === 'Flyer';
  }, 'Sort Ascending never re-ordered the rows by price');
  // and the align entries reach the Dimensions column
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Align Left').firePress();
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Column'
    && c.getHAlign() === 'Left'), 'Align Left never reached the Dimensions column');
};
