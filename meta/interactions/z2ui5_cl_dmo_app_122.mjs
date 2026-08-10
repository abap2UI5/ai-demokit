// Icon press → static client toast (the sample's stethoscope budget icon)
export default async (page, expect) => {
  const icon = page.locator('.sapUiIconPointer').first();
  await icon.waitFor({ state: 'attached', timeout: 10000 });
  // the icon sits in a zero-height row headless - dispatch the click
  await icon.dispatchEvent('click');
  await expect(page.locator('.sapMMessageToast'), 'the Over budget toast').toContainText('Over budget!');
};
