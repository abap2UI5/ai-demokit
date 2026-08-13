// five controller-built Message Dialogs as popup_display fragments; the OK
// button closes client-side (popup_close), so a second open must work too
export default async (page, expect) => {
  const open = async (label, text) => {
    const btn = page.getByRole('button', { name: label, exact: true }).first();
    await expect(btn, `the "${label}" button`).toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMDialog'), `the ${label} dialog`).toContainText(text);
    const ok = page.locator('.sapMDialog').getByRole('button', { name: 'OK', exact: true }).first();
    await expect(ok, 'the dialog OK button').toBeVisibleEnabled();
    await ok.click();
    await expect(page.locator('.sapMDialog'), 'the dialog after popup_close').toHaveCountBelow(1);
  };
  await open('Message Dialog', "That's OpenUI5.");
  await open('Message Dialog (Error)', 'The only error you can make is to not even try.');
};
