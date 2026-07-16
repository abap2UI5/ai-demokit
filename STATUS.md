# STATUS.md — current state & open findings

_Point-in-time summary, last updated **2026-07-16**. Update this file whenever
findings are fixed or new ones land (same-change discipline as AGENTS.md §10).
For the process itself see TRAINING.md; for what abap2UI5 can express see
CAPABILITIES.md._

## Where the repo stands

| Aspect | State |
|---|---|
| Ports | 34 / 446 `sap.m` samples (7.6 %) |
| CI | ABAP_STANDARD, ABAP_CLOUD, ABAP_702 all green |
| Structural view diff | **0 undeclared differences** across all 34 ports (`node scripts/structural-diff.mjs --strict`) |
| Meta sidecars | 34 in `meta/` — status: 30 `generated`, 4 `checked`; deviations: 28 IMPROVISED, 9 DROPPED_171, 3 LIVE_TEST |
| Manually verified in a running system | 420, 421, 526, 530 (`CHECKED`) |
| Archive | `ui5/` complete incl. shared mock data snapshot (`ui5/mock/`, provenance in its README) |

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

## Open findings (backlog, from the 2026-07-16 review)

Fidelity / better generation:
- [ ] **529**: status press shows a toast; the original opens a Dialog —
  expressible 1:1 via `popup_display` (see app 469, CAPABILITIES.md). Fix +
  drop the wrong IMPROVISED justification.
- [ ] **404 / 431**: dropped sample CSS is expressible via a `core:HTML` leaf
  with the `content` attribute (`<style>…</style>`); 404's colored flex boxes
  are the sample's whole point.
- [ ] **530**: `SEP_CHANGE` round-trip is redundant (shared two-way binding
  already updates the Breadcrumbs) and reads private `mProperties` — drop the
  event.
- [ ] **486**: toolbar width round-trip could be a pure expression binding
  (`{= ${slider} + '%' }`), removing `on_event`.
- [ ] **474**: `${$parameters>/item/mProperties/text}` relies on private
  internals without a LIVE-TEST note — restructure or declare.
- [ ] **420/433/440/441/452**: mock-data row subsets partly undeclared
  (433 vs 441 even render different rows for the same collection) — declare
  per port, now checkable against `ui5/mock/products.json`.
- [ ] **423/527**: binding `sorter` replaced by ABAP `SORT` with inline comment
  only — needs a NOTES bullet (527 has no block at all).
- [ ] **452**: try the bound-template variant with a raw binding-info string
  (`sorter: { group: true }`) instead of the static unroll — needs LIVE-TEST.

Live tests pending (in-system):
- [ ] **401** — Reset unchecks the facet popover checkboxes (two-way selected).
- [ ] **469** — PDFViewer renders inside the Dialog at height 100%.
- [ ] **487** — 5-level nested tree binding renders expandable levels.

Idiom / style (low):
- [ ] **526**: 12× duplicated `_event` literal — capture once; lone
  `get_event_arg( )` without index.
- [ ] **528**: off-style up-front attr-table form for static attributes; no
  blank before shuts.
- [ ] Blank-line convention violations: 420, 422, 431, 439, 447, 486.
- [ ] **440**: field `pic_url` breaks the JSON-key naming convention
  (`product_pic_url`).
- [ ] `main` method placed last in 420–423, 527, 530 (skeleton puts it first).

Infrastructure:
- [ ] **generate-coverage.mjs**: `FOCUS_LIBS` filter undocumented /
  contradicts AGENTS.md §7; orphan ports vanish from coverage silently (add a
  warning); anchor the ported-set regex to the header URL line like the other
  scripts.
- [ ] Builder hardening: `a()` on the empty root is silently dropped; `shut()`
  past the root null-refs; duplicate attribute names render invalid XML.
- [ ] TRAINING.md stage 2: generate the header block from `meta/` (inversion).
- [ ] Run `structural-diff.mjs --strict` in CI.
- [x] ~~AGENTS.md §5 "Worked references" points at nonexistent
  `src/04/z2ui5_cl_api_app_416`; §8 names the wrong builder classes~~ — fixed
  2026-07-16 (416 row replaced by app 421, §8 corrected to `z2ui5_cl_api_xml`).
