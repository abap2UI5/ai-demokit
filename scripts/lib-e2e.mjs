/*
 * lib-e2e — shared assertion helpers for the per-port e2e interactions.
 *
 * The interactions live as one module per port under meta/interactions/
 * (loaded by scripts/e2e-smoke.mjs); these helpers are the shared assertions
 * several of them use. Moved verbatim out of e2e-smoke.mjs when the
 * INTERACTIONS map was externalized (2026-08-10).
 */

// poll until a selector reaches at least n matches
export async function waitForCount(page, selector, n, msg) {
  const deadline = Date.now() + 10000;
  for (;;) {
    if ((await page.locator(selector).count()) >= n) return;
    if (Date.now() > deadline) throw new Error(msg);
    await new Promise((r) => setTimeout(r, 250));
  }
}

// the supplier record seeded at the model root must reach the form Inputs
export async function formFieldValues(page) {
  await waitForUi5(page, () => {
    const v = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Input').map((c) => c.getValue());
    return ['Red Point Stores', 'Main St', '31415'].every((x) => v.includes(x));
  }, 'the root-seeded supplier record never reached the form Inputs');
}

// one key press on the slider must move the bound width to 99 % — the shared
// assertion of the "controller sets a width" class (see AGENTS §10 on why the
// handle is focused through the DOM instead of clicked)
export async function sliderDrivenWidth(page, control) {
  const handle = page.locator('.sapMSliderHandle').first();
  if (!(await handle.count())) throw new Error('the width slider rendered no handle');
  await page.evaluate(() => document.querySelector('.sapMSliderHandle').focus());
  await page.keyboard.press('ArrowLeft');
  await waitForUi5(page, (name) => ui5All().some((c) => c.getMetadata().getName() === name && c.getWidth() === '99%'),
    `no ${control} width followed the slider to 99%`, control);
}

export async function valueStateRows(page, expect, control) {
  await expect(page.locator('body'), 'the row labels').toContainText(`${control} with valueState Error`);
  for (const state of ['Information', 'Success', 'Warning', 'Error']) {
    const n = await page.locator(`.sapMInputBaseContentWrapper${state}`).count();
    if (n !== 1) throw new Error(`expected exactly one ${state} row to render that state, got ${n}`);
  }
  // the bound valueStateText reaches the DOM (InputBaseRenderer always writes
  // it into the invisible -sr node, so this holds without opening the popup)
  await expect(page.locator('body'), 'the bound valueStateText of the Warning row')
    .toContainText('Warning message. This is an extra long text');
}

// in-page helpers for property assertions: `ui5All()` is only ever passed
// INTO page.evaluate (it is stringified there, so it must stay self-contained)
export function ui5All() { throw new Error('ui5All() runs in the page only'); }
export const UI5_ALL_SRC = 'const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());';
export async function waitForUi5(page, fn, msg, arg) {
  const expr = `(() => { ${UI5_ALL_SRC} return (${fn.toString()})(${JSON.stringify(arg ?? null)}); })()`;
  await page.waitForFunction(expr, undefined, { timeout: 15000 }).catch(() => { throw new Error(msg); });
}
