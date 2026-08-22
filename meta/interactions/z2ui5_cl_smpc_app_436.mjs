// the ToggleButton pressed state rebuilds the view with the contextMenu subtree
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Tree' && !c.getContextMenu()),
    'the Tree never rendered without a context menu (the toggle starts off)');
  const toggle = page.locator('.sapMToggleBtn').first();
  await expect(toggle, 'the context-menu toggle').toBeVisibleEnabled();
  await toggle.click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Tree' && !!c.getContextMenu()),
    'the pressed toggle never brought back a view carrying the contextMenu subtree');
};
