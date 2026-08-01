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
 * but the boot+render+no-error gate already covers all 94.
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
  ? process.argv[process.argv.indexOf('--only') + 1].split(',').map((s) => s.trim()).filter(Boolean)
  : null;

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

// page-error (real JS exception) messages that are environment noise, not port
// defects. Resource 404/500s are handled separately by response URL (a
// localhost:3000 backend asset failing is real; an unbundled-UI5 resource we
// didn't serve is benign) — the console "Failed to load resource" line carries
// no URL, so it is ignored in favour of the response tracking below.
const BENIGN = [
  /library-preload/i, /messagebundle/i, /i18n/i, /themes?\/|library(\.css|-parameters)/i,
  /theming\.Parameters|\.properties/i, /failed to load (javascript )?resource/i,
  /Core\.applyTheme|sap\.ui\.getCore/i, /favicon/i, /deprecat/i, /sap-ui-cachebuster/i,
  /ERR_TUNNEL_CONNECTION_FAILED/i,
];
const benign = (s) => BENIGN.some((re) => re.test(s));

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
//   SelectDialog opened by control_by_id + its confirm arg: 233
//   fieldGroupIds / validateFieldGroup: 272
const INTERACTIONS = {
  z2ui5_cl_ai_app_005: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Default', exact: true }).first();
    await expect(btn, 'a "Default" press button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMMessageToast'), 'the client-composed press toast').toContainText('Pressed');
  },
  z2ui5_cl_ai_app_019: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Approve', exact: true }).first();
    await expect(btn, 'the "Approve" dialog button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMDialog'), 'the popup_display Dialog').toContainText('Do you want to submit this order?');
  },
  z2ui5_cl_ai_app_060: async (page, expect) => {
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
  z2ui5_cl_ai_app_094: async (page, expect) => {
    const link = page.locator('.sapMListTbl a.sapMLnk').first();
    await expect(link, 'the first product-ID link').toBeVisibleEnabled();
    await link.click();
    await expect(page.locator('.sapMPopover'), 'the BIND_ELEMENT-bound popover').toContainText('Action');
  },
  // server round-trip on a two-way bound control property (busy flips in ABAP)
  z2ui5_cl_ai_app_130: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Toggle Busy State of Both Controls' }).first();
    await expect(btn, 'the busy-toggle button').toBeVisibleEnabled();
    await btn.click();
    // assert the busy STATE class on the bound control — the overlay div
    // itself has a zero-height box in the headless layout and never counts
    // as "visible" to playwright
    await expect(page.locator('.sapUiLocalBusy').first(), 'the bound control turning busy after the round-trip').toBeVisibleEnabled();
  },
  // roundtrip-free control_by_id openBy on a hidden picker (the app-016 idiom)
  z2ui5_cl_ai_app_091: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Open Time Picker', exact: true }).first();
    await expect(btn, 'the openBy anchor button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMPopover'), 'the hidden TimePicker opened anchored').toContainText('');
  },
  // popup_display TableSelectDialog with the FULL 123-row mock + the
  // client-side binding_call Contains search (no round-trip)
  z2ui5_cl_ai_app_104: async (page, expect) => {
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
  z2ui5_cl_ai_app_133: async (page, expect) => {
    const seg = page.getByText('MultiSelect', { exact: true }).first();
    await expect(seg, 'the MultiSelect segment').toBeVisibleEnabled();
    await seg.click();
    await expect(page.locator('.sapMCb').first(), 'list checkboxes after the mode round-trip').toBeVisibleEnabled();
  },
  // sap.ui.unified.Menu anchored open via the 2026-07-27 openBy→open()
  // fallback (no own openBy on this control)
  z2ui5_cl_ai_app_227: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Open Menu', exact: true }).first();
    await expect(btn, 'the menu anchor button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.getByText('My 1st Item', { exact: true }).first(), 'the unified.Menu opened anchored').toBeVisibleEnabled();
  },
  // FeedInput action dialog → enablePostButton round-trip (whitelisted
  // bool method, 2026-07-27) + server-side popup_destroy
  z2ui5_cl_ai_app_236: async (page, expect) => {
    const action = page.locator("[id*='feedActionPlain'] button").first();
    await expect(action, 'the FeedInput action button').toBeVisibleEnabled();
    await action.click();
    await expect(page.locator('.sapMDialog'), 'the action dialog').toContainText('Choose an action.');
    await page.getByRole('button', { name: 'Enable Post Button', exact: true }).first().click();
    await page.locator('.sapMDialog').waitFor({ state: 'hidden', timeout: 10000 });
  },
  // two-way bound SideNavigation.expanded (tags variant) flipped on a round-trip
  z2ui5_cl_ai_app_132: async (page, expect) => {
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
  z2ui5_cl_ai_app_248: async (page, expect) => {
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
  z2ui5_cl_ai_app_249: async (page, expect) => {
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
  z2ui5_cl_ai_app_250: async (page, expect) => {
    const btn = page.locator('.sapMBtn').first();
    await expect(btn, 'the first action button').toBeVisibleEnabled();
    await btn.click();
    await page.waitForFunction(
      () => !!document.querySelector("[class*='ColorPalette']"),
      { timeout: 10000 },
    );
  },
  // BusyDialog open + START_TIMER close chain (the 147 idiom on a dialog)
  z2ui5_cl_ai_app_251: async (page, expect) => {
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
  z2ui5_cl_ai_app_252: async (page, expect) => {
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
  z2ui5_cl_ai_app_122: async (page, expect) => {
    const icon = page.locator('.sapUiIconPointer').first();
    await icon.waitFor({ state: 'attached', timeout: 10000 });
    // the icon sits in a zero-height row headless - dispatch the click
    await icon.dispatchEvent('click');
    await expect(page.locator('.sapMMessageToast'), 'the Over budget toast').toContainText('Over budget!');
  },
  // NumericContent press → the original's 'Fire press' toast
  z2ui5_cl_ai_app_157: async (page, expect) => {
    const tile = page.locator('.sapMNC').first();
    await expect(tile, 'the first NumericContent').toBeVisibleEnabled();
    await tile.click();
    await expect(page.locator('.sapMMessageToast'), 'the press toast').toContainText('Fire press');
  },
  // two-way bound FlexibleColumnLayout.layout flipped on a round-trip
  z2ui5_cl_ai_app_234: async (page, expect) => {
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
  z2ui5_cl_ai_app_238: async (page, expect) => {
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
  z2ui5_cl_ai_app_093: async (page, expect) => {
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
  z2ui5_cl_ai_app_167: async (page, expect) => {
    const item = page.getByText('Child Item 1', { exact: true }).first();
    await expect(item, 'the Child Item 1 nav entry').toBeVisibleEnabled();
    await item.click();
    await expect(page.locator('.sapMMessageToast'), 'the itemPress toast').toContainText('Fired itemPress, item: Child Item 1');
    const user = page.getByRole('button', { name: 'Alan Smith', exact: true }).first();
    await user.click();
    await expect(page.locator('.sapMPopover'), 'the user popover').toContainText('Feedback');
  },
  // GridContainer audit fix: press toast composed from getMetadata().getName()
  z2ui5_cl_ai_app_168: async (page, expect) => {
    const tile = page.locator('.sapMGT').first();
    await expect(tile, 'the first GenericTile').toBeVisibleEnabled();
    await tile.click();
    await expect(page.locator('.sapMMessageToast'), 'the metadata-name toast').toContainText('Press was fired on - sap.m.GenericTile');
  },
  // client-composed toast from ${$source>/text} on a Breadcrumbs Link
  z2ui5_cl_ai_app_003: async (page, expect) => {
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
  z2ui5_cl_ai_app_049: async (page, expect) => {
    // the +/- icons render zero-size in the headless layout - drive the value
    // with the keyboard instead (ArrowUp then Enter fires the change event)
    const input = page.locator('.sapMStepInput input').first();
    await expect(input, 'the first StepInput field').toBeVisibleEnabled();
    await input.click();
    await page.keyboard.press('ArrowUp');
    await page.keyboard.press('Enter');
    await expect(page.locator('.sapMMessageToast'), 'the change-value client toast').toContainText("Value changed to");
  },
  // MenuButton opens its Menu; item select toasts `{0} Pressed`
  z2ui5_cl_ai_app_061: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'File', exact: true }).first();
    await expect(btn, 'the "File" MenuButton').toBeVisibleEnabled();
    await btn.click();
    const item = page.locator('.sapMMenuItem', { hasText: 'Save' }).first();
    await expect(item, 'the opened menu item').toBeVisibleEnabled();
    await item.click();
    await expect(page.locator('.sapMMessageToast'), 'the item-select client toast').toContainText('Action triggered on item: Save');
  },
  // MessagePopover toggleBy (dependents-declared, message table bound)
  z2ui5_cl_ai_app_066: async (page, expect) => {
    const btn = page.locator("[id*='messagePopoverBtn']").first();
    await expect(btn, 'the message-popover toggle button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMMsgPopover, .sapMPopover').first(), 'the toggled MessagePopover').toContainText('Error');
  },
  // MessagePopover toggle + the 2026-07-30 RELATIVE_ONLY URL policy: opening
  // the popover renders the markup links and fires urlValidated → toast
  z2ui5_cl_ai_app_067: async (page, expect) => {
    const btn = page.locator("[id*='messagePopoverBtn']").first();
    await expect(btn, 'the message-popover toggle button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMMsgPopover, .sapMPopover').first(), 'the toggled MessagePopover').toContainText('Error message');
  },
  // ObjectListItem press → `Pressed : {0}` client toast
  z2ui5_cl_ai_app_074: async (page, expect) => {
    const item = page.locator('.sapMObjLItem').first();
    await expect(item, 'the first ObjectListItem').toBeVisibleEnabled();
    await item.click();
    await expect(page.locator('.sapMMessageToast'), 'the press client toast').toContainText('Pressed :');
  },
  // NotificationListItem footer button → static client toast
  z2ui5_cl_ai_app_076: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Accept', exact: true }).first();
    await expect(btn, 'the "Accept" notification button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMMessageToast'), 'the accept client toast').toContainText('Accept Button Pressed');
  },
  // ToggleButton → the `{N?true:false}` conditional placeholder toast
  z2ui5_cl_ai_app_080: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Pressed', exact: true }).first();
    await expect(btn, 'the "Pressed" toggle button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMMessageToast'), 'the conditional-placeholder toast').toContainText('Unpressed');
  },
  // popup_display SelectDialog with the product mock
  z2ui5_cl_ai_app_103: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Show Select Dialog', exact: true }).first();
    await expect(btn, 'the dialog button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMDialog'), 'the SelectDialog').toContainText('Select Product');
  },
  // semantic MultiSelectAction: ${$source>/pressed} → server-composed toast
  z2ui5_cl_ai_app_107: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Multiple Selection', exact: true }).first();
    await expect(btn, 'the MultiSelectAction button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMMessageToast'), 'the toggle-state toast').toContainText('MultiSelect Pressed');
  },
  // popover_display with an embedded unified ColorPicker (2026-07-30 rework)
  z2ui5_cl_ai_app_112: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Open ColorPicker in a ResponsivePopover', exact: true }).first();
    await expect(btn, 'the popover button').toBeVisibleEnabled();
    await btn.click();
    // the popover opening anchored proves popover_display; the picker's
    // inner sliders render zero-size headless, so assert on the container
    await expect(page.locator(".sapMPopover:has([class*='ColorPicker'])").first(), 'the popover with the embedded ColorPicker').toBeVisibleEnabled();
  },
  // two-way bound SideNavigation.expanded flipped on a round-trip
  z2ui5_cl_ai_app_128: async (page, expect) => {
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
  z2ui5_cl_ai_app_134: async (page, expect) => {
    const logo = page.locator("img[src*='SAP_Logo']").first();
    await expect(logo, 'the SAP logo image').toBeVisibleEnabled();
    await logo.click();
    await expect(page.locator('.sapMMessageToast'), 'the logo client toast').toContainText('Logo pressed!');
  },
  // global BusyIndicator show(0) + START_TIMER hide chain (2026-07-30 rework)
  z2ui5_cl_ai_app_147: async (page, expect) => {
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
  z2ui5_cl_ai_app_156: async (page, expect) => {
    const tile = page.locator('.sapMNC').first();
    await expect(tile, 'the first NumericContent').toBeVisibleEnabled();
    await tile.click();
    await expect(page.locator('.sapMMessageToast'), 'the press client toast').toContainText('The numeric content is pressed.');
  },
  // GenericTag press → Card popover rebuilt from the sample fragment
  // (2026-07-30 rework)
  z2ui5_cl_ai_app_170: async (page, expect) => {
    const tag = page.locator('.sapMGenericTag').first();
    await expect(tag, 'the SR GenericTag').toBeVisibleEnabled();
    await tag.click();
    await expect(page.locator('.sapMPopover'), 'the Card popover').toContainText('Sales Revenue');
  },
  // CAL_SELECT/SELECT_TODAY round-trip updating the bound selectedDate Text
  z2ui5_cl_ai_app_177: async (page, expect) => {
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
  z2ui5_cl_ai_app_198: async (page, expect) => {
    const item = page.locator('.sapMObjLItem').first();
    await expect(item, 'the first ObjectListItem').toBeVisibleEnabled();
    await item.click();
    await expect(page.locator('.sapMMessageToast'), 'the press client toast').toContainText('Pressed :');
  },
  // popover_display anchored via $event.oSource.sId + relative {NAME} bindings
  z2ui5_cl_ai_app_229: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Show Popover', exact: true }).first();
    await expect(btn, 'the popover button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMPopover'), 'the anchored popover').toContainText('Email');
    // the root-seeded record really reaches the popover (relative bindings
    // rendered EMPTY here until 2026-08-01 — the app-207 class)
    await expect(page.locator('.sapMPopover'), 'the bound product name').toContainText('Notebook Basic 15');
  },
  // KEYBOARD_SHORTCUT: Ctrl+S fires the backend SAVE command (2026-07-30)
  z2ui5_cl_ai_app_232: async (page, expect) => {
    await page.locator('.sapMPanel').first().click();
    await page.keyboard.press('Control+s');
    await expect(page.locator('.sapMMessageToast'), 'the Ctrl+S command toast').toContainText('CTRL+S: save triggered on controller');
  },
  // check_prevent_default: with the checkbox set, a press round-trips but the
  // eBP wire cancels the built-in selection (2026-07-30 rework)
  z2ui5_cl_ai_app_241: async (page, expect) => {
    const cb = page.locator("[id*='preventDefaultCheckbox']").first();
    await expect(cb, 'the prevent-default checkbox').toBeVisibleEnabled();
    await cb.click();
    // the PREVENT_TOGGLE redraw re-bakes the press wires
    await page.waitForTimeout(1500);
    const item = page.getByText('Building', { exact: true }).first();
    await expect(item, 'the Building item').toBeVisibleEnabled();
    await item.click();
    await expect(page.locator('.sapMMessageToast'), 'the prevented-default toast').toContainText('Default was prevented');
  },
  // NavContainer.to via control_by_id (slot-local id + transition)
  z2ui5_cl_ai_app_242: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'To 2', exact: true }).first();
    await expect(btn, 'the To 2 nav button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.getByText('Page 2', { exact: true }).first(), 'page 2 after the to() call').toBeVisibleEnabled();
  },
  // popover_display ResponsivePopover with custom footer
  z2ui5_cl_ai_app_243: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Popover with Custom Footer', exact: true }).first();
    await expect(btn, 'the popover button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMPopover'), 'the ResponsivePopover').toContainText('OK');
    await expect(page.locator('.sapMPopover'), 'the bound product name').toContainText('Notebook Basic 15');
  },
  // DynamicPage.breakpointChange → bound Avatar displaySize + toast
  // (2026-07-30 rework; needs UI5 >= 1.147)
  z2ui5_cl_ai_app_244: async (page, expect) => {
    await page.setViewportSize({ width: 500, height: 800 });
    await expect(page.locator('.sapMMessageToast'), 'the media-range toast').toContainText('Media Range:');
  },
  // FileUploader UPLOAD round-trip: empty value → 'Choose a file first'
  // (2026-07-30 rework)
  z2ui5_cl_ai_app_246: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Upload File', exact: true }).first();
    await expect(btn, 'the Upload File button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMMessageToast'), 'the empty-value toast').toContainText('Choose a file first');
  },
  // uxap batch b05 (2026-07-31)
  // ObjectPageDynamicHeaderTitle backgroundDesign + backgroundDesignAnchorBar
  z2ui5_cl_ai_app_258: async (page, expect) => {
    await expect(page.locator('.sapUxAPObjectPageHeaderTitle'), 'the dynamic header title').toContainText('Denise Smith');
    await expect(page.locator('.sapUxAPObjectPageNavigation'), 'the anchor bar').toContainText('Section 1');
    // the blocks are the inlined SimpleForms, not the sample's BlockBase
    await expect(page.locator('.sapUiForm').first(), 'the inlined block form').toContainText('some content goes here...');
    // backgroundDesignAnchorBar="Translucent" reaches the AnchorBar toolbar
    // .last() = the in-flow anchor bar; the sticky clone has a zero box
    await expect(page.locator('.sapUxAPObjectPageNavigationTranslucent').last(), 'the Translucent anchor bar').toBeVisibleEnabled();
  },
  // ProgressIndicator + RatingIndicator header facets
  z2ui5_cl_ai_app_259: async (page, expect) => {
    await expect(page.locator('.sapMPI').first(), 'the header ProgressIndicator').toContainText('42%');
    await expect(page.locator('.sapMRI').first(), 'the header RatingIndicator').toBeVisibleEnabled();
    await expect(page.locator('.sapUxAPObjectPageSection').first(), 'the goals section').toContainText('Evangelize the UI framework');
  },
  // preserveHeaderStateOnScroll
  z2ui5_cl_ai_app_260: async (page, expect) => {
    await expect(page.locator('.sapUxAPObjectPageLayout'), 'the preserved header content').toContainText('Cost Center');
    await expect(page.locator('.sapUiForm').first(), 'the inlined GoalsBlock form').toContainText('Mentor junior developers');
    // preserveHeaderStateOnScroll: the header content stays shown while the
    // page scrolls (without it the header snaps away)
    await page.evaluate(() => { const sc = document.querySelector('.sapUxAPObjectPageWrapper, .sapUxAPObjectPageLayout'); if (sc) sc.scrollTop = 1500; });
    await page.waitForTimeout(1000);
    await expect(page.getByText('Cost Center', { exact: true }).first(), 'the header content after scrolling').toBeVisibleEnabled();
  },
  // subSectionLayout="TitleOnLeft" + the EmploymentBlockJob ModelMapping fold
  z2ui5_cl_ai_app_261: async (page, expect) => {
    await expect(page.locator('.sapUxAPObjectPageLayout'), 'the object page').toContainText('Denise Smith');
    const section = page.getByText('Job Relationship', { exact: true }).first();
    await expect(section, 'the Job Relationship subsection title').toBeVisibleEnabled();
    // the folded emp1>/emp2> root fields (HRData /Employee rows 0 and 1)
    await expect(page.locator('.sapUxAPObjectPageLayout'), 'the folded ModelMapping records').toContainText('Michael Adams');
  },
  // ObjectPageLayout.showFooter two-way bound, flipped by a round-trip
  z2ui5_cl_ai_app_262: async (page, expect) => {
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
  z2ui5_cl_ai_app_263: async (page, expect) => {
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
  z2ui5_cl_ai_app_264: async (page, expect) => {
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
  z2ui5_cl_ai_app_029: async (page, expect) => {
    const tile = page.locator('.sapMNC').first();
    await expect(tile, 'the first NumericContent tile').toBeVisibleEnabled();
    await tile.click();
    await expect(page.locator('.sapMMessageToast').last(), 'the tile-press client toast').toContainText('Fire press');
  },
  // tnt NavigationList: the two toolbar buttons flip bound control state
  // server-side (the original used byId().setExpanded / setVisible)
  z2ui5_cl_ai_app_123: async (page, expect) => {
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
  z2ui5_cl_ai_app_172: async (page, expect) => {
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
  z2ui5_cl_ai_app_207: async (page, expect) => {
    await expect(page.locator('.sapMList'), 'the product list').toContainText('Notebook Basic 15');
    const shape = await page.evaluate(() => {
      const El = sap.ui.require('sap/ui/core/Element');
      const items = Object.values(El.registry.all()).filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem');
      return { n: items.length, path: items[0] && items[0].getBindingPath('type') };
    });
    if (!shape.n) throw new Error('no StandardListItem rendered');
    if (shape.path !== '/LISTTYPE') throw new Error(`the item type must bind the absolute /LISTTYPE, got "${shape.path}"`);
  },
  // sap.ui.unified.Menu opened through the 2026-07-27 openBy fallback
  // (open(false, anchor, …) for a control without its own openBy)
  z2ui5_cl_ai_app_228: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Open Menu', exact: true }).first();
    await expect(btn, 'the menu anchor button').toBeVisibleEnabled();
    await btn.click();
    const item = page.getByText('My 1st Item', { exact: true }).first();
    await expect(item, 'the anchored-open unified Menu').toBeVisibleEnabled();
    await item.click();
    await expect(page.locator('.sapMMessageToast').last(), 'the itemSelect client toast').toContainText("'My 1st Item' pressed");
  },
  // SplitApp navigation driven from the backend (control_by_id to/toDetail/…)
  z2ui5_cl_ai_app_097: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Go to Detail page2', exact: true }).first();
    await expect(btn, 'the detail-navigation button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMSplitApp'), 'the second detail page after the round-trip').toContainText('Detail Detail');
  },
  // FileUploader: the upload cycle reduced to client toasts
  z2ui5_cl_ai_app_126: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Upload File', exact: true }).first();
    await expect(btn, 'the Upload File button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMMessageToast').last(), 'the upload-started client toast').toContainText('Uploading file to the local server');
  },
  // per-row bound filter: each row's Select lists only its region's managers
  z2ui5_cl_ai_app_265: async (page, expect) => {
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
  z2ui5_cl_ai_app_267: async (page, expect) => {
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
  z2ui5_cl_ai_app_268: async (page, expect) => {
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
  z2ui5_cl_ai_app_269: async (page, expect) => {
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
  z2ui5_cl_ai_app_270: async (page, expect) => {
    await expect(page.locator('body'), 'the nested grid boxes').toContainText('E Box');
    // the slider handle carries a zero-size box headless (unstyled), so it is
    // focused through the DOM and driven by keyboard — a real user gesture
    // that goes through the Slider's own key handling and the two-way binding
    await sliderDrivenWidth(page, 'sap.m.Panel');
  },
  // GridResponsiveLayout: the layoutChange round-trip names the active
  // GridSettings aggregation, and the containerQuery expression binding
  // follows the SegmentedButton with no round-trip of its own
  z2ui5_cl_ai_app_271: async (page, expect) => {
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
  z2ui5_cl_ai_app_253: (page, expect) => valueStateRows(page, expect, 'DatePicker'),
  z2ui5_cl_ai_app_254: (page, expect) => valueStateRows(page, expect, 'DateRangeSelection'),
  z2ui5_cl_ai_app_255: (page, expect) => valueStateRows(page, expect, 'DateTimePicker'),
  // the "controller sets a width from a slider" class — 144 keeps the
  // round-trip (the bound width is composed in ABAP), 176/213/214 dissolve it
  // into an expression binding; all four must end at 99 % after one key press
  z2ui5_cl_ai_app_144: (page) => sliderDrivenWidth(page, 'sap.m.Panel'),
  z2ui5_cl_ai_app_176: (page) => sliderDrivenWidth(page, 'sap.m.Panel'),
  z2ui5_cl_ai_app_213: (page) => sliderDrivenWidth(page, 'sap.m.Panel'),
  z2ui5_cl_ai_app_214: (page) => sliderDrivenWidth(page, 'sap.ui.layout.VerticalLayout'),
  // the device branch resolved server-side (app 012 precedent): a desktop run
  // must seed the else-branch widths, not the phone ones
  z2ui5_cl_ai_app_173: async (page) => {
    await waitForUi5(page, () => {
      const w = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Image').map((c) => c.getWidth());
      return ['5em', '10em', '15em'].every((x) => w.includes(x));
    }, 'the desktop-branch widths (5em/10em/15em) never reached the three Images');
  },
  // element-bound single record: the folded row really resolves against the
  // serialized default model (render-smoke only sees a mocked one)
  z2ui5_cl_ai_app_206: async (page, expect) => {
    await expect(page.locator('body'), 'the element-bound product').toContainText('Notebook Professional 15');
    await expect(page.locator('body'), 'the bound description').toContainText('2,80 GHz quad core');
  },
  z2ui5_cl_ai_app_209: async (page, expect) => {
    await expect(page.locator('body'), 'the element-bound product').toContainText('Notebook Basic 15');
    await expect(page.locator('body'), 'the bound supplier').toContainText('Very Best Screens');
  },
  // the sorter inside the raw binding-info string really sorts: unsorted, the
  // first row would be "Notebook Basic 15" (the model's first record)
  z2ui5_cl_ai_app_225: async (page, expect) => {
    const first = page.locator('.sapMListTblRow:not(.sapMListTblHeader)').first();
    await expect(first, 'the first table row after the NAME sorter').toContainText('10" Portable DVD player');
  },
  // a record flattened onto the model root must be bound ABSOLUTELY — these
  // four rendered empty until 2026-08-01 (the app-207 class, see AGENTS §5)
  z2ui5_cl_ai_app_195: async (page, expect) => {
    await expect(page.locator('.sapMList'), 'the root-seeded record in the list').toContainText('Notebook Basic 15');
    await expect(page.locator('.sapMList'), 'the bound description').toContainText('HT-1000');
  },
  // the controller's setAlternateRowColors / highlight toggling replaced by
  // two-way bound ToggleButtons + an expression binding on RowSettings
  z2ui5_cl_ai_app_174: async (page, expect) => {
    const alt = page.getByRole('button', { name: 'Toggle Alternate Row Colors', exact: true }).first();
    await expect(alt, 'the alternate-row-colors toggle').toBeVisibleEnabled();
    await alt.click();
    await waitForUi5(page, () => {
      const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table');
      return !!t && t.getAlternateRowColors() === true;
    }, 'the ToggleButton did not flip the Table alternateRowColors through the two-way binding');
    // highlights start ON (seeded true) — turning them off must feed the
    // expression binding on every RowSettings
    const hl = page.getByRole('button', { name: 'Toggle Highlights', exact: true }).first();
    await expect(hl, 'the highlights toggle').toBeVisibleEnabled();
    await hl.click();
    await waitForUi5(page, () => {
      const rs = ui5All().filter((c) => c.getMetadata().getName() === 'sap.ui.table.RowSettings');
      return rs.length > 0 && rs.every((r) => r.getHighlight() === 'None');
    }, 'turning highlights off did not reach the RowSettings highlight expression binding');
  },
  // InitialPagePattern: the value-help icon opens the SelectDialog client-side
  // (control_by_id open) and its confirm transports the picked item's
  // description (${$parameters>/selectedItem}.getDescription()) to the backend
  z2ui5_cl_ai_app_233: async (page, expect) => {
    await page.locator('[id$="-vhi"]').first().dispatchEvent('click');
    const dlg = page.locator('.sapMDialog');
    await expect(dlg, 'the SelectDialog opened by control_by_id').toContainText('Purchases');
    await expect(dlg, 'the bound purchase list').toContainText('BestEastern');
    await dlg.locator('.sapMSLI').first().click();
    await expect(page.locator('body'), 'the purchase selected by the confirm round-trip').toContainText('Computers');
  },
  // fieldGroupIds + validateFieldGroup: leaving a group fires the event with
  // the group's ids, and the backend classifies it into ITS MessageStrip
  z2ui5_cl_ai_app_272: async (page, expect) => {
    const billing = page.locator('#BillingName input, [id$="BillingName-inner"]').first();
    await expect(billing, 'the BillingName input').toBeVisibleEnabled();
    await billing.click();
    // moving focus into ANOTHER group is what triggers the validation
    const discount = page.locator('#DiscountCode input, [id$="DiscountCode-inner"]').first();
    await expect(discount, 'the DiscountCode input').toBeVisibleEnabled();
    await discount.click();
    await expect(page.locator('.sapMMsgStrip'), 'the classified MessageStrip after the round-trip')
      .toContainText("Group 'Billing Information' Validation:Error");
    await expect(page.locator('.sapMMessageToast').last(), 'the validation toast')
      .toContainText("Validation of field group 'Billing Information' triggered.");
  },
  // five controller-built Message Dialogs as popup_display fragments; the OK
  // button closes client-side (popup_close), so a second open must work too
  z2ui5_cl_ai_app_273: async (page, expect) => {
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
  z2ui5_cl_ai_app_142: (page) => formFieldValues(page),
  z2ui5_cl_ai_app_175: (page) => formFieldValues(page),
  // Grid element-binding to an array path + index-relative child bindings
  z2ui5_cl_ai_app_226: async (page, expect) => {
    await expect(page.locator('body'), 'the {0/INTROTEXT1} index-relative binding')
      .toContainText('This Grid Layout sample application demonstrates');
  },
};

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
  .filter((m) => /^z2ui5_cl_ai_app_\d+$/.test(m.class))
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
  const cls = m.class.replace('z2ui5_cl_ai_app_', '');
  if (errs.length) { failed++; console.log(`FAIL  ${cls}  ${errs[0]}`); }
  else console.log(`pass  ${cls}${INTERACTIONS[m.class] ? '  (+interaction)' : ''}`);
}

await browser.close();
backend.kill();
console.log(`\ne2e-smoke: ${metas.length} port(s), ${failed} failing.`);
if (STRICT && failed) process.exit(1);
