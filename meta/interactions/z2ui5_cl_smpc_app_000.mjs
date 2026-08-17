// The overview app (not a numbered port, but the demo's front door). Its info
// button is the app's only backend round-trip, so this one click covers the
// whole draft save -> reload path: it is where the 2026-07-31
// `Network error: ASSERTION_FAILED` regression showed up (open-abap wrote the
// draft XML with unescaped `<`, see pr/open-abap-xml-escaping). The popover
// content also proves the server-side row lookup (only ${CLASS} travels).
export default async (page, expect) => {
  const btn = page.locator('button[title^="Generation notes"]').first();
  await expect(btn, 'a row\'s generation-notes button').toBeVisibleEnabled();
  await btn.click();
  await page.waitForSelector('.sapMPopover', { timeout: 60000 })
    .catch(() => { throw new Error('the generation-notes popover never opened (round-trip failed?)'); });
  await expect(page.locator('.sapMPopover'), 'the generation-notes popover').toContainText('Generation notes');
};
