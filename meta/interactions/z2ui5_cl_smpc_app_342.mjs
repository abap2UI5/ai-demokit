// the bound items aggregation instantiates one Card per row, and the
// number-of-cards Input round-trips into it - what the original does with a
// destroyItems/addItem loop in the controller
export default async (page, expect) => {
  const cards = () => page.locator('.sapFCard,.sapUiIntCard').count();
  if (await cards() !== 0) throw new Error('cards were there before the load');

  const count = page.locator('input.sapMInputBaseInner').nth(1);
  await expect(count, 'the number-of-cards Input').toBeVisibleEnabled();
  await count.fill('4');

  await page.getByRole('button', { name: /Start loading/ }).first().click();
  const deadline = Date.now() + 15000;
  while (await cards() !== 4) {
    if (Date.now() > deadline) throw new Error(`the bound aggregation built ${await cards()} cards, not the 4 the Input asked for`);
    await page.waitForTimeout(250);
  }
};
