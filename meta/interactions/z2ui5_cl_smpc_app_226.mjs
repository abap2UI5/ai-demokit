// Grid element-binding to an array path + index-relative child bindings
export default async (page, expect) => {
  await expect(page.locator('body'), 'the {0/INTROTEXT1} index-relative binding')
    .toContainText('This Grid Layout sample application demonstrates');
};
