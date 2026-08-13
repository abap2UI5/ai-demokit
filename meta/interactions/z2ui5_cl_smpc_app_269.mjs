// DynamicSideContent driven from the backend: the two setShowSideContent
// follow-up actions (hide from the side content's own Close button, show
// from the footer button whose `visible` the breakpoint round-trip drives)
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await expect(page.locator('.sapMList'), 'the feed list').toContainText('Alexandrina Victoria');
  const close = page.getByRole('button', { name: 'Close', exact: true }).first();
  await expect(close, 'the side-content Close button').toBeVisibleEnabled();
  await close.click();
  await waitForUi5(page, () => {
    const d = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.layout.DynamicSideContent');
    return !!d && !d.getShowSideContent();
  }, 'the SIDE_CONTENT_HIDE follow-up action never hid the side content');
  const open = page.getByRole('button', { name: 'Open Side Content', exact: true }).first();
  await expect(open, 'the Open Side Content button (visible off breakpoint S)').toBeVisibleEnabled();
  await open.click();
  await waitForUi5(page, () => {
    const d = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.layout.DynamicSideContent');
    return !!d && d.getShowSideContent();
  }, 'the SIDE_CONTENT_SHOW follow-up action never brought the side content back');
};
