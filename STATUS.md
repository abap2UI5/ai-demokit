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
| Ports | **280** sidecars in `meta/` (src/01: 167 · src/02: 65 · src/03: 18 · src/04: 19 · src/05: 11) |
| Status ladder | 71 `generated` · 146 `reviewed` · 63 `checked` (live-verified) |
| Deviations | 4 DROPPED_171 · 131 IMPROVISED · 35 LIVE_TEST · 406 NOTE · 114 POST_171 |
| Open LIVE_TESTs | **35 ports** carry at least one `LIVE_TEST` deviation — the automated close path is the e2e interaction harness (AGENTS §6 `e2e_smoke`) |
| Declared gate skips | 7 structural-diff · 1 render-smoke (each re-verified per run — a stale skip FAILS) |
| Out-of-scope ported samples | `z2ui5_cl_ai_app_121 (sap.m.sample.UploadSet — deprecated)` · `z2ui5_cl_ai_app_136 (sap.f.sample.SidePanelSingle — control @since 1.107)` · `z2ui5_cl_ai_app_141 (sap.ui.core.sample.InvisibleMessage — control @since 1.78)` · `z2ui5_cl_ai_app_165 (sap.f.sample.ProductSwitchNavigation — control @since 1.72)` · `z2ui5_cl_ai_app_166 (sap.f.sample.SemanticPage — deprecated)` · `z2ui5_cl_ai_app_203 (sap.m.sample.OverflowToolbarTokenizer — control @since 1.139)` — all decided KEEP permanently 2026-07-30 (per-app rationale in ui5/scope-exceptions.json, revertible); the source-backed scope gate stays hard for NEW undecided entries |

_Coverage per library (ported / in scope) is generated into the [README](README.md#coverage); one row per sample in [api.md](api.md)._

<!-- state:end -->

## Open findings (backlog)

- [x] **Smart variant management: solved** (closed 2026-07-28). `sap.ui.comp`'s page
  variant never gets `setPersControler()` — `addPersonalizableControl()` returns early
  for `isPageVariant()`, so a controller-less app has neither the anchor
  (`_oPersoControl`) nor the control promise `initialise()` requires. abap2UI5 does
  the handshake through the `SMART_VARIANT_INIT` action, merged into abap2UI5 main
  with #2481; the PageVariantManagement port is **live-verified**: saving works and the
  saved views are back after a restart (`isInitialized: true`, 7 variants / 7 items).
  The port names the action through `client->cs_event-smart_variant_init` instead of the
  string literal, and now lives in abap2UI5/samples (`z2ui5_cl_demo_app_478`).
  Seven hypotheses died on live evidence before this one, kept so nobody walks them
  again: missing app component (resolves), `flexEnabled` (read only by `sap.ui.rta`),
  association-id prefixing (XMLViews prefix single associations), registration
  (2 controls, `loadVariants` clean), the SAPUI5 docs' page-variant wiring (registers
  **0** controls — the sample's wiring is the right one), `initialise()` as the setter
  (it only reads the field), and anchoring after the fact (the write path works, the
  load path does not).
- [x] **sap.ui.comp ports left this repo** (closed 2026-07-29). The five smart
  control ports needed a SAPUI5 runtime plus a Gateway service, so neither the
  universe, the property gate, `render_smoke` nor the e2e harness could see
  them — they sat outside every check this repo is built on. This repo is now
  **OpenUI5-only** (AGENTS §3): the ports moved to
  [abap2UI5/samples](https://github.com/abap2UI5/samples) `src/00/00`
  (*extended*, next to the existing smart control demos 313/314/319) as
  `z2ui5_cl_demo_app_475`–`_479`, rebuilt on `z2ui5_cl_xml_view`.
- [x] **Out-of-scope ported samples: KEEP permanently** (decided 2026-07-30
  under the session's standing continue-with-everything mandate; each entry
  in `ui5/scope-exceptions.json` carries the per-app rationale and is
  revertible by deleting the port + its entry). All six gate-verified ports
  stay: 121 (UploadSet, deprecated — only upload-set coverage), 136
  (SidePanel @1.107), 141 (InvisibleMessage @1.78 — only a11y-announcement
  idiom), 165 (ProductSwitch @1.72, most borderline), 166 (sap.f
  SemanticPage, deprecated since 1.54 yet widely deployed) and 203
  (OverflowToolbarTokenizer, experimental @1.139). The source-backed scope
  gate stays a **hard gate** (exit 1) for any NEW ported out-of-scope
  sample without a decided entry, so this class of debt cannot regrow.
- [x] **Non-app samples are out of scope** (user decision 2026-07-31, found
  while planning batch b05). Apps 258/259 took the last two portable
  `NEW-CONTROL` rows (`sap.uxap.ObjectPageDynamicHeaderTitle`); everything left
  under that marker was UI5's own **test infrastructure** (`sap.ui.test.*` —
  OPA5 / gherkin / matcher QUnit pages), **Component routing**
  (`sap.ui.core.routing.*`) and the **view-type / XML-templating /
  XMLComposite authoring** demos (`View.*`, `ViewTemplate.*`,
  `XMLComposite.*`) — samples whose control is 1.71-clean but that are not app
  views, so there is nothing to rebuild 1:1. They are now a **second scope
  rule** (AGENTS §1): the families live in `ui5/scope-nonapp.json` with a
  reason each, `scopeOf` returns `nonapp`, `--backlog` never offers them,
  `api.md` still lists them `✗`, and `scope-of.mjs --sample` reports
  `OUT_OF_SCOPE (not an app view — …)`. 39 samples moved out of scope, so the
  honest denominator is **626 in-scope** (was 665) and `sap.ui.core` reads
  80.0 % instead of 27.1 %. Batch planning is **depth-only** from here (lowest
  `covered-control(n)` first, idiom-first within equal n).
  `ControllerExtension` (`sap.ui.core.mvc.ControllerExtension`) joined the list
  in the same pass (user decision): abap2UI5 has no frontend controller to
  extend, so the sample carries no view idiom to rebuild. Deliberately kept
  **in** scope: the two `BoundFilters.*` samples (`sap.ui.model.Filter`) — real
  app views, ported the same day as apps 264/265, so **every remaining
  uncovered control in the backlog is a HOLDOUT**: breadth is closed and batch
  planning is depth-only.
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
  systematic close path is the e2e harness: grow the `INTERACTIONS` map in
  `scripts/e2e-smoke.mjs` (one generic assertion per LIVE_TEST class —
  client-composed toast, popup/popover open, binding_call) and let the
  nightly e2e run (`e2e_nightly.yaml`) convert verified entries into `NOTE`s.
  Every green interaction is human live-check time saved.
- [ ] **Property-gate residual limits** (documented in AGENTS §5): enum
  *values* newer than 1.71 are invisible at the attribute-name level; a
  member relocated to a newer base class reads as that base's version; and a
  **binding-info parameter** (`boundFilters` @1.146, apps 264/265) is not a
  control member at all, so it appears in no gate — declare it by policy. A
  green property-check still does not prove a port ≤ 1.71-clean — the
  control-level `scope-of` check plus by-policy POST_171 declarations remain
  required.
- [ ] **Review-sweep rework backlog (42 ports left).** The 2026-07-27 sweep
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
  Find the rest: sidecar status `generated` minus the 6 scope-exception ports. Note the
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
- [ ] **App 203 out of scope via `@ui5-experimental-since`** —
  `sap.m.OverflowToolbarTokenizer` is experimental since 1.139 with no plain
  `@since`, which the scanners misread as base-version until 2026-07-27
  (both now read the experimental tag). Same pending drop-vs-keep decision
  as the other five `ui5/scope-exceptions.json` entries.
- [ ] pattern-lint stays regex-based **by decision** (2026-07-18): the rule
  set is green and each rule is small; a rewrite on the abaplint AST API only
  pays once regex rules start producing false positives/negatives in
  practice. Revisit when a rule needs real syntax awareness (first candidate:
  anything that must distinguish strings from code).
