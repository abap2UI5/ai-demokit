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
};
