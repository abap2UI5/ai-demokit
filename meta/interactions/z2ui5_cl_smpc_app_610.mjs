// the three switches, the appointments, and one drag that moves an appointment
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const c = ui5All().find((x) => x.getMetadata().getName() === 'sap.m.SinglePlanningCalendar');
    return c && c.getAppointments().length === 36
      && c.getEnableAppointmentsDragAndDrop() === true
      && c.getEnableAppointmentsResize() === true
      && c.getEnableAppointmentsCreate() === true;
  }, 'the calendar never came up with its 36 appointments and all three modes on');

  // a drop moves the appointment and toasts its title
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const spc = reg.find((c) => c.getMetadata().getName() === 'sap.m.SinglePlanningCalendar');
    const app = spc.getAppointments()[0];
    spc.fireEvent('appointmentDrop', {
      appointment: app,
      startDate: new Date(2018, 6, 8, 12, 0),
      endDate: new Date(2018, 6, 8, 13, 0),
      copy: false,
    });
  });
  await expect(page.locator('.sapMMessageToast').last(), 'the APPT_DROP toast')
    .toContainText('has been moved');

  await waitForUi5(page, () => {
    const c = ui5All().find((x) => x.getMetadata().getName() === 'sap.m.SinglePlanningCalendar');
    const model = c.getBinding('appointments').getModel();
    return model.getProperty('/T_APPOINTMENTS/0/START_AT') === '2018-07-08T12:00:00';
  }, 'the dropped appointment never took its new start');
};
