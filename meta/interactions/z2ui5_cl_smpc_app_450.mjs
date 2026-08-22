// the bound layout property replacing the controller's setLayout calls
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.f.FlexibleColumnLayout' && c.getLayout() === 'OneColumn'),
    'the FlexibleColumnLayout never rendered in OneColumn');
  const btn = page.getByRole('button', { name: 'Navigate to Middle Column' }).first();
  await expect(btn, 'the navigate-to-middle button').toBeVisibleEnabled();
  await btn.click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.f.FlexibleColumnLayout' && c.getLayout() === 'TwoColumnsMidExpanded'),
    'the round-trip never wrote TwoColumnsMidExpanded into the bound layout');
};
