# STATUS.md — current state & open findings

_Point-in-time summary, last updated **2026-07-20**. Update this file whenever
findings are fixed or new ones land (same-change discipline as AGENTS.md §10).
For the process itself see TRAINING.md; for what abap2UI5 can express see
CAPABILITIES.md._

## Where the repo stands

| Aspect | State |
|---|---|
| Ports | 54 / **403 in-scope** `sap.m` samples (13.4 %) — in scope = control exists since UI5 1.71 and is not deprecated; 43 of 446 samples are out of scope (16 deprecated, 21 newer, 6 without control metadata) |
| CI | ABAP_STANDARD, ABAP_CLOUD, ABAP_702 all green |
| Structural view diff | **0 undeclared differences** across all 54 ports (`node scripts/structural-diff.mjs --strict`) — including simple **binding values** and, since 2026-07-19, **`id` attributes** (name-level per control type; dropped original ids must be restored or declared) |
| Render smoke | **0 failing / 1 skipped** (`npm run smoke`): every reconstructable port's view loads in a real headless `XMLView.create` (app 481 skipped — helper-method view building is not statically reconstructable); harness carries `sap.f` and mocks scalar-row tables as empty arrays since b05 |
| Pattern lint | **0 errors, 0 warnings, empty baseline** (`node scripts/pattern-lint.mjs`) |
| Meta sidecars | 54 in `meta/` — status: 14 `generated`, **40 `checked`** (live check 2026-07-20); deviations: 30 IMPROVISED, 27 POST_171, **0 LIVE_TEST**, 9 SUBSET_DATA, 57 NOTE, 2 DROPPED_171 (the `p:ColumnAIAction` plugin in apps 401 and 534 — a whole control newer than 1.71, unlike the restorable members). `audit` is a structured object since 2026-07-18 |
| Manually verified in a running system | **40 of 54 ports** — 2026-07-20 human live check per the interaction checklist (all b05/b06 + every port that carried an open question, incl. the 530 restamp); previously: 420/421/526 interactive, 404/431/440/460/487 visual 2026-07-19. The 14 remaining `generated` ports are b01–b04 apps that never carried an open question |
| Archive | `ui5/sap.m/<SampleName>/` — full originals for the 34 ported samples (+2 cross-referenced: `FacetFilterSimple`, `Table`); mock snapshot in `ui5/mock/`. Unported samples are copied over batch by batch. |

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

New generation batches continue as `b07`, `b08`, … per the process in
TRAINING.md.

## Full human live check (2026-07-20) — every open question cleared

The human worked through the complete interaction checklist in a running
system (batches b01–b06, all framework-mechanism firsts incl. the freshly
merged openBy/compound-filter paths, the review-fixed 550 scroll step, the
device> phone checks and the 530 restamp) and confirmed every item. All
LIVE_TEST deviations are closed, **40 of 54 ports are `checked`** — the
14 remaining `generated` ports are b01–b04 apps that never carried an open
question. Next: `golden` promotions are now possible (human judgement per
TRAINING.md) to widen the generation-prompt reference set beyond
408/421/454.

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
binding" LIVE_TEST rewrote to a NOTE (app 460 already proved the
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
  recurrence, flattening declared everywhere, app 539 explicitly reasoned
  the empty-string/enum rule, app 535 seeded `popinLayout` non-empty.
- **App 534** re-applies the app-401 `DROPPED_171` decision for
  `p:ColumnAIAction` (plugin class newer than 1.71 — dropped, not POST_171).
- **Two new framework gaps** → pr/control-methods-openby-setactivepage,
  **implemented upstream 2026-07-20** (new `domRef` arg kind, `openBy`,
  `setActivePage`; folder archived in pr/README Implemented): app 540's
  hidden-DatePicker wiring is now valid (IMPROVISED→LIVE_TEST). App 536's
  Carousel re-sync stays dropped — aggregation-template clone ids are not
  backend-addressable (recorded in the sidecar + CAPABILITIES; an
  index-based page resolution would be a new request if more samples need
  it).
- Render-smoke harness extended for b05: `sap.f` library loaded
  (DynamicPage/GridList/Card in 536/537) and scalar-row tables
  (`TABLE OF string` bound to array properties like `Table.sticky`, app
  534) mocked as empty arrays instead of `{}` rows.
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
  `&#xA;`/`&#xD;`/`&#x9;` (fixes app 445's lost noDataText line break at the
  root).
- **App 401 (FacetFilter)** — Reset now really resets (two-way `selected`
  binding per FacetFilterItem) and the fragile JSON parse of
  `$event.mParameters.selectedItems` (private internals, silent CATCH) is gone;
  full NOTES block added. LIVE-TEST pending.
- **App 454 (MultiInput)** — the 6+1 pre-set tokens from `onInit` render again
  (tokens aggregation), View height restored, NOTES block added.
- **App 422 (ColorPalette)** — boolean `defaultAction` echoed as `true`/`false`
  instead of raw `X`/space.
- **Apps 441/469/481** — existing deviations declared in the header NOTES.

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
  exempted citing app 421) — the human had to fix the same error class twice.
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
  IMPROVISED dropped, LIVE_TEST added. App 460 keeps its static single-record
  resolution (an unrelated deviation), not blocked by the type.
- **MultiInput `addValidator` — NOT a framework gap either** — the bundled
  custom control `z2ui5.cc.MultiInputExt` installs exactly the sample's
  free-text→token validator (`addValidator(({text}) => new Token({key:text,
  text}))`, source-verified in `app/webapp/cc/MultiInputExt.js`) and mirrors
  token changes back via `addedTokens`/`removedTokens` + `change`. CAPABILITIES
  row added (🔶) and the app-454 deviation corrected IMPROVISED→NOTE. Initially
  left unwired (first cc-control usage needs a live check); **wired 2026-07-18**
  (human direction): app 454 now declares `xmlns:z2ui5="z2ui5.cc"` and one
  `z2ui5:MultiInputExt` leaf per token input (`multiInput1`/`multiInput2`,
  matching the original's two addValidator calls); the render-smoke harness
  carries a metadata-only mirror of the cc control so view creation stays
  gate-checked, the behavior check remains a LIVE_TEST.

**Pattern worth noting:** of the four framework ideas the audit raised, only
one (`control_call` whitelist) is a real gap; the composite `Currency` type
and the MultiInput validator were both already in the framework — the map/ports
had wrongly treated them as ❌. Exactly the "declared impossible although it
already works" failure mode CAPABILITIES.md opens by warning against.

**Same failure mode again — `sap.m.MessageView` (2026-07-18):** app 449 was
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
- **Hold-out set defined** — `ui5/holdout.json`, 25 samples across control
  families; marked `HOLDOUT` in `--backlog`, never prompt references, never
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
  the counts above now reflect it. App 449's NOTE no longer claims "no
  MessageManager model" (stale since pr/message-model).
- **Checked-invalidation rule** (new, AGENTS §10 + TRAINING): a code change
  to a `checked` port resets the status until restamped. Applied to 530
  (07-15 check vs 07-16 rework).
- **Structural diff now compares `id` attributes** (name-level per control
  type): app 474 had dropped the original `SB1`/`selectedItemPreview` ids —
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
  catch: app 420's Carousel `ariaLabelledBy` (association only since 1.125)
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
- [ ] property-check blind spot (hold-out probe 2026-07-19): the gate only
  scans `a( n = … )` attributes, so a post-1.71 **event parameter** read via
  `${$parameters>/…}` in a `t_arg` slips through undeclared (probe app 618,
  SearchField `searchButtonPressed` since 1.114). Teach the gate to match
  `$parameters>/<name>` against the entity's member list, or accept and
  keep the AGENTS §10 rule as the only guard.
- [ ] pattern-lint stays regex-based **by decision** (2026-07-18): the rule
  set is green and each rule is small; a rewrite on the abaplint AST API only
  pays once regex rules start producing false positives/negatives in
  practice. Revisit when a rule needs real syntax awareness (first candidate:
  anything that must distinguish strings from code).
- [ ] render-smoke: app 481 is SKIPped (view built via `render_item` helper
  methods — not statically reconstructable). Either teach the reconstructor
  simple single-level helper inlining, or accept the skip; never let skips
  grow silently (the run prints them).
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
  2026-07-16 (416 row replaced by app 421, §8 corrected to `z2ui5_cl_ai_xml`).
