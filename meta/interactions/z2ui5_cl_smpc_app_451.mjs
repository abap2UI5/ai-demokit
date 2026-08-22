// the add wire on the bound TabContainer items
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.TabContainerItem').length === 4,
    'the four seeded tabs never rendered');
  const add = page.locator('.sapMTabContainer .sapMBtn').last();
  await expect(add, 'the add-new-tab button').toBeVisibleEnabled();
  await add.click();
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.TabContainerItem').length === 5,
    'the add round-trip never appended a row to the bound items');
};
