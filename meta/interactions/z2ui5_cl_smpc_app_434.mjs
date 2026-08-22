// popup_display of the Dialog fragment and the popup_close on its buttons
import { waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Show Dialog with content padding' }).first();
  await expect(btn, 'the dialog-open button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMDialog'), 'the dialog fragment').toContainText("'sapUiContentPadding' class is applied");
  const ok = page.getByRole('button', { name: 'Ok' }).first();
  await expect(ok, 'the Ok button').toBeVisibleEnabled();
  await ok.click();
  await waitForUi5(page, () => document.querySelectorAll('.sapMDialog').length === 0,
    'the dialog never closed on popup_close');
};
