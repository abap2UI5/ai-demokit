// the SinglePlanningCalendar and its bound appointments
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.SinglePlanningCalendar'),
    'the SinglePlanningCalendar never rendered');
  // the ISO strings really reach the calendar as Dates through the formatter
  await waitForUi5(page, () => {
    const spc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.SinglePlanningCalendar');
    return spc.getStartDate() instanceof Date && !isNaN(spc.getStartDate().getTime());
  }, 'Formatter.DateCreateObject never turned the seeded ISO string into a Date');
  await waitForUi5(page, () => ui5All().filter((c) => /CalendarAppointment/.test(c.getMetadata().getName()))
    .filter((c) => c.getStartDate() instanceof Date).length > 0,
    'no appointment reached the calendar with a real start date');
  // the three toolbar toggles share their flag with the calendar
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.SinglePlanningCalendar'
    && c.getEnableAppointmentsDragAndDrop() === true && c.getEnableAppointmentsResize() === true),
    'the seeded action flags never reached the calendar');
  // the Create button sits in the calendar's own toolbar and may be in the
  // overflow area, so it is fired through the registry
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && /Create/.test(c.getText() || '')).firePress();
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Dialog'),
    'the Create press never opened the modify dialog (popup_display)');

  // all four pickers share ONE ISO string; the pinned valueFormat
  // (yyyy-MM-dd'T'HH:mm:ss) is what lets both pairs read it. Unpinned, a
  // DatePicker cannot parse an ISO datetime at all and showed the raw
  // "2018-07-09T09:00:00" with no date value (headless probe, 2026-08-26)
  await waitForUi5(page, () => {
    const byName = (n) => ui5All().filter((c) => c.getMetadata().getName() === n);
    const dated = (c) => { const d = c.getDateValue(); return d instanceof Date && !isNaN(d.getTime()); };
    const dtp = byName('sap.m.DateTimePicker'), dp = byName('sap.m.DatePicker');
    return dtp.length === 2 && dp.length === 2 && dtp.every(dated) && dp.every(dated);
  }, 'the modify dialog pickers never parsed the bound ISO value (valueFormat)');

  // handleCheckBoxSelect zeroes both times (_setHoursToZero) — without the
  // ALL_DAY wire an "all-day" appointment was saved as 09:00-10:00
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const cb = reg.find((c) => c.getMetadata().getName() === 'sap.m.CheckBox'
      && c.getText() === 'All-day' && c.getEnabled());
    cb.setSelected(true);
    cb.fireSelect({ selected: true });
  });
  await waitForUi5(page, () => {
    const dp = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.DatePicker');
    return dp.length === 2 && dp.every((c) => /T00:00:00$/.test(c.getValue()));
  }, 'ticking All-day never rewrote the two times to midnight (ALL_DAY)');
};
