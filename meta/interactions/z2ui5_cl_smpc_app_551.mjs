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
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.ui.unified.CalendarAppointment')
    .filter((c) => c.getStartDate() instanceof Date).length > 0,
    'no appointment reached the calendar with a real start date');
  // firstDayOfWeek is an int property fed from the Select's string key
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.SinglePlanningCalendar'
    && c.getFirstDayOfWeek() === -1), 'the first-day-of-week key never reached the calendar as an int');
};
