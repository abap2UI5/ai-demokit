// the change wire recomposing the formatted "text (key)" in ABAP
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const input = page.locator('.sapMInputBaseInner').first();
  await expect(input, 'the ComboBox input').toBeVisibleEnabled();
  await input.click();
  await input.fill('Germany');
  await input.press('Enter');
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.Text' && /Germany \(DE\)/.test(c.getText() || '')),
    'the change round-trip never composed the "text (key)" line in the backend');
};
