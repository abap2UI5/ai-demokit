// the HEADER_TOGGLE round-trip mutates page 1 in the model (title/description/
// avatar cleared and restored), and the afterNavigate isTopPage transport keeps
// the two-way bound Back button in sync with the card's navigation
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const title = page.getByText('Adventure Company', { exact: true }).first();
  await expect(title, 'the card title on page 1').toBeVisibleEnabled();
  // Back starts disabled on the top page
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Button'
    && c.getText() === 'Navigate Back' && c.getEnabled() === false),
  'the Back button did not start disabled');
  // header switch OFF: the round-trip clears the page-1 header data
  await page.locator('.sapMSwtCont').nth(1).click();
  await waitForUi5(page, () => !ui5All().some((c) => c.getMetadata().getName() === 'sap.m.QuickViewPage'
    && c.getTitle() === 'Adventure Company'),
  'the HEADER_TOGGLE round-trip never cleared the page-1 title');
  // and back ON: title and description return
  await page.locator('.sapMSwtCont').nth(1).click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.QuickViewPage'
    && c.getTitle() === 'Adventure Company'),
  'the HEADER_TOGGLE round-trip never restored the page-1 title');
  // the pageLink navigates to the employee page - afterNavigate isTopPage=false
  // enables the two-way bound Back button
  const link = page.getByRole('link', { name: 'John Doe' }).first();
  await expect(link, 'the John Doe pageLink').toBeVisibleEnabled();
  await link.click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Button'
    && c.getText() === 'Navigate Back' && c.getEnabled() === true),
  'afterNavigate(isTopPage=false) never enabled the Back button');
  // navigateBack (roundtrip-free follow_up_action) returns to the top page
  await page.getByRole('button', { name: 'Navigate Back', exact: true }).first().click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Button'
    && c.getText() === 'Navigate Back' && c.getEnabled() === false),
  'afterNavigate(isTopPage=true) never disabled the Back button again');
};
