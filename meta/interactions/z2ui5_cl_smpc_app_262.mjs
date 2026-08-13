// ObjectPageLayout.showFooter two-way bound, flipped by a round-trip
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Toggle Footer', exact: true }).first();
  await expect(btn, 'the Toggle Footer button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapUxAPObjectPageFooter'), 'the footer after the round-trip').toContainText('Accept');
  // the breadcrumb link's client-composed toast — at this viewport the
  // Breadcrumbs collapse into a Select, so pick the entry from its list
  const crumbs = page.locator('.sapMBreadcrumbs .sapMSlt').first();
  await expect(crumbs, 'the collapsed breadcrumbs select').toBeVisibleEnabled();
  await crumbs.click();
  const home = page.locator('.sapMSltPicker li', { hasText: 'Home' }).first();
  await expect(home, 'the Home breadcrumb entry').toBeVisibleEnabled();
  await home.click();
  await expect(page.locator('.sapMMessageToast').last(), 'the breadcrumb client toast').toContainText('Page 1 a very long link clicked');
};
