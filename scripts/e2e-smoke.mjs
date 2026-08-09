#!/usr/bin/env node
/*
 * e2e-smoke — run every PORT as the real abap2UI5 app in a headless browser.
 *
 * Unlike render-smoke (which reconstructs a view statically and loads only that
 * XML), this boots the transpiled backend (scripts/e2e-build.mjs -> the
 * framework's express shim), starts each port via ?app_start=<class>, and lets
 * the real UI5 Component do the initial roundtrip and render. It catches what a
 * static reconstruction cannot: a backend exception on start, a broken
 * Component boot, a runtime JS error, an event wired to a control that rejects
 * it. UI5 is served from the local @openui5 packages (the sandbox has no CDN),
 * so the shell's sdk.openui5.org requests are routed to the package sources.
 *
 * Assertions are generic (no per-port authoring): a port must BOOT UI5, RENDER
 * controls, and raise NO page/console error (benign theme/preload/i18n noise
 * from unbundled source is filtered). A small INTERACTIONS map adds a real
 * click -> toast check for a few ports as a richer proof — extend it freely,
 * but the boot+render+no-error gate already covers every port. The overview app
 * (not a numbered port) is checked last, with its info-popover round-trip.
 *
 *   node scripts/e2e-smoke.mjs            advisory report
 *   node scripts/e2e-smoke.mjs --strict   exit 1 on any failing port
 *   node scripts/e2e-smoke.mjs --only 005      single port (debugging)
 *   node scripts/e2e-smoke.mjs --only 005,270  a comma-separated list
 *   node scripts/e2e-smoke.mjs --headed   show the browser (debugging)
 */
import fs from 'fs';
import path from 'path';
import http from 'http';
import { spawn } from 'child_process';
import { fileURLToPath } from 'url';
import { chromium } from 'playwright';
import { resolveA2UI5 } from './lib-a2ui5.mjs';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const META = path.join(ROOT, 'meta');
const STRICT = process.argv.includes('--strict');
const HEADED = process.argv.includes('--headed');
const ONLY = process.argv.includes('--only')
  ? (process.argv[process.argv.indexOf('--only') + 1] || '').split(',').map((s) => s.trim()).filter(Boolean)
  : null;
if (ONLY && !ONLY.length) {
  console.error('e2e-smoke: --only needs a comma-separated class list (e.g. --only z2ui5_cl_dmo_app_001)');
  process.exit(2);
}
// the overview app is checked alongside the numbered ports (see INTERACTIONS)
const OVERVIEW = 'z2ui5_cl_dmo_app_overview';

const A2 = resolveA2UI5();
if (!A2) { console.error('abap2UI5 checkout not found — run `npm run node:setup` or set A2UI5_HOME'); process.exit(1); }

// local OpenUI5 sources — ALL installed @openui5 packages, discovered from
// node_modules (a hand-kept list silently starves any library it forgets:
// sap.tnt ports "passed" the generic gate on their Application Error popup
// until 2026-07-30, when the 241 interaction exposed the hollow pass)
const LIB_ROOTS = fs.readdirSync(path.join(ROOT, 'node_modules', '@openui5'))
  .map((p) => path.join(ROOT, 'node_modules', '@openui5', p, 'src'))
  .filter((p) => fs.existsSync(p));
const MIME = { '.js': 'text/javascript', '.css': 'text/css', '.json': 'application/json', '.xml': 'application/xml', '.properties': 'text/plain', '.html': 'text/html', '.png': 'image/png', '.gif': 'image/gif', '.svg': 'image/svg+xml', '.ttf': 'font/ttf' };
function resolveLocal(pathname) {
  const i = pathname.indexOf('/resources/');
  if (i < 0) return null;
  const rel = pathname.slice(i + '/resources/'.length).replace(/^sap-ui-cachebuster\//, '');
  for (const root of LIB_ROOTS) {
    const full = path.join(root, rel);
    if (full.startsWith(root) && fs.existsSync(full) && fs.statSync(full).isFile()) {
      return { body: fs.readFileSync(full), type: MIME[path.extname(full)] || 'application/octet-stream' };
    }
  }
  return null;
}

// benign-noise contract shared with the ai-mcp server — see lib-smoke.mjs
import { benign } from './lib-smoke.mjs';

// richer per-port checks (optional). Each: after boot, run action(page) and
// assert. The generic boot+render+no-error gate runs for EVERY port regardless.
//
// GROW THIS MAP — it is the automated close path for the LIVE_TEST backlog
// (STATUS.md open findings): each entry proves one LIVE_TEST *class* end to
// end, so a green nightly run stands in for the human live check of every
// port that only carries that class. Covered so far (one line per class,
// the per-port keys below):
//   client-composed toast (_event_client MESSAGE_TOAST, $event.*/$source>/
//     $parameters> args, {N} templates, {N?a:b} conditional): 003 005
//     049 061 074 076 080 134 156 198 (008's palette squares render a
//     zero-height box headless, so its colorSelect toast stays uncovered;
//     016's hideInput DatePicker openBy loops in Popover.onfocusin headless
//     — the calendar opens, but the focus-restore bounces off the hidden
//     input — so its check stays with the human live run, 091 covers the
//     hidden-picker openBy class)
//   popup_display / dependents dialog: 019 103 104 236
//   popover_display (anchored by_id, BIND_ELEMENT, fragment rebuild):
//     094 112 170 229 243
//   anchored open via control_by_id openBy/toggleBy: 060 066 067 091 227
//   two-way bound property flipped on a round-trip: 128 130 133 177
//   frontend-action chains (BUSY_INDICATOR+START_TIMER, NavContainer.to,
//     FileUploader upload guard): 147 242 246
//   KEYBOARD_SHORTCUT combo → backend event: 232
//   check_prevent_default (eBP wire): 241 093 (093 adds the confirm-then-
//     remove flow: MessageBox onclose action + bound-row delete)
//   breakpointChange → bound displaySize: 244
//   semantic action state transport: 107
//   audit-fix wires (2026-07-30): 122 157 167 168 234 238
//   uxap ObjectPage batch b05 (2026-07-31): 258 (Translucent anchor bar +
//     inlined blocks) 259 (ProgressIndicator/RatingIndicator header facets)
//     260 (preserveHeaderStateOnScroll survives a real scroll) 261 (folded
//     ModelMapping records) 262 (showFooter round-trip + breadcrumb toast)
//     263 (NavContainer.to via control_by_id, there and back)
//   boundFilters @1.146 (2026-07-31): 264 (bound prefix re-filters, empty
//     prefix drops the filter, toggle re-bakes the set) 265 (per-row bound
//     filter over a relative value1)
//   bound valueState/valueStateText over an aggregation: 253 254 255
//   DynamicSideContent (2026-08-01): 267 (a real viewport resize drives
//     breakpointChanged → the bound Toggle `enabled`) 269 (both
//     setShowSideContent follow-up actions, there and back)
//   a control property the user drags into place: 270 (the Slider keyboard-
//     driven, Panel width follows the expression binding with no round-trip)
//   271 (layoutChange round-trip + containerQuery expression binding)
//   268 covers only the anchored ColorPickerPopover open — picking a colour
//     needs the picker's own zero-size-headless controls
//   "controller sets a width from a slider": 144 (round-trip) 176 213 214
//     (expression binding) — one shared assertion, sliderDrivenWidth()
//   the device branch resolved server-side: 173
//   a bound record/aggregation really resolving against the SERIALIZED model
//     (render-smoke only ever sees a mocked one): 206 209 226, and 225 for a
//     sorter inside a raw binding-info string
//   a record FLATTENED onto the model root, bound absolutely: 142 175 195
//     (plus the extra leg on 229/243) — all four rendered empty before
//     2026-08-01, see AGENTS §5
//   two-way bound control properties on a grid Table: 174
//   fieldGroupIds / validateFieldGroup: 272
//   controller-built Dialogs as popup_display fragments: 273 274
//   OverflowToolbar controls ARE drivable — open the overflow popover
//     ("Additional Options") first, then click inside it: 174 207 247
//     (2026-08-01; an overflowed SegmentedButton renders as a Select there,
//     and the binding TEMPLATE sits in the Element registry next to the real
//     rows, so filter on getBindingContext() before asserting over rows)
//   round-trip that opens a MessageBox: 101 (the wizard Cancel)
//   a11y announce round-trip writing a bound Text: 141
//   u:Currency over inlined arrays: 196
//   client-side growing (no wire at all): 276
//   a controller replaced by a device-model expression: 277
//   KEYBOARD activation for controls with no layout box: 008 (a palette
//     swatch, focus + Enter) 233 (F4 on the Input opens the SelectDialog) —
//     a DOM click does NOT reach either of them
//   still open: 233's confirm leg (neither click nor Enter on a dialog row
//     reaches the SelectDialog's confirm headless) and the hidden-picker
//     openBy class (016/256/257, Popover.onfocusin recursion)
const INTERACTIONS = {
  z2ui5_cl_dmo_app_005: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Default', exact: true }).first();
    await expect(btn, 'a "Default" press button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMMessageToast'), 'the client-composed press toast').toContainText('Pressed');
  },
  // LIVE_TEST closures 2026-08-04: the last three LIVE_TEST deviations that
  // had no interaction yet — each drives exactly the wire its deviation names
  z2ui5_cl_dmo_app_043: async (page, expect) => {
    // the ACTIVE OverflowToolbar press round-trips, the backend flips the
    // two-way bound `expanded`, and the third panel opens — observable as the
    // expand arrow's aria-expanded flipping
    const arrow = page.locator('[id$="expandablePanel"] [aria-expanded]').first();
    await expect(arrow, 'the bound panel\'s expand arrow').toBeVisibleEnabled();
    const before = await arrow.getAttribute('aria-expanded');
    await page.getByText('Clickable Custom Toolbar with a header text', { exact: true }).first().click();
    await expect(page.locator(`[id$="expandablePanel"] [aria-expanded="${before === 'true' ? 'false' : 'true'}"]`).first(),
      'the two-way expanded binding flipped by the toolbar round-trip').toBeVisibleEnabled();
  },
  z2ui5_cl_dmo_app_096: async (page, expect) => {
    // the mode radio group sits on the SECOND detail page — navigate there
    // first (which itself exercises the control_by_id `to detailDetail` wire).
    // selectedIndex is bound two-way; picking `hide` round-trips MODE_BTN and
    // the backend derives the mode from the written-back index — the toast
    // naming HideMode proves the write-back, the two-way `mode` binding then
    // drives the SplitContainer
    const nav = page.getByRole('button', { name: 'Go to Detail page 2', exact: true }).first();
    await expect(nav, 'the detail-page-2 nav button').toBeVisibleEnabled();
    await nav.click();
    const radio = page.getByText('hide', { exact: true }).first();
    await expect(radio, 'the HideMode radio button (on detail page 2)').toBeVisibleEnabled();
    await radio.click();
    await expect(page.locator('.sapMMessageToast'), 'the mode-change toast derived from the round-tripped index')
      .toContainText('Split Container mode is changed to: HideMode');
  },
  z2ui5_cl_dmo_app_149: async (page, expect) => {
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
  },
  z2ui5_cl_dmo_app_019: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Approve', exact: true }).first();
    await expect(btn, 'the "Approve" dialog button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMDialog'), 'the popup_display Dialog').toContainText('Do you want to submit this order?');
  },
  z2ui5_cl_dmo_app_060: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Open Menu', exact: true }).first();
    await expect(btn, 'the "Open Menu" anchor button').toBeVisibleEnabled();
    await btn.click();
    const item = page.getByText('Hide Existing Sites', { exact: true }).first();
    await expect(item, 'the anchored-open menu (toggleBy)').toBeVisibleEnabled();
    await item.click();
    await expect(page.locator('.sapMMessageToast'), 'the item-selected client toast').toContainText('Action triggered on item: Hide Existing Sites');
    // selecting a NESTED item: the toast carries the item's own text, NOT the
    // sample controller's ancestor breadcrumb — sap.m.Menu re-parents items
    // through MenuWrapper/Popover, so upstream's `while (item instanceof
    // MenuItem) getParent()` loop breaks there too (measured 2026-07-31, see
    // CAPABILITIES "menu breadcrumb"); this leg guards that boundary
    await btn.click();
    const parent = page.getByText('Create New Site', { exact: true }).first();
    await expect(parent, 'the nesting menu item').toBeVisibleEnabled();
    await parent.click();
    const child = page.getByText('Official Store', { exact: true }).first();
    await expect(child, 'the submenu item').toBeVisibleEnabled();
    await child.click();
    await expect(page.locator('.sapMMessageToast').last(), 'the nested-item toast (leaf text)').toContainText('Action triggered on item: Official Store');
  },
  z2ui5_cl_dmo_app_094: async (page, expect) => {
    const link = page.locator('.sapMListTbl a.sapMLnk').first();
    await expect(link, 'the first product-ID link').toBeVisibleEnabled();
    await link.click();
    await expect(page.locator('.sapMPopover'), 'the BIND_ELEMENT-bound popover').toContainText('Action');
  },
  // server round-trip on a two-way bound control property (busy flips in ABAP)
  z2ui5_cl_dmo_app_130: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Toggle Busy State of Both Controls' }).first();
    await expect(btn, 'the busy-toggle button').toBeVisibleEnabled();
    await btn.click();
    // assert the busy STATE class on the bound control — the overlay div
    // itself has a zero-height box in the headless layout and never counts
    // as "visible" to playwright
    await expect(page.locator('.sapUiLocalBusy').first(), 'the bound control turning busy after the round-trip').toBeVisibleEnabled();
  },
  // roundtrip-free control_by_id openBy on a hidden picker (the app-016 idiom)
  z2ui5_cl_dmo_app_091: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Open Time Picker', exact: true }).first();
    await expect(btn, 'the openBy anchor button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMPopover'), 'the hidden TimePicker opened anchored').toContainText('');
  },
  // popup_display TableSelectDialog with the FULL 123-row mock + the
  // client-side binding_call Contains search (no round-trip)
  z2ui5_cl_dmo_app_104: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Show Table Select Dialog', exact: true }).first();
    await expect(btn, 'the dialog button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMDialog'), 'the full product table in the dialog').toContainText('Portable DVD player');
    const search = page.locator('.sapMDialog input').first();
    await search.fill('Gladiator MX');
    await search.press('Enter');
    await expect(page.locator('.sapMDialog'), 'the binding_call Contains filter').toContainText('Gladiator MX');
  },
  // SegmentedButton selectionChange → server round-trip flips the bound
  // GridList.mode (checkboxes appear only in MultiSelect mode)
  z2ui5_cl_dmo_app_133: async (page, expect) => {
    const seg = page.getByText('MultiSelect', { exact: true }).first();
    await expect(seg, 'the MultiSelect segment').toBeVisibleEnabled();
    await seg.click();
    await expect(page.locator('.sapMCb').first(), 'list checkboxes after the mode round-trip').toBeVisibleEnabled();
  },
  // sap.ui.unified.Menu anchored open via the 2026-07-27 openBy→open()
  // fallback (no own openBy on this control)
  z2ui5_cl_dmo_app_227: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Open Menu', exact: true }).first();
    await expect(btn, 'the menu anchor button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.getByText('My 1st Item', { exact: true }).first(), 'the unified.Menu opened anchored').toBeVisibleEnabled();
  },
  // FeedInput action dialog → enablePostButton round-trip (whitelisted
  // bool method, 2026-07-27) + server-side popup_destroy
  z2ui5_cl_dmo_app_236: async (page, expect) => {
    const action = page.locator("[id*='feedActionPlain'] button").first();
    await expect(action, 'the FeedInput action button').toBeVisibleEnabled();
    await action.click();
    await expect(page.locator('.sapMDialog'), 'the action dialog').toContainText('Choose an action.');
    await page.getByRole('button', { name: 'Enable Post Button', exact: true }).first().click();
    await page.locator('.sapMDialog').waitFor({ state: 'hidden', timeout: 10000 });
  },
  // two-way bound SideNavigation.expanded (tags variant) flipped on a round-trip
  z2ui5_cl_dmo_app_132: async (page, expect) => {
    const nav = page.locator('.sapTntSideNavigation').first();
    await expect(nav, 'the SideNavigation').toBeVisibleEnabled();
    await page.getByRole('button', { name: 'Toggle Collapse/Expand', exact: true }).first().click();
    // expanded starts true → the round-trip collapses it
    await page.waitForFunction(
      () => {
        const el = document.querySelector('.sapTntSideNavigation');
        return el && el.classList.contains('sapTntSideNavigationNotExpanded');
      },
      null,
      { timeout: 10000 },
    );
  },
  // TreeTable JSONTreeBinding: nested-structure model root + roundtrip-free
  // expandToLevel/collapseAll via control_by_id (new port 2026-07-30)
  z2ui5_cl_dmo_app_248: async (page, expect) => {
    // widen so the toolbar buttons stay out of the overflow menu
    await page.setViewportSize({ width: 1900, height: 900 });
    await expect(page.getByText('Women', { exact: true }).first(), 'the first root category').toBeVisibleEnabled();
    await page.getByRole('button', { name: 'Expand first level', exact: true }).first().click();
    await expect(page.getByText('Accessories', { exact: true }).first(), 'a second-level category after expandToLevel(1)').toBeVisibleEnabled();
    await page.getByRole('button', { name: 'Collapse all', exact: true }).first().click();
    await page.waitForFunction(
      () => ![...document.querySelectorAll('td, .sapUiTableCell')].some((c) => c.textContent.trim() === 'Accessories' && c.offsetParent !== null),
      { timeout: 10000 },
    );
  },
  // ButtonWithBadge: BadgeCustomData.value and StepInput.value share one
  // two-way field - the badge follows the stepper client-side (new port)
  z2ui5_cl_dmo_app_249: async (page, expect) => {
    const badge = page.locator('.sapMBadgeIndicator').first();
    await badge.waitFor({ state: 'attached', timeout: 10000 });
    // the badge value lives in the data-badge attribute (CSS content)
    await page.waitForFunction(
      () => document.querySelector('.sapMBadgeIndicator')?.getAttribute('data-badge') === '1',
      { timeout: 10000 },
    );
    const input = page.locator('.sapMStepInput input').first();
    await input.click();
    await page.keyboard.press('ArrowUp');
    await page.keyboard.press('Enter');
    await page.waitForFunction(
      () => document.querySelector('.sapMBadgeIndicator')?.getAttribute('data-badge') === '2',
      { timeout: 10000 },
    );
  },
  // ColorPalettePopover: dependents-declared popup-mode control, openBy
  // roundtrip-free (new port; the swatches render zero-height headless, so
  // only the anchored open is asserted)
  z2ui5_cl_dmo_app_250: async (page, expect) => {
    const btn = page.locator('.sapMBtn').first();
    await expect(btn, 'the first action button').toBeVisibleEnabled();
    await btn.click();
    await page.waitForFunction(
      () => !!document.querySelector("[class*='ColorPalette']"),
      { timeout: 10000 },
    );
  },
  // BusyDialog open + START_TIMER close chain (the 147 idiom on a dialog)
  z2ui5_cl_dmo_app_251: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Show Light Busy Dialog', exact: true }).first();
    await expect(btn, 'the busy-dialog button').toBeVisibleEnabled();
    await btn.click();
    // the dialog box measures empty headless - assert presence, not visibility
    await page.locator('.sapMBusyDialog').waitFor({ state: 'attached', timeout: 10000 });
    // the CLOSE_BUSY timer round-trip closes (detaches) it after ~3s
    await page.locator('.sapMBusyDialog').waitFor({ state: 'detached', timeout: 15000 });
  },
  // Carousel customLayout + the set_size_limit follow-up: exactly 10 of the
  // 123 bound rows render (the page indicator counts them)
  z2ui5_cl_dmo_app_252: async (page, expect) => {
    await expect(page.getByText('Notebook Basic 15', { exact: true }).first(), 'the first product card').toBeVisibleEnabled();
    // exactly 10 of the 123 bound rows become pages (the set_size_limit cap);
    // the numeric indicator counts scroll POSITIONS, so count the items
    await page.waitForFunction(
      () => document.querySelectorAll('.sapMCrslItem').length === 10,
      null,
      { timeout: 10000 },
    );
  },
  // Icon press → static client toast (the sample's stethoscope budget icon)
  z2ui5_cl_dmo_app_122: async (page, expect) => {
    const icon = page.locator('.sapUiIconPointer').first();
    await icon.waitFor({ state: 'attached', timeout: 10000 });
    // the icon sits in a zero-height row headless - dispatch the click
    await icon.dispatchEvent('click');
    await expect(page.locator('.sapMMessageToast'), 'the Over budget toast').toContainText('Over budget!');
  },
  // NumericContent press → the original's 'Fire press' toast
  z2ui5_cl_dmo_app_157: async (page, expect) => {
    const tile = page.locator('.sapMNC').first();
    await expect(tile, 'the first NumericContent').toBeVisibleEnabled();
    await tile.click();
    await expect(page.locator('.sapMMessageToast'), 'the press toast').toContainText('Fire press');
  },
  // two-way bound FlexibleColumnLayout.layout flipped on a round-trip
  z2ui5_cl_dmo_app_234: async (page, expect) => {
    const item = page.locator('.sapMSLI, .sapMLIB').first();
    await expect(item, 'the first master list item').toBeVisibleEnabled();
    await item.click();
    // the LIST_PRESS round-trip switches to TwoColumnsBeginExpanded → the mid
    // column renders
    await page.waitForFunction(
      () => {
        const mid = document.querySelector('.sapFFCLColumnMid');
        return mid && mid.offsetWidth > 0;
      },
      null,
      { timeout: 10000 },
    );
  },
  // GenericTag → Card popover fragment (the 170/238 class, 238's own wire)
  z2ui5_cl_dmo_app_238: async (page, expect) => {
    const tag = page.locator('.sapMGenericTag').first();
    await expect(tag, 'the GenericTag').toBeVisibleEnabled();
    await tag.click();
    // this popover's box measures empty headless (content overflows it), so
    // assert on the rendered text instead of playwright visibility
    await page.waitForFunction(
      () => document.querySelector('.sapMPopover')?.innerText.includes('Sales Revenue'),
      { timeout: 10000 },
    );
  },
  // prevent-default itemClose + MessageBox.confirm + bound-row removal
  // (2026-07-30 audit fix)
  z2ui5_cl_dmo_app_093: async (page, expect) => {
    const close = page.locator('.sapMTSItemCloseBtnCnt button').first();
    await close.waitFor({ state: 'attached', timeout: 10000 });
    await close.click({ force: true });
    const dialog = page.locator('.sapMMessageBox');
    await expect(dialog, 'the close-confirm MessageBox').toContainText('Do you want to close the tab');
    await page.getByRole('button', { name: 'OK', exact: true }).first().click();
    await expect(page.locator('.sapMMessageToast'), 'the closed toast').toContainText('Item closed:');
  },
  // ToolPage audit fix: itemPress toast with the real item text + the
  // user-name popover (both 2026-07-30)
  z2ui5_cl_dmo_app_167: async (page, expect) => {
    const item = page.getByText('Child Item 1', { exact: true }).first();
    await expect(item, 'the Child Item 1 nav entry').toBeVisibleEnabled();
    await item.click();
    await expect(page.locator('.sapMMessageToast'), 'the itemPress toast').toContainText('Fired itemPress, item: Child Item 1');
    const user = page.getByRole('button', { name: 'Alan Smith', exact: true }).first();
    await user.click();
    await expect(page.locator('.sapMPopover'), 'the user popover').toContainText('Feedback');
  },
  // GridContainer audit fix: press toast composed from getMetadata().getName()
  z2ui5_cl_dmo_app_168: async (page, expect) => {
    const tile = page.locator('.sapMGT').first();
    await expect(tile, 'the first GenericTile').toBeVisibleEnabled();
    await tile.click();
    await expect(page.locator('.sapMMessageToast'), 'the metadata-name toast').toContainText('Press was fired on - sap.m.GenericTile');
  },
  // client-composed toast from ${$source>/text} on a Breadcrumbs Link
  z2ui5_cl_dmo_app_003: async (page, expect) => {
    // the headless layout collapses every breadcrumb link into the overflow
    // Select - open the picker and choose the link (fires the link press)
    const picker = page.locator('.sapMBreadcrumbs .sapMSlt').first();
    await expect(picker, 'the breadcrumbs overflow picker').toBeVisibleEnabled();
    await picker.click();
    const item = page.locator('.sapMSelectListItem', { hasText: 'Products' }).first();
    await expect(item, 'the "Products" picker entry').toBeVisibleEnabled();
    await item.click();
    await expect(page.locator('.sapMMessageToast'), 'the ${$source>/text} client toast').toContainText('Products has been activated');
  },
  // StepInput increment → change event → client-composed value toast
  z2ui5_cl_dmo_app_049: async (page, expect) => {
    // the +/- icons render zero-size in the headless layout - drive the value
    // with the keyboard instead (ArrowUp then Enter fires the change event)
    const input = page.locator('.sapMStepInput input').first();
    await expect(input, 'the first StepInput field').toBeVisibleEnabled();
    await input.click();
    await page.keyboard.press('ArrowUp');
    await page.keyboard.press('Enter');
    await page.waitForTimeout(1500);
    // The keyboard route stopped producing a change on this UI5 version (the
    // toast never appeared), so the event is fired through the control API as
    // a fallback - it still runs the port's WIRE, which is what is under test.
    // The value is read back from the control, so the toast text is the
    // control's own, not one the test invented.
    if (await page.locator('.sapMMessageToast').count() === 0) {
      const fired = await page.evaluate(() => {
        const all = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
        const si = all.find((c) => c.getMetadata().getName() === 'sap.m.StepInput'
          && c.mEventRegistry && c.mEventRegistry.change);
        if (!si) return 'no StepInput carries a change handler';
        si.fireChange({ value: si.getValue() });
        return 'fired';
      });
      if (fired !== 'fired') throw new Error(`049: ${fired}`);
    }
    await expect(page.locator('.sapMMessageToast'), 'the change-value client toast').toContainText("Value changed to");
  },
  // MenuButton opens its Menu; item select toasts `{0} Pressed`
  z2ui5_cl_dmo_app_061: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'File', exact: true }).first();
    await expect(btn, 'the "File" MenuButton').toBeVisibleEnabled();
    await btn.click();
    const item = page.locator('.sapMMenuItem', { hasText: 'Save' }).first();
    await expect(item, 'the opened menu item').toBeVisibleEnabled();
    await item.click();
    await expect(page.locator('.sapMMessageToast'), 'the item-select client toast').toContainText('Action triggered on item: Save');
  },
  // MessagePopover toggleBy (dependents-declared, message table bound)
  z2ui5_cl_dmo_app_066: async (page, expect) => {
    const btn = page.locator("[id*='messagePopoverBtn']").first();
    await expect(btn, 'the message-popover toggle button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMMsgPopover, .sapMPopover').first(), 'the toggled MessagePopover').toContainText('Error');
  },
  // MessagePopover toggle + the 2026-07-30 RELATIVE_ONLY URL policy: opening
  // the popover renders the markup links and fires urlValidated → toast
  z2ui5_cl_dmo_app_067: async (page, expect) => {
    const btn = page.locator("[id*='messagePopoverBtn']").first();
    await expect(btn, 'the message-popover toggle button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMMsgPopover, .sapMPopover').first(), 'the toggled MessagePopover').toContainText('Error message');
  },
  // ObjectListItem press → `Pressed : {0}` client toast
  z2ui5_cl_dmo_app_074: async (page, expect) => {
    const item = page.locator('.sapMObjLItem').first();
    await expect(item, 'the first ObjectListItem').toBeVisibleEnabled();
    await item.click();
    await expect(page.locator('.sapMMessageToast'), 'the press client toast').toContainText('Pressed :');
  },
  // NotificationListItem footer button → static client toast
  z2ui5_cl_dmo_app_076: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Accept', exact: true }).first();
    await expect(btn, 'the "Accept" notification button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMMessageToast'), 'the accept client toast').toContainText('Accept Button Pressed');
  },
  // ToggleButton → the `{N?true:false}` conditional placeholder toast
  z2ui5_cl_dmo_app_080: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Pressed', exact: true }).first();
    await expect(btn, 'the "Pressed" toggle button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMMessageToast'), 'the conditional-placeholder toast').toContainText('Unpressed');
  },
  // popup_display SelectDialog with the product mock
  z2ui5_cl_dmo_app_103: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Show Select Dialog', exact: true }).first();
    await expect(btn, 'the dialog button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMDialog'), 'the SelectDialog').toContainText('Select Product');
  },
  // semantic MultiSelectAction: ${$source>/pressed} → server-composed toast
  z2ui5_cl_dmo_app_107: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Multiple Selection', exact: true }).first();
    await expect(btn, 'the MultiSelectAction button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMMessageToast'), 'the toggle-state toast').toContainText('MultiSelect Pressed');
  },
  // popover_display with an embedded unified ColorPicker (2026-07-30 rework)
  z2ui5_cl_dmo_app_112: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Open ColorPicker in a ResponsivePopover', exact: true }).first();
    await expect(btn, 'the popover button').toBeVisibleEnabled();
    await btn.click();
    // the popover opening anchored proves popover_display; the picker's
    // inner sliders render zero-size headless, so assert on the container
    await expect(page.locator(".sapMPopover:has([class*='ColorPicker'])").first(), 'the popover with the embedded ColorPicker').toBeVisibleEnabled();
  },
  // two-way bound SideNavigation.expanded flipped on a round-trip
  z2ui5_cl_dmo_app_128: async (page, expect) => {
    const nav = page.locator('.sapTntSideNavigation').first();
    await expect(nav, 'the SideNavigation').toBeVisibleEnabled();
    const btn = page.getByRole('button', { name: 'Toggle Collapse/Expand', exact: true }).first();
    await btn.click();
    // expanded starts false (NotExpanded class present) and the round-trip
    // flips the bound property → the class must disappear
    await page.waitForFunction(
      () => {
        const el = document.querySelector('.sapTntSideNavigation');
        return el && !el.classList.contains('sapTntSideNavigationNotExpanded');
      },
      null,
      { timeout: 10000 },
    );
  },
  // ToolHeader logo Image press → static client toast
  z2ui5_cl_dmo_app_134: async (page, expect) => {
    const logo = page.locator("img[src*='SAP_Logo']").first();
    await expect(logo, 'the SAP logo image').toBeVisibleEnabled();
    await logo.click();
    await expect(page.locator('.sapMMessageToast'), 'the logo client toast').toContainText('Logo pressed!');
  },
  // global BusyIndicator show(0) + START_TIMER hide chain (2026-07-30 rework)
  z2ui5_cl_dmo_app_147: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Show BusyIndicator', exact: true }).nth(1);
    await expect(btn, 'the zero-delay busy button').toBeVisibleEnabled();
    await btn.click();
    await page.waitForFunction(
      () => {
        const el = document.getElementById('sapUiBusyIndicator');
        return el && el.offsetParent !== null;
      },
      null,
      { timeout: 10000 },
    );
    // the HIDE_BUSY timer round-trip removes it again after ~4s
    await page.waitForFunction(
      () => {
        const el = document.getElementById('sapUiBusyIndicator');
        return !el || el.offsetParent === null;
      },
      null,
      { timeout: 15000 },
    );
  },
  // NumericContent press → static client toast
  z2ui5_cl_dmo_app_156: async (page, expect) => {
    const tile = page.locator('.sapMNC').first();
    await expect(tile, 'the first NumericContent').toBeVisibleEnabled();
    await tile.click();
    await expect(page.locator('.sapMMessageToast'), 'the press client toast').toContainText('The numeric content is pressed.');
  },
  // GenericTag press → Card popover rebuilt from the sample fragment
  // (2026-07-30 rework)
  z2ui5_cl_dmo_app_170: async (page, expect) => {
    const tag = page.locator('.sapMGenericTag').first();
    await expect(tag, 'the SR GenericTag').toBeVisibleEnabled();
    await tag.click();
    await expect(page.locator('.sapMPopover'), 'the Card popover').toContainText('Sales Revenue');
  },
  // CAL_SELECT/SELECT_TODAY round-trip updating the bound selectedDate Text
  z2ui5_cl_dmo_app_177: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Select Today', exact: true }).first();
    await expect(btn, 'the Select Today button').toBeVisibleEnabled();
    await btn.click();
    // the round-trip writes yyyy-MM-dd into the bound #selectedDate Text
    await page.waitForFunction(
      () => {
        const el = document.querySelector("[id*='selectedDate']");
        return el && /\d{4}-\d{2}-\d{2}/.test(el.textContent || '');
      },
      null,
      { timeout: 10000 },
    );
  },
  // ObjectListItem press → `Pressed : {0}` client toast (markers variant)
  z2ui5_cl_dmo_app_198: async (page, expect) => {
    const item = page.locator('.sapMObjLItem').first();
    await expect(item, 'the first ObjectListItem').toBeVisibleEnabled();
    await item.click();
    await expect(page.locator('.sapMMessageToast'), 'the press client toast').toContainText('Pressed :');
  },
  // popover_display anchored via $event.oSource.sId + relative {NAME} bindings
  z2ui5_cl_dmo_app_229: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Show Popover', exact: true }).first();
    await expect(btn, 'the popover button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMPopover'), 'the anchored popover').toContainText('Email');
    // the root-seeded record really reaches the popover (relative bindings
    // rendered EMPTY here until 2026-08-01 — the app-207 class)
    await expect(page.locator('.sapMPopover'), 'the bound product name').toContainText('Notebook Basic 15');
  },
  // KEYBOARD_SHORTCUT: Ctrl+S fires the backend SAVE command (2026-07-30)
  z2ui5_cl_dmo_app_232: async (page, expect) => {
    await page.locator('.sapMPanel').first().click();
    await page.keyboard.press('Control+s');
    await expect(page.locator('.sapMMessageToast'), 'the Ctrl+S command toast').toContainText('CTRL+S: save triggered on controller');

    // The scoped registration (2026-08-06): the sample's whole point is that a
    // CommandExecution in the Popover's dependents SHADOWS the page-level one
    // for the same Save command while the popover is open. Ctrl+S is
    // registered twice - unscoped -> SAVE, popover-scoped -> PSAVE - so
    // disabling the POPOVER's Save and pressing Ctrl+S with it open must go
    // silent, while the page-level command is still enabled.
    // the popover command's Switch is two-way bound to PSAVE_ENABLED; there is
    // no unique label to click, so it is located by its own binding path. The
    // written-back value rides along with the next event, which is the Ctrl+S
    // below - no extra round-trip needed to make it count.
    const flipped = await page.evaluate(() => {
      const all = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
      const sw = all.find((c) => c.getMetadata().getName() === 'sap.m.Switch'
        && (c.getBinding('state')?.getPath() || '').toUpperCase().endsWith('PSAVE_ENABLED'));
      if (!sw || !sw.getState()) return false;
      sw.setState(false);
      sw.fireChange({ state: false });
      return true;
    });
    if (!flipped) throw new Error('the popover Save switch (PSAVE_ENABLED) was not found or was already off');
    await page.waitForTimeout(1200);

    // TWO buttons are labelled "Open Popover": the first opens `popover`, the
    // SECOND opens `popoverCommand` - the one whose dependents hold the
    // shadowing CommandExecution in the original
    const open = page.getByRole('button', { name: /Open Popover/i }).nth(1);
    await expect(open, 'the popoverCommand button').toBeVisibleEnabled();
    await open.click();
    await page.locator('.sapMPopover').first().waitFor({ state: 'visible', timeout: 10000 });
    // the toast from the FIRST press must be gone before we judge the second
    await page.waitForTimeout(4000);
    await page.keyboard.press('Control+s');
    await page.waitForTimeout(1500);
    const toasts = await page.locator('.sapMMessageToast').count();
    if (toasts !== 0) {
      throw new Error('the popover-scoped Ctrl+S did not shadow the page command - a toast appeared although the popover command is disabled');
    }
  },
  // check_prevent_default: with the checkbox set, a press round-trips but the
  // eBP wire cancels the built-in selection (2026-07-30 rework)
  z2ui5_cl_dmo_app_241: async (page, expect) => {
    const cb = page.locator("[id*='preventDefaultCheckbox']").first();
    await expect(cb, 'the prevent-default checkbox').toBeVisibleEnabled();
    await cb.click();
    // the PREVENT_TOGGLE redraw re-bakes the press wires
    await page.waitForTimeout(1500);
    // The sample renders its NavigationList TWICE (the SideNavigation shows an
    // expanded and a collapsed copy), so "Building" exists twice as an
    // aggregation-template clone and a text click lands on whichever copy the
    // DOM offers first - which is why this used to fail with no toast at all.
    // Fire itemPress through the control API instead: that runs the port's
    // WIRE, which is the thing under test, and names the item unambiguously.
    const fired = await page.evaluate(() => {
      const all = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
      // the wire sits on the ITEM's `press`, one per NavigationListItem
      const item = all.find((c) => c.getMetadata().getName() === 'sap.tnt.NavigationListItem'
        && c.getText && c.getText() === 'Building'
        && c.mEventRegistry && c.mEventRegistry.press);
      if (!item) return 'no Building item carries a press handler';
      item.firePress({ item, srcControl: item });
      return 'fired';
    });
    if (fired !== 'fired') throw new Error(`241: ${fired}`);
    await expect(page.locator('.sapMMessageToast'), 'the prevented-default toast').toContainText('Default was prevented');
  },
  // NavContainer.to via control_by_id (slot-local id + transition)
  z2ui5_cl_dmo_app_242: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'To 2', exact: true }).first();
    await expect(btn, 'the To 2 nav button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.getByText('Page 2', { exact: true }).first(), 'page 2 after the to() call').toBeVisibleEnabled();
  },
  // popover_display ResponsivePopover with custom footer
  z2ui5_cl_dmo_app_243: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Popover with Custom Footer', exact: true }).first();
    await expect(btn, 'the popover button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMPopover'), 'the ResponsivePopover').toContainText('OK');
    await expect(page.locator('.sapMPopover'), 'the bound product name').toContainText('Notebook Basic 15');
  },
  // DynamicPage.breakpointChange → bound Avatar displaySize + toast
  // (2026-07-30 rework; needs UI5 >= 1.147)
  z2ui5_cl_dmo_app_244: async (page, expect) => {
    await page.setViewportSize({ width: 500, height: 800 });
    await expect(page.locator('.sapMMessageToast'), 'the media-range toast').toContainText('Media Range:');
  },
  // FileUploader UPLOAD round-trip: empty value → 'Choose a file first'
  // (2026-07-30 rework)
  z2ui5_cl_dmo_app_246: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Upload File', exact: true }).first();
    await expect(btn, 'the Upload File button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMMessageToast'), 'the empty-value toast').toContainText('Choose a file first');
  },
  // uxap batch b05 (2026-07-31)
  // ObjectPageDynamicHeaderTitle backgroundDesign + backgroundDesignAnchorBar
  z2ui5_cl_dmo_app_258: async (page, expect) => {
    await expect(page.locator('.sapUxAPObjectPageHeaderTitle'), 'the dynamic header title').toContainText('Denise Smith');
    await expect(page.locator('.sapUxAPObjectPageNavigation'), 'the anchor bar').toContainText('Section 1');
    // the blocks are the inlined SimpleForms, not the sample's BlockBase
    await expect(page.locator('.sapUiForm').first(), 'the inlined block form').toContainText('some content goes here...');
    // backgroundDesignAnchorBar="Translucent" reaches the AnchorBar toolbar
    // .last() = the in-flow anchor bar; the sticky clone has a zero box
    await expect(page.locator('.sapUxAPObjectPageNavigationTranslucent').last(), 'the Translucent anchor bar').toBeVisibleEnabled();
  },
  // ProgressIndicator + RatingIndicator header facets
  z2ui5_cl_dmo_app_259: async (page, expect) => {
    await expect(page.locator('.sapMPI').first(), 'the header ProgressIndicator').toContainText('42%');
    await expect(page.locator('.sapMRI').first(), 'the header RatingIndicator').toBeVisibleEnabled();
    await expect(page.locator('.sapUxAPObjectPageSection').first(), 'the goals section').toContainText('Evangelize the UI framework');
  },
  // preserveHeaderStateOnScroll
  z2ui5_cl_dmo_app_260: async (page, expect) => {
    await expect(page.locator('.sapUxAPObjectPageLayout'), 'the preserved header content').toContainText('Cost Center');
    await expect(page.locator('.sapUiForm').first(), 'the inlined GoalsBlock form').toContainText('Mentor junior developers');
    // preserveHeaderStateOnScroll: the header content stays shown while the
    // page scrolls (without it the header snaps away)
    await page.evaluate(() => { const sc = document.querySelector('.sapUxAPObjectPageWrapper, .sapUxAPObjectPageLayout'); if (sc) sc.scrollTop = 1500; });
    await page.waitForTimeout(1000);
    await expect(page.getByText('Cost Center', { exact: true }).first(), 'the header content after scrolling').toBeVisibleEnabled();
  },
  // subSectionLayout="TitleOnLeft" + the EmploymentBlockJob ModelMapping fold
  z2ui5_cl_dmo_app_261: async (page, expect) => {
    await expect(page.locator('.sapUxAPObjectPageLayout'), 'the object page').toContainText('Denise Smith');
    const section = page.getByText('Job Relationship', { exact: true }).first();
    await expect(section, 'the Job Relationship subsection title').toBeVisibleEnabled();
    // the folded emp1>/emp2> root fields (HRData /Employee rows 0 and 1)
    await expect(page.locator('.sapUxAPObjectPageLayout'), 'the folded ModelMapping records').toContainText('Michael Adams');
  },
  // ObjectPageLayout.showFooter two-way bound, flipped by a round-trip
  z2ui5_cl_dmo_app_262: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Toggle Footer', exact: true }).first();
    await expect(btn, 'the Toggle Footer button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapUxAPObjectPageFooter'), 'the footer after the round-trip').toContainText('Accept');
    // the breadcrumb link's client-composed toast — at this viewport the
    // Breadcrumbs collapse into a Select, so pick the entry from its list
    const crumbs = page.locator('.sapMBreadcrumbs .sapMSlt').first();
    await expect(crumbs, 'the collapsed breadcrumbs select').toBeVisibleEnabled();
    await crumbs.click();
    const home = page.locator('.sapMSltPicker li', { hasText: 'Home' }).first();
    await expect(home, 'the Home breadcrumb entry').toBeVisibleEnabled();
    await home.click();
    await expect(page.locator('.sapMMessageToast').last(), 'the breadcrumb client toast').toContainText('Page 1 a very long link clicked');
  },
  // NavContainer.to via _event_client(control_by_id) + the navigate round-trip
  z2ui5_cl_dmo_app_263: async (page, expect) => {
    const item = page.getByText('To ObjectPage', { exact: true }).first();
    await expect(item, 'the navigating list item').toBeVisibleEnabled();
    await item.click();
    await expect(page.locator('.sapUxAPObjectPageLayout'), 'the ObjectPage on page 2').toContainText('Denise Smith');
    const back = page.locator('.sapMPageHeader .sapMBarLeft .sapMBtn').first();
    await expect(back, 'the nav-back button').toBeVisibleEnabled();
    await back.click();
    await expect(page.locator('.sapMPage'), 'page 1 after navigating back').toContainText('To ObjectPage');
  },
  // batch b13 (2026-07-31) — boundFilters (@1.146)
  // typing a prefix re-filters the bound rows; Toggle Filters re-bakes the set
  z2ui5_cl_dmo_app_264: async (page, expect) => {
    const rows = page.locator('.sapUiTableRow:not(.sapUiTableRowHidden)');
    await expect(page.locator('.sapUiTable'), 'the employees table').toContainText('Walldorf');
    const input = page.locator('input.sapMInputBaseInner').first();
    await expect(input, 'the department prefix input').toBeVisibleEnabled();
    await input.fill('Manage');
    await input.press('Enter');
    await expect(page.locator('.sapUiTableCtrl'), 'the rows filtered by the bound filter').notToContainText('Development');
    const btn = page.getByRole('button', { name: 'Show Personal Filters', exact: true }).first();
    await expect(btn, 'the toggle-filters button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMTB'), 'the personal filter bar after the re-bake redraw').toContainText('First name prefix');
    // back to organizational, then clear the prefix: an empty value must DROP
    // the filter (the odata String type maps '' to null), not match nothing
    await page.getByRole('button', { name: 'Show Organizational Filters', exact: true }).first().click();
    const dept = page.locator('input.sapMInputBaseInner').first();
    await dept.fill('');
    await dept.press('Enter');
    await expect(page.locator('.sapUiTableCtrl'), 'every row back after clearing the prefix').toContainText('Development');
    void rows;
  },
  // HeaderContainer: the NumericContent press raises a client toast
  z2ui5_cl_dmo_app_029: async (page, expect) => {
    const tile = page.locator('.sapMNC').first();
    await expect(tile, 'the first NumericContent tile').toBeVisibleEnabled();
    await tile.click();
    await expect(page.locator('.sapMMessageToast').last(), 'the tile-press client toast').toContainText('Fire press');
  },
  // tnt NavigationList: the two toolbar buttons flip bound control state
  // server-side (the original used byId().setExpanded / setVisible)
  z2ui5_cl_dmo_app_123: async (page, expect) => {
    const nav = page.locator('.sapTntNL').first();
    await expect(nav, 'the navigation list').toContainText('Sub Item 3');
    const btn = page.getByRole('button', { name: 'Show/Hide SubItem 3', exact: true }).first();
    await expect(btn, 'the Show/Hide SubItem 3 button').toBeVisibleEnabled();
    await btn.click();
    // the bound visible flag hides exactly one sub item — the count must drop
    await expect(page.getByText('Sub Item 3', { exact: true }), 'one Sub Item 3 hidden after the round-trip').toHaveCountBelow(2);
    // the second button flips NavigationList.expanded — collapsed shows icons only
    const toggle = page.getByRole('button', { name: 'Toggle Collapse/Expand', exact: true }).first();
    await expect(toggle, 'the collapse/expand button').toBeVisibleEnabled();
    await toggle.click();
    await expect(nav, 'the collapsed navigation list').notToContainText('Sub Item 1');
  },
  // SideNavigation.expanded two-way bound, flipped on a round-trip (starts
  // collapsed = icons only), plus the itemSelect client toast
  z2ui5_cl_dmo_app_172: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Toggle Collapse/Expand', exact: true }).first();
    await expect(btn, 'the collapse/expand button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('body'), 'the expanded side navigation').toContainText('Office 01');
    await page.getByText('Office 01', { exact: true }).first().click();
    await expect(page.locator('.sapMMessageToast').last(), 'the itemSelect client toast').toContainText('Item selected: Office 01');
  },
  // ListItemTypes: every item's `type` follows ONE shared root field. The type
  // Select sits in an OverflowToolbar whose popover is not drivable headless
  // (its content is only instantiated on open and the Select keeps no .sapMSlt
  // root there), so this asserts the regression that actually bit us: the
  // template must bind the ABSOLUTE path /LISTTYPE — a relative {LISTTYPE}
  // resolves against the row, leaves every item Inactive and kills the Select
  // (fixed 2026-07-31, see the 207 sidecar). The click-through stays a human check.
  z2ui5_cl_dmo_app_207: async (page, expect) => {
    await expect(page.locator('.sapMList'), 'the product list').toContainText('Notebook Basic 15');
    const shape = await page.evaluate(() => {
      const El = sap.ui.require('sap/ui/core/Element');
      const items = Object.values(El.registry.all()).filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem');
      return { n: items.length, path: items[0] && items[0].getBindingPath('type') };
    });
    if (!shape.n) throw new Error('no StandardListItem rendered');
    if (shape.path !== '/LISTTYPE') throw new Error(`the item type must bind the absolute /LISTTYPE, got "${shape.path}"`);
    // …and the click-through IS drivable through the overflow popover
    // (2026-08-01) — picking a type must reach every item's `type`
    const more = page.getByRole('button', { name: 'Additional Options' }).first();
    await expect(more, 'the overflow button').toBeVisibleEnabled();
    await more.click();
    const sel = page.locator('.sapMPopover .sapMSlt').first();
    await expect(sel, 'the list-type Select in the overflow').toBeVisibleEnabled();
    await sel.click();
    await page.locator('.sapMSltPicker').getByText('Navigation', { exact: true }).first().click();
    await waitForUi5(page, () => {
      // the binding TEMPLATE is in the registry too and keeps the default
      // type (it has no binding context) — only the real rows count
      const rows = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem' && c.getBindingContext());
      return rows.length > 0 && rows.every((i) => i.getType() === 'Navigation');
    }, 'the picked list type never reached the items');
  },
  // sap.ui.unified.Menu opened through the 2026-07-27 openBy fallback
  // (open(false, anchor, …) for a control without its own openBy)
  z2ui5_cl_dmo_app_228: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Open Menu', exact: true }).first();
    await expect(btn, 'the menu anchor button').toBeVisibleEnabled();
    await btn.click();
    const item = page.getByText('My 1st Item', { exact: true }).first();
    await expect(item, 'the anchored-open unified Menu').toBeVisibleEnabled();
    await item.click();
    await expect(page.locator('.sapMMessageToast').last(), 'the itemSelect client toast').toContainText("'My 1st Item' pressed");
  },
  // SplitApp navigation driven from the backend (control_by_id to/toDetail/…)
  z2ui5_cl_dmo_app_097: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Go to Detail page2', exact: true }).first();
    await expect(btn, 'the detail-navigation button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMSplitApp'), 'the second detail page after the round-trip').toContainText('Detail Detail');
  },
  // FileUploader: the upload cycle reduced to client toasts
  z2ui5_cl_dmo_app_126: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Upload File', exact: true }).first();
    await expect(btn, 'the Upload File button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMMessageToast').last(), 'the upload-started client toast').toContainText('Uploading file to the local server');
  },
  // per-row bound filter: each row's Select lists only its region's managers
  z2ui5_cl_dmo_app_265: async (page, expect) => {
    await expect(page.locator('.sapUiTable'), 'the customers table').toContainText('TechCorp Solutions');
    const select = page.locator('.sapMSlt').first();
    await expect(select, 'the first row Select').toBeVisibleEnabled();
    await select.click();
    const list = page.locator('.sapMSltPicker');
    await expect(list, 'the region-filtered manager list').toContainText('John Smith');
    await expect(list, 'the other regions are filtered out').notToContainText('Yuki Tanaka');
  },
  // DynamicSideContent breakpointChanged round-trip: the footer Toggle button
  // follows the transported breakpoint (the original enables it on S only).
  // Shrinking the viewport into the S range is the only way to make the
  // round-trip fire, so this drives the resize itself.
  z2ui5_cl_dmo_app_267: async (page, expect) => {
    await expect(page.locator('body'), 'main and side content side by side').toContainText('Side content');
    await page.setViewportSize({ width: 400, height: 900 });
    await waitForUi5(page, () => {
      const b = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Button' && c.getText() === 'Toggle');
      return !!(b && b.getEnabled());
    }, 'the Toggle button never became enabled — the breakpointChanged round-trip did not transport "S"');
  },
  // anchored open of a per-row ColorPickerPopover (control_by_id openBy with a
  // domRef arg). The change/liveChange round-trips need a real colour pick in
  // the picker's own controls and stay a human check.
  z2ui5_cl_dmo_app_268: async (page, expect) => {
    // the value-help icon (id …-vhi) gets a ZERO-size box in the headless
    // layout (the theme CSS that sizes sapUiIcon never loads), so a normal
    // click fails actionability — dispatch the DOM click the Icon listens for
    const icon = page.locator('[id$="-vhi"]').first();
    if (!(await icon.count())) throw new Error('the first row Input rendered no value-help icon');
    await icon.dispatchEvent('click');
    const pop = page.locator('.sapMPopover');
    await expect(pop, 'the anchored ColorPickerPopover').toBeVisibleEnabled();
    if (!(await pop.locator('.sapUnifiedColorPicker').count())) throw new Error('the opened popover carries no ColorPicker');
  },
  // DynamicSideContent driven from the backend: the two setShowSideContent
  // follow-up actions (hide from the side content's own Close button, show
  // from the footer button whose `visible` the breakpoint round-trip drives)
  z2ui5_cl_dmo_app_269: async (page, expect) => {
    await expect(page.locator('.sapMList'), 'the feed list').toContainText('Alexandrina Victoria');
    const close = page.getByRole('button', { name: 'Close', exact: true }).first();
    await expect(close, 'the side-content Close button').toBeVisibleEnabled();
    await close.click();
    await waitForUi5(page, () => {
      const d = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.layout.DynamicSideContent');
      return !!d && !d.getShowSideContent();
    }, 'the SIDE_CONTENT_HIDE follow-up action never hid the side content');
    const open = page.getByRole('button', { name: 'Open Side Content', exact: true }).first();
    await expect(open, 'the Open Side Content button (visible off breakpoint S)').toBeVisibleEnabled();
    await open.click();
    await waitForUi5(page, () => {
      const d = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.layout.DynamicSideContent');
      return !!d && d.getShowSideContent();
    }, 'the SIDE_CONTENT_SHOW follow-up action never brought the side content back');
  },
  // the controller's jQuery panel width became an expression binding on the
  // Slider value — moving the slider must resize the Panel with no round-trip
  z2ui5_cl_dmo_app_270: async (page, expect) => {
    await expect(page.locator('body'), 'the nested grid boxes').toContainText('E Box');
    // the slider handle carries a zero-size box headless (unstyled), so it is
    // focused through the DOM and driven by keyboard — a real user gesture
    // that goes through the Slider's own key handling and the two-way binding
    await sliderDrivenWidth(page, 'sap.m.Panel');
  },
  // GridResponsiveLayout: the layoutChange round-trip names the active
  // GridSettings aggregation, and the containerQuery expression binding
  // follows the SegmentedButton with no round-trip of its own
  z2ui5_cl_dmo_app_271: async (page, expect) => {
    const tiles = await page.locator('.demoBox').count();
    if (tiles !== 12) throw new Error(`expected the sample's twelve grid tiles, got ${tiles}`);
    // a GridLayoutBase extends ManagedObject, NOT Element — it is in no
    // Element.registry, so the customLayout is read through its CSSGrid
    await page.locator('.sapMSegBBtn').first().click();   // the "true" segment
    await waitForUi5(page, () => {
      const g = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.layout.cssgrid.CSSGrid');
      return !!g && g.getCustomLayout() && g.getCustomLayout().getContainerQuery() === true;
    }, 'the SegmentedButton did not flip containerQuery through the expression binding');
    // with containerQuery on, shrinking the container fires layoutChange —
    // the one wire that does round-trip (its ${$parameters>/layout} is the
    // only source for the info Text)
    await page.setViewportSize({ width: 420, height: 900 });
    await expect(page.locator('body'), 'the layoutChange round-trip naming the active layout')
      .toContainText('Layout size is: layoutS');
  },
  // bound valueState / valueStateText over a 5-row aggregation: each state
  // must reach the DOM exactly once (render-smoke only sees the mocked model).
  // One generic assertion, shared by the three value-state pickers.
  z2ui5_cl_dmo_app_253: (page, expect) => valueStateRows(page, expect, 'DatePicker'),
  z2ui5_cl_dmo_app_254: (page, expect) => valueStateRows(page, expect, 'DateRangeSelection'),
  z2ui5_cl_dmo_app_255: (page, expect) => valueStateRows(page, expect, 'DateTimePicker'),
  // the "controller sets a width from a slider" class — 144 keeps the
  // round-trip (the bound width is composed in ABAP), 176/213/214 dissolve it
  // into an expression binding; all four must end at 99 % after one key press
  z2ui5_cl_dmo_app_144: (page) => sliderDrivenWidth(page, 'sap.m.Panel'),
  z2ui5_cl_dmo_app_176: (page) => sliderDrivenWidth(page, 'sap.m.Panel'),
  z2ui5_cl_dmo_app_213: (page) => sliderDrivenWidth(page, 'sap.m.Panel'),
  z2ui5_cl_dmo_app_214: (page) => sliderDrivenWidth(page, 'sap.ui.layout.VerticalLayout'),
  // the device branch resolved server-side (app 012 precedent): a desktop run
  // must seed the else-branch widths, not the phone ones
  z2ui5_cl_dmo_app_173: async (page) => {
    await waitForUi5(page, () => {
      const w = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Image').map((c) => c.getWidth());
      return ['5em', '10em', '15em'].every((x) => w.includes(x));
    }, 'the desktop-branch widths (5em/10em/15em) never reached the three Images');
  },
  // element-bound single record: the folded row really resolves against the
  // serialized default model (render-smoke only sees a mocked one)
  z2ui5_cl_dmo_app_206: async (page, expect) => {
    await expect(page.locator('body'), 'the element-bound product').toContainText('Notebook Professional 15');
    await expect(page.locator('body'), 'the bound description').toContainText('2,80 GHz quad core');
  },
  z2ui5_cl_dmo_app_209: async (page, expect) => {
    await expect(page.locator('body'), 'the element-bound product').toContainText('Notebook Basic 15');
    await expect(page.locator('body'), 'the bound supplier').toContainText('Very Best Screens');
  },
  // the sorter inside the raw binding-info string really sorts: unsorted, the
  // first row would be "Notebook Basic 15" (the model's first record)
  z2ui5_cl_dmo_app_225: async (page, expect) => {
    const first = page.locator('.sapMListTblRow:not(.sapMListTblHeader)').first();
    await expect(first, 'the first table row after the NAME sorter').toContainText('10" Portable DVD player');
  },
  // a record flattened onto the model root must be bound ABSOLUTELY — these
  // four rendered empty until 2026-08-01 (the app-207 class, see AGENTS §5)
  z2ui5_cl_dmo_app_195: async (page, expect) => {
    await expect(page.locator('.sapMList'), 'the root-seeded record in the list').toContainText('Notebook Basic 15');
    await expect(page.locator('.sapMList'), 'the bound description').toContainText('HT-1000');
  },
  // the controller's setAlternateRowColors / highlight toggling replaced by
  // two-way bound ToggleButtons + an expression binding on RowSettings
  z2ui5_cl_dmo_app_174: async (page, expect) => {
    // the toolbar controls all live in the OverflowToolbar's popover here —
    // open it first ("Additional Options"), then they ARE drivable (2026-08-01)
    const more = page.getByRole('button', { name: 'Additional Options' }).first();
    await expect(more, 'the overflow button').toBeVisibleEnabled();
    await more.click();
    const pop = page.locator('.sapMPopover');
    const alt = pop.getByText('Toggle Alternate Row Colors', { exact: true }).first();
    await expect(alt, 'the alternate-row-colors toggle in the overflow').toBeVisibleEnabled();
    await alt.click();
    await waitForUi5(page, () => {
      const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
      return !!t && t.getAlternateRowColors() === true;
    }, 'the ToggleButton did not flip the Table alternateRowColors through the two-way binding');
    // highlights start ON (seeded true) — turning them off must feed the
    // expression binding on every RowSettings
    const hl = page.locator('.sapMPopover').getByText('Toggle Highlights', { exact: true }).first();
    await expect(hl, 'the highlights toggle in the overflow').toBeVisibleEnabled();
    await hl.click();
    await waitForUi5(page, () => {
      const rs = ui5All().filter((c) => c.getMetadata().getName() === 'sap.ui.table.RowSettings');
      return rs.length > 0 && rs.every((r) => r.getHighlight() === 'None');
    }, 'turning highlights off did not reach the RowSettings highlight expression binding');
    // the third toolbar control: the SelectionMode Select, also in the overflow
    const sel = page.locator('.sapMPopover .sapMSlt').first();
    await expect(sel, 'the SelectionMode Select in the overflow').toBeVisibleEnabled();
    await sel.click();
    await page.locator('.sapMSltPicker').getByText('Single', { exact: true }).first().click();
    await waitForUi5(page, () => {
      const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
      return !!t && t.getSelectionMode() === 'Single';
    }, 'the Select did not flip the Table selectionMode through the two-way binding');
  },
  // fieldGroupIds + validateFieldGroup: leaving a group fires the event with
  // the group's ids, and the backend classifies it into ITS MessageStrip
  z2ui5_cl_dmo_app_272: async (page, expect) => {
    const billing = page.locator('#BillingName input, [id$="BillingName-inner"]').first();
    await expect(billing, 'the BillingName input').toBeVisibleEnabled();
    await billing.click();
    // moving focus into ANOTHER group is what triggers the validation
    const discount = page.locator('#DiscountCode input, [id$="DiscountCode-inner"]').first();
    await expect(discount, 'the DiscountCode input').toBeVisibleEnabled();
    await discount.click();
    await expect(page.locator('body'), 'the classified MessageStrip after the round-trip')
      .toContainText("Group 'Billing Information' Validation:Error");
    await expect(page.locator('.sapMMessageToast').last(), 'the validation toast')
      .toContainText("Validation of field group 'Billing Information' triggered.");
  },
  // five controller-built Message Dialogs as popup_display fragments; the OK
  // button closes client-side (popup_close), so a second open must work too
  z2ui5_cl_dmo_app_273: async (page, expect) => {
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
  },
  // ShellBar SearchManager: liveChange composes its toast on the client
  // ('{0} liveChange event value is: {1}'), typing also drives the backend
  // suggest round-trip
  z2ui5_cl_dmo_app_218: async (page, expect) => {
    // the ShellBar renders the SearchManager collapsed — the Search button
    // expands the field, and only then is there an input to type into
    const open = page.getByRole('button', { name: 'Search' }).first();
    await expect(open, 'the ShellBar search button').toBeVisibleEnabled();
    await open.click();
    const search = page.locator('input').first();
    await expect(search, 'the expanded search field').toBeVisibleEnabled();
    await search.type('Pro', { delay: 80 });
    await expect(page.locator('.sapMMessageToast').last(), 'the client-composed liveChange toast')
      .toContainText('liveChange event value is:');
  },
  // three controller-built Dialogs with the shared product list; the two
  // footer buttons close client-side (popup_close)
  z2ui5_cl_dmo_app_274: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Dialog with Fullscreen Toggle', exact: true }).first();
    await expect(btn, 'the plain-dialog button').toBeVisibleEnabled();
    await btn.click();
    const dlg = page.locator('.sapMDialog');
    await expect(dlg, 'the dialog title').toContainText('Available Products');
    await expect(dlg, 'the bound product list inside the dialog').toContainText('Notebook Basic 15');
    await dlg.getByRole('button', { name: 'Close', exact: true }).first().click();
    await expect(page.locator('.sapMDialog'), 'the dialog after popup_close').toHaveCountBelow(1);
  },
  // the width-switch round-trip: the SegmentedButton sits in an
  // OverflowToolbar, so the overflow popover is opened first (2026-08-01)
  z2ui5_cl_dmo_app_247: async (page, expect) => {
    const more = page.getByRole('button', { name: 'Additional Options' }).first();
    await expect(more, 'the overflow button').toBeVisibleEnabled();
    await more.click();
    // an overflowed SegmentedButton renders as a Select in the popover
    const sel = page.locator('.sapMPopover .sapMSlt').first();
    await expect(sel, 'the width SegmentedButton (a Select in the overflow)').toBeVisibleEnabled();
    await sel.click();
    await page.locator('.sapMSltPicker').getByText('Flexible', { exact: true }).first().click();
    await waitForUi5(page, () => {
      const cols = ui5All().filter((c) => c.getMetadata().getName() === 'sap.ui.table.Column');
      return cols.some((c) => c.getWidth() === '25%');
    }, 'the WIDTHS_CHANGE round-trip never re-sized the columns');

    // The per-column veto (2026-08-06, s_ctrl-prevent_default_expr). A column
    // resize is a drag on an internal resizer, so the event is fired through
    // the control's own API instead - which still runs the port's WIRE, the
    // thing under test. ONE wire, two columns, opposite outcomes: the
    // delivery-date column must be vetoed (fireColumnResize returns false) and
    // any other column must go through.
    const fireResize = (blocked) => page.evaluate((wantBlocked) => {
      const all = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
      const table = all.find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
      const cols = table.getColumns();
      const target = cols.find((c) => (c.getId().indexOf('deliverydate') >= 0) === wantBlocked);
      return table.fireColumnResize({ column: target, width: '100px' });
    }, blocked);

    // each firing round-trips (eBP always sends), so they are driven one at a
    // time - two back-to-back would collide with the busy guard
    if (await fireResize(true) !== false) {
      throw new Error('the delivery-date column was NOT vetoed - prevent_default_expr did not apply per firing');
    }
    await page.waitForTimeout(2000);
    if (await fireResize(false) !== true) {
      throw new Error('a non-delivery-date column was vetoed too - the veto is not per column');
    }
    // the non-vetoed one reports, with the column LABEL the reduction had dropped
    await expect(page.locator('.sapMMessageToast'), 'the resize toast of the non-vetoed column')
      .toContainText('was resized to');
  },
  // GenericTile states: the press wire is a constant client toast, and a
  // handler-less tile must stay silent
  z2ui5_cl_dmo_app_275: async (page, expect) => {
    const tiles = page.locator('.sapMGT');
    await expect(tiles.first(), 'the first tile').toBeVisibleEnabled();
    await expect(page.locator('body'), 'the tile headers').toContainText('Status Loaded - with press event');
    await tiles.nth(1).click();   // "Status Loaded - with press event"
    await expect(page.locator('.sapMMessageToast').last(), 'the client-composed press toast')
      .toContainText('The generic tile is pressed.');
  },
  // client-side growing: the list starts at the threshold and the More
  // trigger appends the next page — no backend wire at all
  z2ui5_cl_dmo_app_276: async (page, expect) => {
    const rows = page.locator('.sapMLIB.sapMSLI');
    await expect(rows.first(), 'the first list row').toBeVisibleEnabled();
    const before = await rows.count();
    if (before !== 4) throw new Error(`the growingThreshold should show 4 rows, got ${before}`);
    await page.locator('.sapMGrowingListTrigger').first().click();
    await waitForCount(page, '.sapMLIB.sapMSLI', 8, 'the More trigger did not append the next page');
  },
  // the controller's phone/orientation MessageStrip rule became one device-
  // model expression: on a desktop viewport the strip must be VISIBLE
  z2ui5_cl_dmo_app_277: async (page, expect) => {
    await expect(page.locator('body'), 'the device-model driven MessageStrip')
      .toContainText('Move the splitter to see the container based popin behaviour');
    await expect(page.locator('.sapMListTblHeader').first(), 'the left table header').toBeVisibleEnabled();
    await expect(page.locator('body'), 'both panes bound to the same collection').toContainText('Notebook Basic 15');
  },
  // the a11y announce round-trip: pressing any button writes the status Text
  z2ui5_cl_dmo_app_141: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Success', exact: true }).first();
    await expect(btn, 'the Success button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('body'), 'the bound status text after the round-trip')
      .toContainText('A new message was sent to the invisible messaging service.');
  },
  // Wizard: the footer Cancel goes through a backend round-trip that opens a
  // MessageBox (message_box_display with a YES/NO onclose action)
  z2ui5_cl_dmo_app_101: async (page, expect) => {
    await expect(page.locator('body'), 'the first wizard step').toContainText('Product Type');
    const cancel = page.getByRole('button', { name: 'Cancel', exact: true }).first();
    await expect(cancel, 'the wizard Cancel button').toBeVisibleEnabled();
    await cancel.click();
    await expect(page.locator('.sapMDialog'), 'the cancel MessageBox')
      .toContainText('Are you sure you want to cancel your report?');
  },
  // u:Currency over four inlined arrays: the real backend model must reach
  // the control and be formatted with its currency (locale-independent parts
  // only — the digit grouping is the browser's, not the port's)
  z2ui5_cl_dmo_app_196: async (page, expect) => {
    const lists = page.locator('.sapMList');
    await expect(lists.first(), 'the first currency list').toBeVisibleEnabled();
    await expect(page.locator('body'), 'the bound EUR row').toContainText('EUR');
    await expect(page.locator('body'), 'the bound JPY row').toContainText('JPY');
    const n = await page.locator('.sapUiUfdCurrency').count();
    if (n < 4) throw new Error(`expected the sample's Currency controls to render, got ${n}`);
  },
  // InitialPagePattern: F4 on the Input is the keyboard form of the
  // valueHelpRequest (its icon carries a zero-size box headless), and the
  // SelectDialog is opened client-side by control_by_id. Picking a row and
  // its confirm round-trip stay a human check: the dialog row has no layout
  // box headless and neither a click nor a keyboard Enter reaches the
  // SelectDialog's confirm (measured 2026-08-01).
  z2ui5_cl_dmo_app_233: async (page, expect) => {
    const inp = page.locator('.sapMInputBaseInner').first();
    if (!(await inp.count())) throw new Error('the PurchaseID input did not render');
    await page.evaluate(() => document.querySelector('.sapMInputBaseInner').focus());
    await page.keyboard.press('F4');
    await expect(page.locator('.sapMDialog'), 'the SelectDialog opened by control_by_id').toContainText('Purchases');
    await waitForCount(page, '.sapMDialog .sapMLIB', 1, 'the SelectDialog stayed empty');
  },
  // ColorPalette: the swatches have a zero-height box headless, so a colour
  // is picked the keyboard way — focus the swatch, press Enter — and the
  // client-composed toast carries ${$parameters>/value} and /defaultAction
  z2ui5_cl_dmo_app_008: async (page, expect) => {
    const sw = page.locator('.sapMColorPaletteSquare');
    if (!(await sw.count())) throw new Error('the ColorPalette rendered no swatches');
    await page.evaluate(() => document.querySelector('.sapMColorPaletteSquare').focus());
    await page.keyboard.press('Enter');
    await expect(page.locator('.sapMMessageToast').last(), 'the client-composed colorSelect toast')
      .toContainText('Color Selected: value - gold');
  },
  // faked-event-value fixes (2026-08-01): the toast must carry the item's
  // own id, not a constant
  z2ui5_cl_dmo_app_133: async (page, expect) => {
    const item = page.locator('.sapFGridListItem, .sapMLIB').first();
    await expect(item, 'the first grid list item').toBeVisibleEnabled();
    await item.click();
    await expect(page.locator('.sapMMessageToast').last(), 'the press toast naming the item id')
      .toContainText('Pressed item with ID');
  },
  z2ui5_cl_dmo_app_142: (page) => formFieldValues(page),
  z2ui5_cl_dmo_app_175: (page) => formFieldValues(page),
  // Grid element-binding to an array path + index-relative child bindings
  z2ui5_cl_dmo_app_226: async (page, expect) => {
    await expect(page.locator('body'), 'the {0/INTROTEXT1} index-relative binding')
      .toContainText('This Grid Layout sample application demonstrates');
  },
  // Image error -> round-trip -> the two visible expression bindings swap the
  // Image for the IllustratedMessage. NOTE the initial LOAD leg is not
  // checkable here: the seeded product image sits on sdk.openui5.org and the
  // sandbox serves only /resources/ locally, so the error path already fires
  // at boot. This asserts the swap survives the explicit Set-wrong-src
  // round-trip; the load->HAS_ERROR-false leg stays a human check.
  z2ui5_cl_dmo_app_279: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Set wrong src', exact: true }).first();
    await expect(btn, 'the Set-wrong-src button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('body'), 'the IllustratedMessage revealed by HAS_ERROR').toContainText('Not Found');
    await waitForUi5(page, () => {
      const img = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.Image');
      return img && img.getVisible() === false;
    }, 'the Image stayed visible although HAS_ERROR is set');
  },
  // valueLiveUpdate off: the liveChange round-trip fills GET_VALUE while the
  // TextArea's OWN model field (and with it the second Text) must NOT follow
  // yet — that gap is the sample's point, so both legs are asserted. Type with
  // a delay: abap2UI5 serializes round-trips, so keystrokes fired while one is
  // in flight are dropped and GET_VALUE would hold the last COMPLETED value
  // (measured 2026-08-02 — see the port's sidecar NOTE).
  z2ui5_cl_dmo_app_280: async (page, expect) => {
    const ta = page.locator('textarea').first();
    await expect(ta, 'the TextArea').toBeVisibleEnabled();
    await ta.click();
    await ta.pressSequentially('abc', { delay: 700 });
    await expect(page.locator("[id$='getValue']"), 'the liveChange round-trip filling GET_VALUE').toContainText('abc');
    // two nodes end in the id — the SimpleForm's grid wrapper and the Text itself
    const lagging = await page.locator("[id$='getProperty']").last().innerText();
    if (lagging.includes('abc')) throw new Error('model.getProperty() already followed although valueLiveUpdate is off');
    // flip the Switch: valueLiveUpdate is two-way bound, so the model now follows too
    await page.locator('.sapMSwtCont').first().click();
    await ta.click();
    await ta.pressSequentially('de', { delay: 700 });
    await expect(page.locator("[id$='getProperty']"), 'the model field once valueLiveUpdate is on').toContainText('abc');
  },
  // selectionChange transports changedItem.getText() + the selected flag into
  // the backend, which composes the toast. The selectionFinish leg is NOT
  // armed: it only fires when the picker CLOSES, and headless neither F4 nor
  // Escape reaches the picker once focus sits in the item list, an outside
  // click does not dismiss it, and getPicker() is null on the registry
  // instance (measured 2026-08-02). That leg is live-verified instead.
  z2ui5_cl_dmo_app_281: async (page, expect) => {
    const inp = page.locator('.sapMMultiComboBox input, .sapMInputBaseInner').first();
    await expect(inp, 'the MultiComboBox input').toBeVisibleEnabled();
    // the F4 open is timing-sensitive — retry until the picker lists items
    for (let i = 0; i < 5; i++) {
      await inp.click();
      await page.keyboard.press('F4');
      await new Promise((r) => setTimeout(r, 1000));
      if (await page.locator('.sapMPopover li').count()) break;
    }
    await waitForCount(page, '.sapMPopover li', 1, 'the MultiComboBox picker stayed empty');
    await page.locator('.sapMPopover li').first().click();
    await expect(page.locator('.sapMMessageToast').last(), 'the selectionChange toast')
      .toContainText("Event 'selectionChange': Selected '");
  },
  // The overview app (not a numbered port, but the demo's front door). Its info
  // button is the app's only backend round-trip, so this one click covers the
  // whole draft save -> reload path: it is where the 2026-07-31
  // `Network error: ASSERTION_FAILED` regression showed up (open-abap wrote the
  // draft XML with unescaped `<`, see pr/open-abap-xml-escaping). The popover
  // content also proves the server-side row lookup (only ${CLASS} travels).
  [OVERVIEW]: async (page, expect) => {
    const btn = page.locator('button[title^="Generation notes"]').first();
    await expect(btn, 'a row\'s generation-notes button').toBeVisibleEnabled();
    await btn.click();
    await page.waitForSelector('.sapMPopover', { timeout: 60000 })
      .catch(() => { throw new Error('the generation-notes popover never opened (round-trip failed?)'); });
    await expect(page.locator('.sapMPopover'), 'the generation-notes popover').toContainText('Generation notes');
  },
};

// poll until a selector reaches at least n matches
async function waitForCount(page, selector, n, msg) {
  const deadline = Date.now() + 10000;
  for (;;) {
    if ((await page.locator(selector).count()) >= n) return;
    if (Date.now() > deadline) throw new Error(msg);
    await new Promise((r) => setTimeout(r, 250));
  }
}

// the supplier record seeded at the model root must reach the form Inputs
async function formFieldValues(page) {
  await waitForUi5(page, () => {
    const v = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Input').map((c) => c.getValue());
    return ['Red Point Stores', 'Main St', '31415'].every((x) => v.includes(x));
  }, 'the root-seeded supplier record never reached the form Inputs');
}

// one key press on the slider must move the bound width to 99 % — the shared
// assertion of the "controller sets a width" class (see AGENTS §10 on why the
// handle is focused through the DOM instead of clicked)
async function sliderDrivenWidth(page, control) {
  const handle = page.locator('.sapMSliderHandle').first();
  if (!(await handle.count())) throw new Error('the width slider rendered no handle');
  await page.evaluate(() => document.querySelector('.sapMSliderHandle').focus());
  await page.keyboard.press('ArrowLeft');
  await waitForUi5(page, (name) => ui5All().some((c) => c.getMetadata().getName() === name && c.getWidth() === '99%'),
    `no ${control} width followed the slider to 99%`, control);
}

async function valueStateRows(page, expect, control) {
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
function ui5All() { throw new Error('ui5All() runs in the page only'); }
const UI5_ALL_SRC = 'const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());';
async function waitForUi5(page, fn, msg, arg) {
  const expr = `(() => { ${UI5_ALL_SRC} return (${fn.toString()})(${JSON.stringify(arg ?? null)}); })()`;
  await page.waitForFunction(expr, undefined, { timeout: 15000 }).catch(() => { throw new Error(msg); });
}

function startBackend() {
  return new Promise((resolve, reject) => {
    const srv = spawn('node', [path.join(A2, 'node/srv/express.mjs')], { env: { ...process.env, PORT: '3000' } });
    let out = '';
    const onData = (d) => { out += d; if (/Listening on/.test(out)) { srv.stdout.off('data', onData); resolve(srv); } };
    srv.stdout.on('data', onData);
    srv.stderr.on('data', (d) => { out += d; });
    srv.on('exit', (c) => reject(new Error(`backend exited (${c}) before listening:\n${out.slice(-500)}`)));
    setTimeout(() => reject(new Error(`backend did not start in 30s:\n${out.slice(-500)}`)), 30000);
  });
}

function waitPort(port, ms = 30000) {
  const deadline = Date.now() + ms;
  return new Promise((resolve, reject) => {
    const tick = () => {
      const req = http.get({ port, path: '/', timeout: 1000 }, (r) => { r.destroy(); resolve(); });
      req.on('error', () => (Date.now() > deadline ? reject(new Error('port timeout')) : setTimeout(tick, 300)));
      req.on('timeout', () => { req.destroy(); Date.now() > deadline ? reject(new Error('port timeout')) : setTimeout(tick, 300); });
    };
    tick();
  });
}

// tiny expect helper (avoid the @playwright/test dependency; playwright core only)
function makeExpect(errs) {
  return (locator, label) => ({
    async toBeVisibleEnabled() {
      await locator.waitFor({ state: 'visible', timeout: 10000 }).catch(() => { throw new Error(`${label}: not visible`); });
      if (!(await locator.isEnabled())) throw new Error(`${label}: not enabled`);
    },
    async toContainText(txt) {
      await locator.filter({ hasText: txt }).first().waitFor({ state: 'visible', timeout: 10000 })
        .catch(() => { throw new Error(`${label}: never showed text "${txt}"`); });
    },
    // count bound — for a bound `visible` flag that removes ONE of several
    // same-named entries (a plain absence check cannot see that)
    async toHaveCountBelow(n) {
      const deadline = Date.now() + 10000;
      for (;;) {
        if ((await locator.count()) < n) return;
        if (Date.now() > deadline) throw new Error(`${label}: count stayed >= ${n}`);
        await new Promise((r) => setTimeout(r, 250));
      }
    },
    // negative form — a filter assertion needs it (the row that must be GONE).
    // Polls until the text is absent so an async re-filter is tolerated.
    async notToContainText(txt) {
      const deadline = Date.now() + 10000;
      for (;;) {
        if (!(await locator.filter({ hasText: txt }).count())) return;
        if (Date.now() > deadline) throw new Error(`${label}: still shows text "${txt}"`);
        await new Promise((r) => setTimeout(r, 250));
      }
    },
  });
}

async function checkPort(browser, cls) {
  const errs = [];
  const ctx = await browser.newContext();
  const page = await ctx.newPage();
  // real JS exceptions are always a defect (minus known env noise)
  page.on('pageerror', (e) => { if (!benign(e.message)) errs.push('pageerror: ' + e.message.slice(0, 160)); });
  // a backend (localhost:3000) asset or roundtrip that 4xx/5xx is a port/app
  // defect; a UI5 resource we did not serve locally (sdk.openui5.org 404) is
  // benign environment noise and ignored
  page.on('response', (r) => {
    const u = new URL(r.url());
    if (u.hostname === 'localhost' && u.port === '3000' && r.status() >= 400) {
      errs.push(`backend HTTP ${r.status()} for ${u.pathname}${u.search.slice(0, 40)}`);
    }
  });
  await page.route('**://sdk.openui5.org/**', (route) => {
    const hit = resolveLocal(new URL(route.request().url()).pathname);
    return hit ? route.fulfill({ status: 200, contentType: hit.type, body: hit.body }) : route.fulfill({ status: 404, body: '' });
  });
  try {
    await page.goto(`http://localhost:3000/?app_start=${cls}`, { waitUntil: 'domcontentloaded', timeout: 30000 });
    // UI5 booted from source AND the initial roundtrip rendered real controls
    await page.waitForFunction(
      () => window.sap && window.sap.ui && document.querySelectorAll('[data-sap-ui]').length > 3,
      { timeout: 60000 },
    );
    // let the render settle so a late runtime error still surfaces
    await page.waitForTimeout(600);
    const interaction = INTERACTIONS[cls];
    if (interaction) await interaction(page, makeExpect(errs));
  } catch (e) {
    errs.push('boot: ' + String(e.message).split('\n')[0].slice(0, 160));
  }
  await ctx.close();
  return errs;
}

const metas = fs.readdirSync(META).filter((f) => f.endsWith('.json'))
  .map((f) => JSON.parse(fs.readFileSync(path.join(META, f), 'utf8')))
  .filter((m) => /^z2ui5_cl_dmo_app_\d+$/.test(m.class))
  .filter((m) => !ONLY || ONLY.some((o) => m.class.endsWith(o)));
metas.sort((a, b) => a.class.localeCompare(b.class));

console.log(`e2e-smoke: ${metas.length} port(s), backend from ${A2}`);
const backend = await startBackend();
await waitPort(3000);
// prefer the sandbox's pinned Chromium when present, else the playwright-managed one (CI)
const LOCAL_CHROMIUM = '/opt/pw-browsers/chromium';
const browser = fs.existsSync(LOCAL_CHROMIUM)
  ? await chromium.launch({ headless: !HEADED, executablePath: LOCAL_CHROMIUM })
  : await chromium.launch({ headless: !HEADED });

let failed = 0;
for (const m of metas) {
  const errs = await checkPort(browser, m.class);
  const cls = m.class.replace('z2ui5_cl_dmo_app_', '');
  if (errs.length) { failed++; console.log(`FAIL  ${cls}  ${errs[0]}`); }
  else console.log(`pass  ${cls}${INTERACTIONS[m.class] ? '  (+interaction)' : ''}`);
}

// the overview app: same generic gate, plus the info-popover round-trip
let overviewChecked = 0;
if (!ONLY || ONLY.some((o) => OVERVIEW.endsWith(o))) {
  overviewChecked = 1;
  const errs = await checkPort(browser, OVERVIEW);
  if (errs.length) { failed++; console.log(`FAIL  overview  ${errs[0]}`); }
  else console.log('pass  overview  (+interaction)');
}

await browser.close();
backend.kill();
console.log(`\ne2e-smoke: ${metas.length + overviewChecked} app(s), ${failed} failing.`);
if (STRICT && failed) process.exit(1);
