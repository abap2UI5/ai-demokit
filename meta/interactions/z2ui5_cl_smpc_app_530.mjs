// the ten toolbars resized by one shared expression binding, and the Share toast
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.OverflowToolbar').length === 10,
    'the ten OverflowToolbars never rendered');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.OverflowToolbar')
    .every((c) => c.getWidth() === '100%'), 'the toolbars did not boot at the seeded 100% width');
  // one key press on the slider has to reach ALL ten toolbars
  await page.evaluate(() => document.querySelector('.sapMSliderHandle').focus());
  await page.keyboard.press('ArrowLeft');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.OverflowToolbar')
    .every((c) => c.getWidth() === '99%'), 'the slider never reached the ten toolbar widths');
  // the Share button sits at the end of otb1 and is in the overflow area at
  // this viewport width, so it is pressed through the registry rather than the DOM
  await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Share').firePress();
  })()`);
  await expect(page.locator('.sapMMessageToast'), 'the shareAction toast').toContainText('Share action');
};
