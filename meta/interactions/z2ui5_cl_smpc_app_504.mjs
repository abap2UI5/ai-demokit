// the validator switch in the backend: 'c' becomes a token, 'e' becomes 'f'
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const input = page.locator('.sapMInputBaseInner').first();
  await expect(input, 'the MultiInput').toBeVisibleEnabled();
  await input.click();
  await input.fill('e');
  await input.press('Enter');
  // the validator maps 'e' onto a token with the text 'f'
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.Token' && c.getText() === 'f'),
    'the change round-trip never mapped "e" onto the "f" token');
};
