// the four column header menus and the state their entries drive
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getId().endsWith('productsTable'));
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
    const t = ui5All().find((c) => c.getId().endsWith('productsTable'));
    const first = t.getItems()[0].getCells()[0];
    return first.getTitle() === 'Flyer';
  }, 'Sort Ascending never re-ordered the rows by price');
  // Sorting WHILE GROUPED — the path that was never driven, and the reason a
  // grouper that overruled every ABAP sort survived here. Upstream each action
  // passes a ONE-element list to oBinding.sort( ), which replaces the grouper,
  // so sorting by price must drop the grouping and put Flyer (the cheapest)
  // first. With the grouper still declared, the rebuilt JSONListBinding
  // re-applies SUPPLIERNAME as the primary key and some other row leads.
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.table.columnmenu.ActionItem'
      && c.getLabel() === 'Toggle Grouping').firePress();
  });
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getId().endsWith('productsTable'));
    return t && t.getBinding('items') && t.getBinding('items').isGrouped();
  }, 'Toggle Grouping never put a grouper on the items binding');
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Sort Ascending').firePress();
  });
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getId().endsWith('productsTable'));
    const b = t && t.getBinding('items');
    return b && !b.isGrouped() && t.getItems()[0].getCells()[0].getTitle() === 'Flyer';
  }, 'sorting by price while grouped did not drop the grouper and lead with Flyer');

  // and the align entries reach the Dimensions column
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Align Left').firePress();
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Column'
    && c.getHAlign() === 'Left'), 'Align Left never reached the Dimensions column');
};
