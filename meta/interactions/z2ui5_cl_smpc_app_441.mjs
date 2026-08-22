// the two-way bound separatorStyle (Select -> Breadcrumbs)
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.Breadcrumbs' && c.getSeparatorStyle() === 'Slash'),
    'the Breadcrumbs never rendered on the seeded Slash separator');
  // the Breadcrumbs folds its own links into an overflow Select in this
  // viewport, so address the separator Select by ID rather than by position
  const picker = page.locator('[id$="separatorSelect"]').first();
  await expect(picker, 'the separator-style Select').toBeVisibleEnabled();
  await picker.click();
  const item = page.locator('.sapMSelectListItem', { hasText: 'GreaterThan' }).first();
  await expect(item, 'the GreaterThan entry').toBeVisibleEnabled();
  await item.click();
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.Breadcrumbs' && c.getSeparatorStyle() === 'GreaterThan'),
    'the Select never reached Breadcrumbs.separatorStyle (shared two-way field)');
};
