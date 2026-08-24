// a ComboBox FREE-TEXT entry (the original reads the change event's value, not
// a selected key) has to reach the bound field and re-template the grid -
// typing a template UI5 does not offer in the list.
//
// No round trip is involved: this port has no event wire at all. The effect is
// pure client-side two-way binding on the ComboBox value, with the CSSGrid's
// gridTemplateRows bound to the same field.
//
// Until 2026-08-24 this module asserted only `box.inputValue()`, which is the
// DOM input's own value - the one Playwright had just typed. It was true
// whether or not the value was bound to anything, and the second assertion
// (some element carrying a sapUiLayoutCSSGrid class is visible) is true for any
// rendered grid. Neither ever read gridTemplateRows, which is the only thing
// the deviation is about, so a port with both bindings dead passed unchanged.
// Read the property off the control.
import { waitForUi5, ui5All, UI5_ALL_SRC } from '../../scripts/lib-e2e.mjs';

const templateRows = async (page) => page.evaluate(`(() => { ${UI5_ALL_SRC}
  const g = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.layout.cssgrid.CSSGrid');
  return g ? g.getGridTemplateRows() : null; })()`);

export default async (page, expect) => {
  const box = page.locator('.sapMComboBox input.sapMInputBaseInner').first();
  await expect(box, 'the rows-template ComboBox').toBeVisibleEnabled();
  const before = await box.inputValue();

  const seeded = await templateRows(page);
  if (seeded === null) throw new Error('no sap.ui.layout.cssgrid.CSSGrid on the page');
  if (seeded === '2fr 1fr 1fr') throw new Error(`the grid already carried the value under test ("${seeded}") - pick another`);

  await box.fill('2fr 1fr 1fr');
  await box.press('Enter');

  const after = await box.inputValue();
  if (after !== '2fr 1fr 1fr') throw new Error(`the free text came back as "${after}" (was "${before}")`);

  // the half that actually proves the binding: the GRID took the free text
  await waitForUi5(page, (v) => ui5All().some(
    (c) => c.getMetadata().getName() === 'sap.ui.layout.cssgrid.CSSGrid' && c.getGridTemplateRows() === v,
  ), 'the CSSGrid never took the typed gridTemplateRows', '2fr 1fr 1fr');
};
