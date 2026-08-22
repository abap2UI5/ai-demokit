// the bound Token template plus the tokenDelete wire: the per-token X removes
// exactly that row from the backend table
import { dispatchMouse, waitForUi5 } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  // count the RENDERED tokens - the control registry also holds the bound template
  await waitForUi5(page, () => document.querySelectorAll('.sapMToken').length === 19,
    'the 19 bound Tokens never rendered');
  // the token's delete icon has a ZERO-WIDTH box in the headless layout, so a
  // real click never lands - dispatch the mouse events instead
  await dispatchMouse(page.locator('.sapMTokenIcon').first());
  await waitForUi5(page, () => document.querySelectorAll('.sapMToken').length === 18,
    'tokenDelete never removed the row from the bound table');
};
