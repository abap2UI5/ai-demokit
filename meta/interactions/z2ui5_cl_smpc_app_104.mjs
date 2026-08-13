// popup_display TableSelectDialog with the FULL 123-row mock + the
// client-side binding_call Contains search (no round-trip)
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Show Table Select Dialog', exact: true }).first();
  await expect(btn, 'the dialog button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMDialog'), 'the full product table in the dialog').toContainText('Portable DVD player');
  const search = page.locator('.sapMDialog input').first();
  await search.fill('Gladiator MX');
  await search.press('Enter');
  await expect(page.locator('.sapMDialog'), 'the binding_call Contains filter').toContainText('Gladiator MX');
};
