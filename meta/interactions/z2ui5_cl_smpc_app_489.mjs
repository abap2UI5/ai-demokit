// popup_display of the dialog fragment and the popup_close on its button
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Open Dialog' }).first();
  await expect(btn, 'the open button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMDialog'), 'the dialog').toContainText('Dialog with Segmented Button');
  const close = page.getByRole('button', { name: 'Close' }).first();
  await close.click();
  await waitForUi5(page, () => document.querySelectorAll('.sapMDialog').length === 0,
    'the dialog never closed on popup_close');
};
