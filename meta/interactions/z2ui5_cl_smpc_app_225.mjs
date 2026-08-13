// the sorter inside the raw binding-info string really sorts: unsorted, the
// first row would be "Notebook Basic 15" (the model's first record)
export default async (page, expect) => {
  const first = page.locator('.sapMListTblRow:not(.sapMListTblHeader)').first();
  await expect(first, 'the first table row after the NAME sorter').toContainText('10" Portable DVD player');
};
