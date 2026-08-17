// the anchored ResponsivePopover round-trip: the ColorPicker opens on the
// button that requested it, built by the backend rather than by a fragment
export default async (page, expect) => {
  const open = page.getByRole('button', { name: /Open ColorPicker/ }).first();
  await expect(open, 'the "Open ColorPicker" button').toBeVisibleEnabled();
  await open.click();
  await expect(page.locator('.sapMPopover'), 'the anchored ResponsivePopover').toBeVisibleEnabled();
  // the picker itself, not just an empty popover frame
  await expect(page.locator('.sapMPopover .sapUiColorPicker-ColorPickerMatrix'),
    'the ColorPicker inside the popover').toBeVisibleEnabled();
  await expect(page.locator('.sapMPopover'), 'the picker fields').toContainText('Hex');
};
