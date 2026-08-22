// the first validator running in the backend: the CheckBox gates it and the
// second validator's "#: " prefix is already applied
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const input = page.locator('.sapMInputBaseInner').first();
  await expect(input, 'the first MultiInput').toBeVisibleEnabled();
  await input.click();
  await input.fill('abc');
  await input.press('Enter');
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.Token' && c.getText() === '#: abc'),
    'the change round-trip never created the prefixed token');
};
