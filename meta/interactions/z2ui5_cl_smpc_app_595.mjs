// the page opens on the payment subsection, and the sorted table is there
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const secs = ui5All().filter((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageSection');
    return secs.map((s) => s.getTitle()).join('|')
      === '2014 Goals Plan|Personal|Employment|Table information';
  }, 'the four sections never rendered');

  // selectedSection names a SUBSECTION id; the association resolves it to the
  // section that owns it, which is what opens the page on Personal
  await waitForUi5(page, () => {
    const opl = ui5All().find((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageLayout');
    if (!opl) return false;
    const sel = sap.ui.require('sap/ui/core/Element').getElementById(opl.getSelectedSection());
    return !!sel && sel.getTitle() === 'Personal';
  }, 'the page did not open on the Personal section');

  await waitForUi5(page, () => {
    const sub = ui5All().filter((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageSubSection')
      .find((s) => s.getTitle() === 'Payment information');
    return sub && sub.getMode() === 'Expanded';
  }, 'the payment subsection never came up Expanded');

  // the ui:Table carries the four columns and the rows in Name order
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
    if (!t) return false;
    const cols = t.getColumns().map((c) => c.getLabel().getText ? c.getLabel().getText() : c.getLabel());
    return cols.join(',') === 'Product,Supplier,Category,Price';
  }, 'the ui:Table never got its four columns');

  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
    const ctx = t && t.getBinding('rows') && t.getBinding('rows').getContexts(0, 1)[0];
    return !!ctx && ctx.getObject().PRODUCTID === 'HT-2001';
  }, 'the table rows never arrived in Name order');
};
