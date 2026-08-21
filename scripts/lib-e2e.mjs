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

// The uxap ObjectPageHeader markers — the changes marker, the lock marker and
// the title-selector arrow — are INTERNAL sap.m.Buttons: no text to match on,
// a generated id ending in a known suffix (`-changes`, `-lock`, `-titleArrow`,
// each also in a `-cont` variant used when the title sits in the header
// content), and icon-only, so the harness' unthemed icon font leaves them a
// zero-size box that no actionability check passes. Dispatch the click the way
// the icon lesson prescribes rather than giving the control up.
export async function pressHeaderMarker(page, suffix) {
  const marks = page.locator(`[id$="-${suffix}"], [id$="-${suffix}-cont"]`);
  const n = await marks.count();
  if (!n) throw new Error(`the ObjectPageHeader rendered no "${suffix}" marker button`);
  for (let i = 0; i < n; i++) {
    if (await marks.nth(i).isVisible()) return marks.nth(i).dispatchEvent('click');
  }
  return marks.first().dispatchEvent('click');
}

// A Breadcrumbs control folds its links into a Select once they no longer fit,
// and at the smoke's viewport the uxap header samples do exactly that — so a
// plain getByRole('link') dies in a locator timeout that reads like a broken
// port (the same shape as the OverflowToolbar lesson). Take whichever form is
// on the page.
export async function pressBreadcrumb(page, text) {
  const link = page.locator('.sapMBreadcrumbs').getByRole('link', { name: text, exact: true }).first();
  if (await link.count() && await link.isVisible()) return link.click();
  const select = page.locator('.sapMBreadcrumbs .sapMSlt').first();
  if (!(await select.count())) throw new Error(`no breadcrumb link "${text}", and no collapsed breadcrumbs select either`);
  await select.click();
  return page.locator('.sapMSltPicker li', { hasText: text }).first().click();
}

// in-page helpers for property assertions: `ui5All()` is only ever passed
// INTO page.evaluate (it is stringified there, so it must stay self-contained)
export function ui5All() { throw new Error('ui5All() runs in the page only'); }
export const UI5_ALL_SRC = 'const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());';
export async function waitForUi5(page, fn, msg, arg) {
  const expr = `(() => { ${UI5_ALL_SRC} return (${fn.toString()})(${JSON.stringify(arg ?? null)}); })()`;
  await page.waitForFunction(expr, undefined, { timeout: 15000 }).catch(() => { throw new Error(msg); });
}
