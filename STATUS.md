# STATUS.md — current state & open findings

_Point-in-time summary, last updated **2026-07-16**. Update this file whenever
findings are fixed or new ones land (same-change discipline as AGENTS.md §10).
For the process itself see TRAINING.md; for what abap2UI5 can express see
CAPABILITIES.md._

## Where the repo stands

| Aspect | State |
|---|---|
| Ports | 34 / **403 in-scope** `sap.m` samples (8.4 %) — in scope = control exists since UI5 1.71 and is not deprecated; 43 of 446 samples are out of scope (16 deprecated, 21 newer, 6 without control metadata) |
| CI | ABAP_STANDARD, ABAP_CLOUD, ABAP_702 all green |
| Structural view diff | **0 undeclared differences** across all 34 ports (`node scripts/structural-diff.mjs --strict`) |
| Pattern lint | **0 errors, 0 warnings, empty baseline** (`node scripts/pattern-lint.mjs`) |
| Meta sidecars | 34 in `meta/` — status: 30 `generated`, 4 `checked`; deviations: 15 IMPROVISED, 13 POST_171, 15 LIVE_TEST, 7 SUBSET_DATA, 7 NOTE — DROPPED_171 is empty since the 1:1 restoration |
| Manually verified in a running system | 420, 421, 526, 530 (`CHECKED`) |
| Archive | `ui5/sap.m/<SampleName>/` — full originals for the 34 ported samples (+2 cross-referenced: `FacetFilterSimple`, `Table`); mock snapshot in `ui5/mock/`. Unported samples are copied over batch by batch. |

## Batches

The 34 existing ports are retro-grouped into review batches — one subpackage
`src/01/b<nn>` = one ABAP package = one review unit (recorded per port in
`meta/<class>.json` as `batch`):

| Batch | Theme | Apps | Live-checked |
|---|---|---|---|
| `b01` | Display & navigation | 408, 409, 431, 434, 440, 460, 529, 530 | 530 |
| `b02` | Selection & input | 421, 422, 423, 439, 452, 454, 472, 481, 527, 528 | 421 |
| `b03` | Actions, toolbars & popups | 447, 448, 449, 469, 474, 486, 526 | 526 |
| `b04` | Layout, lists & data | 401, 404, 420, 433, 441, 445, 471, 473, 487 | 420 |

New generation batches continue as `b05`, `b06`, … per the process in
TRAINING.md.

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

- **`pr/control-call-whitelist`** (new, open) — a genuine framework gap: the
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

## Open findings (backlog)

Live tests pending (in-system) — the 2026-07-16 framework source pass
(CAPABILITIES.md) already confirmed the *mechanics* of several; what remains
is visual/UX confirmation:
- [ ] **401** — Reset unchecks the facet popover checkboxes (mechanics
  source-verified: model applied before on_event).
- [ ] **469** — PDFViewer renders inside the Dialog at height 100%.
- [ ] **487** — nested tree binding renders expandable levels (serialization
  source-verified; framework ships z2ui5.cc.Tree).
- [ ] **529** — the press Dialog opens/closes (popup_display).
- [ ] **404/431** — injected CSS styles the flex items / floats the tiles.
- [ ] **486** — expression-bound toolbar widths follow the slider.
- [ ] **530** — separator switches instantly via the shared two-way path.
- [ ] **474** — toast shows the newly selected item (timing source-verified).
- [ ] **452** — convert to the bound-template variant with a raw binding-info
  string (pass-through source-verified) — then LIVE-TEST the group headers.
- [ ] **433/473** — NEW: the `device>` model IS available in main views
  (source-verified) — restore the original `{device>/…}` bindings that were
  dropped as "not expressible", then LIVE-TEST.

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
- [ ] Builder hardening: `a()` on the empty root is silently dropped; `shut()`
  past the root null-refs; duplicate attribute names render invalid XML.
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
