// the shared two-way field: Slider value -> List.itemActionCount
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.List' && c.getItemActionCount() === 2),
    'the List never rendered with the seeded action count');
  await page.evaluate(() => document.querySelector('.sapMSliderHandle').focus());
  await page.keyboard.press('ArrowLeft');
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.List' && c.getItemActionCount() === 1),
    'the Slider never reached List.itemActionCount (shared two-way field)');
};
