// the drill-down through suppliers and categories, and the order selection
//
// NOTE: sap.m.Breadcrumbs builds an INTERNAL sap.m.Link of its own (an empty
// `__link0`, alongside the app's `…breadcrumb-0`), so counting sap.m.Link over
// the whole registry is always one too many. Ask the Breadcrumbs control for
// its own `links` aggregation instead — same lesson as every sap.m.Input
// building an internal suggestion-popup sap.m.Table (2026-08-22).
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  // level 1: the four suppliers, single-select, the two detail columns hidden
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Table');
    return t && t.getItems().length === 4 && t.getMode() === 'SingleSelectMaster';
  }, 'the table never rendered the four suppliers in single-select mode');
  await waitForUi5(page, () => ui5All().some((c) => c.getId().endsWith('weightColumn') && c.getVisible() === false),
    'the Weight column was visible above the leaf level');
  await waitForUi5(page, (n) => {
    const bc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Breadcrumbs');
    return bc && bc.getLinks().length === n;
  }, 'the breadcrumb did not start with the single Suppliers link', 1);
  // drill into the first supplier
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const t = reg.find((c) => c.getMetadata().getName() === 'sap.m.Table');
    t.setSelectedItem(t.getItems()[0], true, true);
  });
  await waitForUi5(page, (n) => {
    const bc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Breadcrumbs');
    return bc && bc.getLinks().length === n;
  }, 'drilling into a supplier never added a breadcrumb link', 2);
  // and into its first category - now the leaf level
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const t = reg.find((c) => c.getMetadata().getName() === 'sap.m.Table');
    t.setSelectedItem(t.getItems()[0], true, true);
  });
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Table');
    return t && t.getMode() === 'MultiSelect';
  }, 'the leaf level never switched the table to MultiSelect');
  await waitForUi5(page, () => ui5All().some((c) => c.getId().endsWith('weightColumn') && c.getVisible() === true),
    'the Weight column stayed hidden on the leaf level');
  // selecting a product feeds the order count and enables the footer button
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const t = reg.find((c) => c.getMetadata().getName() === 'sap.m.Table');
    t.setSelectedItem(t.getItems()[0], true, true);
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Button'
    && c.getText() === 'Order' && c.getEnabled() === true),
    'selecting a product never enabled the Order button');
};
