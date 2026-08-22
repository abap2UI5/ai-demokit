// the refresh wire: one more mock record per refresh, filtered by the bound
// search value. Headless reports no touch support, so the SearchField carries
// the refresh button and the PullToRefresh stays hidden - the search event is
// driven from the field itself, which is the wire both of them share
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => document.querySelectorAll('.sapMSLI').length === 1,
    'the list never rendered the single seeded product');
  const field = page.locator('.sapMSFI').first();
  await expect(field, 'the search field').toBeVisibleEnabled();
  await field.click();
  await field.press('Enter');
  await waitForUi5(page, () => document.querySelectorAll('.sapMSLI').length === 2,
    'the refresh never pushed the second mock record into the bound table');
};
