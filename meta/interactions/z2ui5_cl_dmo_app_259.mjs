// ProgressIndicator + RatingIndicator header facets
export default async (page, expect) => {
  await expect(page.locator('.sapMPI').first(), 'the header ProgressIndicator').toContainText('42%');
  await expect(page.locator('.sapMRI').first(), 'the header RatingIndicator').toBeVisibleEnabled();
  await expect(page.locator('.sapUxAPObjectPageSection').first(), 'the goals section').toContainText('Evangelize the UI framework');
};
