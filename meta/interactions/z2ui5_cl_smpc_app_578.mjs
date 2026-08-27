// the categories start page, the BEGIN-column swap and the two drill-downs.
//
// A registry read proves a control was BUILT and BOUND, never that it reached
// the screen: a FlexibleColumnLayout renders only the CURRENT page of each
// column, so the products table answers its eleven rows just as happily while
// the begin column is still showing the categories. This module asserted
// exactly that until 2026-08-27, which is why it stayed green for weeks while
// the begin-column navigation had never worked once - measured that day, the
// press left `getCurrentBeginColumnPage()` on `categoriesPage`, the products
// DynamicPage without a DOM node, and only a UI5 warning behind
// ("Navigation triggered to page with ID 'mainView--dynamicPageId', but this
// page is not known/aggregated by ... #mainView--fcl-endColumnNav"). The cause
// was a framework cast, not the port: `to` was declared ["controlId", …] so it
// reached sap.f.FlexibleColumnLayout.to as a Control, and that method probes
// its three columns with `getPage( sPageId )`, which a Control never equals -
// so every probe missed and the trailing `else` navigated the END column.
// So every leg below that claims something is ON SCREEN carries the rendered
// filter, and the swap is asserted on the column the `to` is aimed at.
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const fcl = ui5All().find((c) => !c.bIsDestroyed && c.getMetadata().getName() === 'sap.f.FlexibleColumnLayout');
    return Boolean(fcl && fcl.getLayout() === 'OneColumn');
  }, 'the flexible column layout never started on one column');
  // the begin column starts on the categories page - rendered, not merely bound
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => !c.bIsDestroyed && c.getId().endsWith('categoriesTable'));
    return Boolean(t && t.getItems().length === 16
      && t.getDomRef() && document.body.contains(t.getDomRef()));
  }, 'the sixteen categories never rendered on the start page');
  // pressing a category swaps the begin column and opens the mid one
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const t = reg.find((c) => c.getId().endsWith('categoriesTable'));
    t.fireItemPress({ listItem: t.getItems()[4] });
  });
  await waitForUi5(page, () => {
    const fcl = ui5All().find((c) => !c.bIsDestroyed && c.getMetadata().getName() === 'sap.f.FlexibleColumnLayout');
    return Boolean(fcl && fcl.getLayout() === 'TwoColumnsMidExpanded');
  }, 'pressing a category never opened the mid column');
  // THE leg the port's single control_by_id `to` exists for: the sample's
  // router puts its Detail view into beginColumnPages, so the products page has
  // to become the one the BEGIN column shows. A `to` that moves any other
  // column leaves the categories on screen and says nothing about it.
  await waitForUi5(page, () => {
    const fcl = ui5All().find((c) => !c.bIsDestroyed && c.getMetadata().getName() === 'sap.f.FlexibleColumnLayout');
    const cur = fcl && fcl.getCurrentBeginColumnPage();
    return Boolean(cur && cur.getId().endsWith('dynamicPageId')
      && cur.getDomRef() && document.body.contains(cur.getDomRef()));
  }, 'the `to` never moved the BEGIN column onto the products page - the categories page is still the one it shows');
  // the products page shows only the pressed category's rows (index 4 = Laptops)
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => !c.bIsDestroyed && c.getId().endsWith('productsTable'));
    return Boolean(t && t.getItems().length === 11
      && t.getDomRef() && document.body.contains(t.getDomRef()));
  }, 'the eleven Laptops rows never rendered in the begin column');
  // and a supplier opens the end column
  await page.waitForTimeout(1500);
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const t = reg.find((c) => c.getId().endsWith('suppliersTable'));
    t.fireItemPress({ listItem: t.getItems()[0] });
  });
  await waitForUi5(page, () => {
    const fcl = ui5All().find((c) => !c.bIsDestroyed && c.getMetadata().getName() === 'sap.f.FlexibleColumnLayout');
    return Boolean(fcl && fcl.getLayout() === 'ThreeColumnsMidExpanded');
  }, 'pressing a supplier never opened the end column');
};
