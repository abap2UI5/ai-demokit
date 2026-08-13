// tnt NavigationList: the two toolbar buttons flip bound control state
// server-side (the original used byId().setExpanded / setVisible)
export default async (page, expect) => {
  const nav = page.locator('.sapTntNL').first();
  await expect(nav, 'the navigation list').toContainText('Sub Item 3');
  const btn = page.getByRole('button', { name: 'Show/Hide SubItem 3', exact: true }).first();
  await expect(btn, 'the Show/Hide SubItem 3 button').toBeVisibleEnabled();
  await btn.click();
  // the bound visible flag hides exactly one sub item — the count must drop
  await expect(page.getByText('Sub Item 3', { exact: true }), 'one Sub Item 3 hidden after the round-trip').toHaveCountBelow(2);
  // the second button flips NavigationList.expanded — collapsed shows icons only
  const toggle = page.getByRole('button', { name: 'Toggle Collapse/Expand', exact: true }).first();
  await expect(toggle, 'the collapse/expand button').toBeVisibleEnabled();
  await toggle.click();
  await expect(nav, 'the collapsed navigation list').notToContainText('Sub Item 1');
};
