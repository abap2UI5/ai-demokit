// popover_display anchored via $event.oSource.sId + relative {NAME} bindings
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Show Popover', exact: true }).first();
  await expect(btn, 'the popover button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMPopover'), 'the anchored popover').toContainText('Email');
  // the root-seeded record really reaches the popover (relative bindings
  // rendered EMPTY here until 2026-08-01 — the app-207 class)
  await expect(page.locator('.sapMPopover'), 'the bound product name').toContainText('Notebook Basic 15');
};
