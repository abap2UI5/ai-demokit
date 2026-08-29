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
  // the recurrence stack reaches the calendar
  // through the calendar's own aggregation: the BOUND appointments binding
  // keeps a live template in the registry too, so a registry-wide count is one
  // too many (measured 2026-08-22).
  await waitForUi5(page, () => {
    const spc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.SinglePlanningCalendar');
    return spc && spc.getAppointments().length === 9
      && spc.getAppointments().every((a) => a.getMetadata().getName() === 'sap.ui.unified.RecurringCalendarAppointment');
  }, 'the nine recurring appointments never rendered');
  // the Create Appointment button sits in the calendar's own toolbar and may be
  // in the overflow area, so it is fired through the registry
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && (c.getText() || '') === 'Create Appointment').firePress();
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Dialog'),
    'the Create Appointment press never opened the dialog (popup_display)');
  // saving the dialog with NO recurrence is the regression this step exists for.
  // `recurrencePattern` defaults to 1 and its setter REJECTS anything below it,
  // the original leaves the property off a non-recurring appointment, and an
  // ABAP structure cannot leave a field out - so the initial 0 used to reach the
  // setter and terminate the app on the very next render (2026-08-29, found on
  // app 548, which builds its new appointment the same way).
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && (c.getText() || '') === 'Create').firePress();
  });
  await waitForUi5(page, () => {
    const spc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.SinglePlanningCalendar');
    const appts = spc && spc.getAppointments();
    return appts && appts.length === 10 && appts.every((a) => a.getRecurrencePattern() >= 1);
  }, 'the appointment created without a recurrence never reached the calendar - recurrencePattern below 1 terminates the app');
};
