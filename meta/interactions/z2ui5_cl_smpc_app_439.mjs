// the Switch drives containerAuto.toggleStyleClass('sapMShowEmpty-CTX') through
// control_by_id, which is what makes the Auto empty indicator appear
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const sw = page.locator('.sapMSwtCont').first();
  await expect(sw, 'the CSS-class Switch').toBeVisibleEnabled();
  await sw.click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Panel'
    && c.getId().endsWith('containerAuto') && c.hasStyleClass('sapMShowEmpty-CTX')),
    'the Switch never reached containerAuto.toggleStyleClass (control_by_id)');
};
