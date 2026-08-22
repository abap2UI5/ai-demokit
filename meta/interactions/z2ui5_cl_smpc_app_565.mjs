// the popover's NavContainer: the product list and the detail page behind it
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Open Popover'),
    'the opening button never rendered');
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Open Popover').firePress();
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Popover'),
    'the popover never opened');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.NavContainer'),
    'the popover opened without its NavContainer');
  // the items come from the AGGREGATION: a bound aggregation's template is a
  // live Element too, so the registry holds one item more than the model has
  await waitForUi5(page, () => {
    const list = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.List');
    // 100, not 123: a JSONModel's default sizeLimit is 100 and neither the
    // sample nor the port raises it, so the original renders 100 rows too
    return list && list.getItems().length === 100;
  }, 'the bound product list never reached the master page');
  // pressing a row folds that product into the detail fields and navigates
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const list = reg.find((c) => c.getMetadata().getName() === 'sap.m.List');
    list.getItems()[0].firePress();
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.ObjectHeader'
    && c.getTitle() === 'Notebook Basic 15'), 'the pressed row never reached the detail page');
};
