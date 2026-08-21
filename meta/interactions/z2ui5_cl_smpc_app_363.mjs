// TableFreeze: the bound fixedColumnCount and the bound rowMode counts have to
// reach the table, and the Apply clamp round-trip has to write the corrected
// values back INTO the Inputs — the clamp is the whole point of the sample, so
// the assertion is the value the user gets handed back, not just the toast.
import { waitForUi5, ui5All, UI5_ALL_SRC, revealInOverflow } from '../../scripts/lib-e2e.mjs';

const inputValue = async (page, id) => page.evaluate(`(() => { ${UI5_ALL_SRC}
  const i = ui5All().find((c) => c.getId().endsWith('${id}'));
  return i ? i.getValue() : null; })()`);

export default async (page, expect) => {
  await expect(page.locator('body'), 'the seeded rows').toContainText('Notebook Basic 15');

  // The three Inputs must start EMPTY. The original gives them no value, so
  // their placeholders are what the user reads; seeding them from the freeze
  // counts writes "0" into each, and sap.m.Input drops the placeholder the
  // moment a value is set. The port did exactly that until 2026-08-21, and
  // this module could not see it because every assertion below starts by
  // fill()ing over whatever was there.
  for (const id of ['inputColumn', 'inputRow', 'inputBottomRow']) {
    const v = await inputValue(page, id);
    if (v !== '') throw new Error(`${id} starts at "${v}" — its placeholder is hidden, the original starts empty`);
  }
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
    return !!t && t.getFixedColumnCount() === 0;
  }, 'the table did not start with fixedColumnCount 0');

  // a column count over the 12 the table has is clamped back to 12
  const col = page.locator('[id$="inputColumn"] input').first();
  await revealInOverflow(page, col);
  await expect(col, 'the fixed column count input').toBeVisibleEnabled();
  await col.fill('20');
  await page.getByRole('button', { name: 'Apply', exact: true }).first().click();
  await expect(page.locator('.sapMMessageToast').last(), 'the column clamp toast')
    .toContainText('Fixed column count exceeds the total column count.');
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
    return !!t && t.getFixedColumnCount() === 12;
  }, 'the clamped column count did not reach the table');
  if (await inputValue(page, 'inputColumn') !== '12') {
    throw new Error('the clamp did not write the corrected column count back into the Input');
  }

  // top + bottom over the 10 rows the table has: the bottom count is clamped
  const rowInput = page.locator('[id$="inputRow"] input').first();
  await revealInOverflow(page, rowInput);
  await rowInput.fill('8');
  await page.locator('[id$="inputBottomRow"] input').first().fill('7');
  await page.getByRole('button', { name: 'Apply', exact: true }).first().click();
  await expect(page.locator('.sapMMessageToast').last(), 'the row clamp toast')
    .toContainText('Sum of fixed row count and bottom row count exceeds the total row count.');
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
    const rm = t && t.getRowMode();
    return !!rm && rm.getFixedTopRowCount() === 8 && rm.getFixedBottomRowCount() === 1;
  }, 'the clamped row counts did not reach the rowMode');
  if (await inputValue(page, 'inputBottomRow') !== '1') {
    throw new Error('the clamp did not write the corrected bottom row count back into the Input');
  }
};
