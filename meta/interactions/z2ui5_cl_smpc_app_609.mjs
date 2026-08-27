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

  // updateButtonEnabledState: the seeded 9-10 hours are valid, so OK is enabled
  await waitForUi5(page, () => {
    const ok = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'OK');
    return !!ok && ok.getEnabled() === true;
  }, 'the OK button never came up enabled for the seeded 9-10 hours');

  // _setDateValueState: an end that is not AFTER the start paints both
  // DateTimePickers Error and disables OK (DATE_CHECK)
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const start = reg.find((c) => /DTPStartDate$/.test(c.getId()));
    const end = reg.find((c) => /DTPEndDate$/.test(c.getId()));
    end.setValue(start.getValue());
    end.fireChange({ value: end.getValue(), valid: true });
  });
  await waitForUi5(page, () => {
    const ok = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'OK');
    const dtp = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.DateTimePicker');
    return !!ok && ok.getEnabled() === false
      && dtp.length === 2 && dtp.every((c) => c.getValueState() === 'Error');
  }, 'an end that is not after the start never disabled OK nor painted the pickers (DATE_CHECK)');

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

  // cancel closes it again
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.filter((c) => c.getMetadata().getName() === 'sap.m.Button')
      .find((c) => c.getText() === 'Cancel').firePress();
  });
  await waitForUi5(page, () => !ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Dialog'),
    'the Cancel press never closed the modify dialog');
};
