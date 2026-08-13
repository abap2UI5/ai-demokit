// subSectionLayout="TitleOnLeft" + the EmploymentBlockJob ModelMapping fold
export default async (page, expect) => {
  await expect(page.locator('.sapUxAPObjectPageLayout'), 'the object page').toContainText('Denise Smith');
  const section = page.getByText('Job Relationship', { exact: true }).first();
  await expect(section, 'the Job Relationship subsection title').toBeVisibleEnabled();
  // the folded emp1>/emp2> root fields (HRData /Employee rows 0 and 1)
  await expect(page.locator('.sapUxAPObjectPageLayout'), 'the folded ModelMapping records').toContainText('Michael Adams');
};
