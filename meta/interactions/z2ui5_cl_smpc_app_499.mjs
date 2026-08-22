// the binding_call search filter and the selection counter
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  // `.sapMSFI` is the SearchField's wrapper, not its input: typing into it
  // left the control's value empty (measured 2026-08-22) and the liveChange
  // wire never ran. Raise it through the control instead.
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const sf = reg.find((c) => c.getMetadata().getName() === 'sap.m.SearchField');
    sf.setValue('Notebook');
    sf.fireLiveChange({ newValue: 'Notebook' });
  });
  await waitForUi5(page, () => Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem' && c.getDomRef()).length > 0
    && Object.values(sap.ui.require('sap/ui/core/Element').registry.all())
    .filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem' && c.getDomRef())
    .every((c) => /Notebook/.test(c.getTitle())),
    'the binding_call filter never narrowed the list to the Notebooks');
};
