// Edit/Save/Cancel: the form swaps through the bound visible flags, and Cancel
// restores the record the EDIT handler cloned
export default async (page, expect) => {
  const edit = page.getByRole('button', { name: 'Edit', exact: true }).first();
  await expect(edit, 'the Edit button (display mode)').toBeVisibleEnabled();
  await edit.click();

  // the Change form replaced the Display one - inputs, and Save/Cancel instead
  // of Edit (all three driven by the same bound edit_mode flag)
  const save = page.getByRole('button', { name: 'Save', exact: true }).first();
  await expect(save, 'the Save button after EDIT').toBeVisibleEnabled();
  const name = page.locator('input.sapMInputBaseInner').first();
  await expect(name, 'the name Input of the Change form').toBeVisibleEnabled();

  await name.fill('Edited Supplier');
  await page.getByRole('button', { name: 'Cancel', exact: true }).first().click();
  // CANCEL restores the cloned values AND goes back to the Display form
  await expect(page.locator('.sapMText'), 'the Display form after CANCEL').toContainText('Red Point Stores');

  await page.getByRole('button', { name: 'Edit', exact: true }).first().click();
  await page.locator('input.sapMInputBaseInner').first().fill('Edited Supplier');
  await page.getByRole('button', { name: 'Save', exact: true }).first().click();
  // SAVE keeps the edited value and goes back to the Display form
  await expect(page.locator('.sapMText'), 'the Display form after SAVE').toContainText('Edited Supplier');
};
