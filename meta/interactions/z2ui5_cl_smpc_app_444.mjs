// the load round-trip filling the bound items aggregation
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  // the group's action button lives in the notification group header, which
  // folds its buttons into an overflow menu at this viewport - press the
  // control itself through the registry instead of guessing at the DOM
  await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const b = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText && c.getText() === 'Load notifications');
    if (b) { b.firePress(); }
  })()`);
  await waitForUi5(page, () => document.querySelectorAll('.sapMNLI').length > 0,
    'the load round-trip never filled the bound items aggregation');
};
