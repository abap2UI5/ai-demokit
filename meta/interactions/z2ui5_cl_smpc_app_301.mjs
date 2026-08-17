export default async (page) => {
  const t = (sel, n=8) => page.locator(sel).allInnerTexts().then(a => JSON.stringify(a.filter(Boolean).slice(0,n)));
  console.log('  BTN', await t('button'));
  console.log('  TITLE', await t('.sapMTitle,.sapMText', 6));
  console.log('  TAB', await t('.sapMITBText,.sapTntNLI,.sapMSLITitleOnly', 8));
  console.log('  INPUT', await page.locator('input.sapMInputBaseInner').count());
};
