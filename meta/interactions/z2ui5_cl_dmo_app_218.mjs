// ShellBar SearchManager: liveChange composes its toast on the client
// ('{0} liveChange event value is: {1}'), typing also drives the backend
// suggest round-trip
export default async (page, expect) => {
  // the ShellBar renders the SearchManager collapsed — the Search button
  // expands the field, and only then is there an input to type into
  const open = page.getByRole('button', { name: 'Search' }).first();
  await expect(open, 'the ShellBar search button').toBeVisibleEnabled();
  await open.click();
  const search = page.locator('input').first();
  await expect(search, 'the expanded search field').toBeVisibleEnabled();
  await search.type('Pro', { delay: 80 });
  await expect(page.locator('.sapMMessageToast').last(), 'the client-composed liveChange toast')
    .toContainText('liveChange event value is:');
};
