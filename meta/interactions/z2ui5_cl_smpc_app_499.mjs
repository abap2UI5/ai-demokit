// the binding_call search filter and the selection counter
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const field = page.locator('.sapMSFI').first();
  await expect(field, 'the search field').toBeVisibleEnabled();
  await field.click();
  await field.pressSequentially('Notebook', { delay: 400 });
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem' && c.getDomRef()).length > 0
    && Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem' && c.getDomRef())
    .every((c) => /Notebook/.test(c.getTitle())),
    'the binding_call filter never narrowed the list to the Notebooks');
};
