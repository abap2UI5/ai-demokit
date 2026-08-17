export default async (page) => {
  page.on('response', async (r) => {
    if (r.status() >= 400) {
      try { console.log('  HTTP', r.status(), (await r.text()).slice(0, 600)); } catch {}
    }
  });
  await page.getByRole('button', { name: 'Category', exact: true }).first().click();
  await page.waitForTimeout(1200);
  await page.locator('.sapMLIB', { hasText: 'Laptops' }).first().click();
  await page.waitForTimeout(600);
  await page.keyboard.press('Escape');
  await page.waitForTimeout(3000);
};
