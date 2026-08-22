// the toggle wire fetching the next level of the tree
import { waitForUi5, dispatchMouse } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => document.querySelectorAll('.sapMTreeItemBase').length === 2,
    'the two seeded root nodes never rendered');
  // the expander of the second root node (the one carrying the dummy child)
  // the expander is an icon and measures 0x0 in the unthemed harness, so no
  // actionability check passes — dispatch the whole mouse sequence instead
  await dispatchMouse(page.locator('.sapMTreeItemBaseExpander').nth(1));
  await waitForUi5(page, () => document.querySelectorAll('.sapMTreeItemBase').length > 2,
    'the toggle round-trip never appended the next level');
};
