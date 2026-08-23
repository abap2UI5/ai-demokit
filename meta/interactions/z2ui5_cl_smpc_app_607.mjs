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

  // Group hands a Sorter with group:true to the LIVE binding, so UI5 draws a
  // grey SupplierName header above each block - the sample's _fnGroup result,
  // reproduced by UI5's default group function. Before the rework the port
  // only re-sorted the ABAP table and no header existed at all.
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.OverflowToolbarButton'
      && c.getTooltip() === 'Group').firePress();
  });
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Table');
    const heads = t.getItems().filter((i) => i.getMetadata().getName() === 'sap.m.GroupHeaderListItem');
    // one header per supplier block, and each carries the supplier's own name
    return heads.length > 1 && heads.every((h) => typeof h.getTitle() === 'string' && h.getTitle().length > 0);
  }, 'Group never produced the supplier group headers');
  // Reset takes them away again. It is a plain sap.m.Button carrying only a
  // text - Sort and Group are OverflowToolbarButtons with a tooltip, and
  // looking Reset up the same way found nothing and fired on undefined.
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button'
      && c.getText() === 'Reset').firePress();
  });
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Table');
    return t.getItems().every((i) => i.getMetadata().getName() !== 'sap.m.GroupHeaderListItem');
  }, 'Reset never cleared the group headers');
};
