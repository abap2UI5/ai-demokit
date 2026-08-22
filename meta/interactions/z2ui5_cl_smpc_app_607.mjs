// the two toolbars, the slider that shrinks them, and sort / group / reset
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Table');
    return t && t.getItems().length === 100;   // JSONModel sizeLimit
  }, 'the table never rendered its first hundred rows');

  // both toolbars take their width from the slider
  await waitForUi5(page, () => {
    const otb = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.OverflowToolbar');
    return otb.length === 2 && otb.every((o) => o.getWidth() === '100%');
  }, 'the two toolbars never took the slider width');
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Slider').setValue(50);
  });
  await waitForUi5(page, () => {
    const otb = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.OverflowToolbar');
    return otb.every((o) => o.getWidth() === '50%');
  }, 'the toolbars never followed the slider');

  // Sort flips the order in ABAP; the first row changes
  const firstOf = () => page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const t = reg.find((c) => c.getMetadata().getName() === 'sap.m.Table');
    return t.getItems()[0].getCells()[0].getTitle();
  });
  const before = await firstOf();
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.OverflowToolbarButton'
      && c.getTooltip() === 'Sort').firePress();
  });
  await page.waitForFunction((prev) => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const t = reg.find((c) => c.getMetadata().getName() === 'sap.m.Table');
    return t.getItems()[0].getCells()[0].getTitle() !== prev;
  }, before, { timeout: 15000 });
};
