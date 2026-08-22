// the message view inside the popover, its header state and the back button
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Messages'),
    'the Messages button never rendered');
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Messages').firePress();
  });
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.ResponsivePopover'),
    'the popover never opened');
  await waitForUi5(page, () => {
    const mv = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.MessageView');
    return mv && mv.getItems().length === 5;
  }, 'the five mock messages never reached the MessageView');
  // the custom header starts on the list page: title Messages, back button hidden
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Title' && c.getText() === 'Messages'),
    'the popover header does not start on Messages');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Button'
    && c.getIcon() === 'sap-icon://nav-back' && c.getVisible() === false),
    'the back button was visible on the list page');
  // the link of the MessageItem template is the one the controller builds
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Link'
    && c.getText() === 'Show more information'), 'the MessageItem link never rendered');
};
