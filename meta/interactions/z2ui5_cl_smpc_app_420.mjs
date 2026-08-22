// the suggest round-trip: SUGGEST transports the typed value, the server
// applies the compound OR Contains filter via binding_call and re-opens the
// popover via control_by_id suggest( ). Type WITH a delay - the round-trip is
// serialized and lossy under fast typing (the port's LIVE_TEST names this).
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const input = page.locator('.sapMSFI').first();
  await expect(input, 'the SearchField input').toBeVisibleEnabled();
  // the model holds all 123 products, but the instantiated aggregation is
  // capped at the JSONModel default sizeLimit (100) - assert the cap, not the mock
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.SearchField'
    && c.getSuggestionItems().length === 100),
  'the unfiltered suggestionItems never reached the 100-row sizeLimit cap');
  await input.click();
  // 1200ms between keys: each SUGGEST trip must COMPLETE before the next key,
  // or the serialized wire drops the later event and converges on a prefix
  await input.pressSequentially('mouse', { delay: 1200 });
  // the compound filter narrows the aggregation to the OR-Contains matches
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.SearchField'
    && c.getSuggestionItems().length > 0 && c.getSuggestionItems().length < 20
    && c.getSuggestionItems().every((i) => (i.getText() + i.getKey()).toUpperCase().includes('MOUSE'))),
  'the SUGGEST round-trip never filtered the suggestionItems to the Contains matches');
  // Enter fires search without a picked suggestion - the client-composed toast's other branch
  await page.keyboard.press('Enter');
  await expect(page.locator('.sapMMessageToast'), 'the search toast (no suggestion picked)').toContainText('Search is fired!');
};
