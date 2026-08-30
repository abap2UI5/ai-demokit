// the PlanningCalendar rows and their bound appointments//
// NOTE: the calendar controls keep instances of their own next to the bound
// ones (measured 2026-08-22: PlanningCalendar a fourth PlanningCalendarRow,
// Calendar an eighth DateTypeRange), so a registry-wide count is one too many.
// Ask the owning control for its aggregation — the same rule every sap.m.Input
// building an internal suggestion-popup Table taught.
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.PlanningCalendar'),
    'the PlanningCalendar never rendered');
  // the ISO strings really reach the calendar as Dates through the formatter
  await waitForUi5(page, () => {
    const pc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.PlanningCalendar');
    return pc.getStartDate() instanceof Date && !isNaN(pc.getStartDate().getTime());
  }, 'Formatter.DateCreateObject never turned the seeded ISO string into a Date');
  await waitForUi5(page, () => {
    const pc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.PlanningCalendar');
    return pc && pc.getRows().length === 3;
  }, 'the three calendar rows never rendered');
  // the recurring appointments and the recurring non-working periods
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.ui.unified.RecurringCalendarAppointment').length > 0,
    'no RecurringCalendarAppointment reached the rows');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.ui.unified.RecurringNonWorkingPeriod').length > 0,
    'no RecurringNonWorkingPeriod reached the rows');
  // The Create Appointment button opens the create dialog; saving it with NO
  // recurrence is the regression this step exists for. `recurrencePattern`
  // defaults to 1 and its setter REJECTS anything below it, the original leaves
  // the property off a non-recurring appointment, and an ABAP structure cannot
  // leave a field out - so the initial 0 used to reach the setter and terminate
  // the app on the very next render (2026-08-29, from a Developer Tools export).
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && (c.getText() || '') === 'Create Appointment').firePress();
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Dialog'),
    'the Create Appointment press never opened the dialog (popup_display)');
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && (c.getText() || '') === 'Create').firePress();
  });
  await waitForUi5(page, () => {
    const pc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.PlanningCalendar');
    const appts = pc && pc.getRows().length ? pc.getRows()[0].getAppointments() : null;
    return appts && appts.length === 3 && appts.every((a) => a.getRecurrencePattern() >= 1);
  }, 'the appointment created without a recurrence never reached the first row - recurrencePattern below 1 terminates the app');
};
