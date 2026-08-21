// the growing lazy-load round-trip: the More trigger fires updateStarted
// (reason Growing), the server appends the next 30 rows 1:1 with the original
// loop, and the open dialog list grows past the seeded 31
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Show Select Dialog', exact: true }).first();
  await expect(btn, 'the dialog button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMDialog'), 'the SelectDialog').toContainText('Select Product');
  await expect(page.getByText('Name 1', { exact: true }).first(), 'the first seeded row').toBeVisibleEnabled();
  // the growing trigger ("More") requests the next slice and fires updateStarted
  const more = page.locator('.sapMDialog').getByText('More', { exact: false }).first();
  await expect(more, 'the growing More trigger').toBeVisibleEnabled();
  await more.click();
  // the Growing round-trip appended rows 30..59 - the model grows to 61
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.SelectDialog'
    && c.getItems().length > 31),
  'the updateStarted(Growing) round-trip never appended the next slice');
  await expect(page.getByText('Name 45', { exact: true }).first(), 'a lazily loaded row').toBeVisibleEnabled();
};
