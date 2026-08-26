// Edit/Save/Cancel: the form swaps through the bound visible flags, and Cancel
// restores the record the EDIT handler cloned.
//
// BOTH directions of each flag are asserted. The positive side on its own (a
// Save button appears, an Input appears, a Text shows the value) still passes
// when the negation silently evaluates always-true and BOTH forms render on
// top of each other - which is precisely what the `{= !${/EDIT_MODE}}`
// expression on the Edit button and on the Display VBox exists to prevent. So
// every phase also asserts what must be GONE. Until 2026-08-24 this module
// asserted only the positive side, so the "form swap through the bound visible
// flags" the sidecar deviation stamps as e2e-verified on 2026-08-16 was in fact
// only half-covered by that run: a port with a dead negation passed it.
export default async (page, expect) => {
  const editBtn = () => page.getByRole('button', { name: 'Edit', exact: true });
  const saveBtn = () => page.getByRole('button', { name: 'Save', exact: true });

  await expect(editBtn().first(), 'the Edit button (display mode)').toBeVisibleEnabled();
  await expect(page.locator('.sapMText'), 'the Display form before EDIT').toContainText('Red Point Stores');
  await editBtn().first().click();

  // the Change form REPLACED the Display one: inputs and Save/Cancel are there,
  // and the Edit button plus the Display Texts are gone (the negated flag)
  await expect(saveBtn().first(), 'the Save button after EDIT').toBeVisibleEnabled();
  const name = page.locator('input.sapMInputBaseInner').first();
  await expect(name, 'the name Input of the Change form').toBeVisibleEnabled();
  await expect(editBtn(), 'the Edit button after EDIT').toHaveCountBelow(1);
  await expect(page.locator('.sapMText'), 'the Display form after EDIT').notToContainText('Red Point Stores');

  await name.fill('Edited Supplier');
  await page.getByRole('button', { name: 'Cancel', exact: true }).first().click();
  // CANCEL restores the cloned values AND goes back to the Display form
  await expect(page.locator('.sapMText'), 'the Display form after CANCEL').toContainText('Red Point Stores');
  await expect(saveBtn(), 'the Change form after CANCEL').toHaveCountBelow(1);

  await editBtn().first().click();
  await page.locator('input.sapMInputBaseInner').first().fill('Edited Supplier');
  await saveBtn().first().click();
  // SAVE keeps the edited value and goes back to the Display form
  await expect(page.locator('.sapMText'), 'the Display form after SAVE').toContainText('Edited Supplier');
  await expect(saveBtn(), 'the Change form after SAVE').toHaveCountBelow(1);
};
