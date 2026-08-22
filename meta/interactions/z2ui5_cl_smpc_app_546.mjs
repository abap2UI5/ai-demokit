// the PlanningCalendar rows and their bound appointments
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.PlanningCalendar'),
    'the PlanningCalendar never rendered');
  // the ISO strings really reach the calendar as Dates through the formatter
  await waitForUi5(page, () => {
    const pc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.PlanningCalendar');
    return pc.getStartDate() instanceof Date && !isNaN(pc.getStartDate().getTime());
  }, 'Formatter.DateCreateObject never turned the seeded ISO string into a Date');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.PlanningCalendarRow').length === 3,
    'the three calendar rows never rendered');
  // the three roles drive the per-row enable flags through one expression
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.PlanningCalendarRow')
    .every((c) => c.getEnableAppointmentsDragAndDrop() === true),
    'the admin role never enabled drag and drop on every row');
};
