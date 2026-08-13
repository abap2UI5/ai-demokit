export default async (page, expect) => {
  // the urlhelper REDIRECT with NEW_WINDOW on the Image press — the popup
  // opening on the relative Card Explorer URL is the whole wire
  const img = page.locator('.sapMImg').first();
  await expect(img, 'the Card Explorer teaser image').toBeVisibleEnabled();
  const [popup] = await Promise.all([
    page.waitForEvent('popup', { timeout: 10000 }),
    img.click(),
  ]);
  await popup.waitForLoadState('domcontentloaded').catch(() => {});
  if (!popup.url().includes('cardExplorer/index.html')) {
    throw new Error(`REDIRECT popup opened on ${popup.url()} instead of the Card Explorer URL`);
  }
  await popup.close();
};
