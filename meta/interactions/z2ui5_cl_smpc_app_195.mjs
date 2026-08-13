// a record flattened onto the model root must be bound ABSOLUTELY — these
// four rendered empty until 2026-08-01 (the app-207 class, see AGENTS §5)
export default async (page, expect) => {
  await expect(page.locator('.sapMList'), 'the root-seeded record in the list').toContainText('Notebook Basic 15');
  await expect(page.locator('.sapMList'), 'the bound description').toContainText('HT-1000');
};
