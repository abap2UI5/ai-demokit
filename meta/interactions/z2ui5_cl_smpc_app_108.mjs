// app 108 — sap.m.sample.PlanningCalendarSingle
//
// The LIVE_TEST deviation retired the 2026-07-27 run for two reasons: it
// certified TOASTS (this port raises none — both handlers call
// message_box_display, the faithful reproduction of the original's
// MessageBox.show) and it certified interactions the port did not have on that
// date (appointmentSelect / intervalSelect / the ToggleButton arrived
// 2026-08-05). What it left standing is the RENDERING through
// Formatter.DateCreateObject; what it asks for is a fresh run over
//   (a) the two MessageBox legs of handleAppointmentSelect,
//   (b) the showDayNamesLine toggle.
// This module drives exactly those, plus the rendering claim it inherits and
// the intervalSelect wire that shares the deviation's date-transport rule.
import { waitForUi5, ui5All, dispatchMouse } from '../../scripts/lib-e2e.mjs';

// The live PlanningCalendar, resolved fresh every time: Element.registry keeps
// the OUTGOING control while a round-trip tears it down, and a detached one
// answers with its old state.
const PC = `Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
  .find((c) => c.getMetadata().getName() === 'sap.m.PlanningCalendar'
    && !c.bIsDestroyed && c.getDomRef() && document.body.contains(c.getDomRef()))`;

const TOGGLE = `Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
  .find((c) => c.getMetadata().getName() === 'sap.m.ToggleButton' && !c.bIsDestroyed
    && c.getTooltip_AsString() === 'Toggle Day Names Line')`;

export default async (page, expect) => {
  const dialog = page.locator('.sapMDialog');

  // ------------------------------------------------------------------ 1
  // The one claim the retired live check may keep: every appointment and every
  // interval header reaches the calendar as a REAL Date, i.e. the ISO strings
  // in the model went through Formatter.DateCreateObject. Asked of the OWNING
  // controls (pc.getRows()[0].getAppointments()), never of the registry — a
  // bound aggregation's TEMPLATE is a live CalendarAppointment too and answers
  // for no row.
  await waitForUi5(page, () => {
    const pc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.PlanningCalendar'
      && !c.bIsDestroyed && c.getDomRef() && document.body.contains(c.getDomRef()));
    if (!pc || pc.getRows().length !== 1) return false;
    const isDate = (d) => d instanceof Date && !isNaN(d.getTime());
    const row = pc.getRows()[0];
    const apps = row.getAppointments();
    const heads = row.getIntervalHeaders();
    return isDate(pc.getStartDate())
      && apps.length === 21 && heads.length === 3
      && apps.every((a) => isDate(a.getStartDate()) && isDate(a.getEndDate()))
      && heads.every((h) => isDate(h.getStartDate()) && isDate(h.getEndDate()));
  }, 'the calendar never came up with its one row, 21 appointments and 3 interval headers all carrying real Dates — Formatter.DateCreateObject did not turn the seeded ISO strings into date objects');

  // ------------------------------------------------------------------ 2
  // MessageBox leg ONE — handleAppointmentSelect with an appointment.
  // "Team meeting" (2017-01-08 10:00) sits in the Day view's visible range.
  const apptId = await page.evaluate(`(() => {
    const pc = ${PC};
    const a = pc && pc.getRows()[0].getAppointments()
      .find((x) => x.getTitle() === 'Team meeting' && x.getDomRef());
    return a ? a.getId() : null;
  })()`);
  if (!apptId) {
    throw new Error("the 'Team meeting' appointment never rendered into the visible range, so the appointmentSelect wire could not be driven by a gesture at all");
  }

  // An appointment is a zero-size box in the unthemed harness, so the gesture
  // is focus + Enter: CalendarRow.onsapselect only needs the key event's TARGET
  // to be inside the appointment's div, and it then runs the calendar's own
  // selection (setting `selected`, filling aSelectedAppointments) before
  // PlanningCalendar re-fires appointmentSelect. A dispatched mouse sequence is
  // the fallback — CalendarRow.ontap routes to the very same handler.
  await page.evaluate((id) => document.getElementById(id).focus(), apptId);
  await page.keyboard.press('Enter');
  const opened = await dialog.first().waitFor({ state: 'visible', timeout: 5000 }).then(() => true, () => false);
  if (!opened) await dispatchMouse(page.locator(`[id="${apptId}"]`).first());

  // The message is composed in ABAP from what the event carried: the title, the
  // new selected state, and $event.oSource.getSelectedAppointments().length.
  // The selected/deselected WORD is deliberately not asserted: it rides on a
  // boolean t_arg, and a boolean reaches the transpiled backend as the string
  // 'true' (see the e2e-debugging guide) where `= abap_true` cannot match, so
  // the harness always reads "deselected" while a real system reads "selected".
  await expect(dialog, 'the appointmentSelect MessageBox (APPT_SELECT, appointment leg)')
    .toContainText('Team meeting');
  await expect(dialog, "the MessageBox's selected-appointment count, read off getSelectedAppointments()")
    .toContainText('Selected appointments: 1');
  await page.getByRole('button', { name: 'OK', exact: true }).first().click();
  await dialog.first().waitFor({ state: 'hidden', timeout: 10000 });

  // ------------------------------------------------------------------ 3
  // MessageBox leg TWO — the branch with no appointment. The calendar only ever
  // passes `appointments` (and no `appointment`) for a GROUP appointment, which
  // it builds when several appointments collapse into one interval — something
  // this sample's Day view never does. So the event is fired on the calendar
  // itself with the array it would pass, the way app 610 fires appointmentDrop:
  // what is under test here is the port's t_arg expressions and the ABAP ELSE
  // branch, not UI5's own grouping.
  await page.evaluate(`(() => {
    const pc = ${PC};
    const apps = pc.getRows()[0].getAppointments().slice(0, 2);
    pc.fireAppointmentSelect({ appointments: apps, multiSelect: true, domRefId: apps[0].getId() });
  })()`);
  await expect(dialog, 'the appointmentSelect MessageBox (APPT_SELECT, no-appointment leg)')
    .toContainText('2 Appointments selected');
  await page.getByRole('button', { name: 'OK', exact: true }).first().click();
  await dialog.first().waitFor({ state: 'hidden', timeout: 10000 });

  // ------------------------------------------------------------------ 4
  // The showDayNamesLine toggle. No press attribute is emitted: the
  // ToggleButton's `pressed` and the calendar's `showDayNamesLine` are the SAME
  // two-way bound field, so what has to be proven is that a gesture on the
  // button moves the CALENDAR's property — with no round-trip involved.
  const before = await page.evaluate(`(() => { const pc = ${PC}; return pc.getShowDayNamesLine(); })()`);
  if (before !== false) {
    throw new Error(`the calendar already had showDayNamesLine=${before} before the toggle was pressed — the bound field seeds it false, so a press could not be observed as a CHANGE here`);
  }
  const toggleId = await page.evaluate(`(() => { const b = ${TOGGLE}; return b ? b.getId() : null; })()`);
  if (!toggleId) {
    throw new Error('the calendar toolbar carries no "Toggle Day Names Line" ToggleButton — the showDayNamesLine wire could not be driven');
  }
  // The button lives in the PlanningCalendar's own OverflowToolbar. If it
  // folded into the overflow, its DOM sits inside the CLOSED popover and
  // cannot take focus until that popover is opened.
  const focusToggle = () => page.evaluate((id) => {
    const el = document.getElementById(id);
    if (!el) return false;
    el.focus();
    return document.activeElement === el;
  }, toggleId);
  if (!(await focusToggle())) {
    const more = page.getByRole('button', { name: 'Additional Options' });
    const n = await more.count();
    let reached = false;
    for (let i = 0; i < n && !reached; i++) {
      await more.nth(i).click();
      await page.waitForTimeout(600);
      reached = await focusToggle();
    }
    if (!reached) {
      throw new Error(`the "Toggle Day Names Line" button never took focus — tried ${n} overflow popover(s), so the toggle gesture could not be delivered and the showDayNamesLine wire stays unproven`);
    }
  }
  await page.keyboard.press('Enter'); // ToggleButton.onkeydown -> ontap -> setPressed
  await waitForUi5(page, () => {
    const live = (c) => !c.bIsDestroyed && c.getDomRef() && document.body.contains(c.getDomRef());
    const pc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.PlanningCalendar' && live(c));
    const b = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.ToggleButton' && live(c)
      && c.getTooltip_AsString() === 'Toggle Day Names Line');
    return !!pc && !!b && b.getPressed() === true && pc.getShowDayNamesLine() === true;
  }, 'the ToggleButton press never reached the calendar: showDayNamesLine stayed false, so the button and the PlanningCalendar are NOT sharing the bound field the deviation claims');

  // ------------------------------------------------------------------ 5
  // intervalSelect — the sample's "click an interval, get a new appointment"
  // headline, and the one wire that proves the deviation's date-transport rule:
  // the interval's start/end travel as their LOCAL parts (a UTC toISOString()
  // would shift the day), ABAP composes the two ISO strings, the row is
  // inserted, and it comes back through Formatter.DateCreateObject as a Date.
  // The expectation is derived from the parameters the calendar actually
  // delivered, so it fails on a shifted day, a lost hour or a bad zero-pad
  // rather than on which interval was hit.
  await page.evaluate(`(() => {
    const pc = ${PC};
    window.__a2u108 = null;
    const parts = (d) => [d.getFullYear(), d.getMonth() + 1, d.getDate(), d.getHours(), d.getMinutes()];
    pc.attachEventOnce('intervalSelect', (e) => {
      window.__a2u108 = { start: parts(e.getParameter('startDate')), end: parts(e.getParameter('endDate')) };
    });
  })()`);

  // The interval strip has an inline width but no height in the unthemed
  // harness, so the real gesture goes in as a mouse SEQUENCE (CalendarRow.ontap
  // needs mousedown+mouseup, not a lone click).
  const interval = page.locator('[id$="-AppsInt1"]').first();
  if (await interval.count()) await dispatchMouse(interval);
  await page.waitForTimeout(800);
  let picked = await page.evaluate('window.__a2u108');
  if (!picked) {
    // No tap formed — fire what the calendar itself would fire for the second
    // Day interval (_selectInterval ends the range one millisecond before the
    // next interval starts, hence 23:59 on the local clock).
    picked = await page.evaluate(`(() => {
      const pc = ${PC};
      const s = new Date(pc.getStartDate().getTime());
      s.setDate(s.getDate() + 1);
      s.setHours(0, 0, 0, 0);
      const e = new Date(s.getTime() + 24 * 60 * 60 * 1000 - 1);
      const parts = (d) => [d.getFullYear(), d.getMonth() + 1, d.getDate(), d.getHours(), d.getMinutes()];
      pc.fireIntervalSelect({ startDate: s, endDate: e, subInterval: false, row: pc.getRows()[0] });
      return { start: parts(s), end: parts(e) };
    })()`);
  }

  const pad = (n) => String(n).padStart(2, '0');
  const iso = (p) => `${p[0]}-${pad(p[1])}-${pad(p[2])}T${pad(p[3])}:${pad(p[4])}:00`;
  const want = { start: iso(picked.start), end: iso(picked.end) };

  await waitForUi5(page, (w) => {
    const pc = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.PlanningCalendar'
      && !c.bIsDestroyed && c.getDomRef() && document.body.contains(c.getDomRef()));
    if (!pc || pc.getRows().length !== 1) return false;
    const apps = pc.getRows()[0].getAppointments();
    if (apps.length !== 22) return false; // 21 seeded + the one the interval created
    const a = apps.find((x) => x.getTitle() === 'new appointment');
    const ctx = a && a.getBindingContext();
    if (!ctx) return false;
    const d = a.getStartDate();
    return a.getType() === 'Type09'
      && ctx.getProperty('START_AT') === w.start
      && ctx.getProperty('END_AT') === w.end
      && d instanceof Date && !isNaN(d.getTime())
      && d.getDate() === Number(w.start.slice(8, 10))
      && d.getHours() === Number(w.start.slice(11, 13));
  }, `the intervalSelect round-trip never produced the sample's new appointment: the row's appointments never grew to 22 with a 'new appointment' of Type09 running ${want.start} to ${want.end} — either the ten local date parts did not travel, or ABAP composed a different ISO string, or the result never came back through Formatter.DateCreateObject`, want);
};
