// the toggle wire fetching the next level of the tree
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => document.querySelectorAll('.sapMTreeItemBase').length === 2,
    'the two seeded root nodes never rendered');
  // the expander of the second root node (the one carrying the dummy child)
  const expander = page.locator('.sapMTreeItemBaseExpander').nth(1);
  await expect(expander, 'the expander of the second root node').toBeVisibleEnabled();
  await expander.click();
  await waitForUi5(page, () => document.querySelectorAll('.sapMTreeItemBase').length > 2,
    'the toggle round-trip never appended the next level');
};
