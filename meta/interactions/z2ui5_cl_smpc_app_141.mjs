// the a11y announce round-trip: pressing any button writes the status Text
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Success', exact: true }).first();
  await expect(btn, 'the Success button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('body'), 'the bound status text after the round-trip')
    .toContainText('A new message was sent to the invisible messaging service.');
};
