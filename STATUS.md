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
| Ports | **365** sidecars in `meta/` (src/01: 181 · src/02: 130 · src/03: 19 · src/04: 19 · src/05: 16) |
| Status ladder | 158 `generated` · 146 `reviewed` · 61 `checked` (live-verified) |
| Deviations | 5 DROPPED_171 · 58 IMPROVISED · 62 LIVE_TEST · 827 NOTE · 148 POST_171 |
| Open LIVE_TESTs | **62 ports** carry at least one `LIVE_TEST` deviation — the automated close path is the e2e interaction harness (AGENTS §6 `e2e_smoke`) |
| Declared gate skips | 2 structural-diff · 5 render-smoke (each re-verified per run — a stale skip FAILS) |
| Out-of-scope ported samples | `z2ui5_cl_dmo_app_121 (sap.m.sample.UploadSet — deprecated)` · `z2ui5_cl_dmo_app_136 (sap.f.sample.SidePanelSingle — control @since 1.107)` · `z2ui5_cl_dmo_app_141 (sap.ui.core.sample.InvisibleMessage — control @since 1.78)` · `z2ui5_cl_dmo_app_165 (sap.f.sample.ProductSwitchNavigation — control @since 1.72)` · `z2ui5_cl_dmo_app_203 (sap.m.sample.OverflowToolbarTokenizer — control @since 1.139)` — all decided KEEP permanently 2026-07-30 (per-app rationale in ui5/scope-exceptions.json, revertible); the source-backed scope gate stays hard for NEW undecided entries |

_Coverage per library (ported / in scope) is generated into the [README](README.md#coverage); one row per sample in [api.md](api.md)._

<!-- state:end -->

## Open findings (backlog)

- [x] **IMPROVISED harvest — 10 requests implemented, every probe measured, REWORK empty**
  (2026-08-05). The repo's purpose is to expose framework gaps, but the gaps
  were sitting in 136 `IMPROVISED` sidecar texts while `pr/` held exactly one
  open request. All 136 are now classified — repeatably, by
  `node scripts/probes/improvised-cluster.mjs` (`--family <key>` re-reads the
  evidence of one family, `--strict` fails on an unclassified entry, which is
  the ratchet for the next batch; deliberately not in `npm run gates`):

  | Verdict | at the harvest | today | Meaning |
  |---|---:|---:|---|
  | GAP | 15 | **0** | a framework gap — 10 requests filed across three sweeps, **all implemented upstream the same day**, and the last two entries turned out not to be gaps (below) |
  | PROBE | 16 | 1 | a *suspected* gap whose premise is unverified — measure before filing |
  | REWORK | 16 | **0** | expressible today; the port under-delivers — **empty since 2026-08-06** (115 and 118, the two big rebuilds, are done) |
  | BOUNDARY | 16 | 18 | outside abap2UI5 by nature (client-only APIs, sample-local JS, the deterministic-corpus rule, a deliberately unoffered resize round-trip) |
  | POLICY | 73 | 8 | a decided corpus rule; the rest are `NOTE`s now (see below) |

  The **POLICY half was the headline number**: 73 of 136 improvisations were
  the thin frontend, the single default model, mock flattening and BlockBase
  inlining doing what they were decided to do — behaviour-identical, and
  therefore `NOTE`s rather than `IMPROVISED`. **Retyped 2026-08-05** by
  `--retype-policy --write`, which is safe because a gate declaration matches
  the deviation TEXT, never its type (`structural-diff.mjs`, `d.what`). The
  retype is not blind: an entry whose text still NAMES a loss is **held back**
  and listed — 8 of the 73 were (app 261's dropped Expanded view, 267/269's
  lost model indirection, 012's routing, the BlockBase wrappers that lose their
  ids). `IMPROVISED` now means what it says — a behaviour of the original that
  is lost or substituted — and the count reads **39** instead of 136.

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
  - `model-empty-vs-default` was filed as one request and needed **two**
    changes. `omit_initial` is all-or-nothing per bind, and a boolean that must
    send `false` cannot live with that (`abap_false` IS initial, so the filter
    drops it and the control falls back to its default `true`) — app 049's
    rebuild ran into it the moment it was written. The scoped form
    (`omit_initial_paths`) followed the same day, so 049 binds
    `enabled`/`editable` plainly again and has **no binding-value deviation
    left**; `pr/` now holds only the open-abap request.

  **All three pins are on feature branches and MUST become main SHAs before
  this change is merged**: `A2UI5_PIN` points at the abap2UI5 branch commit,
  the three abaplint configs carry a `"branch"` on the abap2UI5 dependency
  (without it `_bind( omit_initial )` and `s_ctrl-prevent_default_expr` are
  syntax errors to ABAP_STANDARD/CLOUD/702), and `@abap2ui5/linter` is pinned
  at the commit that mirrors the new global targets, the `eBP` stub and the
  `/media/range` model path.

  **Re-pinned 2026-08-10 for `_bind( json = abap_true )`** (the
  `card-manifest-object` request, implemented upstream). Same rule, same three
  places, and the 702 config needed a real fix rather than a re-point: it still
  carried the `"branch"` of the already-merged-and-deleted
  `ai-demokit-next-steps` branch **next to** its own `"branch": "702"` - two
  keys for one dependency, the first of them pointing at a branch that no
  longer exists. It is now a single key on the current feature branch. At merge
  time it goes back to `"702"`, and only after the framework's `auto_downport`
  has rebuilt that branch from the merged main - until then the 702 branch
  cannot know the new parameter.

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
  - ~~`imperative-aggregation`~~ **closed 2026-08-05** — none of the four was a
    gap. Two measurements did it: `removeToken`/`removeItem` accept an **ID
    string**, and UI5 runs a **`;`-separated pair** of event handlers. 203 folds
    the tokenizer the sample's add/delete work on into a bound aggregation and
    removes the other three tokenizers' static tokens by id; 076/077 remove the
    notification AND toast its title on one event; 241's Create button appends
    a row to a now-bound NavigationList.
  - ~~`event-veto`~~ **half closed 2026-08-05, the residual filed the same
    day**. App 136's rationale predated `s_ctrl-check_prevent_default` (merged
    2026-07-30): the flag is baked per wire at render time, which is enough
    there because the DIRECTION of the next toggle is known — an expanded panel
    can only collapse — so the flag is the switch that applies, and the
    round-trip re-bakes it. App **247** is the genuine residual: its veto is per
    **column** while the flag is per wire, and `columnResize` is declared on the
    Table, not the Column. Now `pr/conditional-prevent-default` — see the second
    sweep below.
  - ~~`window-resize-event`~~ **measured and filed 2026-08-05** as
    `pr/live-device-model` — see the second sweep below.
  - ~~`shortcut-scope`~~ **closed 2026-08-06** — filed and implemented the same
    day as `keyboard-shortcut-scope`. The registry was keyed by key combination
    alone, so a second registration of the same combo replaced the first and a
    popover-local command could not shadow the page-level one — which is
    exactly what app 232's sample demonstrates, with its own toggle for the
    difference. `cs_event-keyboard_shortcut` now takes a view slot as an
    optional third `t_arg` and dispatch picks the innermost OPEN scope, so 232
    registers `Ctrl+S` twice (unscoped → `SAVE`, popover-scoped → `PSAVE`) and
    its last residual deviation is closed.
  - ~~`template-clone-id`~~ **measured and closed 2026-08-06**, and the
    measurement changed the request. Three sidecars called an aggregation
    template's clone ids *nondeterministic*;
    `scripts/probes/aggregation-item-probe.mjs` shows they are not — UI5 mints
    `<templateId>-<parentId>-<index>` and they survive a model refresh **and** a
    reorder. The real gap is that the parent id carries the view prefix the
    framework assigns at runtime (`v1--tpl-v1--car-0`), which the backend never
    sees. So the fix is not "make the ids stable" but "resolve where the prefix
    is known": every control-resolving argument kind now accepts
    `<id>/<aggregation>/<index>` (`aggregation-item-address`, implemented
    upstream), and app 012 re-syncs its two Carousels again. **PROBE is down to
    one entry** — app 109's per-entry `DateRange` formatting, which the
    expression grammar has no loop for.

  **REWORK** adds three entries to the review backlog below that were not in
  it: app 166 (semantic action toasts + the missing `Messaging.addMessages`
  seed, expressible via `cc.MessageManager`), app 233 (a compound
  `binding_call` OR-filter and `open(searchValue)` both shipped, both unused)
  and apps 022/235 (the sticky controls, per the correction above).

  **Second sweep 2026-08-05 — two more requests, both measured first.** The
  question "are there any NEW request ideas left in the corpus" was answered by
  probing the two leftover families that had a mechanism behind them rather than
  a rationale. Both premises held, so both are filed:
  - **`live-device-model`** (**implemented upstream the same day**) — the shared `device>` model is
    `new JSONModel(Device)`, wrapping the LIVE `sap.ui.Device` object. Device
    mutates itself on resize/rotation, but a JSONModel only notifies its
    bindings when told, so it never is: `scripts/probes/device-model-live-probe.mjs`
    drives a real viewport from 1400px to 420px and reads the rendered binding
    back — `{device>/resize/width}` stays **`1400`**, and one `refresh(true)` on
    Device's own handlers makes it **`420`**. Eleven ports bind this model, so
    the change is unusually cheap for its reach. Two honest findings came with
    it: `{device>/system/phone}` is correctly STATIC (UA/screen based — a
    narrowing desktop window is not a phone), so the eleven ports' branches are
    right as they are and the request must not claim them; and the media RANGE,
    which is what a live breakpoint branch actually wants, has **no bindable
    path at all** (`Device.media` is methods only) — so the request adds
    `/media/range` alongside the refresh.
  - **`conditional-prevent-default`** (**implemented upstream the same day**) — the veto flag is a boolean baked per
    WIRE, so it cannot block one row/column and let the rest through the same
    event (app 247). The proposal reuses the mechanism that is already there: a
    `$`-prefixed value is emitted raw and resolved by
    `BindingParser.parseExpression`, so the veto can be an EXPRESSION.
    `scripts/probes/conditional-veto-probe.mjs` measures the proposed `eBP`
    signature against real OpenUI5 — **one** `columnResize` wire, **one**
    predicate, two columns: the blocked one is vetoed
    (`fireColumnResize` → `false`), the free one goes through, and both still
    round-trip with an identical payload.

  Both landed as `s_ctrl-prevent_default_expr` and a refreshing device model
  with a new `{device>/media/range}` path, and the corpus consumed them the
  same day: app **247** vetoes its delivery-date column again (and reports the
  column LABEL, which the reduction had also dropped), app **168**'s
  `attachLayoutChange` class swap is a live expression binding. App **012**
  is honestly NOT closed — its page count feeds a server-side slice, so a
  client-side count would desync the props it indexes; its sidecar says so.
  A third correction came out of the same round: the `ternary-with-newline`
  candidate had recorded that **a double quote cannot appear in an event-arg
  expression**. It can — that was measured on RAW XML, while
  `z2ui5_cl_util_xml` escapes every attribute value, so the parser never sees
  a bare quote. The `double-quote-escaped` candidate proves it (`"[" + n + "]"`
  → `[7]`), and CAPABILITIES no longer claims the boundary.

  **GAP reached zero on 2026-08-06**, and neither of the last two entries was
  closed by a framework change — both were closed by measuring.
  - App **250**'s `handleLiveChange` was written off as *"direct DOM
    manipulation outside any bindable property, not expressible in the thin
    frontend"*. The original paints the button's ICON by writing `rgba(…)` onto
    `getDomRef().firstChild.firstChild`, and the `css` action deliberately
    writes only on a control's OWN node. But a probe against real OpenUI5 shows
    the icon span **inherits** `color` from the button root — same computed
    colour, no internal DOM touched. The wire is roundtrip-free: the `rgba()`
    string is composed on the client from the four `liveChange` parameters. The
    verdict had been reached too quickly.
  - App **012**'s resize recalculation is reclassified as a **BOUNDARY**.
    Closing it would need a resize → BACKEND event wire, and that is
    deliberately not offered: it is chatty by construction, and every
    display-only case it would serve is already covered by the live device
    model without a round-trip. The one case it genuinely serves is 012's, where
    the count feeds a server-side slice — one port is not enough to file on, so
    the idea is recorded in the sidecar for the second sample that needs it.

  **App 118 closed the REWORK column on 2026-08-06**, the second of the two
  big rebuilds. It had been a single `widgets:Card` with an INVENTED manifest;
  it is now the whole `sap.ui.integration.sample.CardsLayout` page — the
  `f:ShellBar` with its menu and profile, the four-tab `IconTabBar`, and both
  `f:GridContainer`s with all **eight** integration Cards, their
  `GridContainerItemLayoutData` and the sample's `layout`/`layoutS` settings.
  The eight manifests come from `model/cardManifests.json` verbatim, each bound
  as a model field — the JSON must never enter the view XML, where a leading
  `{` reads as a binding. Two things stay declared: the `component` card's
  manifest is a URL to a UI5 Component (abap2UI5 has no place to ship one, so
  whether it loads is the host's CORS decision), and the structural-diff skip
  is **re-worded** — the archived folder carries `componentCard/View.view.xml`,
  which the diff unions into the original side, exactly app 120's shape.

  **A classifier defect fell out of the next sweep (2026-08-06), and it cut
  the count by six.** Two families were matching text that says the port
  AVOIDED their problem: `empty-vs-default` caught "initialized to 'None' so
  no empty string reaches the enum", "the expression can never emit an empty
  enum value", "a harmless string property, no enum/default override" — four
  ports filed as gap victims for *working around the gap correctly* — and
  `array-property` still carried apps 022/235's claim that "neither an array
  property binding nor a setSticky whitelist entry is a proven path", which
  had been false when it was written (app 009 binds it and is live-verified)
  and which those ports' own views had already disproved: both have the
  sticky Label and the three CheckBoxes back. Both patterns are tightened,
  the six sidecars corrected rather than deleted, and a new
  `random-determinism` family holds app 289 — a randomised original becoming a
  deterministic rotation IS a substitution, so it stays `IMPROVISED`, but as a
  BOUNDARY: the determinism is a corpus requirement no framework change would
  ever close. **31 IMPROVISED, and only 2 GAP entries left** (250's internal
  DOM reach, 012's server-side page slice).

  **The two new wires are e2e-verified, and the e2e found a design error in
  one of them** (2026-08-06). App 232's interaction failed on the first run:
  the shortcut scope had been built as a VIEW SLOT only, and the sample's
  Popover is a CONTROL declared in the view's dependents and opened with
  `openBy` — it never enters the framework's popover slot, so the scoped
  registration could never fire and Ctrl+S kept hitting the page command. The
  upstream change now takes a control id as a scope too (a control scope beats
  a slot scope, being the more specific statement), and both interactions pass
  against a real browser and a transpiled backend: 232 goes silent on Ctrl+S
  with the popover's own Save off and the popover open, and 247 vetoes exactly
  the delivery-date column through the same wire that lets every other column
  resize. This is the second time an e2e interaction caught something no unit
  test could — the first was the sap.tnt hollow pass on 2026-07-30.

  **The full sweep is green: 294/294, `--strict` exit 0.** It first reported
  two failures, and both turned out to be the INTERACTIONS, not the ports —
  which is worth writing down, because a wrong interaction is a false alarm
  that costs exactly as much as a real one.
  - App **241** clicked `getByText('Building')`. The sample renders its
    NavigationList **twice** (an expanded and a collapsed copy), so "Building"
    exists twice as an aggregation-template clone and the click landed on
    whichever copy the DOM offered first — no round-trip, no toast. It now
    fires `press` on the item that actually carries the wire.
  - App **049** drove its StepInput with ArrowUp+Enter, which no longer
    produces a `change` on this UI5 version. It keeps the keyboard route and
    falls back to firing `change` through the control API, reading the value
    back off the control so the asserted text is still the control's own.

  Before that was known, the two were checked against this session's framework
  changes by elimination rather than assumed innocent: with the new `eBP`
  signature patched back to its old form in the transpiled backend they still
  failed, and with the device model's refresh handlers removed on top of that
  they still failed. A premise was refuted on the way — the suspicion that
  UI5's `EventHandlerResolver` would choke on the bare `true` the flag form now
  emits in `eBP`'s condition slot. It resolves fine, and a probe candidate now
  proves it.

  A build trap cost about an hour and is written down in E2E.md so it does not
  again: `npm run e2e:build` and the framework's own `npm run verify` downport
  into the SAME two directories, and running them concurrently left 86 files
  under abap2UI5's `src/` rewritten to their v702 form, with nothing in either
  command's output saying so.

  **Two new linter rules, 2026-08-06**, distilled from traps this session hit
  rather than from the corpus (neither fires on any of the 295 files — both are
  things the corpus has avoided by hand so far, which is exactly what a rule
  should make impossible to hit again). `trailing-empty-event-arg`: `get_t_arg`
  buffers an empty argument and flushes it only when a later non-empty one
  follows, so an empty entry BETWEEN filled ones keeps its slot and a TRAILING
  one disappears — the handler's `get_event_arg( n )` reads initial with no
  error anywhere. That is what forced the second half of the
  `control-method-null-arg` fix upstream, and the framework's padding covers a
  nullable declared kind on a control method only, never a backend `_event`.
  `json-literal-in-attribute`: UI5 parses a leading `{` as a binding, so a raw
  JSON object literal in a view attribute is read as a binding path and the
  attribute ends up empty — the classic way to lose an integration Card's
  manifest, which is why app 118 keeps its eight in the model.

  **A linter defect fell out of app 115's rebuild**, and it was silent:
  `aggregationPath` matched the first `path:` with a GREEDY `[^}]*`, which
  runs past a nested object — there is no `}` before `sorter: {` — and
  captured the INNER path. So `{path:'/CATEGORIES', sorter:{path:'NAME'}}`,
  the ordinary sorted aggregation, resolved against `/NAME`, the row shape
  came out null, and **every relative field below such an aggregation stopped
  being checked**. One lazy quantifier fixes it, and the fixed rule reports
  three findings it had been blind to — all three the UI5 samples' own quirks
  that the ports carry verbatim (`type="{Text}"` in 012/094,
  `key="{ProductId}"` over `/Categories` in 115), each now carrying a
  `abap2ui5lint-disable-next-line` with that rationale.

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
  handler mirrors its filter-by-removed-key. IMPROVISED **39 → 38**; the
  REWORK family is down to app **118** alone.
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
