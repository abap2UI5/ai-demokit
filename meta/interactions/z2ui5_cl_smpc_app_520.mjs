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
    const g = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.NotificationListGroup');
    g.setCollapsed(false);
    // setCollapsed alone changes the CONTROL: the onCollapse wire is what
    // fetches the group's items, so it has to be fired too
    g.fireEvent('onCollapse', { collapsed: false });
  })()`);
  // through the group's own aggregation: each group's BOUND items binding
  // keeps a live template in the registry, so a registry-wide count of
  // NotificationListItem answers 5 for three real rows (measured 2026-08-22).
  await waitForUi5(page, () => {
    const g = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.NotificationListGroup');
    return g.length === 2 && g[0].getItems().length === 3 && g[1].getItems().length === 0;
  }, 'expanding the first group never filled it with its three notifications');
};
