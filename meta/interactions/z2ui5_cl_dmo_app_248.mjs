// TreeTable JSONTreeBinding: nested-structure model root + roundtrip-free
// expandToLevel/collapseAll via control_by_id (new port 2026-07-30)
export default async (page, expect) => {
  // widen so the toolbar buttons stay out of the overflow menu
  await page.setViewportSize({ width: 1900, height: 900 });
  await expect(page.getByText('Women', { exact: true }).first(), 'the first root category').toBeVisibleEnabled();
  await page.getByRole('button', { name: 'Expand first level', exact: true }).first().click();
  await expect(page.getByText('Accessories', { exact: true }).first(), 'a second-level category after expandToLevel(1)').toBeVisibleEnabled();
  await page.getByRole('button', { name: 'Collapse all', exact: true }).first().click();
  await page.waitForFunction(
    () => ![...document.querySelectorAll('td, .sapUiTableCell')].some((c) => c.textContent.trim() === 'Accessories' && c.offsetParent !== null),
    { timeout: 10000 },
  );
};
