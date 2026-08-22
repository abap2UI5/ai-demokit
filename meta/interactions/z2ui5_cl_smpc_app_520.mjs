// the lazy fill on expand and the item count toast
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.NotificationListGroup').length === 2,
    'the two NotificationListGroups never rendered');
  // both groups boot collapsed and EMPTY - the fill is the onCollapse round-trip
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.NotificationListGroup')
    .every((c) => c.getCollapsed() === true && c.getItems().length === 0),
    'the groups did not boot collapsed and empty');
  await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    ui5All().find((c) => c.getMetadata().getName() === 'sap.m.NotificationListGroup').setCollapsed(false);
  })()`);
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.NotificationListItem').length === 3,
    'expanding the first group never filled it with its three notifications');
};
