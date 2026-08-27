// the semantic action bar, the bound table, the footer toggle - and the
// MessagesIndicator, whose absence this module could not see until 2026-08-26
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await expect(page.locator('body'), 'the title heading').toContainText('Products List');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.ColumnListItem' && c.getDomRef()).length > 0,
    'the product rows never rendered');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.f.semantic.SemanticPage' && c.getShowFooter() === true),
    'the semantic page did not boot with its footer shown');

  // The z2ui5.cc.MessageManager bridge is what feeds the message> model. Read
  // the model FIRST and fail on its count, because the visible symptom is
  // indirect: SemanticConfiguration binds MessagesIndicator.visible to a
  // formatter over message>/, so an unfed model renders no button at all - a
  // missing-button failure would accuse the popover wire instead of the bridge
  const messages = await page.evaluate(`(() => {
    const Messaging = sap.ui.require('sap/ui/core/Messaging');
    const model = Messaging ? Messaging.getMessageModel()
                            : sap.ui.getCore().getMessageManager().getMessageModel();
    const data = model && model.getData();
    return Array.isArray(data) ? data.map((m) => String(m.message || m.getMessage && m.getMessage())) : null;
  })()`);
  if (!messages || messages.length === 0) {
    throw new Error(`the message> model carries ${messages ? 0 : 'no model at all'} - the z2ui5.cc.MessageManager bridge did not feed it, so the MessagesIndicator stays invisible`);
  }
  if (!messages.some((m) => m.includes('Something wrong happened'))) {
    throw new Error(`the message> model carries ${JSON.stringify(messages)}, not the sample's Error message`);
  }

  // and the indicator the model makes visible (app 448 idiom)
  const indicator = page.locator('.sapMBtn').filter({ hasText: '1' }).first();
  await expect(indicator, 'the messages indicator the fed model makes visible').toBeVisibleEnabled();

  await page.locator('button:has-text("ToggleFooter")').first().click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.f.semantic.SemanticPage' && c.getShowFooter() === false),
    'the ToggleFooter press never reached showFooter');
};
