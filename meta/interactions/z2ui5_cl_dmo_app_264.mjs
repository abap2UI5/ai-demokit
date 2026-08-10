// batch b13 (2026-07-31) — boundFilters (@1.146)
// typing a prefix re-filters the bound rows; Toggle Filters re-bakes the set
export default async (page, expect) => {
  const rows = page.locator('.sapUiTableRow:not(.sapUiTableRowHidden)');
  await expect(page.locator('.sapUiTable'), 'the employees table').toContainText('Walldorf');
  const input = page.locator('input.sapMInputBaseInner').first();
  await expect(input, 'the department prefix input').toBeVisibleEnabled();
  await input.fill('Manage');
  await input.press('Enter');
  await expect(page.locator('.sapUiTableCtrl'), 'the rows filtered by the bound filter').notToContainText('Development');
  const btn = page.getByRole('button', { name: 'Show Personal Filters', exact: true }).first();
  await expect(btn, 'the toggle-filters button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMTB'), 'the personal filter bar after the re-bake redraw').toContainText('First name prefix');
  // back to organizational, then clear the prefix: an empty value must DROP
  // the filter (the odata String type maps '' to null), not match nothing
  await page.getByRole('button', { name: 'Show Organizational Filters', exact: true }).first().click();
  const dept = page.locator('input.sapMInputBaseInner').first();
  await dept.fill('');
  await dept.press('Enter');
  await expect(page.locator('.sapUiTableCtrl'), 'every row back after clearing the prefix').toContainText('Development');
  void rows;
};
