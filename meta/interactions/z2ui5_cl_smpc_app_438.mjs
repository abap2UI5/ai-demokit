// the refresh wire: one more mock record per refresh, filtered by the bound
// search value; headless is a non-touch device, so the SearchField shows the
// refresh button and the PullToRefresh stays hidden
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

const items = () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem').length;

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem').length === 1,
    'the list never rendered the single seeded product');
  const refresh = page.locator('.sapMSFR').first();
  await expect(refresh, 'the SearchField refresh button (non-touch device)').toBeVisibleEnabled();
  await refresh.click();
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem').length === 2,
    'the refresh never pushed the second mock record into the bound table');
};
