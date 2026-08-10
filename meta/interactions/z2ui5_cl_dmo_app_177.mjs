// CAL_SELECT/SELECT_TODAY round-trip updating the bound selectedDate Text
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Select Today', exact: true }).first();
  await expect(btn, 'the Select Today button').toBeVisibleEnabled();
  await btn.click();
  // the round-trip writes yyyy-MM-dd into the bound #selectedDate Text
  await page.waitForFunction(
    () => {
      const el = document.querySelector("[id*='selectedDate']");
      return el && /\d{4}-\d{2}-\d{2}/.test(el.textContent || '');
    },
    null,
    { timeout: 10000 },
  );
};
