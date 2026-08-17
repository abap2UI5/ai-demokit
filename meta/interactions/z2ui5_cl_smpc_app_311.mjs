// the anchored open of the unified Menu, and the item groups it carries
export default async (page, expect) => {
  const open = page.getByRole('button', { name: /Open Menu/ }).first();
  await expect(open, 'the "Open Menu" button').toBeVisibleEnabled();
  await open.click();
  await expect(page.locator('.sapUiMnu'), 'the anchored unified Menu').toBeVisibleEnabled();
};
