// the shared two-way field: StepInput value -> IconTabBar.maxNestingLevel
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => document.querySelectorAll('.sapMITBItem').length === 30,
    'the 30 bound tabs never rendered');
  await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    ui5All().find((c) => c.getMetadata().getName() === 'sap.m.StepInput').setValue(3);
  })()`);
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.IconTabBar' && c.getMaxNestingLevel() === 3),
    'the StepInput never reached IconTabBar.maxNestingLevel (shared two-way field)');
};
