export default async (page) => {
  const j = (a) => JSON.stringify(a.filter(Boolean).slice(0,8));
  console.log('  BTN', j(await page.locator('button').allInnerTexts()));
  console.log('  TXT', j(await page.locator('.sapMText,.sapMTitle,.sapMLabel').allInnerTexts()));
};
