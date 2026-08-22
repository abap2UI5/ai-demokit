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
  // only the three BUILT-IN views survive the custom-view classes
  // only the three BUILT-IN views survive the custom-view classes (the control
  // also keeps internal instances of them, so the check is on the distinct set)
  await waitForUi5(page, () => {
    const names = new Set(ui5All().map((c) => c.getMetadata().getName())
      .filter((n) => /^sap\.m\.SinglePlanningCalendar\w*View$/.test(n)));
    return names.size === 3 && names.has('sap.m.SinglePlanningCalendarDayView')
      && names.has('sap.m.SinglePlanningCalendarWorkWeekView')
      && names.has('sap.m.SinglePlanningCalendarWeekView');
  }, 'the three built-in views never rendered');
};
