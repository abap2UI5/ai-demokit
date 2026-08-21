// ObjectPageLayout.showFooter two-way bound, flipped by a TOGGLE_FOOTER
// round-trip. The footer starts HIDDEN as in the original, so the first press
// is the one that has to make it appear — and the second press is the half a
// single click misses: the port's first draft bound a static as_bool literal
// the round-trip could never reach, which a press-once module would have
// passed. Asserted on the layout's own property, because that IS the binding
// the deviation is about; the Accept button only proves the footer painted.
import { waitForUi5, ui5All, UI5_ALL_SRC } from '../../scripts/lib-e2e.mjs';

const readShowFooter = async (page) => page.evaluate(`(() => { ${UI5_ALL_SRC}
  const l = ui5All().find((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageLayout');
  return l ? l.getShowFooter() : null; })()`);

export default async (page, expect) => {
  await expect(page.locator('.sapUxAPObjectPageHeaderTitle'), 'the header identifier').toContainText('Denise Smith');
  if (await readShowFooter(page) !== false) throw new Error('showFooter did not start false — the footer must start hidden as in the original');

  const btn = page.getByRole('button', { name: 'Toggle Footer', exact: true }).first();
  await expect(btn, 'the Toggle Footer button').toBeVisibleEnabled();
  await btn.click();
  await waitForUi5(page, () => {
    const l = ui5All().find((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageLayout');
    return !!l && l.getShowFooter() === true;
  }, 'TOGGLE_FOOTER did not reach the bound showFooter — the footer stayed hidden');
  await expect(page.locator('.sapUxAPObjectPageFooter'), 'the footer after the round-trip').toContainText('Accept');

  await btn.click();
  await waitForUi5(page, () => {
    const l = ui5All().find((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageLayout');
    return !!l && l.getShowFooter() === false;
  }, 'the second press did not flip showFooter back — the flag latched on');
};
