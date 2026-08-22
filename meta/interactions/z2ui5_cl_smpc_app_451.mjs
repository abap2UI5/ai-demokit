// the add wire on the bound TabContainer items
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  // count the RENDERED tab strips - the registry also holds the bound template
  await waitForUi5(page, () => document.querySelectorAll('.sapMTabStripItem').length === 4,
    'the four seeded tabs never rendered');
  const add = page.locator('.sapMTabContainer .sapMBtn').last();
  await expect(add, 'the add-new-tab button').toBeVisibleEnabled();
  await add.click();
  await waitForUi5(page, () => document.querySelectorAll('.sapMTabStripItem').length === 5,
    'the add round-trip never appended a row to the bound items');
};
