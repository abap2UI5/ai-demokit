// uxap batch b05 (2026-07-31)
// ObjectPageDynamicHeaderTitle backgroundDesign + backgroundDesignAnchorBar
export default async (page, expect) => {
  await expect(page.locator('.sapUxAPObjectPageHeaderTitle'), 'the dynamic header title').toContainText('Denise Smith');
  await expect(page.locator('.sapUxAPObjectPageNavigation'), 'the anchor bar').toContainText('Section 1');
  // the blocks are the inlined SimpleForms, not the sample's BlockBase
  await expect(page.locator('.sapUiForm').first(), 'the inlined block form').toContainText('some content goes here...');
  // backgroundDesignAnchorBar="Translucent" reaches the AnchorBar toolbar
  // .last() = the in-flow anchor bar; the sticky clone has a zero box
  await expect(page.locator('.sapUxAPObjectPageNavigationTranslucent').last(), 'the Translucent anchor bar').toBeVisibleEnabled();
};
