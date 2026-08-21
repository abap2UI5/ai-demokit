// Four legs of this port's deviation:
//   (a) TITLE_SELECTOR — the header's title-selector arrow opens the Select
//       Product by ResponsivePopover, anchored at $event.oSource.sId,
//   (b) ITEM_SELECT — picking a list entry round-trips and the server answers
//       with popover_close, so the popover has to go away again,
//   (c) MARK_LOCKED — the lock marker opens the second anchored popover,
//   (d) the two breadcrumb Link toasts.
// Both markers are internal icon-only buttons — see pressHeaderMarker.
import { pressHeaderMarker, pressBreadcrumb } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await expect(page.locator('.sapUxAPObjectPageHeaderTitle'), 'the header identifier')
    .toContainText('Long title that wraps and goes over more lines');

  // (a) the select popover
  await pressHeaderMarker(page, 'titleArrow');
  const pop = page.locator('.sapMPopover');
  await expect(pop, 'the Select Product by popover').toContainText('Select Product by');
  await expect(pop, 'the bound product list in the popover').toContainText('Category');

  // (b) picking an entry round-trips and the answer closes the popover
  await pop.getByText('Category', { exact: true }).first().click();
  await expect(page.locator('.sapMPopover:visible'), 'the popover after ITEM_SELECT').toHaveCountBelow(1);

  // (c) the lock popover
  await pressHeaderMarker(page, 'lock');
  await expect(page.locator('.sapMPopover'), 'the Locked popover')
    .toContainText('This profile is being edited by another user.');
  await page.keyboard.press('Escape');

  // (d) both breadcrumb toasts
  await pressBreadcrumb(page, 'Page 1 a very long link');
  await expect(page.locator('.sapMMessageToast').last(), 'the LINK1 toast')
    .toContainText('Page 1 a very long link clicked');
  await pressBreadcrumb(page, 'Page 2 long link');
  await expect(page.locator('.sapMMessageToast').last(), 'the LINK2 toast')
    .toContainText('Page 2 long link clicked');
};
