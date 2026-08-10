// Carousel customLayout + the set_size_limit follow-up: exactly 10 of the
// 123 bound rows render (the page indicator counts them)
export default async (page, expect) => {
  await expect(page.getByText('Notebook Basic 15', { exact: true }).first(), 'the first product card').toBeVisibleEnabled();
  // exactly 10 of the 123 bound rows become pages (the set_size_limit cap);
  // the numeric indicator counts scroll POSITIONS, so count the items
  await page.waitForFunction(
    () => document.querySelectorAll('.sapMCrslItem').length === 10,
    null,
    { timeout: 10000 },
  );
};
