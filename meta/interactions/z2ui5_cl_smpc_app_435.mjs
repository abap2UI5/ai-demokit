// the id split (source id -> indicator + value) writing the two bound
// ProgressIndicator properties, and the InvisibleMessage announcement
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Set to 50%' }).first();
  await expect(btn, 'the first "Set to 50%" button').toBeVisibleEnabled();
  await btn.click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.ProgressIndicator'
    && c.getPercentValue() === 50 && c.getDisplayValue() === '50%'),
    'the pressed button never reached the bound percentValue/displayValue of its ProgressIndicator');
};
