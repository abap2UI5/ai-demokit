# STATUS.md — current state & open findings

_Two parts: a **generated** point-in-time state (from `meta/` — never edit it
by hand, `scripts/generate-status.mjs` regenerates it via the pre-commit hook
and the `meta_valid` CI job fails a PR with a stale block) and the
**hand-maintained** open-findings backlog below it. The chronological journal
(batches, probes, audits — one section per event) moved to
[STATUS-history.md](STATUS-history.md); **new journal entries go there**, in
the same same-change discipline as AGENTS.md §10. For the process itself see
TRAINING.md; for what abap2UI5 can express see CAPABILITIES.md._

## Current state (generated)

<!-- state:start -->

| Aspect | State |
|---|---|
| Ports | **416** sidecars in `meta/` (src/01 OpenUI5 <= 1.71: 291 · src/02 OpenUI5 > 1.71: 125) |
| Per library | sap.f: 19 · sap.m: 219 · sap.tnt: 17 · sap.ui: 130 · sap.uxap: 31 |
| Status ladder | 209 `generated` · 146 `reviewed` · 61 `checked` (live-verified) |
| Deviations | 5 DROPPED_171 · 66 IMPROVISED · 72 LIVE_TEST · 887 NOTE · 168 POST_171 |
| Open LIVE_TESTs | **72 ports** carry at least one `LIVE_TEST` deviation — the automated close path is the e2e interaction harness (AGENTS §6 `e2e_smoke`) |
| Declared gate skips | 2 structural-diff · 4 render-smoke (each re-verified per run — a stale skip FAILS) |
| Out-of-scope ported samples | `z2ui5_cl_smpc_app_121 (sap.m.sample.UploadSet — deprecated)` · `z2ui5_cl_smpc_app_136 (sap.f.sample.SidePanelSingle — control @since 1.107)` · `z2ui5_cl_smpc_app_141 (sap.ui.core.sample.InvisibleMessage — control @since 1.78)` · `z2ui5_cl_smpc_app_165 (sap.f.sample.ProductSwitchNavigation — control @since 1.72)` · `z2ui5_cl_smpc_app_203 (sap.m.sample.OverflowToolbarTokenizer — control @since 1.139)` — all decided KEEP permanently 2026-07-30 (per-app rationale in ui5/scope-exceptions.json, revertible); the source-backed scope gate stays hard for NEW undecided entries |

_Coverage per library (ported / in scope) is generated into the [README](README.md#coverage); one row per sample in [api.md](api.md)._

<!-- state:end -->

## Open findings (backlog)

- [ ] **open-abap XML escaping — patched here, open upstream.**
  `CALL TRANSFORMATION id … RESULT XML` writes character data unescaped in
  open-abap-core, so any app whose model carries a `<` persists a draft its own
  `CL_IXML` cannot parse back and every later round-trip fails with
  `Network error: ASSERTION_FAILED` (user report 2026-07-31 on the Pages demo's
  overview; STATUS-history has the analysis). Both transpiled builds now
  transpile against a locally patched clone
  (`web/ci/patch_open_abap_xml.mjs`); the request is filed as
  `pr/open-abap-xml-escaping`. When it is merged upstream: drop the patch
  script, the two clone steps (`web/package.json` assemble,
  `scripts/e2e-build.mjs`) and the `folder` lib entries, and delete the pr/
  folder.
- [ ] **LIVE_TEST debt → e2e interactions.** The open `LIVE_TEST` count (see
  the generated table) is the corpus' unverified-behaviour backlog. The
  systematic close path is the e2e harness: add a per-port interaction module
  under `meta/interactions/<class>.mjs` (one generic assertion per LIVE_TEST
  class — client-composed toast, popup/popover open, binding_call; the
  directory's README carries the coverage catalogue) and, after a green
  run, `node scripts/close-live-tests.mjs --close <nums>` converts the
  verified entries into `NOTE`s mechanically (text kept verbatim, so gate
  declarations keep matching). The 2026-08-04 state "every LIVE_TEST port
  has an interaction" no longer holds: the batches added since (apps
  299–366) ship their LIVE_TESTs without interactions — `validate-meta`
  reports that gap count as an advisory so it stays visible. A red
  nightly opens/updates an issue instead of hiding in the Actions tab.
  Every green interaction is human live-check time saved.
- [ ] **Property-gate residual limits** (documented in AGENTS §5): enum
  *values* newer than 1.71 are invisible at the attribute-name level; a
  member relocated to a newer base class reads as that base's version; and a
  **binding-info parameter** (`boundFilters` @1.146, apps 264/265) is not a
  control member at all, so it appears in no gate — declare it by policy. A
  green property-check still does not prove a port ≤ 1.71-clean — the
  control-level `scope-of` check plus by-policy POST_171 declarations remain
  required.
- [ ] **Review-sweep rework backlog.** The 2026-07-27 sweep
  promoted 152 of 201 `generated` ports to `reviewed`; the rest stayed
  `generated` with **corrected, honest sidecars** and need real view/logic
  rework. **Closed 2026-07-28:** the whole dead-`_event`-wire class (138, 143,
  145, 146, 148, 150 — pattern-lint `dead-event-wire`, BASELINE now empty) and
  the app-220 crash. Each was rebuilt the thin-frontend way where the
  capability exists — two-way binding + expression binding for 146/150/145,
  a real `on_event` dispatcher for 143/138, and the full drag & drop reorder
  for 148 (CAPABILITIES marks it ✅, so the earlier "not reproduced" was a
  wrong improvisation). Only 138's slider (a jQuery DOM width on a
  `sap.m.Page`, which has no width property) and 145's `RevealGrid` overlay
  (a sample-local helper module) stay dropped, now declared as such. Also closed in the
  same pass: 124 (a `liveChange` round-trip per drag step → the expression
  binding), 160 (toast → the real `MessageBox.alert`, which its own sidecar had
  already flagged as a wrong improvisation), 163 (hardcoded button captions →
  `${$source>/text}`, and the dropped `ActionSheet.fragment.xml` rebuilt and
  anchored via `popover_display`), 109 (`weekNumber` / `date` event parameters
  now transported into the toast texts) and 127 (`$event.oSource.sId` instead
  of a bare "Pressed"). **Still open:** the rest of the toast-substitution
  class (URLHELPER, timers, generalized `control_by_id`, the remaining
  controller-built popups — 106/107/112/147/149/170/218/244/246) and faked
  event values in the ports not listed above. The dropped sample CSS of 122/124
  is **closed** (2026-07-28): both stylesheets are archived (closing that `§4`
  gap) and injected through a `core:HTML` `<style>` leaf.
  Find the rest: sidecar status `generated` minus the 5 scope-exception ports
  (newer ports still awaiting their first review are `generated` too). Note the
  reworked ports keep status `generated`: the headline gap is closed and
  gate-verified, a full end-to-end re-review per port is not done.
  **Closed 2026-07-30:** the whole remaining toast-substitution class —
  106/107 (MultiSelect toggle state + the MessagesIndicator MessagePopover
  over the `message>` model via the cc.MessageManager bridge), 112 (the
  ResponsivePopover-with-ColorPicker via `popover_display`), 147 (the global
  BusyIndicator show/hide reproduced with `BUSY_INDICATOR` + `START_TIMER`),
  149 (URLHELPER REDIRECT instead of the toast), 170 (the Card popover
  fragment 1:1 + the Edit `areaShrinkRatio` toggle via two-way binding),
  218 (the dropped `oSF.suggest()` popup-reopen wired as a second
  `control_by_id` follow-up), 244 (`breakpointChange` → bound Avatar
  `displaySize`, POST_171 @1.147) and 246 (the original `handleUploadPress`
  empty-check/upload/clear instead of the tooltip-derived toast).
  **Closed 2026-08-01 — the residual faked-event-value audit.** It is a script
  now: `scripts/probes/faked-event-value-audit.mjs` compares every sample's own
  `MessageToast.show(… + oEvent…)` against the port's wire and reports a port
  whose text is a CONSTANT. It found **two** real cases, both fixed — app 133
  (all four GridList toasts had dropped the item id; now
  `{0?Selected:Unselected} item with ID {1}` and friends over
  `${$parameters>/listItem}.getId()` / `$event.oSource.sId`) and app 100 (a
  constant instead of *"Link 'X' was clicked"*, with the back-button branch
  missing entirely; the navigate event now transports the navOrigin text and
  an ABAP `COND` rebuilds the original if/else). The two remaining hits
  (118/203) are deliberately dropped interactions, declared IMPROVISED.
  Re-run the probe after any batch that adds toast wires.
  **Closed 2026-08-05 — app 115**, the larger of the two rebuilds the harvest
  left in REWORK. It was a 3-column breadth probe over 5 seeded rows with a
  `structural_diff` skip; it is now the full `sap.ui.table.sample.Basic`:
  all **13** columns (Text/Input/Label/ObjectStatus/`u:Currency`/ComboBox/
  Link/Button/CheckBox/Select/MultiInput/`c:Icon`/DatePicker templates) over
  the complete 123-row mock, with the Suppliers/Categories arrays
  `initSampleDataModel` derives and the two Available formatters computed in
  ABAP (`AVAILABLESTATE`/`AVAILABLEICON`, thin-frontend rule). The skip is
  **gone** — structural-diff now runs it and the only difference left is the
  declared `p:ColumnAIAction` (`sap.m.plugins` @1.136, DROPPED_171). The two
  display-only handlers (`handleDetailsPress`, `onPaste`) resolve on the
  client through `control_global MESSAGE_TOAST` with the row/parameter value
  as an event argument; only `updateMultipleSelection`, which mutates the
  model, stays a round-trip. The original's `key="{ProductId}"` on the
  `/Categories`-bound suggestion template is ported **verbatim** (it yields an
  empty key there — the sample's own quirk) rather than repaired, and the
  handler mirrors its filter-by-removed-key. One more `IMPROVISED` closed
  with it (deviation totals are never repeated here — the generated state
  block above is the count); the REWORK family is down to app **118** alone.
- [ ] **App 203 out of scope via `@ui5-experimental-since`** —
  `sap.m.OverflowToolbarTokenizer` is experimental since 1.139 with no plain
  `@since`, which the scanners misread as base-version until 2026-07-27
  (both now read the experimental tag). Decided KEEP with the other
  `ui5/scope-exceptions.json` entries (2026-07-30, see the generated state
  block's out-of-scope list) — this item stays open only for the revisit
  option the exception file documents.
- [ ] **Port numbering carries one historic gap (231).** `validate-meta` now
  enforces gap-free numbering with `231` as the single pinned exception:
  closing it means renumbering the ~60 ports above (class names, sidecars,
  e2e INTERACTIONS keys, history references) — a maintainer decision, not a
  gate side effect. Any NEW gap fails the gate.
- [ ] **App 298 renders the products mock's integer dimensions with a
  trailing `.0`.** Its row type declares `Width`/`Depth`/`Height` as
  `p LENGTH 4 DECIMALS 1`, but the shared mock mixes integers (`30`) with
  one-decimal values (`40.8`) in those columns and they are only bound into
  the text template `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}` — so the port
  shows `30.0 x 18.0 x 3.0 cm` where the original shows `30 x 18 x 3 cm`.
  `port-a-sample` already states the rule (a display-only value with variable
  decimals in a text template stays `TYPE string`); app 377 follows it on the
  same mock. No gate sees this — `data-fidelity` does not compare numbers.
  Fixing 298 is a one-line type change plus a re-check of its `checked` state.
- [ ] **App 089 binds a device-model path the framework does not carry.**
  `expanded="{device>/isNoPhone}"` is kept verbatim from the demo kit, but
  `isNoPhone` is a demo-kit helper property; the framework's `device>` model
  wraps raw `sap.ui.Device`, which has no such key, so the binding resolves to
  nothing. Apps 030 and 378–381 express the same intent as
  `{= !${device>/system/phone} }`. The sidecar's NOTE currently describes the
  verbatim form as intentional.
