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
| Ports | **247** sidecars in `meta/` (src/01: 149 · src/02: 56 · src/03: 12 · src/04: 19 · src/05: 11) |
| Status ladder | 50 `generated` · 146 `reviewed` · 51 `checked` (live-verified) |
| Deviations | 4 DROPPED_171 · 117 IMPROVISED · 50 LIVE_TEST · 304 NOTE · 96 POST_171 |
| Open LIVE_TESTs | **47 ports** carry at least one `LIVE_TEST` deviation — the automated close path is the e2e interaction harness (AGENTS §6 `e2e_smoke`) |
| Declared gate skips | 7 structural-diff · 1 render-smoke (each re-verified per run — a stale skip FAILS) |
| Out-of-scope ported samples | `z2ui5_cl_ai_app_121 (sap.m.sample.UploadSet — deprecated)` · `z2ui5_cl_ai_app_136 (sap.f.sample.SidePanelSingle — control @since 1.107)` · `z2ui5_cl_ai_app_141 (sap.ui.core.sample.InvisibleMessage — control @since 1.78)` · `z2ui5_cl_ai_app_165 (sap.f.sample.ProductSwitchNavigation — control @since 1.72)` · `z2ui5_cl_ai_app_166 (sap.f.sample.SemanticPage — deprecated)` · `z2ui5_cl_ai_app_203 (sap.m.sample.OverflowToolbarTokenizer — control @since 1.139)` — standing debt pending a maintainer decision (drop vs documented exception), surfaced by the source-backed scope gate (pr/scope-since-from-source) |

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
- [ ] **Out-of-scope ported samples** (listed live in the generated table
  above): the source-backed scope gate (`scopeOf` falls back to control-level
  `@since`/`@deprecated` from `ui5/properties.json`, wired 2026-07-26 —
  closes the open ask of `pr/scope-since-from-source`) now surfaces every
  ported sample whose control is deprecated or newer than 1.71, including
  `sap.f.semantic.SemanticPage` (deprecated since 1.54) which the earlier
  hand audit had missed. Pending maintainer decision per app: drop the port,
  or keep it permanently. Until then the five carry documented entries in
  `ui5/scope-exceptions.json`; since 2026-07-26 the check is a **hard gate**
  (exit 1) for any NEW ported out-of-scope sample without such an entry, and
  stale entries fail too.
- [ ] **LIVE_TEST debt → e2e interactions.** The open `LIVE_TEST` count (see
  the generated table) is the corpus' unverified-behaviour backlog. The
  systematic close path is the e2e harness: grow the `INTERACTIONS` map in
  `scripts/e2e-smoke.mjs` (one generic assertion per LIVE_TEST class —
  client-composed toast, popup/popover open, binding_call) and let the
  nightly e2e run (`e2e_nightly.yaml`) convert verified entries into `NOTE`s.
  Every green interaction is human live-check time saved.
- [ ] **Property-gate residual limits** (documented in AGENTS §5): enum
  *values* newer than 1.71 are invisible at the attribute-name level; a
  member relocated to a newer base class reads as that base's version. A
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
  empty-check/upload/clear instead of the tooltip-derived toast). What
  remains of this backlog is only the residual faked-event-value audit
  across `generated` ports.
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
