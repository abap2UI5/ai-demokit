// the statically set contextual width and the button that halves it
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Table');
    return t && t.getContextualWidth() === '500px' && t.getItems().length === 22;
  }, 'the table never rendered with its seeded contextual width and 22 rows');
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Button').firePress();
  });
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Table');
    return t && t.getContextualWidth() === '100px';
  }, 'the button never changed the contextual width');
};
