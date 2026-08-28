// SinglePlanningCalendarDateSelection: the selectedDatesChange toast carries
// the WHOLE selectedDates array (a list of DateRange CONTROLS the frontend
// marshals into its public properties), which is what the client expression
// grammar could never do — it has no loop. A single range would not prove it,
// so two are handed over and both lines are asserted.
//
// The event is fired on the control rather than driven through the grid: a day
// header hit box in the SinglePlanningCalendar's week header measures zero
// unthemed headless, and the wire under test starts at the event, not at the
// gesture (same technique as apps 520/526).
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const toggle = page.locator('button[title="Enable multi-day selection"]').first();
  await expect(toggle, 'the multi-day selection ToggleButton').toBeVisibleEnabled();
  await toggle.click();
  // the round trip flips the bound dateSelectionMode AND the bound tooltip —
  // asserting only the tooltip would pass on a port that never told the control
  await waitForUi5(page, () => {
    const spc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.SinglePlanningCalendar');
    const btn = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.ToggleButton');
    return spc && spc.getDateSelectionMode() === 'MultiSelect'
      && btn && btn.getTooltip() === 'Disable multi-day selection';
  }, 'the toggle round-trip never reached dateSelectionMode / the tooltip');

  await page.waitForFunction(() => !window.z2ui5 || !window.z2ui5.isBusy);
  await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const DateRange = sap.ui.require('sap/ui/unified/DateRange');
    const spc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.SinglePlanningCalendar');
    // LOCAL midnight of two days — what the control itself puts in the
    // aggregation when a user picks them
    spc.fireEvent('selectedDatesChange', { selectedDates: [
      new DateRange({ startDate: new Date(2018, 6, 9) }),
      new DateRange({ startDate: new Date(2018, 6, 10) }),
    ] });
  })()`);

  const toast = page.locator('.sapMMessageToast').last();
  await expect(toast, 'the selectedDatesChange toast').toContainText('1: 2018-07-09');
  await expect(toast, 'the second marshalled DateRange').toContainText('2: 2018-07-10');
};
