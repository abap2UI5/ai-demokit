// Wizard: the footer Cancel goes through a backend round-trip that opens a
// MessageBox (message_box_display with a YES/NO onclose action), and — since
// 2026-08-28 — the Edit links of the review page, which are the port's
// backToPage legs.
//
// Those legs were SILENT NO-OPS until the A2UI5_PIN bump to 2567ee10: the
// frontend did not list backToPage, so it took the unlisted-method path and
// handed sap.m.NavContainer the RAW ABAP literal, while `_pageStack` holds
// runtime-prefixed ids. UI5 answered "Cannot navigate backToPage(...) because
// target page was not found among the previous pages." and left the review page
// up — no wrong target, no exception, nothing to catch. So the assertion is on
// the NavContainer's CURRENT page, which is the only thing that separates a
// working back-navigation from a dead one.
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await expect(page.locator('body'), 'the first wizard step').toContainText('Product Type');
  const cancel = page.getByRole('button', { name: 'Cancel', exact: true }).first();
  await expect(cancel, 'the wizard Cancel button').toBeVisibleEnabled();
  await cancel.click();
  await expect(page.locator('.sapMDialog'), 'the cancel MessageBox')
    .toContainText('Are you sure you want to cancel your report?');
  await page.getByRole('button', { name: 'NO', exact: true }).first().click();

  // complete the wizard: the `to` leg, which always worked
  await page.waitForFunction(() => !window.z2ui5 || !window.z2ui5.isBusy);
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getId().endsWith('CreateProductWizard')).fireComplete();
  });
  await waitForUi5(page, () => {
    const nav = ui5All().find((c) => !c.bIsDestroyed && c.getMetadata().getName() === 'sap.m.NavContainer');
    const cur = nav && nav.getCurrentPage();
    return Boolean(cur && cur.getId().endsWith('wizardReviewPage'));
  }, 'the wizard-complete `to` never reached the review page');

  // an Edit link: backToPage the content page, then goToStep. The goToStep
  // alone would pass on a dead back-navigation, so the PAGE is what is asserted
  await page.waitForFunction(() => !window.z2ui5 || !window.z2ui5.isBusy);
  await page.getByRole('link', { name: 'Edit', exact: true }).first().click();
  await waitForUi5(page, () => {
    const nav = ui5All().find((c) => !c.bIsDestroyed && c.getMetadata().getName() === 'sap.m.NavContainer');
    const cur = nav && nav.getCurrentPage();
    const wiz = ui5All().find((c) => !c.bIsDestroyed && c.getId().endsWith('CreateProductWizard'));
    return Boolean(cur && cur.getId().endsWith('wizardContentPage')
      && wiz && String(wiz.getCurrentStep()).endsWith('ProductTypeStep'));
  }, 'the Edit link never came back to the wizard content page — backToPage is a no-op again');
};
