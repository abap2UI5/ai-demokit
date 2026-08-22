// the SinglePlanningCalendar and its bound appointments
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await new Promise((r) => setTimeout(r, 4000));
  const probe = await page.evaluate(() => {
    const all = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const spc = all.find((c) => c.getMetadata().getName() === 'sap.m.SinglePlanningCalendar');
    const ap = spc ? spc.getAppointments() : [];
    const b = spc ? spc.getBinding('appointments') : null;
    return 'appts=' + ap.length + ' types=' + Array.from(new Set(ap.map((a) => a.getMetadata().getName().split('.').pop()))).join(',')
      + ' bindLen=' + (b ? b.getLength() : 'none')
      + ' nwp=' + (spc && spc.getNonWorkingPeriods ? spc.getNonWorkingPeriods().length : 'no-getter');
  });
  throw new Error('PROBE ' + probe);
};
