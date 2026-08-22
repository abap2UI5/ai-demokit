// the shared two-way bound mode field: Select.selectedKey -> Tree.mode
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Tree' && c.getMode() === 'MultiSelect'),
    'the Tree never rendered in the seeded MultiSelect mode');
  const picker = page.locator('.sapMSlt').first();
  await expect(picker, 'the selection-mode Select').toBeVisibleEnabled();
  await picker.click();
  const item = page.locator('.sapMSelectListItem', { hasText: 'Single Selection Left' }).first();
  await expect(item, 'the "Single Selection Left" entry').toBeVisibleEnabled();
  await item.click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Tree' && c.getMode() === 'SingleSelectLeft'),
    'the Select never reached Tree.mode (shared two-way field)');
};
