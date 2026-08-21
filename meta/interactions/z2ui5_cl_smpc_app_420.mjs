// the suggest round-trip: SUGGEST transports the typed value, the server
// applies the compound OR Contains filter via binding_call and re-opens the
// popover via control_by_id suggest( ). Type WITH a delay - the round-trip is
// serialized and lossy under fast typing (the port's LIVE_TEST names this).
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const input = page.locator('.sapMSFI').first();
  await expect(input, 'the SearchField input').toBeVisibleEnabled();
  // all 123 products before any suggest
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.SearchField'
    && c.getSuggestionItems().length === 123),
  'the unfiltered suggestionItems never reached 123 rows');
  await input.click();
  await input.pressSequentially('mouse', { delay: 700 });
  // the compound filter narrows the aggregation to the OR-Contains matches
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.SearchField'
    && c.getSuggestionItems().length > 0 && c.getSuggestionItems().length < 20
    && c.getSuggestionItems().every((i) => (i.getText() + i.getKey()).toUpperCase().includes('MOUSE'))),
  'the SUGGEST round-trip never filtered the suggestionItems to the Contains matches');
  // Enter fires search without a picked suggestion - the client-composed toast's other branch
  await page.keyboard.press('Enter');
  await expect(page.locator('.sapMMessageToast'), 'the search toast (no suggestion picked)').toContainText('Search is fired!');
};
