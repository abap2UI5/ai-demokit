// the weight tabs filtering the table the backend sends, and the process look of the bar
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
  // the process look: three Horizontal filters with a separator between each pair
  await waitForUi5(page, () => {
    const bar = ui5All().find((c) => c.getId().endsWith('idIconTabBar'));
    if (!bar || bar.getItems().length !== 5) return false;
    const filters = bar.getItems().filter((i) => i.getMetadata().getName() === 'sap.m.IconTabFilter');
    const seps = bar.getItems().filter((i) => i.getMetadata().getName() === 'sap.m.IconTabSeparator');
    return filters.length === 3 && seps.length === 2
      && filters.every((f) => f.getDesign() === 'Horizontal')
      && seps.every((s) => s.getIcon() === 'sap-icon://open-command-field');
  }, 'the three Horizontal filters and their two icon separators never rendered');
  // the counts are the sample's composed '{Ok} of {Total}' strings
  await waitForUi5(page, () => {
    const bar = ui5All().find((c) => c.getId().endsWith('idIconTabBar'));
    return bar && bar.getItems().filter((i) => i.getCount && i.getCount())
      .map((i) => i.getCount()).join('|') === '53 of 123|51 of 123|19 of 123';
  }, 'the composed tab counts never reached the three filters');

  for (const [key, n] of [['Ok', 57], ['Heavy', 45], ['Overweight', 21]]) {
    await page.evaluate(selectKey, key);
    await waitForUi5(page, (want) => {
      const t = ui5All().find((c) => c.getId().endsWith('productsTable'));
      return t && t.getItems().length === want;
    }, `the ${key} tab did not narrow the table to its ${rows(n)} rows`, rows(n));
  }
};
