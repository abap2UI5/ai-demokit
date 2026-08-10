// sap.ui.unified.Menu opened through the 2026-07-27 openBy fallback
// (open(false, anchor, …) for a control without its own openBy)
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Open Menu', exact: true }).first();
  await expect(btn, 'the menu anchor button').toBeVisibleEnabled();
  await btn.click();
  const item = page.getByText('My 1st Item', { exact: true }).first();
  await expect(item, 'the anchored-open unified Menu').toBeVisibleEnabled();
  await item.click();
  await expect(page.locator('.sapMMessageToast').last(), 'the itemSelect client toast').toContainText("'My 1st Item' pressed");
};
