// the NumericContent press raising the MessageBox.alert
export default async (page, expect) => {
  const tile = page.locator('.sapMNC').first();
  await expect(tile, 'the first NumericContent').toBeVisibleEnabled();
  await tile.click();
  await expect(page.locator('.sapMDialog'), 'the alert').toContainText('Link was clicked!');
};
