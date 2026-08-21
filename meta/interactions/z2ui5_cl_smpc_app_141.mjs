// The a11y announce round-trip: pressing a button writes the status Text.
//
// The assertion names the PRESSED BUTTON now, which is the point: until
// 2026-08-21 the port wrote one constant sentence for all four buttons, so
// this module passed no matter which one was clicked and could not tell the
// wire from a hard-coded string. The original composes the line from the
// button's own type and text, both of which ride along as event args, so the
// Success button must produce "type Accept" and "text Success" — a value only
// a working wire can supply.
export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Success', exact: true }).first();
  await expect(btn, 'the Success button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('body'), 'the status text naming the pressed button')
    .toContainText('Button with type Accept and text Success is pressed');
  await expect(page.locator('body'), 'the sentence the original wraps it in')
    .toContainText('was sent to the invisible messaging service.');
};
