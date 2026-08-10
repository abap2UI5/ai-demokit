// popover_display with an embedded unified ColorPicker (2026-07-30 rework)
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Open ColorPicker in a ResponsivePopover', exact: true }).first();
  await expect(btn, 'the popover button').toBeVisibleEnabled();
  await btn.click();
  // the popover opening anchored proves popover_display; the picker's
  // inner sliders render zero-size headless, so assert on the container
  await expect(page.locator(".sapMPopover:has([class*='ColorPicker'])").first(), 'the popover with the embedded ColorPicker').toBeVisibleEnabled();
};
