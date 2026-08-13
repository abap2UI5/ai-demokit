export default async (page, expect) => {
  // the mode radio group sits on the SECOND detail page — navigate there
  // first (which itself exercises the control_by_id `to detailDetail` wire).
  // selectedIndex is bound two-way; picking `hide` round-trips MODE_BTN and
  // the backend derives the mode from the written-back index — the toast
  // naming HideMode proves the write-back, the two-way `mode` binding then
  // drives the SplitContainer
  const nav = page.getByRole('button', { name: 'Go to Detail page 2', exact: true }).first();
  await expect(nav, 'the detail-page-2 nav button').toBeVisibleEnabled();
  await nav.click();
  const radio = page.getByText('hide', { exact: true }).first();
  await expect(radio, 'the HideMode radio button (on detail page 2)').toBeVisibleEnabled();
  await radio.click();
  await expect(page.locator('.sapMMessageToast'), 'the mode-change toast derived from the round-tripped index')
    .toContainText('Split Container mode is changed to: HideMode');
};
