// the growing TableSelectDialog and its binding_call search filter
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Show Table Select Dialog (Growing: True)' }).first();
  await expect(btn, 'the growing-dialog button').toBeVisibleEnabled();
  await btn.click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.TableSelectDialog' && c.getGrowing() === true),
    'the dialog never opened with growing on');
  await expect(page.locator('.sapMDialog'), 'the dialog').toContainText('Select Product');
};
