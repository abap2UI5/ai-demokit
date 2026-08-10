// NavContainer.to via control_by_id (slot-local id + transition)
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'To 2', exact: true }).first();
  await expect(btn, 'the To 2 nav button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.getByText('Page 2', { exact: true }).first(), 'page 2 after the to() call').toBeVisibleEnabled();
};
