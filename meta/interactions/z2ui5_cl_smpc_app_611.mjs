// the three special dates and the popover a marked day opens
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const r = ui5All().filter((c) => c.getMetadata().getName() === 'sap.ui.unified.DateTypeRange');
    return r.length === 3 && r.map((x) => x.getType()).join(',') === 'Type01,Type02,None';
  }, 'the three special dates never rendered with their types');

  // selecting day 5 of the current month opens the popover
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const cal = reg.find((c) => c.getMetadata().getName() === 'sap.ui.unified.Calendar');
    const now = new Date();
    const day = new Date(now.getFullYear(), now.getMonth(), 5);
    cal.fireEvent('select', {}, false, false);
    cal.removeAllSelectedDates();
    const DateRange = sap.ui.require('sap/ui/unified/DateRange');
    cal.addSelectedDate(new DateRange({ startDate: day }));
    cal.fireSelect({});
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Popover'),
    'the marked day never opened the popover');
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Text'
      && (c.getText() || '').startsWith('Day type: '));
    return !!t && t.getText() === 'Day type: Type01';
  }, 'the popover never named the day type');
};
