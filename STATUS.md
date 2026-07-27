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
| Ports | **251** sidecars in `meta/` (src/01: 149 · src/02: 55 · src/03: 12 · src/04: 19 · src/05: 11 · src/06: 5) |
| Status ladder | 52 `generated` · 146 `reviewed` · 53 `checked` (live-verified) |
| Deviations | 4 DROPPED_171 · 136 IMPROVISED · 76 LIVE_TEST · 265 NOTE · 95 POST_171 |
| Open LIVE_TESTs | **72 ports** carry at least one `LIVE_TEST` deviation — the automated close path is the e2e interaction harness (AGENTS §6 `e2e_smoke`) |
| Declared gate skips | 7 structural-diff · 6 render-smoke (each re-verified per run — a stale skip FAILS) |
| Out-of-scope ported samples | `z2ui5_cl_ai_app_121 (sap.m.sample.UploadSet — deprecated)` · `z2ui5_cl_ai_app_136 (sap.f.sample.SidePanelSingle — control @since 1.107)` · `z2ui5_cl_ai_app_141 (sap.ui.core.sample.InvisibleMessage — control @since 1.78)` · `z2ui5_cl_ai_app_165 (sap.f.sample.ProductSwitchNavigation — control @since 1.72)` · `z2ui5_cl_ai_app_166 (sap.f.sample.SemanticPage — deprecated)` · `z2ui5_cl_ai_app_203 (sap.m.sample.OverflowToolbarTokenizer — control @since 1.139)` — standing debt pending a maintainer decision (drop vs documented exception), surfaced by the source-backed scope gate (pr/scope-since-from-source) |

_Coverage per library (ported / in scope) is generated into the [README](README.md#coverage); one row per sample in [api.md](api.md)._

<!-- state:end -->

## Open findings (backlog)

- [ ] **sap.ui.comp ports carry OpenUI5 reference links.** The five smart
  control ports (`src/06/b01`, apps 248-252) are listed in the in-system
  overview app with the orange **SAPUI5** badge, but the row's four reference
  links are built unconditionally against `sdk.openui5.org` /
  `github.com/SAP/openui5`, where `sap.ui.comp` does not exist — so API,
  source and live-sample links do not resolve for those rows. The commercial
  host is not an option (`pattern-lint` `commercial-ui5-host`); the fix is to
  suppress or re-target the links for `ui5_only` rows in
  `scripts/generate-overview.mjs`. Their ABAP-class link is correct.
- [ ] **Variant management crashes on save (app 251) — pinned to `control: null`.**
  Live debugger (2026-07-27, pause on caught exceptions) stops at
  `sap/ui/fl/write/api/SmartVariantManagementWriteAPI-dbg.js:28`,
  `Utils.getAppComponentForControl(mPropertyBag.control).getId()`, with
  **`mPropertyBag = {control: null, changeSpecificData: {…}}`** — call stack
  `Button press → SmartVariantManagementBase:156 → SmartVariantManagement:1451/1021/1035
  → …:459 → SmartVariantManagementWriteAPI.addVariant:89 → :28`. So `sap.ui.comp` hands
  the flex API a **null** control when saving a page variant; nothing on the resolution
  side is broken. Refuted along the way, each live: missing app component
  (`getAppComponentForControl(<SVM>)` returns `container-z2ui5`), `flexEnabled` (read only
  by `sap.ui.rta`, never by `sap.ui.fl` — a `pr/` on that premise was withdrawn),
  association-id prefixing (`XMLTemplateProcessor` `_iKind === 3` → `createId`), and
  registration (`getPersonalizableControls()` → 2, both resolvable, types `table`/`filterBar`,
  keys `SmartTablePKey`/`SmartFilterPKey`; `loadVariants` resolves cleanly). Open: which
  lookup inside `SmartVariantManagement` yields null — the frame above the API
  (`…:459`) has to be read in the debugger. Port-side changes meanwhile: the
  `pageVariantPersistencyKey` custom data plus the docs' wiring (no `smartVariant`
  associations) is now deployed and **does not fix it** — `control` is still `null`, same
  frame, same stack. Both wirings therefore behave identically, which points at a missing
  `initialise()` handshake rather than at the declarative configuration: `sap.ui.comp`'s
  own documentation shows the app calling `addPersonalizableControl()` **and**
  `initialise(fnCallback, oControl)`, and the curated abap2UI5 sample
  `z2ui5_cl_demo_app_111` does exactly that from custom JS. Tested live: calling
  `oSVM.initialise(fn, <filter bar>)` by hand answers **"initialise on an unknown
  control."** — although `getPersonalizableControls()` lists exactly that filter bar
  (type `filterBar`, id resolvable, key `SmartFilterPKey`). So the control is in the
  registration list but not in whatever list `initialise` checks; the same failing lookup
  is what yields `control: null` on save. Open: read the `sap.ui.comp` source in the
  running app (`-dbg` files are served) — search the loaded sources for "unknown control"
  and read the frame `SmartVariantMan…del-dbg.js:459` that fills `control:`.
- [ ] **sap.ui.comp ports are all unverified (5 open LIVE_TESTs).** They need
  a SAPUI5 runtime plus a Gateway service exposing the tutorial's `Products`
  entity set, so neither `render_smoke` (declared skips) nor the e2e harness
  can exercise them — the first real check has to be a live one.
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
- [ ] **Review-sweep rework backlog (49 ports).** The 2026-07-27 sweep
  promoted 152 of 201 `generated` ports to `reviewed`; the remaining 49 stay
  `generated` with **corrected, honest sidecars** and need real view/logic
  rework. Recurring classes: dead `_event` wires with no `on_event`
  dispatcher (pattern-lint `dead-event-wire`, 6 BASELINE entries), toast
  substitutions around capabilities CAPABILITIES marks expressible
  (MessageBox `onclose`, `popover_display`, URLHELPER, timers, generalized
  `control_by_id` methods — the app-042 class), faked event values where the
  `$event.*` transport exists, dropped sample CSS (122/124, plus §4 archive
  gaps), and one source-verified crash risk (app 220: empty-string endDate
  through `DateCreateObject`). Find them: sidecar status `generated` minus
  the 5 scope-exception ports.
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
