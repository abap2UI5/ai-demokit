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
  // the rows come from the AGGREGATION: a bound aggregation's template is a live
  // Element too, so the registry always holds one row more than the model has
  await waitForUi5(page, () => {
    const pc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.PlanningCalendar');
    return pc.getRows().length === 2;
  }, 'the two calendar rows never rendered');
  // the three roles drive the per-row enable flags through one expression; the
  // Select starts on admin, which may modify every row
  await waitForUi5(page, () => {
    const pc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.PlanningCalendar');
    return pc.getRows().every((r) => r.getEnableAppointmentsDragAndDrop() === true
      && r.getEnableAppointmentsResize() === true && r.getEnableAppointmentsCreate() === true);
  }, 'the admin role never enabled drag and drop on every row');
};
