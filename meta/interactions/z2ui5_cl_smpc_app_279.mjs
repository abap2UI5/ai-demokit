// Image error -> round-trip -> the two visible expression bindings swap the
// Image for the IllustratedMessage. NOTE the initial LOAD leg is not
// checkable here: the seeded product image sits on sdk.openui5.org and the
// sandbox serves only /resources/ locally, so the error path already fires
// at boot. This asserts the swap survives the explicit Set-wrong-src
// round-trip; the load->HAS_ERROR-false leg stays a human check.
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Set wrong src', exact: true }).first();
  await expect(btn, 'the Set-wrong-src button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('body'), 'the IllustratedMessage revealed by HAS_ERROR').toContainText('Not Found');
  await waitForUi5(page, () => {
    const img = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Image');
    return img && img.getVisible() === false;
  }, 'the Image stayed visible although HAS_ERROR is set');
};
