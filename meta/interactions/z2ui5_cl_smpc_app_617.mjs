// the weight tabs filtering the table the backend sends, and the two radio groups folding into the bar's two bound
// BackgroundDesign enums
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
  // both enums are seeded from the groups' own first button — never empty
  await waitForUi5(page, () => {
    const bar = ui5All().find((c) => c.getId().endsWith('idIconTabBar'));
    return bar && bar.getBackgroundDesign() === 'Solid' && bar.getHeaderBackgroundDesign() === 'Solid';
  }, 'the seeded BackgroundDesign enums never reached the IconTabBar');

  for (const [key, n] of [['Ok', 46], ['Heavy', 45], ['Overweight', 21]]) {
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
  // the two radio groups fold into the bar's two bound enums
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const g = reg.filter((c) => c.getMetadata().getName() === 'sap.m.RadioButtonGroup')[0];
    g.setSelectedIndex(2);
    g.fireSelect({ selectedIndex: 2 });
  });
  await waitForUi5(page, () => {
    const bar = ui5All().find((c) => c.getId().endsWith('idIconTabBar'));
    return bar && bar.getBackgroundDesign() === 'Translucent';
  }, 'the background design group never repainted the bar');
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const g = reg.filter((c) => c.getMetadata().getName() === 'sap.m.RadioButtonGroup')[1];
    g.setSelectedIndex(1);
    g.fireSelect({ selectedIndex: 1 });
  });
  await waitForUi5(page, () => {
    const bar = ui5All().find((c) => c.getId().endsWith('idIconTabBar'));
    return bar && bar.getHeaderBackgroundDesign() === 'Transparent'
      && bar.getBackgroundDesign() === 'Translucent';
  }, 'the header background design group never repainted the header');
};
