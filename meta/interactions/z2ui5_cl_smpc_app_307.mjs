// CalendarMultipleDaySelection: clicking a day round-trips the WHOLE
// selectedDates aggregation in one marshalled arg and fills the List. Two days
// are picked, because one proves nothing about the array route — the 31-slot
// per-index wire this replaced carried the first day just as well. "Remove All
// Selected Dates" then has to clear BOTH sides — the model AND the aggregation
// the control writes itself, which is what the removeAllSelectedDates
// follow-up action does (abap2UI5 #2535; before it the days stayed highlighted)
import { waitForCount } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const day = page.locator('.sapUiCalItem').first();
  if (!(await day.count())) throw new Error('the Calendar rendered no day cells');
  // the day cell carries no clickable layout box headless, so a day is
  // picked the keyboard way — focus the cell, press Enter
  await page.evaluate(() => document.querySelectorAll('.sapUiCalItem')[0].focus());
  await page.keyboard.press('Enter');
  await waitForCount(page, '.sapUiCalItemSel', 1, 'the clicked day was not selected');
  await waitForCount(page, '.sapMSLI', 1, 'the selected day did not reach the List');
  await page.evaluate(() => document.querySelectorAll('.sapUiCalItem')[1].focus());
  await page.keyboard.press('Enter');
  await waitForCount(page, '.sapUiCalItemSel', 2, 'the second day was not selected');
  await waitForCount(page, '.sapMSLI', 2,
    'the second day never reached the List — the marshalled DateRange array did not travel whole');
  await page.getByRole('button', { name: 'Remove All Selected Dates', exact: true }).first().click();
  await expect(page.locator('.sapMList'), 'the List after Remove All').toContainText('No Dates Selected');
  await expect(page.locator('.sapUiCalItemSel'), "the calendar's highlighting after removeAllSelectedDates")
    .toHaveCountBelow(1);
};
