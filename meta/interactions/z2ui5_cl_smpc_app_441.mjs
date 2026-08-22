// the two-way bound separatorStyle (Select -> Breadcrumbs) and one link toast
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Breadcrumbs' && c.getSeparatorStyle() === 'Slash'),
    'the Breadcrumbs never rendered on the seeded Slash separator');
  const picker = page.locator('.sapMSlt').first();
  await expect(picker, 'the separator-style Select').toBeVisibleEnabled();
  await picker.click();
  const item = page.locator('.sapMSelectListItem', { hasText: 'GreaterThan' }).first();
  await expect(item, 'the GreaterThan entry').toBeVisibleEnabled();
  await item.click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Breadcrumbs' && c.getSeparatorStyle() === 'GreaterThan'),
    'the Select never reached Breadcrumbs.separatorStyle (shared two-way field)');
};
