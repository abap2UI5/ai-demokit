// the bound Token template plus the tokenDelete wire: the per-token X removes
// exactly that row from the backend table
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

const tokens = () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Token').length;

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Token').length === 19,
    'the 19 bound Tokens never rendered');
  // the X of the first token fires tokenDelete with its key
  const del = page.locator('.sapMTokenIcon').first();
  await expect(del, 'the delete icon of the first token').toBeVisibleEnabled();
  await del.click();
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Token').length === 18,
    'tokenDelete never removed the row from the bound table');
};
