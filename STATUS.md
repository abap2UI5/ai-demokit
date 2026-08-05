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
| Ports | **293** sidecars in `meta/` (src/01: 177 · src/02: 67 · src/03: 19 · src/04: 19 · src/05: 11) |
| Status ladder | 86 `generated` · 146 `reviewed` · 61 `checked` (live-verified) |
| Deviations | 4 DROPPED_171 · 121 IMPROVISED · 492 NOTE · 121 POST_171 |
| Open LIVE_TESTs | **0 ports** carry at least one `LIVE_TEST` deviation — the automated close path is the e2e interaction harness (AGENTS §6 `e2e_smoke`) |
| Declared gate skips | 6 structural-diff · 3 render-smoke (each re-verified per run — a stale skip FAILS) |
| Out-of-scope ported samples | `z2ui5_cl_ai_app_121 (sap.m.sample.UploadSet — deprecated)` · `z2ui5_cl_ai_app_136 (sap.f.sample.SidePanelSingle — control @since 1.107)` · `z2ui5_cl_ai_app_141 (sap.ui.core.sample.InvisibleMessage — control @since 1.78)` · `z2ui5_cl_ai_app_165 (sap.f.sample.ProductSwitchNavigation — control @since 1.72)` · `z2ui5_cl_ai_app_203 (sap.m.sample.OverflowToolbarTokenizer — control @since 1.139)` — all decided KEEP permanently 2026-07-30 (per-app rationale in ui5/scope-exceptions.json, revertible); the source-backed scope gate stays hard for NEW undecided entries |

_Coverage per library (ported / in scope) is generated into the [README](README.md#coverage); one row per sample in [api.md](api.md)._

<!-- state:end -->

## Open findings (backlog)

- [ ] **IMPROVISED harvest — 5 of 6 requests implemented, 6 probes owed**
  (2026-08-05). The repo's purpose is to expose framework gaps, but the gaps
  were sitting in 136 `IMPROVISED` sidecar texts while `pr/` held exactly one
  open request. All 136 are now classified — repeatably, by
  `node scripts/probes/improvised-cluster.mjs` (`--family <key>` re-reads the
  evidence of one family, `--strict` fails on an unclassified entry, which is
  the ratchet for the next batch; deliberately not in `npm run gates`):

  | Verdict | # | Meaning |
  |---|---:|---|
  | GAP | 15 | a framework gap — 6 requests filed, **5 implemented upstream the same day** |
  | PROBE | 16 | a *suspected* gap whose premise is unverified — measure before filing |
  | REWORK | 16 | expressible today; the port under-delivers (review backlog) |
  | BOUNDARY | 16 | outside abap2UI5 by nature (client-only APIs, sample-local JS) |
  | POLICY | 73 | a decided corpus rule; the deviation is the rule working |

  The **POLICY half is the headline number**: 73 of 136 improvisations are the
  thin frontend, the single default model, mock flattening and BlockBase
  inlining doing what they were decided to do — behaviour-identical, and
  arguably `NOTE`s rather than `IMPROVISED`. Retyping them is a separate
  change (gate declarations match on deviation text) and is **not** done here.

  **Implemented upstream + consumed by the corpus** (details in the
  `pr/README.md` Implemented table; each port's sidecar deviation moved from
  `IMPROVISED` to `NOTE`): `_bind( omit_initial )` → app **049** is the
  sample's one bound template again instead of 14 unrolled items ·
  `CONTROL_METHODS css` → apps **138/267/269** resize their `sap.m.Page`
  container from the Slider again · `controlIdOrNull` → app **263** clears the
  association instead of naming the first section · `INVISIBLE_MESSAGE` → app
  **289** announces its regenerated strip · `FORMATTING` → app **196** renders
  its two custom currencies with 4 and 5 decimals · `setSticky` is whitelisted
  but see the correction below.

  **Two premises did not survive contact with the code, and both are recorded
  rather than quietly dropped:**
  - `table-set-sticky` claimed the bound-array path was unproven. **App 009
    binds `sticky` to an ABAP string table and is live-verified**, so it was
    proven all along. The whitelist entry still closes a footgun (an imperative
    `setSticky` silently received a string), but apps **022/235** — which
    deleted the sticky Label + three CheckBoxes from their view — are plain
    REWORK against app 009's pattern, not gap victims. Open, in the rework
    backlog below.
  - `model-empty-vs-default` is only **half** closed. `omit_initial` is
    all-or-nothing per bind, and a boolean that must send `false` cannot live
    with that (`abap_false` IS initial, so the filter drops it and the control
    falls back to its default `true`). App 049 carries its two boolean columns
    as strings + an expression binding — its only remaining binding-value
    deviation. The path-scoped half stays open in `pr/model-empty-vs-default`.

  **Both pins are on feature branches and MUST become main SHAs before this
  change is merged** (same rule the linter pin already carries): `A2UI5_PIN`
  points at the abap2UI5 branch commit, the three abaplint configs carry a
  `"branch"` on the abap2UI5 dependency (without it `_bind( omit_initial )` is
  a syntax error to ABAP_STANDARD/CLOUD/702), and `@abap2ui5/linter` is pinned
  at the commit that mirrors the two new global targets.

  **The PROBE families are the open work** (the biggest one is now measured and closed) — each is a plausible gap that a
  measurement could refute, and this repo's rule is that a request is filed on
  evidence, not on a rationale (cf. the withdrawn `urlhelper-abap-api`, whose
  premise was simply wrong — and now `table-set-sticky`, whose premise was half
  wrong). In descending value:
  - ~~`event-value-unreachable`~~ **measured and closed 2026-08-05** — it was
    the biggest family (7 deviations) and it was **not a gap at all**.
    `scripts/probes/event-arg-expression-probe.mjs` boots real OpenUI5, wires
    each candidate the way the framework emits it, fires the event and reports
    what the handler received: **all six candidates resolve** — indexed access
    into an array-valued getter, indexed access into an array PARAMETER,
    chained calls, arithmetic, `.join( ',' )` over an array, and a class-name
    ternary. Six of the seven ports are reworked (see the journal): the four
    calendar ports (139/151/177/220) now report the **clicked day** instead of
    the server date — including 177's re-click deselect, reproduced through a
    `getSelectedDates().length > 0` guard in the wire — 228 composes the
    sample's full submenu/MenuTextFieldItem branch in one expression, and 186's
    two resize toasts carry their pane-size arrays. App **109** keeps its
    name-only `selectedDatesChange` toast: that parameter is an array of
    `DateRange` CONTROLS the original iterates and formats **per entry**, and
    the expression grammar has no loop (the same boundary as app 060's
    breadcrumb). Its sidecar is corrected to say that instead of "control
    references are not transportable".
  - `imperative-aggregation` (4, apps 076/077/203/241): `addToken`/`addItem`/
    `removeItem` over statically declared children. App 085 already answers it
    (fold the static children into a bound aggregation); confirm that is always
    available, then these are REWORK, not gaps.
  - `event-veto` (2, apps 136/247): app 136's veto predates
    `s_ctrl-check_prevent_default` (merged 2026-07-30) and its guard switches
    are two-way bound, so it is probably REWORK; app 247 needs a **per-column**
    veto, which the render-time flag genuinely cannot express.
  - `template-clone-id` (1, app 012), `window-resize-event` (1, app 012),
    `shortcut-scope` (1, app 232): one port each, each already named as an
    open idea in its own sidecar. File only if a second sample needs them.

  **REWORK** adds three entries to the review backlog below that were not in
  it: app 166 (semantic action toasts + the missing `Messaging.addMessages`
  seed, expressible via `cc.MessageManager`), app 233 (a compound
  `binding_call` OR-filter and `open(searchValue)` both shipped, both unused)
  and apps 022/235 (the sticky controls, per the correction above).

  One gate consequence to re-check later: app 049 now declares a
  `render_smoke` skip. Its bound template binds the numeric StepInput
  properties over rows that deliberately do not set them, and UI5 logs
  "must be a number" for such a row — which the **original sample** produces
  just as well (its own template binds `min='{min}'` over rows without a min).
  The skip goes when the render gate learns to treat an absent numeric path as
  the control default.

- [x] **Metadata snapshot: both follow-ups done** (closed 2026-08-02).
  `ui5/properties.json` is now the output of the **linter's**
  `generate-metadata.mjs` run against this repo's own OpenUI5 checkout
  (`OPENUI5_DIR=… node node_modules/@abap2ui5/linter/scripts/generate-metadata.mjs
  --out ui5/properties.json`), so there is one metadata parser in the ecosystem
  and the snapshot still matches the `release` field of `ui5/universe.json`.
  Both pending
  items are settled:
  - **The dependency is pinned by SHA.** As of 2026-08-05 it points at
    **`c0e58d0`, a linter FEATURE-BRANCH commit** — the same SHA the VS Code
    extension pins, so the two consumers judge by one linter state. Over
    `5b17036` this adds no new rules: `9c2f2b1` brought fix/baseline plumbing
    for the extension (`attachNamespaceFixes` export, file-relative baseline
    keys, `./baseline` subpath), `c0e58d0` widens `view-never-displayed`'s
    display list by `popover_display`/`nest*_view_display` (a false positive
    the extension's snippet gate caught; can only remove findings, and the
    corpus had none). Gates re-ran green after each bump (293 ports,
    0 failing). The previous feature-branch pin `10920f7` is meanwhile part
    of linter main via its PR #9. The corpus
    now gates the eleven 2026-08-04 rules too (`popover-display-val`,
    `uncurated-formatter`, `hardcoded-binding-path`,
    `missing-view-display-on-navigated`, `separate-lifecycle-ifs`,
    `duplicate-for-iterator`, `binding-to-nonpublic`, `ui5-internal-access`,
    `commercial-ui5-host` gating; `unknown-event-parameter` as a budgeted
    advisory; `enum-value-too-new` in `VERSION_TYPES`, POST_171-excusable) —
    pattern-lint's whole generic half moved there across the two rounds.
    **This pin must become a main SHA before this change is merged**
    (linter AGENTS.md carries the same rule); corpus movement from the bumps:
    0 new violations (app 028's two `enum-value-too-new` findings land on its
    existing frameType POST_171 declarations — the rule's first run confirmed
    a hand-written audit), +1 advisory (app 268's forwarded `colorString`,
    inside the ratchet budget).
  - **The stale scope exception is gone.** The regenerated snapshot dropped the
    two false deprecations of the old parser (`sap.f.semantic.SemanticPage`,
    `sap.f.DynamicPageTitle` — a file-level `@deprecated` JSDoc block sitting
    on a local variable, attributed to the control) and gained the real one on
    `sap.ui.core.XMLComposite`. So app 166 is **in scope**, its
    `ui5/scope-exceptions.json` entry was removed (5 exceptions left), `sap.f`
    in-scope rose 32 → 34 and the two XMLComposite samples moved from *nonapp*
    to *deprecated*. The snapshot also carries the full member shape now (976
    controls, ~479 kB), which is what makes it the same artefact the linter
    generates for itself.

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
  stayed: 121 (UploadSet, deprecated — only upload-set coverage), 136
  (SidePanel @1.107), 141 (InvisibleMessage @1.78 — only a11y-announcement
  idiom), 165 (ProductSwitch @1.72, most borderline), 166 (sap.f
  SemanticPage, deprecated since 1.54 yet widely deployed) and 203
  (OverflowToolbarTokenizer, experimental @1.139). App 166 left the list
  again on 2026-08-02: the regenerated metadata snapshot dropped the false
  deprecation, so it is plainly in scope and 5 exceptions remain. The source-backed scope
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
  client-composed toast, popup/popover open, binding_call) and, after a green
  run, `node scripts/close-live-tests.mjs --close <nums>` converts the
  verified entries into `NOTE`s mechanically (text kept verbatim, so gate
  declarations keep matching). Since 2026-08-04 every LIVE_TEST port has an
  interaction (043/096/149 were the last three without one) and a red
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
- [ ] **App 203 out of scope via `@ui5-experimental-since`** —
  `sap.m.OverflowToolbarTokenizer` is experimental since 1.139 with no plain
  `@since`, which the scanners misread as base-version until 2026-07-27
  (both now read the experimental tag). Same pending drop-vs-keep decision
  as the other five `ui5/scope-exceptions.json` entries.
- [x] pattern-lint stays regex-based **by decision** (2026-07-18), and since
  2026-08-04 it is **corpus-policy only**: the ten generic rules moved into
  the linter (token-/string-aware there, several with `--fix`) and are gated
  via `view_gates`; what stays here is method order, formatting, sidecar
  conventions and the corpus-specific lessons (`dead-event-wire`,
  `unguarded-date-formatter`). The syntax-awareness question answered itself:
  a rule that needs it belongs in the linter anyway.
- [ ] **Port numbering carries one historic gap (231).** `validate-meta` now
  enforces gap-free numbering with `231` as the single pinned exception:
  closing it means renumbering the ~60 ports above (class names, sidecars,
  e2e INTERACTIONS keys, history references) — a maintainer decision, not a
  gate side effect. Any NEW gap fails the gate.
