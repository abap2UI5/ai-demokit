// the load round-trip filling the bound items aggregation, and the group close
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const load = page.getByRole('button', { name: 'Load notifications' }).first();
  await expect(load, 'the load button').toBeVisibleEnabled();
  await load.click();
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.NotificationListItem').length > 0,
    'the load round-trip never filled the bound items aggregation');
};
