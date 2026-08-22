// the shared two-way field: StepInput value -> IconTabBar.maxNestingLevel
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  // 31 DOM items for 30 bound tabs: the IconTabBar renders an overflow item
  // of its own next to them (measured 2026-08-22), so the bar's own items
  // aggregation is what says 30.
  await waitForUi5(page, () => {
    const bar = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.IconTabBar');
    return bar && bar.getItems().length === 30;
  }, 'the 30 bound tabs never rendered');
  await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const si = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.StepInput');
    si.setValue(3);
    // setValue alone changes the CONTROL, not the bound model — fire the
    // change so the two-way binding writes the shared field
    si.fireChange({ value: 3 });
  })()`);
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.IconTabBar' && c.getMaxNestingLevel() === 3),
    'the StepInput never reached IconTabBar.maxNestingLevel (shared two-way field)');
};
