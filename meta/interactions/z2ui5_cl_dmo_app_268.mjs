// anchored open of a per-row ColorPickerPopover (control_by_id openBy with a
// domRef arg). The change/liveChange round-trips need a real colour pick in
// the picker's own controls and stay a human check.
export default async (page, expect) => {
  // the value-help icon (id …-vhi) gets a ZERO-size box in the headless
  // layout (the theme CSS that sizes sapUiIcon never loads), so a normal
  // click fails actionability — dispatch the DOM click the Icon listens for
  const icon = page.locator('[id$="-vhi"]').first();
  if (!(await icon.count())) throw new Error('the first row Input rendered no value-help icon');
  await icon.dispatchEvent('click');
  const pop = page.locator('.sapMPopover');
  await expect(pop, 'the anchored ColorPickerPopover').toBeVisibleEnabled();
  if (!(await pop.locator('.sapUnifiedColorPicker').count())) throw new Error('the opened popover carries no ColorPicker');
};
