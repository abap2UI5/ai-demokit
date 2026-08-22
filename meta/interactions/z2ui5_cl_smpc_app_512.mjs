// the token creation keeping the model list in sync
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const input = page.locator('.sapMInputBaseInner').first();
  await expect(input, 'the MultiInput').toBeVisibleEnabled();
  await input.click();
  await input.fill('alpha');
  await input.press('Enter');
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.StandardListItem' && c.getTitle() === 'text: alpha'),
    'the added token never reached the model list');
};
