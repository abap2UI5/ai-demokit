# STATUS-history.md — the chronological journal

_The append-only history of the project: batches, probes, audits, fixes —
one section per event, newest first. **New journal entries go here** (same
same-change discipline as AGENTS.md §10). The current point-in-time state
(generated counts) and the open findings backlog live in
[STATUS.md](STATUS.md). Numbers quoted inside these sections are snapshots
of their date and are NOT kept current._

## Depth port BusyDialogLight — coverage crosses 250 (2026-07-30)

- **App 251** (`sap.m.sample.BusyDialogLight`): the controller's
  `oDialog.open()` + `setTimeout(close, 3000)` is the app-147 idiom applied
  to a dialog — `SHOW_BUSY` round-trips into `control_by_id BusyDialog open`
  plus `START_TIMER CLOSE_BUSY 3000`, the timer round-trip closes. The
  single-control `BusyDialog.fragment.xml` is inlined into `l:dependents`
  (the `core:Fragment` reference dropped, declared). Every fast gate green
  on the first pass. **Coverage 250/741.**

## Depth port ColorPalettePopover (2026-07-30)

- **App 250** (`sap.m.sample.ColorPalettePopover`, covered-control(1) depth):
  the controller lazily builds SIX differently configured
  `ColorPalettePopover` instances and `openBy()`s them — the port declares
  all six 1:1 in the view's `mvc:dependents` and opens each roundtrip-free
  via `control_by_id openBy` (the dependents-declared popup-mode idiom at
  its largest so far). `colorSelect` is the app-008 client-composed toast.
  Coverage 249/741.
- Two boundary findings, both declared: **an XML `string[]` attribute
  splits on commas**, so `hsl(0,100%,71%)` and `rgb(255,234,234)` cannot
  ride the `colors` attribute at all (CSSColor validation also rejects any
  escaping workaround) — they become their exact hex equivalents
  `#ff6b6b`/`#ffeaea`; and `handleLiveChange` paints the pressed button's
  icon via raw DOM styling (`getDomRef().firstChild...style.color`) —
  direct DOM manipulation with no bindable property, dropped IMPROVISED.

## Depth port ButtonWithBadge (2026-07-30)

- **App 249** (`sap.m.sample.ButtonWithBadge`, covered-control(1) depth pick,
  idiom-first): the badge idiom exists nowhere else in the corpus —
  `sap.m.BadgeCustomData` (@1.80, secondary control under the in-scope
  `sap.m.Button` headline, the app-244 Avatar precedent), `Button.badgeStyle`
  (@1.132) and the `BadgeEnabler` `setBadgeMin/MaxValue` methods via
  `control_by_id`. Coverage 248/741.
- Thin-frontend rewires, all declared: the StepInput and the badge share one
  two-way `/BADGECURRENT` field (the controller's `getBadgeCustomData().
  setValue()` copy becomes a binding, the StepInput `change` wire is
  dropped); the min/max clamp logic runs server-side with the
  reset-to-last-accepted behaviour of the original, and the accepted value
  reaches the button via `setBadgeMin/MaxValue` follow-ups; the icon/text
  `{= ${/flag} ? ${/value} : '' }` expression bindings port verbatim via the
  `_bind`-interpolation form. `badgeMin/Max` are `TYPE i` (the original
  model carries strings, the `numeric-bound-as-string` lint wants numbers —
  declared).

## Out-of-scope debt decided: all six ports KEEP permanently (2026-07-30)

- The six-port drop-vs-keep question (STATUS open findings since 2026-07-26)
  is **decided: KEEP, permanently** — taken in-session under the standing
  continue-with-everything mandate after the question had been surfaced to
  the maintainer four times without an objection; recorded so it can be
  revisited: reverting any one app is deleting the port + its
  `ui5/scope-exceptions.json` entry.
- Per-app rationale lives in the exceptions file: 121 UploadSet (deprecated,
  only upload-set coverage), 136 SidePanel (@1.107), 141 InvisibleMessage
  (@1.78, only a11y-announcement idiom), 165 ProductSwitch (@1.72, the most
  borderline), 166 sap.f SemanticPage (deprecated since 1.54, complements
  the sap.m.semantic ports), 203 OverflowToolbarTokenizer (experimental
  @1.139, documents the experimental-tag scanner lesson). All six are
  gate-verified working ports; deleting them would remove training signal
  the corpus has nowhere else.
- The class cannot regrow: the source-backed scope gate stays a **hard
  gate** (exit 1) for any NEW ported out-of-scope sample without a decided
  entry, and stale entries fail too. The generated STATUS row now reads
  "decided KEEP" instead of "pending".

## First GROUP-nested port: TreeTable.JSONTreeBinding (2026-07-30)

- **App 248** (`sap.ui.table.sample.TreeTable.JSONTreeBinding`) is the first
  port of a GROUP-nested sample (`<Group>.<Child>` universe naming, AGENTS
  §1) — and the only genuinely portable NEW-CONTROL entry left in the
  backlog tail (the rest is OPA/gherkin test samples, routing/view concept
  samples and OData tree bindings). `validate-meta`'s sample-name regex
  still rejected group names (`<lib>.sample.<Name>` with no dots); it now
  allows the dotted child part — the scaffolder already handled the
  mapping.
- The port models the fixed-depth Clothing tree as **nested ABAP types
  under a `CATALOG-CLOTHING` structure**, so the rows binding keeps the
  original's `/catalog/clothing` root + `arrayNames: ['CATEGORIES']`
  1:1 (`_bind` on a structure component resolves the deep path). Two
  homogeneous-type caveats are declared: a level-3 leaf carries an empty
  child array (JSONTreeBinding reads [] as a leaf), and a level-3 category
  row serializes initial `AMOUNT`/`SIZE` fields — `SIZE ''` stays hidden
  through the original's own `!!${size}` guard, and `Currency.value` gets
  the app-220 optional-value guard so category Price cells stay empty
  (declared; the plain `{amount}` would render `0.00`).
- All four toolbar actions are wired 1:1 roundtrip-free: `collapseAll` /
  `expandToLevel(1)` via `control_by_id`, and **Collapse/Expand selection
  via `$event.oSource.getParent().getParent().getSelectedIndices()`** —
  the resolved index array passes through `castArgAuto` untouched into the
  public `collapse`/`expand` methods. e2e interaction: expand first level →
  'Accessories' renders, collapse all → gone.
- Interactions batch 3 was trimmed to what proves stable headless: 132
  (tags-variant SideNavigation collapse round-trip) is armed and its
  LIVE_TEST converted; 097/101/172/207/233 need per-app debugging that
  outgrew this pass (Wizard footer clicks time out, SplitApp detail text
  never surfaces, the ListItemTypes Select id collides) — they stay
  LIVE_TEST, un-armed, for a later pass.

## Framework bug found by e2e: the MessageBox onclose action never reached the backend (2026-07-30)

- Arming the 093 close-confirm interaction surfaced a **real abap2UI5
  regression**: `Messages.js` passed the pressed MessageBox action INSIDE
  the event array (`eB([ONCLOSE, sAction])`, since #2441), but
  `Server.roundtrip` reads the event name from `ARGUMENTS[0][0]` and then
  **shifts the whole array away** — the action never landed in
  `T_EVENT_ARG`, so `get_event_arg( )` after an onclose event always
  returned initial. Every confirm dialog's OK/YES was indistinguishable
  from Cancel (silently — the wrong branch just ran). Fixed upstream on
  the abap2UI5 branch: the action rides as the first positional argument
  (`eB([ONCLOSE], sAction)`), the shape `evImageEditorPopupClose` already
  used; ABAP mirror regenerated (`app2abap`), abaplint 0.
- In the e2e harness the symptom was harsher than in a real system: the 702
  downport materializes the `t_event_arg[ v ]` table expression into a
  `READ TABLE` + `RAISE cx_sy_itab_line_not_found`, and e2e-build maps that
  RAISE to `ASSERT 1 = 0` — which the ABAP `TRY ... CATCH cx_root` does NOT
  catch, so the read of a missing arg 500s the round-trip instead of
  returning initial. Worth remembering when an e2e run shows
  `ASSERTION_FAILED at ...get_event_arg`: in a real system that path is a
  caught no-op.
- Affected ports: 093 (new close-confirm flow) and **101** (the Wizard's
  cancel/submit confirm — its `CANCEL_CLOSED` branch could never see `YES`
  under the broken wire). CAPABILITIES' MessageBox row now documents the
  regression window; both ports work unchanged with the fix. **With the fix
  in the rebuilt harness the 093 interaction runs green end to end** (close
  icon → confirm with the item name → OK → row removed + toast), and the
  audit interactions all pass (092/122/157/167/168/234/238 — 238's popover
  box measures empty headless, so its assertion reads the rendered text).
  Open-LIVE_TEST ports 49 → 47.

## Faked-event-value audit + formatter guard closure (2026-07-30, follow-up to the pr/-closure batch)

- **pr/formatter-date-empty-guard closed — already upstream.** The guard
  (`if (!s) return null;` in `DateCreateObject`) ships in abap2UI5's
  `model/formatter.js` with the exact Invalid-Date rationale as a source
  comment (ABAP mirror included). Folder deleted, Implemented row added;
  the port-side expression guards and the `unguarded-date-formatter`
  pattern-lint rule stay as defense in depth for systems on older
  framework releases. `pr/` is now down to ONE deliberately deferred
  request (`menu-item-selected-path`, user decision 2026-07-20).
- **The faked-event-value audit ran as a scripted sweep** over the 49
  `generated` ports (original controller reads `getParameter`/`getSource`
  values + port transports no `$`-arg + port toasts): four hits, each
  fixed 1:1 the same day:
  - **092** `TableAutoPopin`: `onPopinChanged` now composes
    `Number of hidden pop-ins: {0}` from
    `${$parameters>/hiddenInPopin}.length` client-side (was a static
    round-trip toast).
  - **093** `TabContainer`: the full `itemCloseHandler` —
    `check_prevent_default` on the itemClose wire (the original calls
    `preventDefault()` unconditionally), name + row index transported (the
    dnd `oParent.indexOfItem` idiom), `MessageBox.confirm` with `onclose`,
    OK deletes the bound row (`removeItem` for a bound aggregation) and
    toasts with the 500ms duration, Cancel toasts the cancel text.
  - **167** `ToolPage`: itemPress toasts the real item text, itemSelect
    navigates the NavContainer to the item's key page (roundtrip-free
    `control_by_id to` with `${$parameters>/item}.getKey()`),
    `sideExpanded` + the toggle tooltip are two-way bound with the
    pre-toggle tooltip semantics, the user popover (Feedback/Help/Logout)
    and the Quick Create dialog are rebuilt 1:1 (design guard server-side
    on `${$source>/design}`).
  - **168** `GridContainer`: the three switches now DRIVE the grid —
    `snapToRow`/`allowDenseFill`/`inlineBlockLayout` two-way bound to the
    switch states (007/128 pattern, change wires dropped and declared);
    `columnsChange` recomputes the bound columns counter; tile/card
    presses toast `Press was fired on - {0}` from
    `$event.oSource.getMetadata().getName()`; the sample-local RevealGrid
    helper stays dropped (145 precedent), now without a fake toast.
- Six new INTERACTIONS arm the fixes (093 confirm-close, 122, 157, 167,
  168, 234 FCL layout flip, 238 Card popover); results in the follow-up
  commit after the rebuild.

## Backlog sweep (2026-07-30) — three pr/ closed against upstream, the toast-substitution class reworked, INTERACTIONS 12 → 39

The two "deferred — too large" framework requests turned out to be **already
merged upstream** (abap2UI5 main had moved past our stale local ref):
`cs_event-keyboard_shortcut` and the MessagePopover URL policies landed with
**#2482**, and `s_ctrl-check_prevent_default` (the `eBP` wire) is in main too.
So the work was port integration, not framework code:

- **pr/ closed (3):** `core-commandexecution-keyboard-shortcuts` — app 232
  registers Ctrl+S/Ctrl+D on init, every `cmd:` button fires the same backend
  SAVE/DELETE/PSAVE events and the backend gates each command on its
  enabled/visible flags (residual: the registry is document-global, no
  popover-local command scope). `event-prevent-default` — app 241 bakes
  `check_prevent_default = prevent_default` into all eight press wires; the
  checkbox got a declared `select` wire whose redraw re-bakes the flag
  (status reset `checked` → `generated` per the invalidation rule).
  `messagepopover-async-url` — app 067 installs the `RELATIVE_ONLY` policy on
  init and wires the original's `urlValidated` toast 1:1. CAPABILITIES rows
  flipped ❌ → ✅ (keyboard shortcuts, conditional preventDefault) and a new
  `setAsyncURLHandler` row added; folders deleted, Implemented rows left.
- **Toast-substitution rework (9 ports, the STATUS backlog list):** 106/107
  (`${$source>/pressed}` toggle toast + the controller-built MessagePopover
  over the `message>` model as a MessagesIndicator dependent, seeded through
  the `z2ui5.cc.MessageManager` bridge), 112 (ResponsivePopover-with-
  ColorPicker via `popover_display`, the Device.system.phone branch as
  `device>` bindings), 147 (global BusyIndicator 1:1: `BUSY_INDICATOR`
  show(delay) + `START_TIMER` HIDE_BUSY duration → hide — the setTimeout
  chain as frontend actions), 149 (URLHELPER REDIRECT, the original's
  relative Card-Explorer URL), 170 (Card.fragment.xml rebuilt 1:1 into an
  anchored `popover_display` on both wired presses + the Edit button's
  `areaShrinkRatio` toggle as a two-way binding), 218 (the review-flagged
  `oSF.suggest()` popup-reopen wired as a second `control_by_id` follow-up),
  244 (`breakpointChange` @1.147 wired as a view attribute, POST_171 —
  Phone/Tablet/Desktop → bound Avatar `displaySize` + the media-range
  toast), 246 (the original `handleUploadPress`: two-way bound value,
  empty → 'Choose a file first', else `upload` + `clear` follow-ups;
  `checkFileReadable` declared inexpressible).
- **e2e INTERACTIONS 12 → 39**: per-port click→assert checks now cover every
  major LIVE_TEST class — client-composed toasts (003/005/008/016/049/061/
  074/076/080/134/156/198), popups & popovers (019/066/067/103/104/112/170/
  229/236/243), anchored opens (060/091/227), two-way round-trips (128/130/
  133/177), action chains (147/242/246), the new keyboard-shortcut (232),
  prevent-default (241), breakpointChange (244) and semantic-state (107)
  wires. The nightly e2e run is the close path that converts verified
  LIVE_TEST entries into NOTEs.
- All fast gates green at commit time (abaplint 0 across all three configs'
  root build, pattern-lint 0 — the 149 object-literal arg moved to the
  pipe-template form the `event-arg-bare-brace` rule expects —,
  structural-diff 0 undeclared, render-smoke 0 failing, data-fidelity 0,
  property-check 0).
- **e2e evidence + conversions (same day, follow-up commit):** the full
  246-port run finished **0 failing** with every armed interaction green
  against the freshly transpiled backend — including
  the three new framework wires (232 Ctrl+S → SAVE toast, 241 checkbox →
  redraw → 'Default was prevented', 244 viewport shrink → 'Media Range:'
  toast) and the reworked 147/170/112/246/107 flows. **Open-LIVE_TEST ports
  62 → 49**: fully covered entries became NOTEs with the run's evidence
  (003/005/049/060/074/080/091/130/133/147/156/177/198/236), partially
  covered ones keep LIVE_TEST with the evidence appended (061/066/067/076/
  103/104/112/128/134/227/229/232/241/242/243/246). Three harness findings:
  **(a)** `LIB_ROOTS` was a hand-kept six-package list, so `sap.tnt`/
  `sap.uxap`/`sap.ui.table`/`sap.ui.integration`/`sap.ui.codeeditor` ports
  "passed" the generic gate on their *Application Error popup* — the list is
  now discovered from `node_modules/@openui5` (the 241 interaction exposed
  the hollow pass); **(b)** app 016's `hideInput` DatePicker `openBy` opens
  the calendar but then loops in `Popover.onfocusin` headless (focus-restore
  bounces off the hidden input) — wiring is 1:1 with the original, recorded
  as a LIVE_TEST finding for the next live check, 091 covers the class;
  **(c)** app 008's palette squares render a zero-height box headless, so
  its colorSelect toast stays uncovered. The headless layout also collapses
  003's breadcrumb links into the overflow Select (the interaction goes
  through the picker) and hides 049's +/- icons (driven by keyboard).

## Backlog sweep (2026-07-28) — dead wires closed, an app-killing crash proved and fixed, the OpenUI5 snapshots refreshed

The open findings that were actionable without a live system, worked off in one
change:

- **`generate_result` had been failing since 2026-07-27** — its `npm ci` runs
  inside the freshly cloned OpenUI5 checkout, and OpenUI5's own committed
  `package-lock.json` had drifted from its `package.json` (`Missing: js-yaml@3.14.2,
  argparse@1.0.10, sprintf-js@1.0.3`), which `npm ci` treats as a hard EUSAGE
  failure. Nothing this repo can fix upstream, so the step falls back to
  `npm install` — we only need their jsdoc toolchain, not a reproducible install.
  **Verified end-to-end the same day, which also corrected the diagnosis**:
  OpenUI5 repaired their lock upstream on 2026-07-28, so `npm ci` succeeds again
  and the workflow would have recovered on its own. The fallback is therefore
  hardening against the next drift, not a live fix — but the outage was real and
  cost eight days of coverage refresh.
- **App 220 (`sap.ui.unified.CalendarMinMax`) did not just have a "crash risk" —
  it did not render at all**, and it is fixed. The 07-27 sweep had traced it in
  the sources; a probe now shows it empirically
  (`scripts/probes/calendar-empty-enddate-probe.mjs`, real OpenUI5 in headless
  Chromium, calendar focused on the month that carries the disabled dates):
  with the plain formatter binding over the empty `END` field the view throws
  *"Date must be a JavaScript or UI5Date date object"* and renders **0** calendar
  days; with the conversion guarded in the binding
  (`` `{= ${END} ? Formatter.DateCreateObject(${END}) : null }` ``, a backtick
  literal so the braces survive) the empty row yields `endDate` `null` and all 42
  days render. The probe also killed the obvious alternative fix: seeding
  `end = start` would disable **nothing**, because `Month._checkDateEnabled`
  compares a range strictly exclusive (`> start && < end`) and reaches its
  single-day branch only when there is no `endDate` at all. Distilled into
  AGENTS §10, CAPABILITIES (date-object row) and the new pattern-lint rule
  `unguarded-date-formatter`, which was regression-tested against the pre-fix code.
- **The dead-`_event`-wire class is closed** (BASELINE now empty). Six ports,
  each rebuilt the way the capability allows rather than left firing a
  round-trip no branch handled: 146 and 150 and 145 the thin-frontend way
  (two-way bound `value`/`selectedKey`/`selectedIndex` + an expression binding
  carrying the controller's own switch — the app-053 shape), 143 and 138 with a
  real `on_event` dispatcher over bound properties (`showFooter` /
  `areaShrinkRatio`, `showSideContent` / Toggle `enabled`), and 148 with the
  **full drag & drop reorder** — CAPABILITIES marks it ✅, so "reorder logic not
  reproduced" had been a wrong improvisation: the drop ships both row indices
  and the insert position as client-resolved `$`-args and `on_event` replays the
  original splice arithmetic in ABAP. 138 also now carries its
  `breakpointChanged` parameter (`${$parameters>/currentBreakpoint}`) instead of
  faking it. Two behaviours stay genuinely dropped and are declared as such:
  138's slider (a jQuery DOM width on a `sap.m.Page`, which has no width
  property) and 145's `RevealGrid` overlay (a sample-local helper module, not a
  UI5 API). The six keep status `generated` — the headline gap is closed and
  gate-verified, a full end-to-end re-review per port is not.
- **Five more capability-refuted substitutions replaced** in the same pass, each
  one a case where the port had claimed a loss the framework can express:
  **124** did a full backend round-trip per slider drag step → the same
  expression binding as 053/146; **160** toasted "Link pressed" where the
  original opens `MessageBox.alert('Link was clicked!')` → `message_box_display`
  (its own sidecar had already called this a wrong improvisation); **163**
  hardcoded each button's caption into its toast → `${$source>/text}`, and its
  dropped `ActionSheet.fragment.xml` is rebuilt 1:1 and anchored with
  `popover_display( by_id = $event.oSource.sId )`; **109** toasted only event
  names → `weekNumberPress`/`startDateChange` now carry their `weekNumber` /
  `date` parameters (`selectedDatesChange` stays name-only: its parameter is an
  array of DateRange *controls*, which is not transportable); **127** toasted a
  bare "Pressed" on the rationale that the runtime id is "not reproducible
  statically" → it does not need reproducing, `$event.oSource.sId` reads it off
  the event.
- **The dropped sample CSS of 122/124 is shipped** — and the "blocked" call that
  first went with it was wrong. `curl` to `raw.githubusercontent.com` is refused
  by this environment's proxy, and that was taken for "no OpenUI5 source
  reachable"; **`git clone` of `SAP/openui5` works fine**, which is what the
  pipeline uses anyway. With the checkout, both missing stylesheets were
  recovered and archived (closing that §4 archive gap) and injected into the
  ports through a `core:HTML` `<style>` leaf, the documented CAPABILITIES form.
  Both ports had been carrying the class names with no rules behind them: app
  122 rendered every icon at the default size (the sample is *about* icon
  sizes) and app 124's five grid tiles rendered as unstyled text instead of the
  blue rounded boxes. **Lesson: one blocked protocol is not a blocked network** —
  check the transport the tooling actually uses before declaring a task
  impossible.
- **The OpenUI5-derived snapshots were refreshed by hand** from that checkout,
  the work `generate_result` had not been doing since 2026-07-20:
  `ui5/properties.json` (831 → 928 controls), `ui5/universe.json` (736 → 741
  samples — five new `sap.f.HeroBanner` samples, all @1.152 and therefore out of
  scope) and `api.md`/README against real control metadata from OpenUI5
  **1.152.0**.
- **The `sap.ui.comp` overview rows no longer hand out links that 404.** The
  three OpenUI5 reference links (API, sample source, live runner) are built only
  for a library OpenUI5 actually ships; a `ui5_only` row renders just its ABAP
  class link plus a MessageStrip saying why. The commercial host stays excluded
  (`pattern-lint` `commercial-ui5-host`).
- **App 251 names the variant action through `client->cs_event-smart_variant_init`**
  now that abap2UI5 #2481 is on main — the last open cleanup of the smart-controls
  batch. `pr/smartvariant-initialise` is retired per the `pr/` convention (folder
  removed, recorded in the implemented table).
- **One new `pr/` request filed:** `formatter-date-empty-guard` — make
  `Formatter.DateCreateObject` return `null` for a falsy input instead of an
  Invalid Date. Low priority (every port can guard it itself, and pattern-lint
  now makes sure it does), but the unguarded failure mode is a whole-view crash
  that names neither the control nor the field.

Ladder unchanged (48 `generated` · 146 `reviewed` · 57 `checked`) — the reworked
ports keep their rung, the headline gap is what closed; open LIVE_TESTs 70 → 61. All gates green: abaplint STANDARD + CLOUD + the 702
downport, validate-meta, pattern-lint (incl. the new rule), structural-diff
--strict, structure-lint, property-check, data-fidelity, render-smoke.

## Overview state survives the browser Back button (2026-07-27)

User report: search something in the overview, or flip the Shell switch, start
an app and press Back - the overview comes back in its default state. Two
independent causes, both fixed.

- **Framework (abap2UI5, branch `claude/ai-demokit-state-loss-cyz42a`,
  pr/nav-app-call-caller-draft).** Every roundtrip saves the app under a NEW
  draft id, and `nav_app_call` saves the CALLING app - including the two-way
  model delta that arrived with the triggering event - under that fresh id.
  The caller's hash entry, however, still carried the draft of its last
  RENDER, so Back restored the state the user saw before touching any
  control. The response now carries `nav_app_call_prev_app`/`_id` and
  `View1._repointCallerEntry` `replaceHash`es the caller's entry onto the
  fresh draft before pushing the called app's route (KEEP mode; first hop of
  a request only, so `A -> B -> C` keeps A's entry). Covered by
  `node/tests/view1History.spec.js` (6 cases, the repoint one fails without
  the fix) and an extended `test_stack_call`.
- **Overview app.** The search query lived only in the frontend: the
  SearchField had no bound `value`, and the filter is a `binding_call` on the
  table's items binding, which a rebuilt view starts without. The query is
  now two-way bound (`search_query`), so it travels with the START_APP event
  and comes back with the app state, and `view_display` re-applies the very
  same `binding_call` filter through `follow_up_action` whenever the restored
  query is non-initial. The Shell/tree switches and the three filter
  checkboxes needed no app change - they were already two-way bound and only
  ever lost to the framework issue above.
- **Not covered by an e2e run**: the overview cannot do a second roundtrip on
  the transpiled Node backend at all - reloading its own draft dies in the
  transpiled `cl_ixml` parse (`ASSERTION_FAILED`, uncatchable in JS), and a
  `nav_app_call` to a fresh app dies in `main_attri_db_load` for the same
  reason. Both are open-abap runtime limits, not app defects (a real system
  runs this daily), so the browser-level proof stays a human check; the
  framework half is unit-tested instead.

## sap.ui.comp smart controls ported — and two lessons (2026-07-27)

New library tree `src/06` (`sap.ui.comp`), batch `b01`, apps 248-252 rebuilt
from the SAPUI5 **Smart Controls tutorial** (SmartField, SmartForm,
SmartFilterBar+SmartTable, page variant management, SmartChart). `sap.ui.comp`
ships only with SAPUI5, so the ports sit outside the OpenUI5 universe, the
`render_smoke` runtime and the property gate by design — AGENTS §3 documents
each exception, `ui5/sap.ui.comp/README.md` the template provenance (the
public SAP-docs sources, since no OpenUI5 checkout carries these samples).

Three lessons came out of the review and the first live run, all now encoded:

- **Never invent a service path.** The first draft pointed every port at
  `/sap/opu/odata/sap/Z2UI5_SMART_TUT_0n_SRV/` — a name that exists in no
  system, which makes an app look runnable when it renders an empty control.
  Corrected to the Gateway demo service `GWSAMPLE_BASIC` (`ProductSet`,
  activate in `/IWFND/MAINT_SERVICE`) with the entity set / field-name
  adaptation declared IMPROVISED per port; where no standard service can
  serve the sample (app 252 needs an *analytical* one), the placeholder now
  reads as a placeholder: `…/<YOUR_ANALYTICAL_SERVICE>/`. Rule written into
  AGENTS §3 and CAPABILITIES.
- **The variant-save crash: solved, after seven refuted hypotheses.**
  Saving a view in app 251 throws `Cannot read properties of undefined
  (reading 'getId')`. `sap.ui.comp` is closed, but the crashing line is not:
  `sap/ui/fl/write/api/SmartVariantManagementWriteAPI.js:26` (and
  `SmartVariantManagementApplyAPI.loadVariants`) call
  `Utils.getAppComponentForControl(oControl).getId()` with no guard, and that
  helper returns `undefined` for an `undefined` control — the exact shape of the
  error. Four hypotheses then died on live evidence, in this order: the app
  component is missing (it resolves), `flexEnabled` gates it (the flag appears
  nowhere in `sap.ui.fl` — only `sap.ui.rta` reads it; a `pr/` request filed on
  that premise was withdrawn the same day), the `smartVariant` association does
  not resolve (XMLViews prefix single associations via `createId`), and no
  personalizable control is registered (`getPersonalizableControls()` returns 2
  and `loadVariants` resolves cleanly). The cause is still open — the lesson to
  keep is the method, not the answer: read the open-source half of the stack
  before filing anything, and check each hypothesis in the running app before
  writing it down as a finding. Port-side fixes landed regardless: the
  `pageVariantPersistencyKey` custom data the docs require, and the filter event
  moved off the backend round-trip.
- **Variant management needed a framework action — and got one.** Saving a
  view in app 251 threw `Cannot read properties of undefined (reading 'getId')`.
  Five hypotheses died on live evidence (app component, `flexEnabled`,
  association-id prefixing, registration, and the SAPUI5 docs' own page-variant
  wiring — which registers **0** controls where the sample's registers 2). The
  actual gap: `sap.ui.comp` expects a controller to call
  `initialise(fnCallback, oPersoControl)`; without it `_oPersoControl` stays
  `null` and `sap/ui/fl/write/api/SmartVariantManagementWriteAPI.js:26` dereferences
  it. Setting the field by hand in the console made Save As work at once, which
  sized the gap exactly. abap2UI5 now has `SMART_VARIANT_INIT` (branch
  `claude/smart-controls-samples-vdfr5y`, four specs, ABAP mirror regenerated;
  the test sandbox also needed the timer globals), and app 251 calls it via
  `follow_up_action`. Method note for next time: the closed half of a stack is
  usually reachable anyway — `sap.ui.fl` is open source and the running system
  serves the `-dbg` sources.
- **The answer: `setPersControler()`, the call a page variant never gets.**
  `addPersonalizableControl()` (read from the served `-dbg` sources) ends with
  `if (this.isPageVariant()) { return this }` **before** `setPersControler()` —
  the setter that both anchors the personalizable control and creates the control
  promise `initialise()` requires. A controller-less app therefore has neither:
  saving dies in `sap.ui.fl`, and once the field is forced by hand the write path
  works while the load path still aborts, so nothing shows after a restart.
  abap2UI5's `SMART_VARIANT_INIT` action now calls `setPersControler()` and then
  `initialise()` as soon as the control's wrapper exists. Live: `isInitialized:
  true`, 7 variants / 7 items, saved views back after a restart.
  What finally cracked it was a temporary tracing build the maintainer installed —
  every hypothesis before that was refuted by a console one-liner, and the ones
  that survived longest were the ones nobody could measure. **Method to keep:
  when the closed half of a stack blocks you, print the function itself
  (`String(oControl.someMethod)`) — sap.ui.comp's sources are served as `-dbg`
  files in the running app, so nothing here needed guessing at all.**
- **A SmartTable without a `UI.LineItem` annotation renders NO columns.**
  First live run of apps 250/251 against GWSAMPLE_BASIC came up with the
  "add columns to see the content" placeholder. The assumption written into
  the sidecars - that the control falls back to all metadata fields - was
  wrong; the initially visible fields have to be named. Both ports now carry
  `initiallyVisibleFields="ProductID,Name,Category,SupplierName,Price"` (an
  attribute the sample does not need, because its own service annotates its
  four columns), declared per port, and AGENTS §3 states the rule.
- **structural-diff was blind to camelCase namespace prefixes.** `isControl`
  matched the prefix as `[a-z]+:`, so every `smartForm:SmartForm`,
  `smartField:SmartField`, `smartTable:SmartTable`, … counted as a lowercase
  *aggregation* and was ignored on both sides — the whole comparison was
  vacuous for these five ports (they reported 0 diffs while one binding
  genuinely differed). The prefix is irrelevant to the control-vs-aggregation
  distinction; the regex now allows any prefix and the real diff surfaced
  (app 249 `{CategoryName}` → `{Category}`). No other port changed.

## pr/ backlog swept — two framework features landed, ports rewired (2026-07-27)

Full pass over the 12 `pr/` requests (user ask after the #37 merge). Result:
**8 implemented · 2 deliberately deferred · 2 niche-open**, every README now
carries an explicit status line.

- **Landed in abap2UI5** (branch `claude/ai-demokit-review-qavjtr`, one
  commit, abaplint 0, ABAP mirror regenerated via `npm run app2abap`):
  **(a)** the `openBy` dispatch falls back to
  `open(false, anchor, 'begin top', 'begin bottom', anchor)` for controls
  without an own `openBy` — `sap.ui.unified.Menu` — so the same wire covers
  every menu family (pr/unified-menu-open-anchored); **(b)**
  `enablePostButton: ["bool"]` listed in `CONTROL_METHODS`
  (pr/feedinput-enable-post-button).
- **Ports**: 227/228 needed no code change — their declared no-op `openBy`
  wires became functional (deviations rewritten IMPROVISED→NOTE, LIVE_TEST
  re-scoped). 236 rewired 1:1: the dialog buttons now toggle the owning
  FeedInput via `follow_up_action(enablePostButton)` + `popup_destroy`, the
  owning feed transported as a static button `t_arg` literal (added ids
  `feedActionPlain`/`feedActionIcon`, declared). Two new e2e INTERACTIONS
  (227 anchored unified.Menu open, 236 dialog→enable→close) verify both
  features against the transpiled framework.
- **Deferred with reasons in the READMEs**: `event-prevent-default` and
  `core-commandexecution-keyboard-shortcuts` both touch the core event
  protocol (eB array slots / a client shortcut registry) — too large to land
  without framework-side tests; `menu-item-selected-path` and
  `messagepopover-async-url` stay niche-open.
- AGENTS §5 cheat-sheet + CAPABILITIES frontend-action rows updated (the
  unified.Menu "current gap" caveat replaced by the fallback).

## Human live check + PR #38 distilled (2026-07-27, after the #37 merge)

- **Nine ports live-verified in a running system and promoted to `checked`**
  (065, 084, 085, 096, 108, 140, 164, 171, 241) — each closes a whole
  LIVE_TEST *class*: MessageManager cc, URLHelper triggers (the class the
  sandboxed e2e can never verify), Tokenizer two-way, SplitContainer
  `control_by_id` navigation, the date-object Formatter path, the two
  sweep-repaired ports (140/164), the nested-object runtime bind, and the
  tnt controller-built Dialog. CAPABILITIES upgraded in the same change:
  the nested single-object row is now **✅ live-verified** (was 🧪), and the
  MessageManager/URLHelper/SplitContainer-nav/date-object rows carry
  live-verified 2026-07-27 evidence.
- **PR #38 (human fix) distilled**: abapGit XML files MUST start with the
  UTF-8 BOM — four agent-written files lacked it; new pattern-lint rule
  `abapgit-xml-bom` gates every `src/**/*.xml` bytewise, and §10 documents
  it plus the second #38 lesson (a single giant `VALUE #( )` exceeds ABAP's
  maximum statement length — the overview catalog now splits in halves via
  `VALUE #( BASE result … )`, kept intact by the regenerated overview).
  The overview class was also regenerated with the merged generator — the
  #38 copy had been produced with a pre-#37 generator state and
  reintroduced the `<CLASS>` ABAP-Doc lint hit.

## Review sweep (2026-07-27) — the empty `reviewed` rung filled: 152 promoted, 49 flagged

The quality ladder's middle rung had been empty since its definition (0
`reviewed` ports). A full adversarial sweep over all 201 `generated` ports
(14 batches, each port read against its archived original, the mocks —
byte-level where inlined — and the abap2UI5/OpenUI5 sources) closed that:

- **152 ports promoted to `reviewed`**, ~60 of them after documentation/data
  fixes applied in the same pass: missing POST_171 declarations of
  gate-invisible members (control-level `NotificationList` @1.90,
  aggregation-level `Title.content` @1.87 / `StandardListItem.avatar` @1.98 /
  `IconTabFilter.items` @1.77, enum values Indication15–20 @1.120,
  `core:require` ≥1.74), wrong deviation vocabulary retyped per the settled
  policy, corrected audit flags, missing inline `"` comments, and real data
  fixes verified against the mocks (lost `&&`-join spaces in 076/077,
  neighbour-copied toast text in 157, an invented row + reordered tail in
  164, mock-contradicting literals in 113/115, ToolbarDesign enum order in
  086, missing `NEW_WINDOW` in 084, wrong token-delete text in 085, twelve
  malformed attribute lines in 140, §5 underscore-field renames in
  192/197/199/201/211/215/223/229/235).
- **49 ports stay `generated`** with corrected, honest sidecars — the rework
  backlog (STATUS.md open findings): dead `_event` wires without an
  `on_event` dispatcher (new pattern-lint rule `dead-event-wire`, 6 BASELINE
  entries), toast substitutions around expressible capabilities (the app-042
  class — several rationales were source-refuted, e.g. "MessageBox has no
  return path", "upload not whitelisted", "suggest not whitelisted"), faked
  event values where `$event.*` transport exists, dropped sample CSS
  (122/124 + §4 archive gaps), and one source-verified crash risk (app 220:
  `end=""` through `DateCreateObject` → invalid-date throw in
  `CalendarDate.fromLocalJSDate`).
- **New scope blind spot found and closed**: `sap.m.OverflowToolbarTokenizer`
  (app 203) is `@ui5-experimental-since 1.139` with no plain `@since` — both
  source scanners (`scope-of.mjs`, `generate-properties.mjs`) now read the
  experimental tag; 203 joins `ui5/scope-exceptions.json` pending the same
  maintainer decision as the other five.
- Concurrency note: the first sweep attempt hit the session limit mid-write
  (13 of 14 agents); partial edits were reverted and the batches re-run —
  only fully-reported batches were ever committed.

All gates green after the sweep (abaplint STANDARD+CLOUD, validate-meta,
pattern-lint incl. the new rule, structural-diff --strict, structure-lint,
property-check, data-fidelity, render-smoke). Ladder now: 49 `generated` ·
152 `reviewed` · 45 `checked`.

## Hold-out probe #2 (2026-07-26) — fidelity way up, syntax is the new frontier

Second regeneration probe, protocol identical to the 2026-07-19 baseline
(full write-up + gate table: **`probes/holdout-2026-07-26.md`**). All 24
hold-out samples generated from scratch by fresh agents (restricted inputs,
no validation runs), scored once, adversarially reviewed (5 reviewers).

**Headline vs baseline:** review MAJORs **6 → 2**, undeclared structural
diffs **4 → 0**, render-smoke raw failures **2 → 0** (zero harness fixes,
was 2), invented data values **0** (data-fidelity green, reviewers verified
mocks byte-level). The two MAJORs are not rule gaps: 618 has a mechanical
paren-balance error (does not compile), 624 rebuilt a MessageBox as a
Dialog on a source-refutable claim (the app-042 lesson class —
`message_box_display` HAS `onclose`). abaplint-green-first-try dropped
22/25 → 19/24: **syntax slips in long builder chains (3 paren errors) are
now the dominant first-try failure mode**, while everything downstream of
syntax improved sharply. The property gate's documented enum blind spot bit
for real once (602 `CalendarDayType.NonWorking` @1.121, undeclared).
Friction logs contained zero capability complaints — nine recurring doc
gaps were distilled into AGENTS/CAPABILITIES in the same change (static-app
skeleton, camelCase-vs-references contradiction, rows-not-columns,
`controllerName` IGNORED_ATTRS, MessageBox `onclose`, MessageToast
positional call, leading-`{0}` template, stale whitelist-only
CONTROL_METHODS phrasing, sidecar `checked` omission). Probe ports were
never merged; only the report landed.

## Infrastructure sweep (2026-07-26) — scope gate wired, data-fidelity gate, STATUS split, e2e nightly

External review round ("was würdest du verbessern?"), all points implemented in
one change:

- **Scope gate is source-authoritative offline** (`pr/scope-since-from-source`
  → implemented): `generate-properties.mjs` now emits each control's
  class-level `@since`/`@deprecated` into `ui5/properties.json` (925 controls,
  621 with a class-level since), and `scopeOf` in `generate-coverage.mjs` (plus
  generate-overview + generate-status) falls back to it when `universe.json`
  carries null. First run surfaced **five** out-of-scope ported samples — the
  four known (121 UploadSet, 136 SidePanel, 141 InvisibleMessage, 165
  ProductSwitch) **plus app 166 (`sap.f.semantic.SemanticPage`, deprecated
  since 1.54)** the manual audit had missed. Pending maintainer decision,
  tracked in STATUS.md. The regenerated properties.json also caught two
  undeclared POST_171 members in app 121 (`UploadSet.mode` 1.100,
  `afterItemRemoved` 1.83) — declared.
- **Universe cleaned**: the 29 "without control metadata" rows classified
  against the checkout — 18 non-samples (shared helpers, test infra, group
  folders with nested samples) now excluded via `ui5/universe-excludes.json`,
  8 real samples mapped to their owning control via `ui5/entity-overrides.json`
  (docuindex gaps: ObjectHeaderResponsiveVI, Form480/SimpleForm480,
  ControllerExtension, 4× sap.uxap ObjectPage*), 3 demo apps
  (AIIntegration/UXCIntegration/TsHelloWorld) stay `unknown` by design.
  Universe: 707 → 689 samples, in-scope 641 → 639.
- **New gate `data_fidelity`** (`scripts/data-fidelity.mjs`, in `checks` CI):
  every asset literal in a port must exist (basename) in the sample's own
  archived files/mocks, full paths must match a mock occurrence, no SAPUI5
  CDN hosts. This is the deterministic half of the 2026-07-24 data audit —
  it reproduces the historical app-162 bug (HT-1000 vs HT-7777) exactly and
  found one live issue (app 121's invented `Screenshot.png`, now declared).
  Mock corpus resolution handles the demo-kit runner's implicit default
  products model (top-level-key match, not just file-name match). `--report`
  prints the value-level audit worksheet. Escapes: deviation naming the
  basename, or sidecar `data_fidelity.skip` (validated by validate-meta).
- **STATUS split**: the journal moved to `STATUS-history.md` (this file);
  STATUS.md is now a generated state block (`scripts/generate-status.mjs`,
  markers `<!-- state:start/end -->`, wired into pre-commit + meta_valid like
  the overview) + the hand-maintained open-findings backlog. The old
  hand-maintained "Where the repo stands" table had frozen at 109 ports/67
  sidecars while the corpus grew to 246 — generated counts cannot drift.
- **e2e nightly** (`.github/workflows/e2e_nightly.yaml`): the heavy real-app
  gate now runs every night (clones abap2UI5, transpiles, boots all ports in
  Chromium) instead of on-demand only; `e2e-smoke.mjs` no longer hardcodes
  the sandbox Chromium path. INTERACTIONS grew from 1 to 4 entries, each
  proving one LIVE_TEST class end to end: 005 client-composed toast, 019
  popup_display Dialog, 060 anchored toggleBy + item-select toast, 094
  popover BIND_ELEMENT. Growing this map is the automated close path for
  the 72-port LIVE_TEST backlog (STATUS.md).
- **Training pairs exportable** (`scripts/export-training-pairs.mjs`): the
  TRAINING.md fine-tune JSONL shape as a command — 45 `checked` pairs today,
  hold-outs always excluded.
- **i18n policy settled** (user decision): a frontend i18n/resource model
  **contradicts the thin-frontend principle by design** — ABAP translates
  natively (text elements/OTR, `sy-langu`) and serves finished strings as
  bound model fields. CAPABILITIES gained an "i18n texts" row; the §5
  cheat-sheet i18n row now says "never propose frontend i18n as a pr/".
- **Doc drift fixed**: README pipeline/scope text (was sap.m-only, now the
  ten-library reality), AGENTS §3 folder table (`src/02/03/05` were marked
  "planned" though long existing), AGENTS §7 overview description, and a
  pre-existing pattern-lint violation in the generated overview class
  (`<CLASS>` in ABAP Doc from the hash-routing PR) fixed at the generator.
- **Depth phase prepared (same day, second pass)**: the universe now includes
  the demo kit's GROUP-nested samples (47 added: `TreeTable.…`, `p13n.…`,
  `UploadSetwithTablePlugin.…`, `View.…`, `ViewTemplate.…`, …) — taken only
  when the docuindex lists the child as an official sample, named
  `<Group>.<Child>`, archived flat as `ui5/<lib>/<Group>.<Child>/`
  (scaffolder maps the path). Universe 689 → 736 samples, backlog 398 → 425
  with 47 on uncovered controls. `--backlog` now sorts depth rows ascending
  by `covered-control(n)`, and AGENTS §1/TRAINING document the idiom-first
  depth criteria (within equal n, pick the sample exercising something no
  existing port of that control does; skip true near-duplicates). Snapshot
  rebuilt from the fork — api.json metadata absent until the next weekly
  `generate_result` run, the properties.json control-level fallback covers
  Since/Deprecated meanwhile.
- **data_fidelity stage 2 (same day, second pass)**: the gate now also parses
  every `VALUE #( … )` table block (string-literal-aware — parens inside
  backtick literals are data, not nesting) and compares it against its ONE
  best-matching mock array: positional row/field string equality on a full
  inline, per-field set membership on a subset (a legitimate `/Coll/0..n`
  passes, an invented value fails), equality modulo the sanctioned
  sdk.openui5.org host-absolutization, numbers uncompared. Corpus is clean
  (0 errors over 246 ports); both paths regression-tested with injected
  142-class bugs. The out-of-scope check also became a **hard gate** the
  same day (`ui5/scope-exceptions.json`, stale entries fail), and the e2e
  INTERACTIONS grew 4 → 8 verified LIVE_TEST-class checks
  (+091 openBy hidden picker, +104 dialog + binding_call search, +130
  two-way busy round-trip, +133 GridList mode round-trip).
- **app 234 downport defect fixed + gated**: three `FOR i = …` iterators in
  one method downport to three `DATA i TYPE i` — the 702 build and the e2e
  transpiler both failed on it. Renamed to `i`/`j`/`k`; new pattern-lint
  rule `duplicate-for-iterator` (verified: fires 2× on the old code) + §10
  gotcha, per the "greppable lesson → rule" discipline.

## Property gate extended to all libraries (2026-07-24) — blind spot closed

The systemic follow-up (the property gate was `sap.m`-only, so post-1.71 members
in every other library passed vacuously — the root cause of the POST_171 debt
swept earlier). Fixed for real:

- **`generate-properties.mjs`**: `LIB_DIRS` now covers all ten ported libraries
  and scans each **recursively** (nested controls: `form/SimpleForm`,
  `cards/NumericHeader`, `sap.m/semantic/*`, …). `ui5/properties.json` grew
  263 → **831 controls**. A missing lib dir is skipped with a warning (not fatal).
  CI-safe: `generate_result` clones the full OpenUI5 repo, so all libs' `src/`
  are present (verified in `generate_result.yaml`).
- **`property-check.mjs`**: builds a prefix→namespace map from each port's own
  `xmlns` declarations and resolves every control's full dotted name (not just
  `sap.m.<X>`), then walks the parent chain as before. The `sap.m`-only skip is
  gone.
- **Two members the manual audit had missed/deferred, now caught and declared**:
  app 108 `CalendarAppointment.ariaHasPopup` (1.150.0, genuinely in the original
  view) and app 167 `NavigationListItem.expanded` (reads 1.121 — a base-class
  relocation, property predates 1.71; declared with that note). `property-check`
  is green across all 178 ports; the gate now enforces POST_171 for every library
  automatically, so this class of debt cannot silently return.

Residual limits (documented in §5): enum *values* newer than 1.71 stay invisible
at the attribute-name level; a member relocated to a newer base class reads as
that base's version.

## Subagent cold-read probe (2026-07-24) — app 178 (sap.uxap ObjectPage, BlockBase inlining)

Eighth cold-read port and the hardest so far: `sap.uxap.sample.ObjectPageSubSectionWithActions`
(app 178, `src/03`), the thinnest library. Machine-green all gates. Coverage
**178**, `sap.uxap` 2→3. The documented-but-barely-exercised **BlockBase-inlining
idiom worked cleanly** — three `blockcolor:BlockBlue` refs inlined as `core:HTML`
divs (app 161 precedent), one IMPROVISED deviation naming the block→content
substitution covered both structural-diff lines (`control missing` blockcolor:BlockBlue
+ `control extra` core:HTML). All uxap members @since-checked (≤ 1.71).

Even this hardest port surfaced only consistency nits (blank-line prose vs the 161
precedent; §4 "archive everything" vs the reality that SharedBlock sources aren't
copied into `ui5/`; the block-view path pattern). CAPABILITIES BlockBase row
clarified (block-view path, single-deviation declaration, not-offline-archived).
**Conclusion: the agent-file hardening is saturated** — eight consecutive
cold-read ports across seven libraries built machine-green from the docs alone;
recent friction is cross-corpus consistency, not capability or spec gaps.

## Subagent cold-read probe (2026-07-24) — app 177 (sap.ui.unified CalendarDateInterval)

Seventh cold-read port: `sap.ui.unified.sample.CalendarDateIntervalBasic` (app
177, first `sap.ui.unified.CalendarDateInterval`), machine-green, 0 diffs.
Coverage **177**, `sap.ui.unified` 5→6. Data-less-but-stateful (inline flag,
no `model_init`). One LIVE_TEST (event date simplified, same as app 139).

Friction is now down to `@since`-check refinements — both added to the §5
property-gate caveat: **(a)** an inherited member's `@since` lives in the
**parent class file** (follow the `extend` chain — `CalendarDateInterval` →
`Calendar.js`); **(b)** a member with **no `@since` tag** is base-version (≤ 1.71,
no POST_171). The core spec is otherwise saturated for this port class — recent
friction logs surface only cross-corpus consistency nits (references using
dispreferred-but-valid patterns, the scaffolder stub vs the data-less rule),
not capability gaps.

## Subagent cold-read probe (2026-07-24) — app 176 (sap.f GridList grouping)

Sixth cold-read port: `sap.f.sample.GridListBoxContainerGrouping` (app 176),
machine-green. Coverage **176**, `sap.f` 12→13. `sap.f.AvatarGroup` (the only
un-ported *new* sap.f control) was skipped — render-hostile (declared skip), so
a clean depth port was taken. All members @since-checked (≤ 1.71). Slider→width
done as a roundtrip-free expression binding (spec-preferred over the round-trip
that the nearest reference app 144 actually uses — the docs prefer it but no gate
enforces it; noted).

Two doc fixes from the friction log:
- **§5**: `stringify( )` renders from the root, so **trailing `shut( )`s are
  optional** — a chain may end at the deepest node with a bare `).` (all open
  nodes close structurally in the output). `shut( )` only moves the cursor to add
  a higher sibling. Confirmed in the builder (`stringify` → `root->render( )`).
- **generation-prompt.txt**: the `<DESCRIPT>` line now matches §5 (scaffolder's
  `<library> - <sample name>` default) instead of the old `<entity> - <desc>`
  that contradicted it.

## Subagent cold-read probe (2026-07-24) — app 175 (first SimpleForm) + ref bug

Fifth cold-read port: `sap.ui.layout.sample.SimpleFormToolbar` (app 175, first
`sap.ui.layout.form.SimpleForm` — a new control), machine-green, **0 structural
diffs**. Coverage **175**, `sap.ui.layout` 10→11. All SimpleForm members
@since-checked by hand (≤ 1.71, no POST_171).

- **app 142 fixed** — like 162, its nearest-neighbour data was wrong: it seeded
  `Titanium`/`Walldorf`/`Star Street`… but its sample `bindElement`s
  `/SupplierCollection/0` and the mock's only row is `Red Point Stores` / `Main
  St 1618` / `Maintown`. Corrected all address fields to the real row-0 values.
- **Recurring IMPROVISED-vs-NOTE confusion resolved in §5** (surfaced by 173/175
  and flagged earlier): a pure prefix-drop that renders identically (0 diffs) is
  `NOTE`; `IMPROVISED` only when the fold loses/changes data. Also documented the
  `bindElement('/X/0')` → seed-fields-at-default-model-root idiom, and that
  seeded values must be the actual mock row, verified — not a neighbour's.
- **§5**: a camelCase JSON key mirrors verbatim into the ABAP field / binding
  (`SupplierName`→`{SUPPLIERNAME}`, never `SUPPLIER_NAME`).

Pattern across the probes: the written spec builds correct ports, but several
**existing ports carry wrong seeded data copied from neighbours** (162, 142) —
the "verify against the sample's own mock, not the nearest port" caution (§5) is
now doubly proven.

**Data-fidelity audit run (2026-07-24):** all 175 ports scanned, the
single-record-flatten / named-model-scalar class verified value-by-value against
each sample's actual mock. Result: **one more bug — app 119 (FixFlexVertical)**
seeded `HT-1000.jpg` where its `{img>/products/pic1}` binding resolves to
`HT-7777-large.jpg` (same wrong-neighbour copy as 162). Fixed. Everything else
verified correct (image ports 006/031/046/162/173; supplier flatteners
020/084/142/175; product flatteners 041/071/073/087/089/048; date/wizard
017/018/101). The corpus is otherwise data-clean; multi-row verbatim tables were
spot-checked only (row 0 correct) and are lower-risk.

## Subagent cold-read probe (2026-07-24) — app 174 + json-to-abap truncation fix

Fourth cold-read port: `sap.ui.table.sample.RowHighlights` (app 174), machine-green
all gates. Coverage **174**, `sap.ui.table` 3→4. Chosen over the suggested
TreeTable because that needs a recursive/arbitrary-depth tree binding ABAP can't
type (new **CAPABILITIES ❌ row**) — a genuine boundary the probe pinned down.

The friction log drove several fixes:

- **`json-to-abap.mjs` truncation bug fixed** — it inferred a numeric column's
  type from the **first row only**, so a decimal column whose row 0 is
  integer-valued (`Price` 956) was typed `i` and every later decimal (`6.99`)
  silently `Math.trunc`ated. Now it scans **all rows**, emits any decimal column
  as a backtick string (no truncation) and warns. **app 170's data was corrupt
  from this** (Width/Depth/Height `40.8→40`, Price `6.99→6`) — regenerated with
  the fixed tool: dimensions now `TYPE string` (display-only text template, exact
  decimals), Price packed with decimals preserved.
- **`structural-diff` mechanics documented** (§6): it flags only *missing*
  controls/attrs (extras never), compares the full **qname incl. prefix**, and a
  diff is "declared" only when a deviation's `what` names the missing item
  verbatim — so dropping a `press`/`change` handler for a binding must name that
  attribute.
- **CAPABILITIES**: recursive TreeTable binding ❌ (fixed-depth nesting stays ✅).
- **§10 gotcha**: abaplint `commented_code` fires on English comments with `/` +
  UI5 identifiers — reword.

## Subagent cold-read probe (2026-07-24) — app 173 + a bug in its reference

Third cold-read port: `sap.ui.layout.sample.VerticalLayout` (app 173, first
`sap.ui.layout.VerticalLayout`), machine-green all gates. Coverage **173**,
`sap.ui.layout` 9→10. The written spec was sufficient to build a correct port —
the friction was that the **nearest reference (app 162, HorizontalLayout)
contradicted the spec**, and the probe caught a real bug in it:

- **app 162 fixed** — it seeded `pic1 = …/HT-1000.jpg` (host-relative), but the
  shared demo mock `sap/ui/demo/mock/img.json` has `products.pic1 =
  …/HT-7777-large.jpg`. Wrong image id **and** a relative URL against the
  `sdk.openui5.org` asset-host rule. Corrected to the absolute `HT-7777-large`
  URL (a model-seed value; no gate saw it — render-smoke mocks the model,
  structural-diff ignores data). app 173 seeded the correct value.
- **Doc fix** — §5 "Worked references" now warns that a reference shows an idiom,
  not ground truth: the spec/CAPABILITIES/sample-source win on conflict, and
  seeded data values must be checked against the sample's own mock, not the
  neighbour.

**Open maintainer question flagged by the probe:** the deviation *type* for a
named-model prefix-fold is inconsistent across the corpus — §5 says `IMPROVISED`,
CAPABILITIES frames a pure prefix-drop as the faithful standard (0 diffs), and
ports split (006/173 `IMPROVISED`, 162 `NOTE`). A one-line policy — `NOTE` for a
pure same-data prefix-drop, `IMPROVISED` only when the fold loses columns or
resolves statically — would make it countable. Left for a maintainer decision,
not rewritten unilaterally.

## Non-sap.m POST_171 audit (2026-07-24) — systemic debt swept

Prompted by the 128/132 finding, a full `@since` audit of all 61 non-`sap.m`
ports (`src/02`–`src/05`) — the libraries the property gate is blind to — every
member cross-checked against the OpenUI5 source, then independently re-verified
before fixing. **Undeclared post-1.71 debt found and corrected in 5 ports:**

| Port | Member(s) now declared | @since |
|---|---|---|
| 113 (`sap.tnt.InfoLabel`) | `InfoLabel.icon` | 1.74 |
| 128 (`sap.tnt.SideNavigation`) | `NavigationListItem.selectable` | 1.116 |
| 132 (`sap.tnt.SideNavigation`) | `NavigationListItem.selectable` + `tag` aggr. | 1.116 / 1.149 |
| 164 (`sap.ui.table.Table`) | `Table.rowMode` aggregation | 1.119 |
| 167 (`sap.tnt.ToolPage`) | `NavigationListItem.selectable`/`design`/`press`/`ariaHasPopup` (fixed a wrong @since citation) | 1.116 / 1.133 |

Excluded as false positives (base-class relocation, still functionally pre-1.71):
`NavigationListItem.expanded` (@since 1.121, the `NavigationListItemBase` split)
and `.visible` (@since 1.52). Every other non-`sap.m` port uses only members
`@since ≤ 1.71`. This closes the debt the blind gate had accumulated; the real
fix (extending `properties.json`/`LIB_DIRS` to the other libraries so the gate
enforces this automatically) remains the open follow-up, gated on the
`generate_result` CI checkout including those libs' `src/`.

## Subagent cold-read probe (2026-07-24) — app 172 + latent POST_171 debt found

Second subagent cold-read: `sap.tnt.sample.SideNavigationUnselectableParents`
(app 172, `src/05/b06`), machine-green (all gates incl. render-smoke), one
POST_171 (`NavigationListItem.selectable` 1.116) + two LIVE_TEST. Coverage
**172**, `sap.tnt` 7→8.

The probe's manual `@since` discipline (forced by the property-gate blindness
documented the same day) **found real latent debt**: apps **128 and 132** ship
`NavigationListItem.selectable="false"` (@since 1.116) with **no POST_171
declaration** — the blind gate had hidden it. Corrected both sidecars. (app 167
already declared it.) This is exactly the failure the property-gate caveat warns
about, now proven to have already happened; a broader `@since` sweep of all
non-`sap.m` ports (`src/02`–`src/05`) is a worthwhile follow-up.

Doc fixes from the friction log: the client-toast `t_arg` tuple order
(object/method/template/arg, wire token `MESSAGE_TOAST`) added to the §5
cheat-sheet; §5 now states a data-less-but-stateful app seeds its flag inline
(no `model_init`) and that a scalar literal→two-way binding is faithful, not a
structural-diff trigger (declare LIVE_TEST for the behaviour, not the diff).

## Subagent cold-read probe (2026-07-24) — app 171, first `sap.ui.unified.Currency`

A fresh subagent (its own context, no port memory) ported
`sap.ui.unified.sample.CurrencyInTable` from the agent files alone, ran every
gate green, and returned a friction log — the strongest test yet of "can an AI
build from the docs". Result: **machine-green** (abaplint STANDARD+CLOUD,
validate-meta, pattern-lint, structure-lint, structural-diff `--strict` 0
undeclared / clean 1:1, property-check, render-smoke pass). Coverage **171**,
`sap.ui.unified` 4→5. One deviation: LIVE_TEST on the nested-object bind.

Independently re-verified before commit. The probe surfaced four real doc gaps,
all fixed same change:

- **Nested single (non-array) object bind** `{transactionAmount/size}` was
  undocumented (only nested *arrays* were). New CAPABILITIES row (🧪) + §5
  cheat-sheet: keep a nested ABAP structure, bind the relative sub-path
  `{OBJ/FIELD}`, don't flatten. app 171 proves view-create; runtime bind LIVE_TEST.
- **`property_gate` covers `sap.m` only** — `properties.json` holds no other
  library, so for `src/02`–`src/05` the gate passes vacuously. §5/§6 now say so
  and require a manual `@since` check against the OpenUI5 source. (Re-checked
  169/170's non-sap.m members by hand: all ≤1.71 — `snappedTitleOnMobile` 1.63,
  Grid/GridData 1.15, DynamicPage* 1.42 — no undeclared POST_171.)
- **`path:` inside a raw binding string uses the upper-cased ABAP field name**
  (`'exchangeRate'`→`'EXCHANGE_RATE'`), same as the brace form — no gate catches
  a stale camelCase path. Added to §5 + the cheat-sheet typed-binding row.
- **`<DESCRIPT>` rule** contradicted the scaffolder and had no offline
  description source — §5 now endorses the scaffolder's `<library> - <name>`
  default.

## From-scratch probe (2026-07-24) — app 169, first `sap.ui.layout.Grid` port

The real regeneration probe the agents-usability pass owed: **built entirely
from the agent files**, from the OpenUI5 source (`oblomov-dev/fork-openui5`
cloned into the session), no reference to another port (there was none — new
control). Chosen breadth-first: `sap.ui.layout.sample.GridData`
(`sap.ui.layout.Grid` + the `GridData` responsive layoutData — span / indent /
linebreak / visibility), a single-view sample so `structural-diff` is meaningful.

**Machine-green on the first serious pass** — abaplint STANDARD + CLOUD (0
issues), validate-meta, pattern-lint (after fix, see below), structure-lint,
structural-diff `--strict` (**0 undeclared**; 2 declared: the injected CSS
`core:HTML` + the dropped `Slider.liveChange`), render-smoke (real
`XMLView.create`, **pass**), property-check (0 post-1.71). Coverage **169**;
`sap.ui.layout` 8→9. Deviations: 1 IMPROVISED (the eight Sliders'
`.onSliderMoved` resizes the grid wrapper by jQuery DOM traversal — no
server/bindable equivalent, dropped), 2 NOTE (CSS injected via `core:HTML`;
`core:HTML` div/`FormattedText` markup written decoded).

Two friction points a fresh AI hits — the docs were correct but not crisp, now
fixed in the same change (AGENTS §5 "Idiom cheat-sheet" CSS row + CAPABILITIES
"Custom CSS"):

- **`core:HTML content` needs decoded markup.** The original view.xml carries
  it entity-encoded (`&lt;div&gt;`); you must write the literal `<div>` because
  the builder re-escapes on stringify — copying the entities double-escapes.
- **Escaped braces `\{ \}` must be a backtick literal**, not a `|…|` template.
  Backtick passes `\{` through to the serialized attribute; a pipe collapses
  `\{`→`{` and re-crashes — the exact reverse of the typed-binding string (which
  wants real braces and so uses the pipe). Verified against apps 026/028.

A third, minor: `pattern-lint no-blank-before-shut` requires a blank line before
the first `)->shut(` of a closing group — easy to miss from the prompt's terse
"before shut". Fixed (15 warnings → 0); prompt wording left as-is (the rule
gates it anyway).

## Agents-usability pass (2026-07-24) — make the docs hand an AI the exact rule

Focus: lower the barrier for an AI to build a port first-try from the agent
files alone. Cold-read one weakly-covered port (app 164, `sap.ui.table`
RowModes) against ground truth + the offline gate baseline (all green:
validate-meta 168/168, pattern-lint 0/0, structural-diff `--strict` 0
undeclared, structure-lint 0). Full write-up: **`probes/agents-usability-2026-07-24.md`**.

Three idioms were correct in the docs but **buried in prose** (an AI had to
re-derive the one-line action): named-model folding, typed/complex bindings with
escaped braces, and the aggregation namespace. Fixed same change:

- **`AGENTS.md` §5 — new "Idiom cheat-sheet"**: the ~12 recurring hard idioms as
  copy-paste one-liners (`original → port → detail`), each pointing at its
  long-form rule + proving app; the two ❌ boundaries (control factories,
  app-authored JS formatters) stated once as "declare, don't improvise".
- **`AGENTS.md` §5 — aggregation-namespace rule** made explicit (an aggregation
  carries its XML tag's namespace = its parent control's; a wrong `ns` is an
  unknown-aggregation node `render_smoke` rejects), app 164 as example.
- **`scripts/generation-prompt.txt`** — three lines added to the first-read
  prompt (aggregation ns, always-escape-`\{ \}`-in-`|…|`, one-default-model /
  typed binding); re-spliced into `README.md`.
- **overview app regenerated** — committed copy was stale (missing `ui5_only`),
  the "system push carries stale generated files" gotcha; idempotent regen.

No ports changed; coverage unchanged at 168. Owed next: a real from-scratch
regeneration probe per thin library once OpenUI5 is reachable — cold-read
catches doc-extraction friction, only a fresh port surfaces uncovered idioms.

## Batches b05–b07 — stress-test ports, maximally-diverse controls (2026-07-23) — 12 ports

Three more diverse faithful batches to stress-test how far abab2UI5 reaches,
each internally maximally-different. All machine-green (abaplint
STANDARD/CLOUD/702, validate-meta, pattern-lint, structural-diff `--strict`,
property-check, render-smoke):

- **b05 (137–141):** `sap.ui.table.Table` multi-level column headers
  (multiLabels/headerSpan) · `sap.ui.layout.DynamicSideContent` · `sap.ui.unified.Calendar`
  · `sap.ui.layout.BlockLayout` (6 rows/7 cells, color shades A–F) ·
  `sap.ui.core.InvisibleMessage`.
- **b06 (142–145):** `sap.ui.layout.form.Form` (FormContainers + toolbars +
  GridData) · `sap.f.DynamicPage` (title/header/content/footer + tnt:InfoLabel)
  · `sap.f.GridList` GridBoxLayout · `sap.ui.layout.cssgrid` gridAutoFlow +
  RadioButtonGroup.
- **b07 (146–148):** `sap.ui.core` HyphenationAPI (core:HTML) ·
  `sap.ui.core.BusyIndicator` (global) · `sap.f.GridList` **drag & drop**
  (dnd:DragInfo + GridDropInfo).

New paradigms exercised without framework changes: the sap.ui.table grid table
with `multiLabels`/`headerSpan`, a full `sap.ui.layout.form.Form` tree,
`DynamicSideContent`/`DynamicPage` responsive containers, and drag-and-drop
config. One transpiler/checker footnote: the `sap.f.dnd` `GridDropInfo` keeps a
hyphen-free `dndgrid` xmlns alias (the original's `dnd-grid` prefix trips the
static regexes; the alias names the same URI). Coverage: **148** ports across
10 libraries.

## Where the repo stands

| Aspect | State |
|---|---|
| Ports | 109 / **403 in-scope** `sap.m` samples (27.0 %) — in scope = control exists since UI5 1.71 and is not deprecated; 43 of 446 samples are out of scope (16 deprecated, 21 newer, 6 without control metadata) |
| CI | ABAP_STANDARD, ABAP_CLOUD, ABAP_702 all green |
| Structural view diff | **0 undeclared differences** across all 64 ports (`node scripts/structural-diff.mjs --strict`) — including simple **binding values** and, since 2026-07-19, **`id` attributes** (name-level per control type; dropped original ids must be restored or declared) |
| Render smoke | **0 failing / 0 skipped** (`npm run smoke`): every port's view loads in a real headless `XMLView.create` — incl. app 049, now reconstructed by the **handle-aware path** (`extractDocsWithHelpers`: a builder handle is a stack snapshot, a captured handle passed into a builder-returning helper is inlined re-anchored per call). The declared-skip mechanism stays as a CI-enforced safety net for any future idiom the reconstructor cannot rebuild (undeclared non-reconstructable = FAIL, stale declaration = FAIL); harness carries `sap.f` and mocks scalar-row tables as empty arrays since b05 |
| Pattern lint | **0 errors, 0 warnings, empty baseline** (`node scripts/pattern-lint.mjs`) |
| Meta sidecars | 67 in `meta/` — status: 21 `generated`, 41 `checked`, **5 `golden`** (401, 421, 454, 540, 543 — promoted 2026-07-20 after the full live check); deviations: 39 IMPROVISED, 34 POST_171, 81 NOTE, 3 DROPPED_171 (the `p:ColumnAIAction` plugin in apps 009/022/534 — a whole control newer than 1.71, unlike the restorable members). **0 LIVE_TEST** (b07/b08 menu + message-popover paths live-checked 2026-07-22) and **0 SUBSET_DATA** (retired 2026-07-22 — every port now inlines the full mock row set). `audit` is a structured object since 2026-07-18 |
| Manually verified in a running system | **46 of 67 ports** — adds 060/061/066/067 (menu + MessagePopover, human live check 2026-07-22) to the 2026-07-20 checked set; the 21 remaining `generated` ports are b01–b04 apps that never carried an open question (machine-verified only) |
| Archive | `ui5/sap.m/<SampleName>/` — full originals for the 44 ported samples (+2 cross-referenced: `FacetFilterSimple`, `Table`); mock snapshot in `ui5/mock/`. Unported samples are copied over batch by batch. |

## Batch b04 — faithful diverse cross-library ports (2026-07-23) — 3 ports

Third diverse faithful batch, three libraries. All machine-green (abaplint
STANDARD/CLOUD/702, validate-meta, pattern-lint, structural-diff `--strict`
**0 diffs each**, property-check, render-smoke):

- **134** `sap.tnt.ToolHeader` — a shell-like app header: two ToolHeaders in a
  ScrollContainer with `OverflowToolbarButton`s, `ToolHeaderUtilitySeparator`,
  Avatar/Image, each item carrying `OverflowToolbarLayoutData`
  priorities/groups. Logo/Avatar presses → client toasts; the original's
  `Device.media` responsive-visibility handler is a device behaviour not
  reproduced server-side.
- **135** `sap.ui.model.type.Currency` (`sap.ui.core` TypeCurrency) — the
  **composite** data-type binding: every Input/Text binds
  `parts:['/amount','/currency']` with `type:'CurrencyType'` + formatOptions
  (showMeasure/showNumber/preserveDecimals/currencyCode/style). Paths generated
  via `_bind` (both fields land in the render-smoke mock model).
- **136** `sap.f.SidePanel` Single — a docked side panel: `f:mainContent`
  (buttons, veto Switches, ten body Texts) + `f:items` → `SidePanelItem`.
  `toggle` → client toast (the original's preventDefault veto by the two
  switches is a live interaction, not reproduced).

New batch folders `src/05/b04`, `src/02/b04`, `src/04/b03`. Coverage: **136**
ports across 10 libraries.

## Batch b03 — faithful diverse cross-library ports (2026-07-23) — 5 ports

Second diverse faithful batch, three libraries, chosen for paradigms b02 didn't
touch. All machine-green (abaplint STANDARD/CLOUD/702, validate-meta,
pattern-lint, structural-diff `--strict` **0 diffs each**, property-check,
render-smoke):

- **129** `sap.ui.model.type.Integer` (`sap.ui.core` TypeInteger) — the
  **data-type binding** paradigm: `core:require` pulls in the Integer type and
  `form:SimpleForm` Inputs/Texts bind `{path, type:'IntegerType', formatOptions}`
  (min/maxIntegerDigits) 1:1. The path is generated via `_bind(val=… path=X)`
  (never hardcoded — a pattern-lint rule), which also puts the field in the
  render-smoke mock model.
- **130** `sap.ui.core` ControlBusyIndicator — `busy` state on a Panel + Icon,
  toggled server-side (bound boolean); the original's 5 s setTimeout auto-reset
  is simplified to a toggle.
- **131** `sap.ui.core` BasicThemeParameters — MessageStrip + Link (the sample
  is just a pointer to the external Theme Parameter Toolbox).
- **132** `sap.tnt.SideNavigation` WithTags — richer than b02's 128: every
  `tnt:tag` carries an `ObjectStatus` badge (IndicationColor 15-20, inverted),
  plus `NavigationListGroup` + `fixedItem`; expand toggled server-side.
- **133** `sap.f.GridList` Modes — the **data-bound list** paradigm: 11 product
  rows inlined from `model/data.json`, a `GridListItem` template with
  `counter`/`highlight`/`type` bindings + `{= …}` expression-bound visibility,
  a `SegmentedButton` whose `selectionChange` drives `mode` + `headerText`
  server-side, `f:customLayout` → `GridBasicLayout`. Absent enum-ish JSON
  fields are seeded with their UI5 defaults (`type→Inactive`, `Status→None`) so
  the bound enum properties stay valid — renders identically, and
  structural-diff compares only binding paths.

New batch folders `src/02/b03`, `src/05/b03`, `src/04/b02`. Coverage: **133**
ports across 10 libraries.

## Batch b02 — faithful diverse cross-library ports (2026-07-23) — 7 ports

First **faithful** (structurally verified, not probe) batch that spans past
`sap.m`, picked for maximal control diversity across four libraries. All seven
are machine-green (abaplint STANDARD/CLOUD/702, validate-meta, pattern-lint,
structural-diff `--strict` with **0 diffs each**, property-check, render-smoke):

- **122** `sap.ui.core.Icon` — icon-font gallery (`core:Icon` × 5 in an HBox,
  each with `FlexItemData` layoutData; stethoscope press → client toast).
- **123** `sap.tnt.NavigationList` — nav tree with nested items; the two toolbar
  buttons flip `expanded` / a sub-item's `visible` server-side (boolean model
  fields, `view_model_update`).
- **124** `sap.ui.layout.cssgrid.CSSGrid` — CSS-grid page layout, five
  `core:HTML` tiles (raw HTML in `content`, escaped 1:1 incl. the original's
  quirks) + `GridItemLayoutData`; Slider `liveChange` → panel width roundtrip.
- **125** `sap.ui.layout.Splitter` — resizable split panes with
  `SplitterLayoutData` (fully static, no controller).
- **126** `sap.ui.unified.FileUploader` — file uploader + upload button
  (upload cycle reduced to client toasts — endpoint-dependent, LIVE_TEST).
- **127** `sap.ui.core.InvisibleText` — ARIA-description Page (12 buttons across
  customHeader/subHeader/content/footer, six `core:InvisibleText` targets,
  `ariaLabelledBy`/`ariaDescribedBy` associations 1:1).
- **128** `sap.tnt.SideNavigation` — side nav with `NavigationListGroup`s +
  `fixedItem`, external-link items; expand/hide toggles server-side.

New batch folders `src/02/b02` (sap.ui.* → 122/124/125/126/127) and
`src/05/b02` (sap.tnt → 123/128). Coverage: **128** ports across 10 libraries.
Two render-smoke lessons re-confirmed: (a) a nested aggregation (`layoutData`)
needs its **own** `shut()` plus one for the parent control before a sibling —
one missing `shut()` silently nests the next control inside the previous one;
(b) a bound property whose `DATA` uses an inline `VALUE` clause is invisible to
render-smoke's typed-model derivation (it only reads assignment seeds), so such
fields mock as empty string and fail strict boolean/numeric property typing —
seed them with a plain assignment on init instead.

## Beyond sap.m: sap.f library started (2026-07-22) — src/04/b01

First expansion past `sap.m`. **sap.f** (Fiori flagship) is now a second library
in coverage/universe and the render-smoke harness (its `@openui5` package ships
in `LIB_ROOTS`). Two ports, both machine-green: **110** ShellBar (static app
shell header with a sap.m Menu + profile Avatar) and **111** GridList (grid
layout list, 27 items, Slider→panel-width via a roundtrip-free expression
binding). Infra: `FOCUS_LIBS += sap.f`; the 42 sap.f demokit samples merged into
`ui5/universe.json` from the fork's docuindex (null since/deprecated — no built
SDK api.json, so a full regen would wipe sap.m's scope metadata; the manual
merge preserves it, sap.f starts with permissive scope). **structural-diff was
hardcoded to `ui5/sap.m/`** and now resolves `ui5/<lib>/<Name>` from the sample
library, so sap.f (and future libs) are structurally verified. Coverage:
109/488 across 2 libraries. Deferred (own follow-up batch): the sap.f controls
with popover fragments / named models (AvatarGroup — also hits a headless
AvatarGroup render-restart loop —, DynamicPage, FlexibleColumnLayout, Card,
GridContainer, ProductSwitch, SidePanel, SemanticPage).

## Batch b14 generated (2026-07-22) — planning calendars (2 ports)

The two calendar NEW controls, both machine-green including render-smoke:
**108** PlanningCalendar (the Single variant — a single-row day planner with 21
appointments + 3 interval headers) and **109** SinglePlanningCalendar (the
DateSelection variant — Day/WorkWeek/Week/Month views + 11 appointments). Both
prove the **date-object property** path end to end in the ai-demokit builder: the
model carries plain ISO strings and the object-typed `startDate`/`endDate`
(PlanningCalendar / SinglePlanningCalendar / `unified:CalendarAppointment`) are
converted at the binding with `Formatter.DateCreateObject` via
`core:require="{Formatter: 'z2ui5/model/formatter'}"` (POST_171, UI5 >= 1.74) —
**no framework change needed**, the curated formatter already ships it and
render-smoke registers the same module (the `xmlns:core` declaration is required
alongside `core:require`). The original `UI5Date.getInstance(y, month0, d, …)`
values are normalized to ISO 1:1 (0-based months; JS Date overflow rolled
forward). Interactive paths (appointment/interval select, view/date change,
mode toggle) are simplified toasts, `LIVE_TEST`. Remaining calendar work is
**depth only** — the other ~22 PlanningCalendar/SinglePlanningCalendar variants
now that both controls are covered.

## Batch b13 generated (2026-07-22) — sap.m.semantic pages (3 ports)

The `sap.m.semantic` page family, all machine-green: **105**
SemanticPageFullScreen (`FullscreenPage` + the full semantic-action set),
**107** SemanticPage (`SplitContainer` master/detail with SortSelect bound to a
2-row filter-type table, PagingButton, custom footer/share content) and **106**
SemanticPageFloatingFooter (same with `floatingFooter='true'`). Each semantic
action toasts its class name (passed as a t_arg literal); `positionChange` and
custom-button presses transport `${$parameters>/newPosition}` /
`$event.oSource.sId`. All interactive paths `LIVE_TEST`. No framework change
needed. **Remaining in-scope NEW controls**: only the `PlanningCalendar` and
`SinglePlanningCalendar` families are left — both need the date-object property
support (CAPABILITIES 🔶, per-binding `Formatter.DateCreateObject`) and warrant
a dedicated batch.

## Batch b12 generated (2026-07-22) — dialogs, pickers & master-detail (10 ports)

Ten breadth-first `NEW-CONTROL` ports (095–104), each machine-green (abaplint
STANDARD/CLOUD/702, validate-meta, pattern-lint, structural-diff `--strict`,
property-check, render-smoke `--strict`): **095** TimePickerSliders (dialog +
sliders), **096** SplitContainer, **097** SplitApp (master-detail),
**098** ViewSettingsDialog (sort/group/filter, 3 dialogs in `mvc:dependents`,
`open [pageKey]`), **099** QuickViewCard + **100** QuickView (nested
pages/groups/elements; QuickView flattens 4 named models into 4 ABAP tables),
**101** Wizard (4 steps + review NavContainer, validation in ABAP,
`goToStep`/`discardProgress`), **102** InputModelUpdate (OData mock → ABAP
timer), **103** SelectDialog + **104** TableSelectDialog (per-button config via
bound properties, full 123-row ProductCollection, client-side `binding_call`
search). All interactive navigation/selection paths are flagged `LIVE_TEST`.

**Paired framework change** (abap2UI5 branch
`claude/ai-demokit-next-batches-rq9sfy`, `pr/split-container-nav`, merged
upstream as **#2470**, folder removed):
six control methods whitelisted in `CONTROL_METHODS` (both `FrontendAction.js`
and the ABAP mirror `z2ui5_cl_app_frontendaction_js`) so the ports drive them
1:1 — `toDetail`/`toMaster`/`backDetail`/`backMaster`/`setMode`
(SplitApp/SplitContainer) and `navigateBack` (QuickView/QuickViewCard); 4 new
node tests (41 pass), abaplint clean.

## Real-app e2e smoke — runs every port as the actual app (2026-07-22)

`render-smoke` renders a *reconstructed* view; it cannot see the backend
roundtrip, Component boot or event wiring. New heavy, on-demand harness that
runs the **real** app:

- `scripts/e2e-build.mjs` (`npm run e2e:build`) — assembles the transpiled
  backend: copies the abap2UI5 framework src + all 94 ports + the
  `z2ui5_cl_ai_xml` builder into a build dir, **downports a copy** to v702 with
  the framework's own `.github/abaplint/abap_702.jsonc` rule set (the transpiler
  rejects modern `COND … LET …`; a minimal downport produced undefined-var JS,
  so the full `check_syntax`/`definitions_top` rules are required), then
  transpiles with `@abaplint/transpiler` → `node/output`. The framework SOURCE
  is never mutated (only its gitignored build dirs). Needs an abap2UI5 checkout
  with `node_modules` (`A2UI5_HOME`, default `../abap2UI5`).
- `scripts/e2e-smoke.mjs` (`npm run e2e`) — boots the framework's express shim
  (`ZCL_SICF` → `z2ui5_cl_http_handler`, the same open-abap runtime as the
  framework's own e2e), then for each port opens headless Chromium at
  `?app_start=<class>`. UI5 is served from the local `@openui5` packages (the
  sandbox blocks the `sdk.openui5.org` CDN, so those requests are routed to the
  package sources). Generic assertions, no per-port authoring: **boots UI5 +
  renders controls + no backend 4xx/5xx + no JS exception** (benign
  theme/preload/i18n noise from unbundled source filtered by response URL). A
  small `INTERACTIONS` map adds real click→assert checks (005 press →
  client-composed "…​Pressed" toast).
- Result: **94/94 ports pass** — every port runs, boots and renders as the real
  app. Uses `playwright` core (no new dep) like render-smoke; not in the fast
  gate set (multi-minute transpile + browser), meant for pre-release / when the
  framework wire or runtime changes. This is the automated counterpart to the
  manual live check that the `LIVE_TEST` deviations track.

## Live-check fixes on b09–b11 (2026-07-22) + three new pr requests

Human live check surfaced six runtime issues (machine checks can't see them);
all fixed, all six checks still green:

- **094** — the popover's Action button used `cs_event-popup_close` (destroys
  the `POPUP` slot), so a `POPOVER` never closed → **`cs_event-popover_close`**.
- **080** — `${$source>/pressed}` did not resolve at runtime; the source id +
  pressed state now arrive via **`$event.oSource.sId`** and
  **`$event.oSource.getPressed()`** (the proven `$event.oSource.*` path).
- **092** — the `Slider.liveChange` / `MultiComboBox.selectionFinish` server
  round-trips returned an empty response and **blanked the view**; both were
  dropped at the time. **Superseded 2026-07-22**: `selectionFinish` is now wired
  1:1 through the new `setHiddenInPopin` control method (see the framework
  section below); only the `Slider.liveChange` (`setWidth`) stays inert.
  `popinChanged` still toasts.
- **085** — the first Tokenizer's tokens are now **model-bound** (`t_tokens`);
  add appends, delete removes by key (`$event.getParameter('tokens')[0].getKey()`).
- **081** — the incremental backend load is now reproduced 1:1 (start with one
  product, each pull appends the next via `fill_all` + a `shown` counter) instead
  of binding the full 123 up front.
- **084** — fixed with the real **`URLHELPER`** frontend action
  (`cs_event-urlhelper`): `TRIGGER_TEL`/`TRIGGER_SMS` take the number as a plain
  string param, `TRIGGER_EMAIL`/`REDIRECT` a `{ EMAIL/URL, … }` object-literal
  `t_arg` (`get_t_arg` emits `{`-prefixed args raw as UI5 event-handler object
  literals). An earlier claim that URLHELPER had "no ABAP path" was **wrong** —
  it is callable; the withdrawn `urlhelper-abap-api` pr is recorded in
  `pr/README` Declined. **`open_new_tab` is same-origin-only** (`isValidRedirectURL`),
  so it can't open external sites/`tel:`/`mailto:` — the external links in apps
  **041/073** were switched from `open_new_tab` to `urlhelper` REDIRECT
  (correctness fix), and CAPABILITIES.md updated.

Both **`pr/`** requests from the checks —
`table-hidden-in-popin` (092) and
`popover-bind-element` (094) — are now
**implemented** in the framework (see the next section).

## Framework features implemented (2026-07-22) — `setHiddenInPopin` + `BIND_ELEMENT`

Both were carried into abap2UI5 (branch `claude/ai-demokit-edge-cases-ftv30b`)
and the two demokit apps rewired to use them:

- **`setHiddenInPopin`** — new `sap.m.Table` entry in `CONTROL_METHODS`
  (`["object"]`), in both `app/webapp/core/FrontendAction.js` and the ABAP
  generator mirror `z2ui5_cl_app_frontendaction_js`. **App 092** now reproduces
  `onSelectionFinish` 1:1: the `MultiComboBox` `selectedKeys` are two-way bound
  to `t_hidden`, and `selectionFinish` forwards them as a JSON Priority array via
  `follow_up_action( cs_event-control_by_id, setHiddenInPopin )`.
- **`BIND_ELEMENT`** — new `cs_event-bind_element` constant + `evBindElement`
  action (both JS files) + brace-stripping arg formatting in
  `get_event_client`, so a whole view slot can be element-bound to a table row
  through `follow_up_action`. **App 094** now reproduces the original
  `oPopover.bindElement(...)`: the popover uses relative bindings
  (`{PRODUCT_ID}` / `{NAME}` / `{PRODUCT_PIC_URL}`) and
  `follow_up_action( val = cs_event-bind_element, view = cs_view-popover,
  t_arg = VALUE #( ( idx ) ( client->_bind( t_products ) ) ) )` binds the
  popover slot to `t_products/<index>`, the index taken from the pressed row's
  binding context. 3 node tests added (29 pass, abaplint clean).

Both apps stay machine-green (abaplint against the updated framework,
validate-meta, pattern-lint, structural-diff `--strict`, property-check,
render-smoke `--strict` — 094 now renders 2 docs incl. the popover). Their
sidecars' `IMPROVISED` deviations were rewritten from "dropped/inert" to the
faithful wiring. **LIVE-TEST pending** on both.

## Overview: always-shown Audit column (2026-07-22)

The overview table gained an **Audit** column (`scripts/generate-overview.mjs`,
computed from each port's ABAP source at generation time, always visible). One
badge per framework-wiring fact the port uses: `_event_client` (9 apps) and its
`t_arg` form (3), `follow_up_action` (14) and its `t_arg` form (14), opens a
`Popup` (8) or `Popover` (1), and **literal binding** (40) — a path written by
name in clear text (`{FIELD}` / `{/Path}`) instead of via `client->_bind`, the
form that breaks on a variable rename.

## Overview overhaul (2026-07-22) — releases, filters, Shell, split Open

Further reworked `scripts/generate-overview.mjs` (all offline, baked into the
generated class at generation time):

- **Title** now carries the ported-app count — `abap2UI5 Demo Kit (94)`.
- **Release column** (next to Sample): the direct UI5 release the whole *sample*
  needs = the control `since` raised by any kept post-1.71 member (parsed from the
  POST_171 deviation texts); blank = available since forever. The existing
  **Since** column keeps showing the *control's* own since (next to Control).
- **Deviation** rescaled 1→10 (`min(10, 1 + weighted deviations)`) and **no longer
  coloured** (plain text).
- **UI5 only column**: badges rows whose control is not part of OpenUI5. The
  membership oracle is `ui5/properties.json` ∪ `@openui5` source module (`.js`) ∪
  library.js / .library mentions — so statics (URLHelper) and CSS-class doc
  entities (StandardMargins/ContainerPadding) count as OpenUI5; only the two
  demo-kit-only composite *Pattern* samples (012/013) flag `ui5_only` (2).
- **Header filter checkboxes** (default all on), filtering the table entirely on
  the client via each row's `visible` expression (no round-trip): Hide non-OpenUI5,
  Hide newer than 1.71 (2020) (28 apps), Hide deprecated (0). Disabled while the
  tree is shown.
- **Shell switch** (next to Tree view) toggles the `sap.m.Shell` letterboxing
  (`appWidthLimited`), two-way bound, client-side.
- **Open column split into two buttons**: the first starts the abap2UI5 app
  **in-page from the backend** via `client->nav_app_call` (server event
  `START_APP`). The overview enables **hash routing** (UI5 Router style) once
  with `client->set_nav_routing( )`; the framework then pushes the bookmarkable
  route `#/app/<CLASS>` for the called app, and the native browser Back/Forward
  buttons navigate between the overview and the launched apps — no new tab, no
  page reload. The second button opens the reference-links popover, trimmed to
  the four external links (OpenUI5 API, source, live sample, ABAP class). The
  same two buttons sit on every tree leaf.

Follow-up refinements (2026-07-22): the **Release** column is renamed **Since**
and only shows a value when higher than the control's own since (otherwise it
just repeats it); **both Since columns are sortable and coloured orange**
(`ObjectStatus` Warning via a `{= … ? 'Warning' : 'None' }` expression) when newer
than 1.71. **UI5 only → Version** (still the orange SAPUI5 badge). The **Note
column is removed**; its info (checked status, post-1.71 note, generation notes)
moved **into the links popover**, which also carries the four reference links. The
two Open buttons are **swapped** (links-popover first, app-launch second), on the
table and the tree. The `Tree`-nested-in-`Table` startup crash from the first cut
is fixed (missing `shut()` restored). The popover's generation notes render as an
**HTML bullet list** (`FormattedText`, one `<li>` per bullet, the type label in
bold; the note text is HTML-escaped, then the builder's `xml_escape` + UI5's
single un-escape show it verbatim). The **sample-since version parser** was fixed:
it now takes the max of *all* version tokens in the POST_171 texts (the old
`since X.Y` regex missed the common `since UI5 1.84` phrasing, so the column was
nearly always blank); 28 rows now carry a sample-since (matching the 28 post-1.71
ports).

## Batch b11 generated (2026-07-22) — pages, pickers, tables & popovers (7 ports)

Classes **088–094**, breadth-first NEW-CONTROL: 088 StandardMarginsAll
(`sap.ui.core.StandardMargins`), 089 PageStandardClasses (`sap.m.Page`),
090 DialogSearch (`sap.m.SearchField`), 091 TimePickerHidden (`sap.m.TimePicker`),
092 TableAutoPopin (`sap.m.Table`), 093 TabContainer, 094
PopoverControllingCloseBehavior (`sap.m.Popover`). Machine-verified green
(abaplint, validate-meta, pattern-lint, structural-diff `--strict`,
property-check, render-smoke `--strict`); status `generated`.

Notables: **091** reuses the app-016 openBy pattern (source `sId` via
`$event.oSource.sId` → `control_by_id`/`openBy` follow-up); **092** keeps the
declarative `autoPopinMode` + `Column.importance` 1:1 (the imperative
setWidth/setHiddenInPopin handlers dropped) and reuses the curated
`Formatter.weightState`; **090** and **094** build their dialog/popover via
`popup_display`/`popover_display` in `on_event` (094 passes the row values as
event args and anchors by `sId`). **This batch is 7 ports, not 10**: the three
remaining backlog-top controls were **deferred** as too lossy for a 1:1 port
(AGENTS §5) — **SemanticPage** (semantic-page landmark aggregations),
**QuickView/QuickViewCard** (multi-page card navigation + navOrigin), and
**ViewSettingsDialog** (custom sort/filter/group tabs). They stay NEW-CONTROL in
the backlog for a dedicated effort, alongside the calendar family
(PlanningCalendar / SinglePlanningCalendar) and SplitApp/SplitContainer that now
dominate the backlog top.

## Batch b10 generated (2026-07-22) — toolbars, tiles & lists (10 ports)

Classes **078–087**, breadth-first NEW-CONTROL: 078 TileContent,
079 TitleLink (`sap.m.Title`), 080 ToggleButton, 081 PullToRefresh,
082 SlideTile, 083 StandardListItemAvatar (`sap.m.StandardListItem`),
084 UrlHelper (`sap.m.URLHelper`), 085 TokenizerBasic (`sap.m.Tokenizer`),
086 ToolbarDesign (`sap.m.OverflowToolbar`), 087 ContainerNoPadding
(`sap.ui.core.ContainerPadding`, an IconTabBar demo). Machine-verified green
(abaplint, validate-meta, pattern-lint, structural-diff `--strict`,
property-check, render-smoke `--strict`); status `generated`.

Notables: **083** keeps the original's `{/ProductCollection}` List element
binding + `{0/Name}..{3/Name}` index item bindings against the full 123-row
default-model table; **084** flattens `/SupplierCollection/0` to a `/S_SUPPLIER`
record and maps the URLHelper tel/sms/email triggers to toasts (website →
open_new_tab); **086** turns the Select `change` design/style handlers into
two-way binds + an expression-binding `visible`; **087** flattens the
`/ProductCollectionStats/Counts` to `/TOTAL /OK /HEAVY /OVERWEIGHT`.
The two heaviest OverflowToolbar samples (OverflowToolbarFooter, full table +
menu; OverflowToolbarTokenizer, many tokenizers + DateTimePicker/SegmentedButton)
were left in the backlog for a dedicated effort rather than forced in.

## Batch b09 generated (2026-07-22) — objects, inputs & notifications (10 ports)

The next 10 backlog-top NEW-CONTROL samples, breadth-first (one port per
uncovered control), classes **068–077**: 068 Slider, 069 RadioButton,
070 ProgressIndicator, 071 ObjectIdentifier, 072 ObjectNumber,
073 ObjectAttributes (`sap.m.ObjectAttribute`), 074 ObjectListItem,
075 SelectList, 076 NotificationListItem, 077 NotificationListGroup.
Machine-verified to green (abaplint ×STANDARD, validate-meta, pattern-lint,
structural-diff `--strict`, property-check, render-smoke `--strict`). Status
`generated` (no human live check yet).

Notables: the list ports (**074**, **075**) inline the full 123-row mock
per the 2026-07-22 no-subset rule; **074** precomputes the `.formatter.status`
ValueState into a `STATUS_STATE` field (the app-038/545 pattern). The
single-record display ports (**071**, **073**) reproduce the original's
`{/ProductCollection/0}` element binding as a one-record `/S_PRODUCT` structure
(the 041 pattern); **072** carries records 0–5 as a 6-row table and
element-binds each ObjectNumber to `/T_PRODUCTS/0..5` (index binding, inlined
`_bind` per control). **070**'s two interactive ProgressIndicators are set via
two-way bound percentValue/displayValue + a SET event (replacing the
controller's byId setters). New POST_171 firsts: `RadioButton.wrapping`/
`wrappingType` (1.126), `ProgressIndicator.displayAnimation` (1.73),
`ObjectNumber.inverted`/`active`/`press` (1.86), `ObjectAttribute.ariaHasPopup`
(1.97). The notification ports are static declarations (close's client-side
`removeItem` is not mirrored → toast; declared). Open LIVE_TESTs (machine-only):
the `${$source>/title}` event args (076/077), the interactive PI SET round-trip
(070), the feedback popup + open_new_tab (073), the ObjectNumber index bindings
(072).

## Full mock data + deviation score (2026-07-22)

Two user decisions this day:

- **No more data subsetting.** The nine `SUBSET_DATA` ports were rebuilt to
  inline the **full mock row set** (all 123 `/ProductCollection` rows of
  `ui5/mock/products.json`), byte-identical to the mock: **006, 030, 033, 034,
  039, 040** (product lists), **012** (all 123 rows loaded, the table binding
  still filters to `Category = Laptops` as the original does client-side; `price`
  bumped to `DECIMALS 2` so the 19 non-integer prices stay exact) and **022**
  (full products + the precomputed `/ProductCollectionStats/Filters` counters —
  16 categories / 12 suppliers — which is what the original binds). **041** keeps
  its single `/ProductCollection/0` binding (that is the original's own
  single-record binding, not a subset) — its tag was relabelled `NOTE`. The
  `SUBSET_DATA` deviation type is **retired**: `validate-meta` now rejects it and
  `AGENTS.md §model_init` requires the full row set. All checks stay green
  (abaplint, structural-diff `--strict`, validate-meta, pattern-lint,
  property-check, render-smoke `--strict`).
- **Rating (1–5) in the overview app.** A sortable **Rating** column in
  `z2ui5_cl_ai_app_overview` scores, "by feel", how much attention a port
  deserves — not a strict deviation count. Four things push it up (all
  additive): **complexity** (a big view / rich interaction — LOC, `_event*`/
  `follow_up_action` count, control count), **rework** (every non-1:1
  substitution `IMPROVISED`/`DROPPED_171`/`SUBSET_DATA` or documented `NOTE`
  subtlety), **discussed** (a port reviewed together — it carries a `checked`
  block), and **test-priority** (pending `LIVE_TEST`s, roundtrip-free/runtime
  wiring, popups/popovers, a needs-newer-than-1.71 render). `score =
  min(5, max(1, round(1 + Σweights)))`; 1 = simple faithful 1:1, 5 = complex /
  reworked / worth a close look. Sort descending to find the samples worth a
  closer manual look. Computed in `scripts/generate-overview.mjs`. Current
  spread: **6×1, 32×2, 24×3, 15×4, 17×5** (was briefly rescaled to 1–10, taken
  back to 1–5 with the richer heuristic on user request 2026-07-22).
- **Four LIVE_TESTs closed.** 060 Menu, 061 MenuButton, 066 MessagePopover,
  067 MessagePopoverAsync were human live-checked (open/toggle + item paths) and
  promoted `generated → checked`; their `LIVE_TEST` entries became live-verified
  `NOTE`s. (Later that day the client-composed-toast conversions — 005, 060, 061,
  077, see below — re-opened a few `LIVE_TEST`s for the new roundtrip-free
  mechanism.)

## Client-composed toasts (2026-07-22)

The abap2UI5 branch gained `pr/message-toast-format`: a `control_global`
single-string method (`MessageToast.show`, `MessageBox.*`) composes its text
from a template + client-resolved args (`{0}`,`{1}`,… filled by `$event.*` /
`${$parameters>/…}`), so a **dynamic** toast is roundtrip-free — 1:1 with the
demo-kit `MessageToast.show("…" + evt.…)`. `get_t_arg` quotes a leading `{0}`
placeholder so a value-first template survives; a lone string is unchanged.
Ports **005** (Button, 12 presses), **060** (Menu), **061** (MenuButton) and
**077** (NotificationListGroup) converted — each loses its `on_event` entirely
and becomes **init-only**. Toasts whose text is computed server-side (019, 024,
…) correctly keep their round-trip. All gates green; the four converted ports
carry a `LIVE_TEST` for the new mechanism.

Follow-ups (same day): **003, 016, 074, 076, 091** converted (all init-only;
016 also moved its openBy from a round-trip to `_event_client`). Then two
framework additions closed the last gaps — a **conditional placeholder**
`{N?trueText:falseText}` (truthiness of the value) and **single-quote escaping**
in `get_t_arg` (`'` → `\'`) — which unblocked **080** (ToggleButton,
`{0} {1?Pressed:Unpressed}` from `getPressed()`), **049** (StepInput,
`Value changed to '{0}'`) and **008** (ColorPalette, two args incl. a `\n`).
Twelve ports total are now client-composed/init-only. Kept on their round-trip
by design: server-computed or model-mutating toasts (019, 024, 025's action
branch, 047, 085).

## control_by_id view-slot fix + golden category retired (2026-07-22)

- **Runtime bug fixed.** After the framework moved the view to its own `view`
  parameter (`get_event_client` inserts it at `t_arg` index 2 for
  `control_by_id`), the ports that still carried an explicit empty `( `` )` view
  slot ended up with `[id, '', '', method, …]`, so the frontend read
  `method = ''` and logged `CONTROL_BY_ID: method '' not allowed` (openBy/
  toggleBy never fired). Dropped the empty slot in **060, 065, 066, 067, 091**
  and in the overview generator's tree Expand-all/Collapse-all buttons; correct
  form is `( id ) ( method ) ( params )`. New pattern-lint rule
  `control-by-id-empty-view-slot` guards it.
- **`golden` status retired** (user decision — "erstmal keine golden kategorie").
  The five golden ports (007, 016, 019, 022, 040) are now plain `checked`;
  `validate-meta` drops `golden` from the status vocabulary; the overview
  generator drops the `golden` flag (it fed only the rating's "discussed"
  signal, now `checked`-only); AGENTS.md / TRAINING.md updated. Former golden
  ports may now be refactored to the current conventions like any other.

## Batches

The 34 existing ports are retro-grouped into review batches — one subpackage
`src/01/b<nn>` = one ABAP package = one review unit (recorded per port in
`meta/<class>.json` as `batch`):

| Batch | Theme | Apps | Live-checked |
|---|---|---|---|
| `b01` | Display & navigation | 408, 409, 431, 434, 440, 460, 529, 530 | 431, 434, 440, 460, 529, 530 |
| `b02` | Selection & input | 421, 422, 423, 439, 452, 454, 472, 481, 527, 528 | 421, 452, 454 |
| `b03` | Actions, toolbars & popups | 447, 448, 449, 469, 474, 486, 526 | 469, 474, 486, 526 |
| `b04` | Layout, lists & data | 401, 404, 420, 433, 441, 445, 471, 473, 487 | 401, 404, 420, 433, 471, 473, 487 |
| `b05` | Backlog top: bars, tables, custom items & patterns | 531, 532, 533, 534, 535, 536, 537, 538, 539, 540 | all (2026-07-20) |
| `b06` | Date pickers, dialogs, feeds & tiles | 541, 542, 543, 544, 545, 546, 547, 548, 549, 550 | all (2026-07-20) |
| `b07` | Icon tabs, tile content, menus, list items & message strips | IconTabHeader, ImageContent, InputListItem, LabelProperties, LightBox, Menu, MenuButton, MessageStrip, NewsContent, NumericContent (classes 055–064) | — (machine-verified only) |
| `b08` | Message popover (all three MessagePopover samples) | MessagePopoverMessageHandling (065), MessagePopover (066), MessagePopoverAsyncMessageHandling (067) | 065–067 (2026-07-22) |
| `b09` | Objects, inputs & notifications | Slider, RadioButton, ProgressIndicator, ObjectIdentifier, ObjectNumber, ObjectAttributes, ObjectListItem, SelectList, NotificationListItem, NotificationListGroup (classes 068–077) | — (machine-verified only) |
| `b10` | Toolbars, tiles & lists | TileContent, TitleLink, ToggleButton, PullToRefresh, SlideTile, StandardListItemAvatar, UrlHelper, TokenizerBasic, ToolbarDesign, ContainerNoPadding (classes 078–087) | — (machine-verified only) |
| `b11` | Pages, pickers, tables & popovers | StandardMarginsAll, PageStandardClasses, DialogSearch, TimePickerHidden, TableAutoPopin, TabContainer, PopoverControllingCloseBehavior (classes 088–094) | — (machine-verified only) |

New generation batches continue as `b08`, `b09`, … per the process in
TRAINING.md.

## Batch b08 generated (2026-07-20) — the whole MessagePopover family (3 ports)

All three `sap.m.MessagePopover` demo-kit samples, so the control has no
ambiguous representative. To port the canonical simple one, **`sap.m.sample.
MessagePopover` was taken out of the hold-out set** (`ui5/holdout.json`,
25 → 24; user decision 2026-07-20) — it is the clean base demo, so it earns a
port rather than staying a regression reference.

- **066 MessagePopover** (base) — the canonical demo: an empty Page + a footer
  button that toggles a MessagePopover listing five static messages
  (Error/Warning/Success/Error/Information) with a MessageItem `link`. The
  MessagePopover (built in the sample's controller) is declared in the button's
  `dependents`; `oMessagePopover.toggle(button)` becomes the new `toggleBy`
  frontend action anchored to `$event.oSource.sId`; the three severity
  formatters (icon/type/count) are precomputed from the static mock. app-038
  plain-table shape — no cc, no `message>` needed.
- **067 MessagePopoverAsyncMessageHandling** — same shape with
  `markupDescription=true` and an HTML-rich first message; the controller's
  `setAsyncURLHandler` (client-side async URL validation) has no equivalent and
  is dropped (declared).
- **065 MessagePopoverMessageHandling** — the message-model app, ported on a
  **new `z2ui5.cc.MessageManager`** companion control (abap2UI5, this branch)
  that bridges the UI5 message manager to a two-way bound ABAP table:
  app-authored messages (`items`) are reconciled into the manager with a target
  + the view's model as processor (field valueState), while binding-type/
  constraint validation still auto-collects into `message>`. The cc mirrors the
  MultiInputExt pattern, is unit-tested (add/dedup/remove-own/leave-foreign/
  defer) and in the preload. So the earlier "message-manager-binding already
  covered" note was only half-right: reading was covered by `message>`,
  **writing** needed this cc. Port: two forms bound to `/T_FORMS` (3-row
  subset) + `/T_EMPLOYMENT` with typed value bindings + constraints
  (auto-collection), MessagePopover on `{message>/}`, the cc on `/T_MESSAGES`,
  Save authors a demo message. Controller-only severity/group/scroll/
  CommandExecution dropped (declared).

All three machine-verified green (abaplint STANDARD+CLOUD, validate-meta,
pattern-lint, structural-diff `--strict`, render-smoke `--strict` with a new
`z2ui5.cc.MessageManager` harness mirror + empty `message>` model,
property-check). The message-manager runtime (065's auto-collection + cc
reconcile + valueState; the toggleBy toggle; activeTitlePress) stays LIVE_TEST
— unverifiable headlessly. Render-smoke bugs fixed while porting 065: a missing
Button-closing `shut` (MessagePopover leaked as a direct Button child), the
email regex needing `\\`-escaped backslashes for the binding parser, and
`DATA … TYPE <named-table-type>` not recognised as a table by the
reconstructor (switched to inline `STANDARD TABLE OF`, the AGENTS §5
convention).

## Batch b07 generated (2026-07-20)

The next 10 backlog-top NEW-CONTROL samples, breadth-first (one port per
uncovered control), classes **055–064**: 055 IconTabHeader, 056 ImageContent,
057 InputListItem, 058 LabelProperties (`sap.m.Label`), 059 LightBox,
060 Menu, 061 MenuButton, 062 MessageStripWithEnableFormattedText,
063 NewsContent, 064 NumericContentIcon. Machine-verified to green
(abaplint ×STANDARD+CLOUD, validate-meta, pattern-lint, structural-diff
`--strict`, render-smoke `--strict`, property-check). Adversarial AI review
(2 reviewers × 5 apps): **9 CLEAN, 1 MINOR, 0 MAJOR** — the MINOR was app 060's
press handler dropping the sample's toggle (close-if-open) branch; the menu's
open/closed state lives client-side and is not reliably mirrorable
server-side, so the port always (re-)opens and the reduction is now declared
in the sidecar.

Three controls at the top of the backlog were **deferred** rather than forced
into a lossy 1:1 (AGENTS §5 "if the sample's whole point needs an
inexpressible feature, do not port it"): **InitialPagePattern** (an
app-level pattern — seven fragments, value-help dialog, IllustratedMessage,
client filtering), **InputModelUpdate** (its whole point is oData v2 late
binding via `bindElement`/`dataReceived`, and abap2UI5 serves a single
default model), and **MessagePopoverMessageHandling** (built on the UI5
MessageManager / message model). They stay `NEW-CONTROL` in the backlog for a
later dedicated effort.

Techniques worth noting: **060 Menu** reuses the app-016 openBy
frontend action — the Menu is declared in the Button's `dependents`
aggregation and opened via `control_by_id`/`openBy` anchored to
`$event.oSource.sId`. **058 LabelProperties** is roundtrip-free: the four
controller handlers become two-way `state` binds (displayOnly/wrapping) plus
`{= }` expression bindings (`wrappingType = hyphenation ? 'Hyphenated' :
'Normal'`, container `width = slider_value + '%'`), the app-007 pattern.
**062 MessageStrip** keeps the post-1.71 `controls` multi-link aggregation
(1.129, declared) and the `enableFormattedText` HTML strips. New POST_171
firsts this batch: `Button.ariaHasPopup` (1.84, app 060),
`MenuButton.beforeMenuOpen` (1.94, app 061), `MessageStrip.controls` (1.129,
app 062). The b07 ports are `generated` (no human live check yet); the menu
item-arg paths (`${$parameters>/item/text}`) and the openBy anchoring are the
open LIVE_TESTs.

**Framework gaps from b07 — two implemented upstream, one deferred:**
- **`menu-toggle-openby` → implemented 2026-07-20**: `toggleBy: ["domRef"]`
  added to `CONTROL_METHODS` (`control.isOpen() ? close() : openBy(anchor)`,
  no server-side open state). App 060 converted openBy→toggleBy — the
  press-to-toggle menu is now 1:1 (the IMPROVISED toggle-reduction is gone).
  Framework unit tests added.
- **`formatter-inline-icon` → implemented 2026-07-20**: `expandInlineIcons`
  added to the curated `model/formatter.js` (replaces `%%icon:sap-icon://…%%`
  placeholders with the `sapMMsgStripInlineIcon` markup via `IconPool`, the
  `getInlineIcon` equivalent). App 062's inlineIconsHelper converted to
  placeholders + a `core:require` formatter binding — no more guessed
  codepoints. Framework unit tests added; the render-smoke harness formatter
  mirror gained `expandInlineIcons`.
- **`menu-item-selected-path` → deferred** (user decision): the selected menu
  item's ancestor breadcrumb for 060/061; cosmetic (toast text), likely a
  documented boundary rather than a framework change. Folder kept under `pr/`.

Both implemented requests removed their `pr/` folders and moved to the
`pr/README` Implemented table; CAPABILITIES.md updated (toggleBy row, formatter
`expandInlineIcons`). A fourth idea, exposing the MessageManager for the
deferred `MessagePopoverMessageHandling`, was **investigated and not filed** —
the `message>` model (2026-07-18) and the plain-table approach (app 038)
already cover the MessagePopover family, so that sample is a porting task, not
a framework gap.

## Full human live check (2026-07-20) — every open question cleared

The human worked through the complete interaction checklist in a running
system (batches b01–b06, all framework-mechanism firsts incl. the freshly
merged openBy/compound-filter paths, the review-fixed 550 scroll step, the
device> phone checks and the 530 restamp) and confirmed every item. All
LIVE_TEST deviations are closed, **40 of 54 ports are `checked`** — the
14 remaining `generated` ports are b01–b04 apps that never carried an open
question. Follow-up same day: **five ports promoted to `golden`** (401 compound
filter + formatter, 421 expression bindings, 454 cc-control tokens,
540 frontend action, 543 dialog flows) — the generation-prompt reference
set in AGENTS §5 now spans six worked references across the technique
range.

## Human visual pass over b05+b06 (2026-07-20, earlier the same day)

All 20 new ports were started in a running system and render without
errors (apps opened and looked at; interactions not exercised). Closed on
that basis: 401's weight-state colors and 542's date-type rendering half
(DateTimeWithTimezone composites, empty-string DTP11, Islamic calendar).
The interaction LIVE_TESTs stay open — a prioritized detail-check list
was handed to the human (top of the list: 454 tokens, 540 openBy,
401 compound filter, 469/471, 550's fixed initial scroll step).

## Batch b06 generated (2026-07-20)

The next 10 backlog-top NEW-CONTROL samples (breadth-first): 541
DateRangeSelection, 542 DateTimePicker, 543 DialogConfirm, 544
DisplayListItem, 545 DraftIndicator, 546 FeedContent, 547 Feed
(FeedInput), 548 FeedListItem, 549 GenericTag, 550 HeaderContainer.
Machine-verified to green (abaplint ×3, validate-meta, pattern-lint,
structural-diff --strict, render-smoke --strict, property-check);
generation fixes: 544 chain-end paren, 541 t_arg alignment, 543 fragment
extras declared. Adversarial AI review (2 reviewers × 5 apps): **7 CLEAN,
2 MINOR, 1 MAJOR** — the MAJOR was a real behavior bug in 550
(`scrollStepByItem` seeded 0 instead of the UI5 default 1: initial arrow
scroll was 200 px instead of one item, with a sidecar note asserting the
wrong default as fact — fixed, seeded 1). MINORs fixed: 544's
supplier.json is now snapshotted byte-identical in `ui5/mock/` (the
AGENTS §4 offline-verifiability lesson) and its false "first element
binding" LIVE_TEST rewrote to a NOTE (app 041 already proved the
mechanism); 547's date-rebuild note now names the server-vs-browser
timezone delta. The reviewers source-verified the heavy claims: 541/542's
date-type bindings (source patterns, DateTimeWithTimezone V4
constraints), 545's DraftIndicator setter-equivalence, and 548's
`.indexOfItem(...)` method-call event arg (legal per ExpressionParser).
Notables: 545 replaces the un-whitelisted DraftIndicator show* calls with
a source-verified equivalent two-way `state` binding; 542/541 carry the
full date-type battery (source patterns, DateTimeWithTimezone V4
constraints, DateCreateObject); 544 fetched the un-snapshotted
supplier.json from upstream and noted it.

## Batch b05 generated (2026-07-19) — first post-probe batch

The first 10 backlog-top NEW-CONTROL samples (breadth-first per AGENTS §1),
generated with the probe-hardened rule set, machine-verified to green
(abaplint ×3, validate-meta, pattern-lint, structural-diff --strict,
render-smoke --strict, property-check) and adversarially AI-reviewed
(2 reviewers × 5 apps): **7 CLEAN, 3 MINOR, 0 MAJOR, no BUG-class
findings** — none of the probe's three MAJOR root causes recurred. Review
findings fixed in-place: ComparisonPattern archive completed
(formatter.js/manifest.json beyond the sample's own incomplete `files`
list), 536/540 sidecar prose now references the filed pr, 534's four
numeric mock fields retyped packed (batch-consistent with 535), 535's
popinLayout round-trip converted to the 534 expression-binding form, and
535's sidecar corrected on the local-vs-shared products.json difference
(HT-9995 differs in content). Highlights:

- The probe's distilled rules visibly held: no `popover_display( val = )`
  recurrence, flattening declared everywhere, app 015 explicitly reasoned
  the empty-string/enum rule, app 010 seeded `popinLayout` non-empty.
- **App 009** re-applies the app-401 `DROPPED_171` decision for
  `p:ColumnAIAction` (plugin class newer than 1.71 — dropped, not POST_171).
- **Two new framework gaps** → pr/control-methods-openby-setactivepage,
  **implemented upstream 2026-07-20** (new `domRef` arg kind, `openBy`,
  `setActivePage`; folder archived in pr/README Implemented): app 016's
  hidden-DatePicker wiring is now valid (IMPROVISED→LIVE_TEST). App 012's
  Carousel re-sync stays dropped — aggregation-template clone ids are not
  backend-addressable (recorded in the sidecar + CAPABILITIES; an
  index-based page resolution would be a new request if more samples need
  it).
- Render-smoke harness extended for b05: `sap.f` library loaded
  (DynamicPage/GridList/Card in 536/537) and scalar-row tables
  (`TABLE OF string` bound to array properties like `Table.sticky`, app 009) mocked as empty arrays instead of `{}` rows.
- New LIVE_TESTs are tracked in the b05 sidecars (popup/timer cycle 533,
  image dialog 538, `$source>/selectedKey` arg 535, sticky round-trip 534,
  binding_call-on-init + `to` navigation 536, popup focus flow 537).

## Verified fixed (2026-07-16)

An AI cross-review of all 34 ports against their JS/XML originals (5 parallel
reviewers), followed by fixes:

- **generate-overview.mjs** — regex parser rewritten line-based: a blank line
  before `CLASS` no longer drops the NOTES, later header markers no longer leak
  into the CHECKED text, literal chunking can no longer split a doubled
  backtick. Output byte-identical on the existing 34 ports.
- **Builder `z2ui5_cl_ai_xml`** — LF/CR/TAB in attribute values now escape to
  `&#xA;`/`&#xD;`/`&#x9;` (fixes app 035's lost noDataText line break at the
  root).
- **App 022 (FacetFilter)** — Reset now really resets (two-way `selected`
  binding per FacetFilterItem) and the fragile JSON parse of
  `$event.mParameters.selectedItems` (private internals, silent CATCH) is gone;
  full NOTES block added. LIVE-TEST pending.
- **App 040 (MultiInput)** — the 6+1 pre-set tokens from `onInit` render again
  (tokens aggregation), View height restored, NOTES block added.
- **App 008 (ColorPalette)** — boolean `defaultAction` echoed as `true`/`false`
  instead of raw `X`/space.
- **Apps 034/044/049** — existing deviations declared in the header NOTES.

## Verified fixed (2026-07-16, second pass — fidelity backlog)

- **529**: toast replaced by the original's controller-built Dialog
  (`popup_display` + FragmentDefinition, per CAPABILITIES.md).
- **404 / 431**: the dropped sample CSS is injected via a `core:HTML`
  `content` attribute; 431 also carries the `tileLayout` class again on the
  15 tiles that have it in the original.
- **530**: redundant `SEP_CHANGE` round-trip removed — selectedKey and
  separatorStyle share one two-way path; the private event path is gone.
- **486**: toolbar widths are a pure expression binding
  (`{= ${slider} + '%' }`); `on_event` removed.
- **474**: private event path replaced by a two-way bound `selectedKey`
  (+ item keys as a declared port addition).
- **420/433/440/441/452**: mock-data subsets declared per port (the mock has
  123 rows — full unrolls add no demo value); **423/527**: sorter→`SORT`
  declared; **440**: `pic_url` renamed to convention (`product_pic_url`).
- Idiom: **526** captures the shared press event once + indexed event args
  (later simplified to `get_event_arg( )` when the convention inverted);
  **528/434** blank-line fixes — pattern-lint is at 0/0 with an empty baseline.

## Distilled from human fixes (2026-07-17)

Two human correction commits so far; every change fed back as a rule:

- `_bind_edit( path = abap_true )` for bare model paths (452) → CAPABILITIES.
- `t_arg` continuations align under `val` (421/422) → pattern-lint warn rule.
- Client handles (bind AND event) inline at each control, never captured —
  even repeated, even in expression bindings (526, then 486; 481/421 aligned
  accordingly) → pattern-lint error rule + AGENTS §5. Process lesson: my
  first distillation scoped the rule too narrowly (events only, bind handles
  exempted citing app 007) — the human had to fix the same error class twice.
  When distilling, prefer the GENERAL principle over the narrowest reading.
- Derive values from data like the original (530 `t_items[ 1 ]-text`),
  all-or-nothing `VALUE #( )` alignment after renames (440), minimal inline
  comments (452) → AGENTS §8.
- Trap: abapGit pushes from a stale system state can revert newer generated
  files (overview, twice) → AGENTS §10 gotcha; regenerate + diff after every
  human push.

## Full-port audit (2026-07-17)

A framework-aware re-review of all 34 ports (4 parallel reviewers, one per
batch) against their JS/XML originals, the current AGENTS/CAPABILITIES rules,
and the latest abap2UI5 changes (`control_call`/`control_call_by_id`,
`message_box_display` `dependentOn`/`contentWidth`, the `device>` model on
every view slot, nested-table deltas, `_bind`→two-way). Result: 25 ports
unchanged (incl. the golden set 420/421/526 confirmed still-current), 9 would
be generated differently. Fixed in this change:

- **472 (RangeSlider)** — the ten bound `value`/`value2` fields were `TYPE
  string` seeded with numeric literals; UI5 2.x strict-type validation rejects
  a string on a numeric property (the same class as the app-486 Slider gotcha,
  AGENTS §10). Retyped to `TYPE i`. **No gate caught this** → new pattern-lint
  rule `numeric-bound-as-string`.
- **441 (ListCounter)** — `DATA t_products TYPE TABLE OF ...` (implicit default
  key), the only occurrence in `src/`; it slipped the abaplint `defaultKey`
  gate, which only matches an explicit `DEFAULT KEY`. Fixed to `TYPE STANDARD
  TABLE OF ... WITH EMPTY KEY` → new pattern-lint rule `default-key-table`.
- **529 (ObjectStatus)** — a stale inline comment claimed the press "is wired
  to a message toast"; the code builds the original Dialog via `popup_display`.
  Comment removed.
- **447 / 452** — the self-referential `IMPROVISED` deviations reclassified to
  `NOTE`: `message_box_display` (447) and the default group header (452) are
  the documented 1:1 paths in CAPABILITIES.md, not workarounds.

Second pass — the four remaining audit items worked off (2026-07-17):
- [x] **434** — the `imageContainer` background-color CSS is kept and the
  sample's `styles.css` injected via a `core:HTML` `content` attribute (as
  431/404); deviation IMPROVISED→LIVE_TEST. Structural diff still 0 (the EXTRA
  `core:HTML` is matched by the declaration).
- [x] **454** — `suggestionItems` converted to the raw `sorter` binding-info
  string (`{ path: '…', sorter: {path: 'NAME'} }`), the ABAP `SORT` dropped;
  the pre-set-tokens deviation IMPROVISED→NOTE (a ✅ capability, not a
  workaround).
- [x] **439** — the CenterCenter toast is now docked 1:1 via
  `message_toast_display( my = 'center center' at = 'center center' )` — the
  client method exposes the full MessageToast options object (source-verified
  in `Messages.js`). New CAPABILITIES row; the "not expressible" NOTE corrected.
- [x] **401** — reclassified the two mislabeled IMPROVISED deviations to NOTE
  (the two-way FacetFilter multi-select is CAPABILITIES ✅ with 401 as its own
  evidence port; the two static lists are a faithful equivalent). The
  structural rewrite into a doubly-nested `lists` aggregation-template was
  **deliberately not done**: no port proves that aggregation-of-aggregation
  shape and it cannot be live-tested here — recorded as a LIVE_TEST option, not
  shipped blind on a working source-verified port.

## Framework requests + capability wins from the audit (2026-07-17)

Two ideas the audit surfaced, handled per their true nature:

- **`pr/control-call-whitelist`** (new; **implemented upstream 2026-07-18**,
  see the section below) — a genuine framework gap: the
  `control_call_by_id` whitelist (`to/back/focus/scrollToIndex/scrollTo`) does
  not include the imperative methods two 1:1 ports need — `PDFViewer.open()`
  (469) and `Panel.setExpanded()` (471). Written up as a forwardable request to
  broaden the list (its own comment already scopes it to "imperative methods
  with no binding equivalent"). `addValidator` (454) is explicitly out of scope
  (a client callback, not a one-shot call).
- **Composite `Currency` type — NOT a framework gap** — a source + samples
  check showed `sap.ui.model.type.Currency` is a client-side standard type and
  the curated samples (`z2ui5_cl_demo_app_369`/`_172`) already bind it via a raw
  binding-info string; the builder only XML-escapes attribute values, so it
  passes through to `XMLView.create` unmangled — exactly the sorter story. So a
  framework PR would be wrong. Instead: CAPABILITIES.md row split (standard
  composite **types** ✅ via raw binding-info string; only custom JS formatter
  **functions** stay ❌), and ports **440**/**401** converted to keep the
  original Currency binding 1:1 over a numeric `PRICE` (`TYPE p`) field —
  IMPROVISED dropped, LIVE_TEST added. App 041 keeps its static single-record
  resolution (an unrelated deviation), not blocked by the type.
- **MultiInput `addValidator` — NOT a framework gap either** — the bundled
  custom control `z2ui5.cc.MultiInputExt` installs exactly the sample's
  free-text→token validator (`addValidator(({text}) => new Token({key:text,
  text}))`, source-verified in `app/webapp/cc/MultiInputExt.js`) and mirrors
  token changes back via `addedTokens`/`removedTokens` + `change`. CAPABILITIES
  row added (🔶) and the app-454 deviation corrected IMPROVISED→NOTE. Initially
  left unwired (first cc-control usage needs a live check); **wired 2026-07-18**
  (human direction): app 040 now declares `xmlns:z2ui5="z2ui5.cc"` and one
  `z2ui5:MultiInputExt` leaf per token input (`multiInput1`/`multiInput2`,
  matching the original's two addValidator calls); the render-smoke harness
  carries a metadata-only mirror of the cc control so view creation stays
  gate-checked, the behavior check remains a LIVE_TEST.

**Pattern worth noting:** of the four framework ideas the audit raised, only
one (`control_call` whitelist) is a real gap; the composite `Currency` type
and the MultiInput validator were both already in the framework — the map/ports
had wrongly treated them as ❌. Exactly the "declared impossible although it
already works" failure mode CAPABILITIES.md opens by warning against.

**Same failure mode again — `sap.m.MessageView` (2026-07-18):** app 038 was
marked `IMPROVISED` / the map carried "MessageManager / `message>` model ❌",
yet the port already renders the MessageView 1:1 by binding the messages as a
plain ABAP table on the `items` aggregation with a `MessageItem` template — the
documented idiomatic path, not a workaround. The curated sample
`z2ui5_cl_demo_app_038` (abap2UI5/samples) proves the full set incl. grouping,
Dialog and MessagePopover. Corrected: app-449 deviation `IMPROVISED`→`NOTE`, and
the CAPABILITIES row split — `sap.m.MessageView`/`MessageItem`/`MessagePopover`
is ✅, only the MessageManager **auto-collection** of client-side control
validation messages stays ❌ (a separate, rarely-needed mechanism, not required
to render a MessageView). Fourth "already works" case after Currency,
MultiInput validator and the popup-mode controls — the map is consistently more
pessimistic than the framework.

## Verification & process upgrades (2026-07-18)

A hardening pass over the pipeline itself (builder, gates, planning):

- **Render-smoke gate** (`scripts/render-smoke.mjs`, CI job `render_smoke`,
  `npm run smoke`) — every port's view XML is reconstructed from the builder
  calls, fed a typed mock model derived from its TYPES/DATA/model_init, and
  loaded with a real `XMLView.create` in headless Chromium against the
  OpenUI5 runtime from the `@openui5/*` npm packages (offline). The first run
  caught and led to fixing:
  - **431/404/434** — literal CSS braces in a `core:HTML` `content` attribute
    are parsed as a **binding** by the XMLView parser and crash view creation;
    the CSS-injection technique only works with `\{ … \}` escapes. Braces
    escaped in all three ports, CAPABILITIES.md row updated, new pattern-lint
    rule `unescaped-brace-in-style-content`. (404/434 had hidden it because
    the value sat in a helper variable the first parser version dropped.)
  - **433** — `quantity TYPE string` bound to the int property
    `StandardListItem.counter` → strict-type rejection; retyped `TYPE i`.
    Same class as 472/486, but on a **table field**, which the scalar
    pattern-lint rule cannot see — the smoke gate covers this class now.
- **Structural diff compares binding values** — where the original attribute
  is a plain `{path}` binding and the port writes a literal, the tokens must
  match (case/underscore-normalized, flattened paths on the last segment).
  First run flagged the app-401 `ObjectIdentifier` `{Category}` cell —
  verified correct against the original controller (it swaps that cell), and
  the app-460 sidecar now names its statically resolved bindings precisely.
- **Builder hardened + unit-tested** — `a()` on the empty root, `shut()`
  past the root and duplicate attribute names now ASSERT instead of silently
  producing wrong XML; `z2ui5_cl_ai_xml` carries a local test class
  (nesting, attr targeting, escaping, `as_bool`).
- **Breadth-first batch planning** — `--backlog` sorts samples on uncovered
  controls (`NEW-CONTROL`) first; one port per control before depth
  (AGENTS §1). 190 of 369 backlog samples sit on uncovered controls.
- **Hold-out set defined** — `ui5/holdout.json`, 24 samples across control
  families (was 25 until `sap.m.sample.MessagePopover` was ported in b08,
  2026-07-20); marked `HOLDOUT` in `--backlog`, never prompt references, never
  `golden`. First regeneration probe is due **before batch b05**.
- **Generation prompt single-sourced** — `scripts/generation-prompt.txt`,
  spliced into README by `generate-coverage.mjs`; the `meta_valid` job also
  regenerates coverage so README/api.md cannot drift.
- **Sidecar `audit` structured** — `{ frontend_action, event_t_arg, note? }`,
  enforced by validate-meta.

## Whitelist request implemented + ports converted (2026-07-18)

The `pr/control-call-whitelist` request was implemented upstream in
[abap2UI5/abap2UI5](https://github.com/abap2UI5/abap2UI5): `CONTROL_METHODS`
in `app/webapp/core/FrontendAction.js` now also whitelists `open: []`,
`close: []` and `setExpanded: ["bool"]` (embedded frontend regenerated, unit
specs extended). Follow-through in this repo, same change:

- **469** — converted from the Dialog-embedding workaround to the original's
  popup mode: the `PDFViewer` is declared in the view's `mvc:dependents`
  aggregation (the `addDependent` equivalent), `source` is bound, and
  `SHOW_PDF` runs `view_model_update` + `control_call_by_id( method = 'open' )`.
  IMPROVISED narrowed to the per-image JSONModel flattening (named-models
  family); the Dialog deviation is gone.
- **471** — converted from the two-way bound `expanded` + `view_model_update`
  workaround to the original's imperative toggle: `TOOLBAR_PRESSED` inverts a
  server-side mirror and calls `control_call_by_id( method = 'setExpanded' )`.
  The view now matches the original `view.xml` exactly; IMPROVISED dropped.
- CAPABILITIES.md: new rows for popup-mode controls in `mvc:dependents` and
  for imperative one-shot control methods; frontend-action catalog updated.
- **`pr/formatter-registry`** (new; **implemented 2026-07-18 as a curated
  module — after a security detour worth recording**): app-supplied
  client-side formatter functions, the next-most-common remaining gap. An
  eval-based first design (`register_formatter` shipping JS strings, compiled
  client-side with the `Function` constructor before view creation) was
  implemented upstream and **reverted the same day as a security decision**
  (human review 2026-07-18): it required `unsafe-eval` in the CSP — against
  the framework's strict-CSP direction (security headers, `_runCustomJs`
  deprecation) — and an official register-a-JS-string API invites building
  formatter bodies from data, a server-mediated XSS foot-gun. The trust-model
  argument ("the server ships all frontend code anyway") does not justify the
  *mechanism class*. The shipped design instead mirrors an original UI5 app's
  **formatter file** (human direction 2026-07-18): abap2UI5 now serves a
  curated formatter module in the standard app layout —
  `app/webapp/model/formatter.js`, next to `model/models.js` — a real script
  resource, no ABAP API change, growth via framework PRs only (the
  `control_call_by_id` whitelist model). Views wire it via
  `core:require="{Formatter: 'z2ui5/model/formatter'}"` (UI5 ≥ 1.74,
  POST_171 in ports; the published `z2ui5.Formatter` global covers older
  releases). It re-exports the `z2ui5.Util` date helpers so Util can fold in
  over time. Outcome:
  - **401** — the appended table's weight state keeps the original
    parts+formatter binding: the view requires the module like the original
    controller requires `./Formatter`, and binds
    `formatter: 'Formatter.weightState'` — the alias reference mirrors the
    original's `.formatter.weightState`. The interim expression-binding
    version and the precomputed `WEIGHT_STATE` column are both gone.
  - render-smoke harness mirrors the module's fixed contract (faithful
    `weightState` registered as the named module `z2ui5/model/formatter`,
    kept in sync with abap2UI5).
  - CAPABILITIES.md formatter row is 🔶: curated-module reference first,
    expression binding for app-specific one-offs, ABAP preformatting as the
    fallback; factories returning controls stay ❌.

## Formatter pack + binding_call implemented (2026-07-18)

A demo kit census (all 446 sap.m samples: ~45 use formatters, 35 in scope,
three different `weightState` variants under one name; 61 controllers call
`getBinding(...)`) led to two framework additions, both implemented upstream
the same day and demoed by beta samples in abap2UI5/samples `src/00/08`:

- **pr/formatter-demokit-pack** — six curated functions in
  `z2ui5/model/formatter` (`weightStateByValue`, `stockStatusState`/`-Icon`,
  `round2DP`, `dimensions`, `deliveryStatusState`); with the existing
  `weightState` every unported in-scope sample with a dedicated formatter
  file now ports with its original `formatter:` binding structure (renamed
  references need a `NOTE` deviation). Beta sample 453.
- **pr/binding-call** — declarative filter/sort on an aggregation binding
  (`binding_call_by_id` after a backend event, or roundtrip-free via
  `_event_client` + `cs_event-binding_call` with `${$parameters>/…}` args);
  closes the `oBinding.filter(...)` controller pattern 1:1, model untouched.
  Beta samples 454 (backend) / 455 (live, no roundtrip). Unlocks the
  SearchField/SelectDialog/ViewSettingsDialog/ListSelectionSearch families
  (~15–20 backlog samples) without IMPROVISED model filtering.

CAPABILITIES rows added/extended; live checks of 453/454/455 are the next
LIVE_TEST candidates (sample 455 is the first `_event_client` + `$`-arg
resolution proof).

## Date-object properties probed + arg-serializer bug fixed (2026-07-18)

- **Calendar date properties** (`CalendarAppointment.startDate` etc.,
  `type: "object"`) demand real JS `Date`s — a headless probe against the
  OpenUI5 runtime (`scripts/probes/date-object-probe.mjs`) proved: plain
  string binding crashes view creation, binding types throw
  (`Date.formatValue` has no `object` target), but a
  `formatter: 'Formatter.DateCreateObject'` binding renders identically to
  a real-Date model. CAPABILITIES row added; beta sample 456
  (abap2UI5/samples) demos the pattern. A model-level `utclong`
  auto-reviver was considered and **rejected** (it would retype every
  timestamp field, changing unrelated plain bindings); a per-path opt-in
  reviver remains an option only if the modify/DnD calendar samples prove
  the `$event`-arg write-back insufficient. Unlocks the ~25
  PlanningCalendar/SinglePlanningCalendar display samples.
- **`get_t_arg` positional bug found live and fixed upstream**: the arg
  serializer dropped every empty argument, shifting the following ones —
  a `control_call_by_id` without `view` sent its method name in the view
  slot (`method 'X' not allowed`, beta samples 448/449). Fixed in
  abap2UI5 (inner empties kept as `''`, trailing empties still trimmed;
  unit-tested). **Ports 469/471 were affected** — their pending
  `control_call_by_id` LIVE_TESTs ran against the broken serializer and
  can now be re-tested.
- Same-day builder lesson from the live checks: `z2ui5_cl_xml_view`
  navigation is per-method — child-less controls like `object_status`
  still navigate INTO themselves (sibling needs `get_parent( )`); rule
  documented in the samples AGENTS.md (bit sample 453).

## message> model, DnD reorder, roundtrip e2e (2026-07-18, second round)

- **pr/message-model implemented** — every view slot now carries the UI5
  message model as `message>` with `handleValidation` registration;
  CAPABILITIES flipped the "MessageManager auto-collection" row ❌→✅
  (seventh "already/nearly free" case). Unlocks the MessagePopover family
  (4–5 samples); beta sample 458.
- **DnD reorder confirmed framework-complete** — no gap: `dnd:DragDropInfo`
  + `$`-arg indexes + ABAP reorder covers the pattern (samples 307/459);
  CAPABILITIES row added. The TableDnD/TreeDnD family ports need no
  framework change.
- **Transpiled-backend roundtrip limitation was stale** — the Node backend
  renders view XML (typed-variable fix in `check_on_init` took effect);
  abap2UI5's `roundtrip.spec.js` now asserts view XML on init, the
  model-delta-before-on_event contract and the browser-rendered message
  box. Relevant here: the wire contract the ports rely on is now
  regression-tested upstream.

## Control/binding calls consolidated into follow_up_action (2026-07-19)

The interim client methods `control_call`, `control_call_by_id` and
`binding_call_by_id` (branch-only, never released) were removed upstream;
their events are now public `cs_event` constants (`control_global`,
`control_by_id`, `binding_call`) scheduled via `follow_up_action` with
positional `t_arg` (`control_by_id`: id, view — `''` = global lookup: all
slots' local ids are searched, then the global element registry
(`ViewSlots.resolveById`) —, method, params; `control_global`: object,
method, params; `binding_call`: id, aggregation, method, params). Wire format and frontend whitelist are
unchanged, so no LIVE_TEST result is invalidated. Follow-through here:
ports 469/471 migrated to the event-based calls, meta sidecars + overview
regenerated, CAPABILITIES rows reworded.

## Full re-review against the current rule set (2026-07-19)

A "would this be generated differently today?" pass over all 34 ports
(4 parallel reviewers, one per batch, against the archived originals and the
current AGENTS/CAPABILITIES). 32 of 34 ports were already what today's rules
produce; two were regenerated, plus hygiene. All changes in this pass:

- **401 (FacetFilterLight)** — four upgrades: (1) the appended table's
  `items` keeps the original `sorter` binding-info string, the ABAP `SORT`
  is gone (the 2026-07-17 conversion wave had missed this port); (2) the
  Dimensions cell binds the original composite
  `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}` over real columns instead of a
  precomputed `DIMENSIONS` string; (3) the header toolbar is restored — the
  popin-layout ComboBox (two-way `selectedKey`; the Table's added
  `popinLayout` expression maps empty→Block like the controller default) and
  the Hide/Show ToggleButton (two-way `pressed`; the restored infoToolbar's
  `visible` is a pure expression) — only the sticky Label/CheckBoxes stay
  IMPROVISED (array property) and `p:ColumnAIAction` is now a proper
  DROPPED_171; (4) the ABAP-side model filtering is now **declared**: the
  nested AND-of-ORs filter exceeds the single-filter `binding_call`
  whitelist — CAPABILITIES row scoped accordingly, forwardable request
  **pr/binding-call-compound-filters** opened.
- **460 (ObjectHeader)** — converted from full static resolution to the
  original element binding + relative field bindings 1:1 (`binding=` on a
  one-record `/S_PRODUCT` structure, Currency number binding kept); only
  the context path deviates. First `binding=` context port, LIVE_TEST.
- **Self-referential deviations reclassified** IMPROVISED→NOTE in 472
  (range→value/value2), 486 (expression-bound widths), 474 (two-way
  selectedKey) — same class the 2026-07-17 audit fixed for 447/452/454/449;
  the counts above now reflect it. App 038's NOTE no longer claims "no
  MessageManager model" (stale since pr/message-model).
- **Checked-invalidation rule** (new, AGENTS §10 + TRAINING): a code change
  to a `checked` port resets the status until restamped. Applied to 530
  (07-15 check vs 07-16 rework).
- **Structural diff now compares `id` attributes** (name-level per control
  type): app 047 had dropped the original `SB1`/`selectedItemPreview` ids —
  restored; the gate keeps it from recurring. Extra port-added ids stay
  unflagged.
- **Style normalized**: 528 rewritten from the one-off `a = VALUE #( )`
  string-table form to the canonical chained `a()` calls; 526 `v =` columns
  realigned (golden reference); 486 double blank line removed; multi-line
  inline comments compressed to the §8 one-liner in 422/431/434/447/454/469.
- **AGENTS §5 fixed**: the expression-binding paragraph still instructed
  "capture each bind handle once" — contradicting the never-capture rule and
  pattern-lint; now shows the inline form (421's actual code). STATUS's
  `control_by_id` empty-view wording corrected to the framework behavior
  (global lookup, not "keeps the slot").

## Hold-out regeneration probe #1 (2026-07-19) — baseline set

The first TRAINING.md regeneration probe ran: all 25 hold-out samples
generated from scratch, first-try, scored by every gate plus a 5-reviewer
adversarial pass. Full protocol and per-app numbers:
**`probes/holdout-2026-07-19.md`**. Headlines: 21/25 CI-green on first try,
23/25 structural-diff-clean, 0 genuine render failures, review 14 CLEAN /
5 MINOR / 6 MAJOR with only **three root causes** behind all MAJORs —
each distilled in the same change:

- `popover_display( val = )` guessed by analogy (3 apps, does not compile)
  → exact signature in CAPABILITIES, pattern-lint rule
  `popover-display-val`, prompt updated.
- `CONTROL_METHODS` arg-kinds ignored (2 apps: `to` transition /
  ViewSettingsDialog `open` page silently dropped, mis-filed as LIVE_TEST)
  → AGENTS §10 gotcha + CAPABILITIES row warning + pr/control-method-args
  (**implemented upstream same day**: `to [transitionName]`,
  `open [pageKey]`, `goToStep [controlId, bool]`; `castArgs` no longer pads
  missing trailing args — folder removed, see pr/README Implemented).
- Empty-string flattening breaks enum properties / overrides defaults
  (1 app, QuickView) → AGENTS §5 model rule, prompt updated.

Probe-found infrastructure fixes (landed 2026-07-19): render-smoke
formatter mirror synced to the full upstream contract; `resolveExpr` now
resolves `&&`-chained templates. The probe ports themselves are never
merged (hold-out discipline); the worktree snapshot exists only locally.

## Compound binding_call filters implemented + 401 converted (2026-07-20)

The last open framework request, pr/binding-call-compound-filters, was
implemented upstream (`BINDING_METHODS.filter` accepts a JSON groups
payload: OR inside each group, AND across groups, whitelisted operators,
empty clears; the positional single-filter form is unchanged). Port 401
now expresses the original's nested FacetFilter exactly — apply_filter
builds the groups JSON from the two-way bound selected flags and schedules
`cs_event-binding_call`; the ABAP-side model rebuild and the
`t_products_all` mirror are gone (deviation IMPROVISED→NOTE, new
LIVE_TEST). **pr/ is empty again** — every request implemented or
declined; see pr/README.

## Open findings (backlog)

Live tests: **ALL CLEARED 2026-07-20** — the human live check followed the
interaction checklist through batches b01–b06 (facet compound filter + Reset
+ popin toggle 401, MultiInputExt tokens 454, popup PDFViewer 469, panel
toggle 471, group headers 452, slider widths 486, selection toast 474,
press Dialog 529, BusyDialog timer cycle 533, sticky round-trip 534,
ComparisonPattern navigation 536, cookie focus flow 537, image dialog 538,
hidden-DatePicker openBy 540, date-picker CHANGE round-trips 541/542,
dialog flows 543, feed sender args 547/548, scroll-step switching 550, the
device> phone checks 433/434/473, and the 530 RESTAMP). Every LIVE_TEST
deviation is closed and the apps are promoted to `checked` in their
sidecars; 40 of 54 ports are now live-verified (the remaining 14 are
b01–b04 ports that never carried an open question).

Idiom / style (low):
- [x] ~~`main` method placed last in several ports~~ — done 2026-07-16: new
  convention, `z2ui5_if_app~main` is always the first method and the rest
  follow in call order (17 ports reordered, pattern-lint enforces main-first);
  also `get_event_arg( )` is now the required simplest form (index only for
  position 2+ — the earlier index-1 rule was inverted by decision).

Infrastructure:
- [x] ~~Property-level 1.71 gate~~ — done 2026-07-16:
  `scripts/generate-properties.mjs` parses per-member `@since` from the
  OpenUI5 sources into `ui5/properties.json` (refreshed weekly by
  generate_result); `scripts/property-check.mjs` runs in CI. Policy decision
  same day: **1:1 beats 1.71-purity** — post-1.71 members are KEPT when the
  original uses them and must be declared as `POST_171` (the gate enforces
  the declaration); the previously dropped members were restored. First
  catch: app 006's Carousel `ariaLabelledBy` (association only since 1.125)
  had been silently copied without any declaration.
- [x] ~~generate-coverage.mjs: `FOCUS_LIBS` undocumented; orphan ports vanish
  silently; header-regex fragility~~ — done 2026-07-16: ported set comes from
  `meta/`, the universe from the committed `ui5/universe.json` snapshot
  (refreshed by generate_result from the checkout), orphan ports are warned
  about, `FOCUS_LIBS` documented in AGENTS §7; api.md is one flat table with
  the deprecation info inline.
- [x] ~~Builder hardening: `a()` on the empty root is silently dropped; `shut()`
  past the root null-refs; duplicate attribute names render invalid XML~~ —
  done 2026-07-18: all three ASSERT (fail fast at the call site), plus a local
  unit test class on `z2ui5_cl_ai_xml`.
- [x] ~~property-check blind spot (hold-out probe 2026-07-19): the gate only
  scans `a( n = … )` attributes, so a post-1.71 **event parameter** read via
  `${$parameters>/…}` in a `t_arg` slips through undeclared (probe app 618,
  SearchField `searchButtonPressed` since 1.114)~~ — done 2026-07-20:
  `usedMembers` now also scans each control slice for `$parameters>/<name>`
  and resolves the first path segment against the same flat member map
  (event parameters already carry their `@since` in `properties.json`, e.g.
  `sap.m.SearchField.searchButtonPressed` = 1.114), attributing the ref to
  the control that fired it (the one carrying the event `a()`, = last
  opened). Error message names it as an event parameter and a `POST_171`
  deviation clears it, exactly like a property. Zero new errors on the 54
  live ports (every existing `$parameters` ref is ≤ 1.71); verified with a
  throwaway SearchField probe that the undeclared→declared transition flips
  exit 1→0. Deeper path segments (`item/oParent`) are runtime object fields,
  not metadata, and stay unchecked by design.
- [ ] pattern-lint stays regex-based **by decision** (2026-07-18): the rule
  set is green and each rule is small; a rewrite on the abaplint AST API only
  pays once regex rules start producing false positives/negatives in
  practice. Revisit when a rule needs real syntax awareness (first candidate:
  anything that must distinguish strings from code).
- [x] ~~render-smoke: app 049 is SKIPped (view built via `render_item` helper
  methods — not statically reconstructable). Either teach the reconstructor
  simple single-level helper inlining, or accept the skip; never let skips
  grow silently~~ — resolved 2026-07-20 by making the skip an explicit,
  CI-enforced decision (the second option). Single-level inlining does not
  actually suffice: the builder is handle-based (`open`/`shut` navigate a
  tree via held node refs, not one global stack), so app 049's `render_item`
  passes the List handle in and chains a returned handle out — faithfully
  rebuilding it needs a handle-tracking interpreter, and a wrong-but-rendering
  reconstruction would be a *false pass*, strictly worse than a visible skip.
  So: a port may declare `"render_smoke": { "skip": true, "reason": "…" }` in
  its sidecar (validated by validate-meta); render-smoke SKIPs a declared
  port but now **FAILS** an undeclared non-reconstructable one (helper-method
  builder calls with no declaration) *and* FAILS a stale declaration (a port
  that reconstructs but still declares skip). Skips can no longer grow
  silently — a new helper-built port fails CI until a human consciously
  declares or reconstructs it.
  **Update 2026-07-22 — the handle-tracking interpreter was actually built**
  (`extractDocsWithHelpers` in render-smoke.mjs). A builder handle is now a
  stack snapshot (root..cursor); `DATA(list) = view->…->open( List )` saves it,
  a builder-returning helper (`METHODS … RETURNING VALUE(result) TYPE REF TO
  z2ui5_cl_ai_xml`) is parsed once into a relative op-chain, and every
  `render_item( list = list … )->leaf( … )` call is inlined re-anchored to its
  argument handle with the non-entry params (`label`) substituted string-aware.
  app 049 reconstructs faithfully (14 CustomListItems, each `HBox` → label
  VBox + StepInput VBox) and renders for real — **not** a wrong-but-rendering
  false pass: the tree is byte-correct. The declared-skip mechanism stays as the
  safety net for a future idiom the interpreter still can't rebuild. Its own
  skip declaration was removed; run is now **0 failing / 0 skipped**.
- [x] ~~render-smoke harness gaps found by the 2026-07-19 hold-out probe~~ —
  fixed same day: (a) the inline formatter mirror had only `weightState`
  while upstream `model/formatter.js` had grown the date helpers + demo kit
  pack — now mirrors the full curated contract; (b) `resolveExpr` treated a
  value starting with `|` as ONE template, so a template continued with `&&`
  leaked literal `| &&` into the attribute — now the (template-aware) `&&`
  split runs first and each piece resolves independently. Existing 34 ports
  unaffected (0 failing / 1 skipped before and after).
- [x] ~~TRAINING.md stage 2: generate the header block from `meta/`
  (inversion)~~ — done 2026-07-16, stricter than planned: port classes carry
  no header at all; `meta/` is the source of truth (validate-meta in CI,
  pattern-lint blocks `"!` in ports).
- [x] ~~Run `structural-diff.mjs --strict` in CI~~ — done 2026-07-16: the
  `checks` workflow runs pattern-lint, structural-diff --strict and a
  generated-artifacts sync check on every PR.
- [x] ~~AGENTS.md §5 "Worked references" points at nonexistent
  `src/04/z2ui5_cl_ai_app_416`; §8 names the wrong builder classes~~ — fixed
  2026-07-16 (416 row replaced by app 007, §8 corrected to `z2ui5_cl_ai_xml`).
