// the colorSet expression over all ten MessageStrips
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.MessageStrip' && c.getColorSet() === 'ColorSet1').length === 10,
    'the ten strips never rendered on ColorSet1');
  const picker = page.locator('.sapMSlt').first();
  await expect(picker, 'the ColorSet Select').toBeVisibleEnabled();
  await picker.click();
  const item = page.locator('.sapMSelectListItem', { hasText: 'ColorSet 2' }).first();
  await expect(item, 'the ColorSet 2 entry').toBeVisibleEnabled();
  await item.click();
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.MessageStrip' && c.getColorSet() === 'ColorSet2').length === 10,
    'the Select never reached the ten colorSet expressions');
};
