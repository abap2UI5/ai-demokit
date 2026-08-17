// A fully static, init-only port: nothing to drive, so what has to be verified
// is that the ObjectPageLayout actually RENDERS - its header identifier, the
// collapsed header content and the sections below it. The generic boot gate
// only proves the app answered with controls at all.
export default async (page, expect) => {
  await expect(page.locator('.sapUxAPObjectPageLayout'), 'the ObjectPageLayout').toBeVisibleEnabled();
  await expect(page.locator('.sapUxAPObjectPageHeaderTitle'), 'the header identifier')
    .toContainText('Rowan Atkinson');
  await expect(page.locator('.sapUxAPObjectPageLayout'), 'the header content')
    .toContainText('Bangalore, India');
  await expect(page.locator('.sapUxAPObjectPageLayout'), 'the sections')
    .toContainText('2014 Goals Plan');
};
