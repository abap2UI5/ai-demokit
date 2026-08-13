// sap.ui.unified.Menu anchored open via the 2026-07-27 openBy→open()
// fallback (no own openBy on this control)
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Open Menu', exact: true }).first();
  await expect(btn, 'the menu anchor button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.getByText('My 1st Item', { exact: true }).first(), 'the unified.Menu opened anchored').toBeVisibleEnabled();
};
