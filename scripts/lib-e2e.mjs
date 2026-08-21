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
    // measured 2026-08-21: these markers DO get a layout box (123x22) even
    // unthemed, so a real click is what fires their press — a dispatched
    // 'click' alone reaches the DOM node without ever becoming a UI5 press.
    if (await marks.nth(i).isVisible()) return marks.nth(i).click();
  }
  return dispatchMouse(marks.first());
}

// A control that measures zero in the unthemed harness cannot be clicked, and
// a lone dispatched 'click' is not enough for everything: sap.ui.table's
// pointer extension acts on the mousedown/mouseup pair, so its tree expand
// icon ignores a bare click event and only the whole sequence toggles the node
// (measured 2026-08-21 on app 364 — click alone left the tree collapsed).
export async function dispatchMouse(locator) {
  await locator.dispatchEvent('mousedown');
  await locator.dispatchEvent('mouseup');
  await locator.dispatchEvent('click');
}

// The sap.ui.table extension toolbar is an OverflowToolbar, and at the smoke's
// viewport it folds EVERY one of its controls into the "Additional Options"
// popover — so a direct locator for a toolbar control fails with "not visible"
// or a 30s timeout that reads like a broken port. This puts the wanted control
// back on screen: it returns at once if the control is already visible (the
// port may render wide enough not to overflow at all), and otherwise opens the
// overflows in turn until the control appears.
//
// Trying them IN TURN rather than taking the first is the point: a page can
// carry several OverflowToolbars — app 357 has one on the table and a second
// in the footer, so "the first Additional Options button" opens the wrong one
// and the control still never shows. A round-trip re-renders the toolbar and
// closes the popover, so call this again before each toolbar interaction.
export async function revealInOverflow(page, locator) {
  const shown = async () => (await locator.count()) && (await locator.first().isVisible());
  if (await shown()) return;
  const more = page.getByRole('button', { name: 'Additional Options' });
  const n = await more.count();
  for (let i = 0; i < n; i++) {
    await more.nth(i).click();
    await page.waitForTimeout(600);
    if (await shown()) return;
    await page.keyboard.press('Escape');
    await page.waitForTimeout(300);
  }
  throw new Error(`the control never appeared — tried ${n} overflow popover(s)`);
}

// Type into a field whose liveChange ROUND-TRIPS per keystroke. Such a wire is
// lossy, not queued: a round-trip in flight drops the events behind it, which
// is what the linter's own `live-event-roundtrip` advisory says about these
// ports. A fixed inter-key delay only makes the loss less likely, never
// impossible — measured 2026-08-21 on app 407, `pressSequentially` with a
// 300ms delay swallowed the "a" and the backend filtered on "Sles", which then
// matched nothing and produced an assertion failure that looked like a broken
// filter. So each character waits for the BOUND VALUE to catch up before the
// next one is pressed, which is deterministic instead of merely likely.
export async function typeLive(page, locator, text, idSuffix) {
  const read = () => page.evaluate(`(() => { ${UI5_ALL_SRC}
    const f = ui5All().find((c) => c.getId().endsWith(${JSON.stringify(idSuffix)}));
    return f ? f.getValue() : null; })()`);
  await locator.click();
  for (let i = 0; i < text.length; i++) {
    const want = text.slice(0, i + 1);
    let settled = false;
    for (let attempt = 0; attempt < 4 && !settled; attempt++) {
      await locator.press(text[i]);
      await page.waitForTimeout(900); // land AND settle: a late echo arrives here, not later
      settled = (await read()) === want;
      if (!settled) await locator.fill(text.slice(0, i)); // put the prefix back and retry
    }
    if (!settled) {
      throw new Error(`the live field never settled on "${want}" — the round-trip keeps overwriting the typed value`);
    }
  }
}

// A uxap ObjectPageHeaderActionButton renders ICON-ONLY in the header: its
// text is not painted and the button's accessible name comes from the TOOLTIP
// instead, so getByRole('button', { name: <the button's text> }) matches
// nothing at all (measured 2026-08-21 on app 408, where the "toggle title"
// button answers to "synchronize"). Resolve it through the control registry,
// which is the only place its text still exists.
export async function pressHeaderAction(page, text) {
  const id = await page.evaluate(`(() => { ${UI5_ALL_SRC}
    const b = ui5All().find((c) => /ActionButton$/.test(c.getMetadata().getName())
      && c.getText && c.getText() === ${JSON.stringify(text)});
    return b ? b.getId() : null; })()`);
  if (!id) throw new Error(`the header has no action button with text "${text}"`);
  return page.locator(`[id="${id}"]`).first().click();
}

// A Breadcrumbs control folds its links into a Select once they no longer fit,
// and at the smoke's viewport the uxap header samples do exactly that — so a
// plain getByRole('link') dies in a locator timeout that reads like a broken
// port (the same shape as the OverflowToolbar lesson). Take whichever form is
// on the page.
// Located by TEXT, never by role+name: a Breadcrumbs link renders as
// `<a aria-labelledby="<itself> <the current-location text>">`, so its
// ACCESSIBLE NAME is its own text plus the trailing location — and
// getByRole('link', { name, exact: true }) therefore matches nothing at all
// (measured 2026-08-21 on app 416: byRole 0 hits, byText 1).
export async function pressBreadcrumb(page, text) {
  const link = page.locator('.sapMBreadcrumbs').getByText(text, { exact: true }).first();
  if ((await link.count()) && (await link.isVisible())) return link.click();
  const select = page.locator('.sapMBreadcrumbs .sapMSlt').first();
  if (!(await select.count())) throw new Error(`no breadcrumb link "${text}", and no collapsed breadcrumbs select either`);
  await select.click();
  return page.locator('.sapMSltPicker li', { hasText: text }).first().click();
}

// in-page helpers for property assertions: `ui5All()` is only ever passed
// INTO page.evaluate (it is stringified there, so it must stay self-contained)
export function ui5All() { throw new Error('ui5All() runs in the page only'); }
export const UI5_ALL_SRC = 'const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());';
// A predicate that THROWS is not a predicate that is false. waitForFunction
// rejects either way, and swallowing the reason turns a broken assertion into a
// confident lie about the port: app 351's Remove wire reported itself as
// "never shrank the bound contentAreas aggregation" for three runs while a
// direct dump after the same press showed it had shrunk — the predicate was
// calling getDomRef() on a control the re-render had already destroyed, which
// throws. So a rejection that is not a timeout keeps its own message.
export async function waitForUi5(page, fn, msg, arg) {
  const expr = `(() => { ${UI5_ALL_SRC} return (${fn.toString()})(${JSON.stringify(arg ?? null)}); })()`;
  await page.waitForFunction(expr, undefined, { timeout: 15000 }).catch((e) => {
    const why = String(e && e.message);
    if (/Timeout .* exceeded/.test(why)) throw new Error(msg);
    throw new Error(`${msg} — but the check itself failed: ${why.split('\n')[0].slice(0, 140)}`);
  });
}
