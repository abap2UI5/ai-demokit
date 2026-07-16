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
| Meta sidecars | 34 in `meta/` — status: 30 `generated`, 4 `checked`; deviations: 35 IMPROVISED, 11 DROPPED_171, 10 LIVE_TEST |
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
- **Builder `z2ui5_cl_api_xml`** — LF/CR/TAB in attribute values now escape to
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
- Idiom: **526** captures the shared press event once + `get_event_arg( 1 )`;
  **528/434** blank-line fixes — pattern-lint is at 0/0 with an empty baseline.

## Open findings (backlog)

Live tests pending (in-system):
- [ ] **401** — Reset unchecks the facet popover checkboxes (two-way selected).
- [ ] **469** — PDFViewer renders inside the Dialog at height 100%.
- [ ] **487** — 5-level nested tree binding renders expandable levels.
- [ ] **529** — the press Dialog opens/closes (popup_display).
- [ ] **404/431** — injected CSS styles the flex items / floats the tiles.
- [ ] **486** — expression-bound toolbar widths follow the slider.
- [ ] **530** — separator switches instantly via the shared two-way path.
- [ ] **474** — two-way selectedKey is updated before on_event runs.
- [ ] **452** — try the bound-template variant with a raw binding-info string
  (`sorter: { group: true }`) instead of the static unroll.

Idiom / style (low):
- [ ] `main` method placed last in 420–423, 527, 530 (skeleton puts it
  first) — cosmetic, postponed.

Infrastructure:
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
  `src/04/z2ui5_cl_api_app_416`; §8 names the wrong builder classes~~ — fixed
  2026-07-16 (416 row replaced by app 421, §8 corrected to `z2ui5_cl_api_xml`).
