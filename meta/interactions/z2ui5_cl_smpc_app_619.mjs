// the weight tabs filtering the table the backend sends, and the bar's responsive padding
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

// the bar's select is the only wire: it carries ${$parameters>/key} back and
// the backend re-sends the filtered table (app 298 idiom)
const selectKey = (key) => {
  const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
  const bar = reg.find((c) => c.getId().endsWith('idIconTabBar'));
  bar.setSelectedKey(key);
  bar.fireSelect({ key, selectedKey: key, item: bar.getItems().find((i) => i.getKey && i.getKey() === key) });
};

// a JSONModel's default sizeLimit is 100 and neither the sample nor the port
// raises it, so an unfiltered table renders 100 of the 123 rows
const rows = (n) => Math.min(n, 100);

export default async (page, expect) => {
  await waitForUi5(page, (n) => {
    const t = ui5All().find((c) => c.getId().endsWith('productsTable'));
    return t && t.getItems().length === n;
  }, 'the table never rendered its seeded rows', rows(123));
  // the responsive padding classes ride on the bar itself
  await waitForUi5(page, () => {
    const bar = ui5All().find((c) => c.getId().endsWith('idIconTabBar'));
    return bar && ['sapUiResponsivePadding--header', 'sapUiResponsivePadding--content']
      .every((c) => bar.hasStyleClass(c));
  }, 'the two responsive padding classes never reached the IconTabBar');

  for (const [key, n] of [['Ok', 57], ['Heavy', 45], ['Overweight', 21]]) {
    await page.evaluate(selectKey, key);
    await waitForUi5(page, (want) => {
      const t = ui5All().find((c) => c.getId().endsWith('productsTable'));
      return t && t.getItems().length === want;
    }, `the ${key} tab did not narrow the table to its ${rows(n)} rows`, rows(n));
  }
  // All puts every row back
  await page.evaluate(selectKey, 'All');
  await waitForUi5(page, (n) => {
    const t = ui5All().find((c) => c.getId().endsWith('productsTable'));
    return t && t.getItems().length === n;
  }, 'the All tab never cleared the filter', rows(123));
};
