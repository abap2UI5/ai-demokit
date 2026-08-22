// the one bound tabDensityMode behind eight bars, and the ninth that has none
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

const BOUND = ['idIconTabBar0', 'idIconTabBar1', 'idIconTabBar2', 'idIconTabBar3',
  'idIconTabBar4', 'idIconTabBar5', 'idIconTabBar6', 'idIconTabBar7'];

const pickDensity = (index) => {
  const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
  const g = reg.find((c) => c.getMetadata().getName() === 'sap.m.RadioButtonGroup');
  g.setSelectedIndex(index);
  g.fireSelect({ selectedIndex: index });
};

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All()
    .filter((c) => c.getMetadata().getName() === 'sap.m.IconTabBar').length === 9,
    'the nine IconTabBars never rendered');
  // the seeded enum is the group's own first button — never an empty string
  await waitForUi5(page, (ids) => ids.every((id) => {
    const bar = ui5All().find((c) => c.getId().endsWith(id));
    return bar && bar.getTabDensityMode() === 'Cozy';
  }), 'the eight bound bars never came up on the seeded Cozy density', BOUND);
  // one round trip moves all eight; the ninth binds nothing and stays put
  for (const [index, mode] of [[1, 'Compact'], [2, 'Inherit'], [0, 'Cozy']]) {
    await page.evaluate(pickDensity, index);
    await waitForUi5(page, (arg) => arg.ids.every((id) => {
      const bar = ui5All().find((c) => c.getId().endsWith(id));
      return bar && bar.getTabDensityMode() === arg.mode;
    }), `the ${mode} radio button never reached the eight bound bars`, { ids: BOUND, mode });
    await waitForUi5(page, () => {
      const inline = ui5All().find((c) => c.getId().endsWith('iconTabBarInlineIcons'));
      return inline && inline.getTabDensityMode() === 'Cozy';
    }, 'the ninth bar followed the density although it binds none of it');
  }
};
