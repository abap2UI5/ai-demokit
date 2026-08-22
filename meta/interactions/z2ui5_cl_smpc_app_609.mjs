// the create-and-edit app: the Create action, the modify dialog and the details popover
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const c = ui5All().find((x) => x.getMetadata().getName() === 'sap.m.SinglePlanningCalendar');
    return c && c.getAppointments().length === 35 && c.getViews().length === 3;
  }, 'the calendar never came up with its 35 appointments and three views');

  // Create opens the modify dialog
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Create').firePress();
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Dialog'),
    'the Create action never opened the modify dialog');

  // the type Select carries the whole CalendarDayType enum, key === text
  await waitForUi5(page, () => {
    const sel = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Select'
      && c.getItems().length > 10);
    return !!sel && sel.getItems().every((i) => i.getKey() === i.getText())
      && sel.getItems().some((i) => i.getKey() === 'Type09');
  }, 'the type Select never got the enum members');

  // cancel closes it again
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.filter((c) => c.getMetadata().getName() === 'sap.m.Button')
      .find((c) => c.getText() === 'Cancel').firePress();
  });
  await waitForUi5(page, () => !ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Dialog'),
    'the Cancel press never closed the modify dialog');
};
