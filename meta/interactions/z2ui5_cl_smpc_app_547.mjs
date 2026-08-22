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
    return pc.getRows().length === 3;
  }, 'the three calendar rows never rendered');
  // the Add button opens the create dialog; it sits in the calendar's own
  // OverflowToolbar and may be in the overflow area, so it is fired by id
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getId().endsWith('addButton')).firePress();
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Dialog'),
    'the Add press never opened the create dialog (popup_display)');
  await expect(page.locator('.sapMDialog'), 'the create dialog').toContainText('Interval appointment');
};
