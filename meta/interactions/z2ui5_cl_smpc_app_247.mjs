// the width-switch round-trip: the SegmentedButton sits in an
// OverflowToolbar, so the overflow popover is opened first (2026-08-01)
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const more = page.getByRole('button', { name: 'Additional Options' }).first();
  await expect(more, 'the overflow button').toBeVisibleEnabled();
  await more.click();
  // an overflowed SegmentedButton renders as a Select in the popover
  const sel = page.locator('.sapMPopover .sapMSlt').first();
  await expect(sel, 'the width SegmentedButton (a Select in the overflow)').toBeVisibleEnabled();
  await sel.click();
  await page.locator('.sapMSltPicker').getByText('Flexible', { exact: true }).first().click();
  await waitForUi5(page, () => {
    const cols = ui5All().filter((c) => c.getMetadata().getName() === 'sap.ui.table.Column');
    return cols.some((c) => c.getWidth() === '25%');
  }, 'the WIDTHS_CHANGE round-trip never re-sized the columns');

  // The per-column veto (2026-08-06, s_ctrl-prevent_default_expr). A column
  // resize is a drag on an internal resizer, so the event is fired through
  // the control's own API instead - which still runs the port's WIRE, the
  // thing under test. ONE wire, two columns, opposite outcomes: the
  // delivery-date column must be vetoed (fireColumnResize returns false) and
  // any other column must go through.
  const fireResize = (blocked) => page.evaluate((wantBlocked) => {
    const all = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const table = all.find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
    const cols = table.getColumns();
    const target = cols.find((c) => (c.getId().indexOf('deliverydate') >= 0) === wantBlocked);
    return table.fireColumnResize({ column: target, width: '100px' });
  }, blocked);

  // each firing round-trips (eBP always sends), so they are driven one at a
  // time - two back-to-back would collide with the busy guard
  if (await fireResize(true) !== false) {
    throw new Error('the delivery-date column was NOT vetoed - prevent_default_expr did not apply per firing');
  }
  await page.waitForTimeout(2000);
  if (await fireResize(false) !== true) {
    throw new Error('a non-delivery-date column was vetoed too - the veto is not per column');
  }
  // the non-vetoed one reports, with the column LABEL the reduction had dropped
  await expect(page.locator('.sapMMessageToast'), 'the resize toast of the non-vetoed column')
    .toContainText('was resized to');
};
