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
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.PlanningCalendarRow').length === 3,
    'the three calendar rows never rendered');
  // the Add button opens the create dialog
  await page.locator('button[title="Add"]').first().click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Dialog'),
    'the Add press never opened the create dialog (popup_display)');
  await expect(page.locator('.sapMDialog'), 'the create dialog').toContainText('Interval appointment');
};
