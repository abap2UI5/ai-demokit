// a swipe gesture cannot be produced headless, so this drives the wire the
// swipe would raise: the direction decides the bound button text and type
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => document.querySelectorAll('.sapMSLI').length > 0,
    'the product list never rendered');
  await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const list = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.List');
    list.fireSwipe({ swipeDirection: 'EndToBegin', listItem: list.getItems()[0], swipeContent: list.getSwipeContent() });
  })()`);
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .some((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Disapprove'),
    'the swipe round-trip never rewrote the bound swipe button');
};
