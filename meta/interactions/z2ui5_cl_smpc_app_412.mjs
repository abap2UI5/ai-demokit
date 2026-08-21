// The four legs of this port's deviation, in the order that keeps them
// independent — the setSelectedSection leg scrolls the page, so it runs last
// once the header links have been used.
//   (a) TITLE_SELECTOR round-trip opening the QuickView popover at the
//       pressed link ($event.oSource.sId anchor),
//   (b) the pageLink navigation to companyEmployeePageId INSIDE the popover,
//   (c) the two client-composed toasts,
//   (d) the setSelectedSection frontend action on the 'Order Details' link.
// `John Miller` is deliberately NOT the link used for (a): it exists twice in
// the header (once inert, with a leading space, in Contact Information), so
// `Julie Armstrong` is the unambiguous Changed-By/Created-By trigger.
export default async (page, expect) => {
  await expect(page.locator('.sapUxAPObjectPageHeaderTitle'), 'the header title')
    .toContainText('Object Page Header with Links, Rating Indicator, and Object Status');

  // (a) the anchored QuickView
  const trigger = page.getByRole('link', { name: 'Julie Armstrong', exact: true }).first();
  await expect(trigger, 'the Created By link').toBeVisibleEnabled();
  await trigger.click();
  const pop = page.locator('.sapMPopover');
  await expect(pop, 'the QuickView popover').toContainText('Adventure Company');
  await expect(pop, 'the QuickView first page').toContainText('Contact Details');

  // (b) the in-popover pageLink navigation to the employee page
  const pageLink = pop.getByRole('link', { name: 'John Doe', exact: true }).first();
  await expect(pageLink, 'the Main Contact pageLink').toBeVisibleEnabled();
  await pageLink.click();
  await expect(pop, 'the QuickView employee page').toContainText('Department Manager');
  await page.keyboard.press('Escape');

  // (c) the two client-composed toasts
  await page.getByRole('link', { name: 'Status', exact: true }).first().click();
  await expect(page.locator('.sapMMessageToast').last(), 'the Status link toast')
    .toContainText('Navigate to another page in the same application (List of delivery items)');
  await page.getByRole('link', { name: 'Robotech (234242343)', exact: true }).first().click();
  await expect(page.locator('.sapMMessageToast').last(), 'the Supplier link toast')
    .toContainText('Navigate to external application.');

  // (d) the setSelectedSection follow-up — the Order Details form is what
  // becomes reachable once the layout selects that section
  await page.getByRole('link', { name: 'Order Details', exact: true }).first().click();
  await expect(page.locator('.sapUxAPObjectPageLayout'), 'the Order Details section after setSelectedSection')
    .toContainText('589946637');
};
