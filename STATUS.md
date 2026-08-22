# STATUS.md — current state & open findings

_Two parts: a **generated** point-in-time state (from `meta/` — never edit it
by hand, `scripts/generate-status.mjs` regenerates it via the pre-commit hook
and the `meta_valid` CI job fails a PR with a stale block) and the
**hand-maintained** open-findings backlog below it. The chronological journal
(batches, probes, audits — one section per event) moved to
[docs/history.md](docs/history.md); **new journal entries go there**, under the
same-change discipline of AGENTS.md §10. For the process itself see
TRAINING.md; for what abap2UI5 can express see CAPABILITIES.md._

## Current state (generated)

<!-- state:start -->

| Aspect | State |
|---|---|
| Ports | **504** sidecars in `meta/` (src/01 OpenUI5 <= 1.71: 353 · src/02 OpenUI5 > 1.71: 151) |
| Per library | sap.f: 21 · sap.m: 305 · sap.tnt: 17 · sap.ui: 130 · sap.uxap: 31 |
| Status ladder | 88 `generated` · 355 `reviewed` · 61 `checked` (live-verified) |
| Deviations | 5 DROPPED_171 · 78 IMPROVISED · 22 LIVE_TEST · 1168 NOTE · 219 POST_171 |
| Open LIVE_TESTs | **22 ports** carry at least one `LIVE_TEST` deviation — the automated close path is the e2e interaction harness (AGENTS §6 `e2e_smoke`) |
| Declared gate skips | 2 structural-diff · 4 render-smoke (each re-verified per run — a stale skip FAILS) |
| Out-of-scope ported samples | `z2ui5_cl_smpc_app_121 (sap.m.sample.UploadSet — deprecated)` · `z2ui5_cl_smpc_app_136 (sap.f.sample.SidePanelSingle — control @since 1.107)` · `z2ui5_cl_smpc_app_141 (sap.ui.core.sample.InvisibleMessage — control @since 1.78)` · `z2ui5_cl_smpc_app_165 (sap.f.sample.ProductSwitchNavigation — control @since 1.72)` · `z2ui5_cl_smpc_app_203 (sap.m.sample.OverflowToolbarTokenizer — control @since 1.139)` — all decided KEEP permanently 2026-07-30 (per-app rationale in ui5/scope-exceptions.json, revertible); the source-backed scope gate stays hard for NEW undecided entries |

_Coverage per library (ported / in scope) is generated into the [README](README.md#coverage); one row per sample in [api.md](api.md)._

<!-- state:end -->

## Open findings (backlog)

- [ ] **The per-port review sweep — every port that was `generated` has now
  been read.** Each port is read against its ARCHIVED ORIGINAL
  (view, controller, mock, stylesheet) and, where a claim rests on UI5's own
  behaviour, against the OpenUI5 sources in `node_modules/@openui5/`. That last
  step is what separates this from a gate: every finding below is invisible to
  `structural_diff`, `data_fidelity`, `pattern_lint` and `view_gates`, all of
  which were green on all of them.
  **Waves 1–11 (2026-08-21) read all 91 ports that were `generated` when the
  sweep began, plus 60 more that entered it along the way.** Promotions go to
  `reviewed` only for the ports that came back clean; a port whose defect was
  fixed stays `generated` until it has been measured against a rebuilt backend,
  which is what most of the remaining `generated` count now is — ports waiting
  for a nightly, not ports nobody has looked at.
  Two of the findings were not in the ports at all but in the GATES, and they
  are the most reusable thing the sweep produced. Both were escape hatches that
  matched by SUBSTRING:
  - `view-gates`' `declares( )` let ANY deviation excuse a version finding, so
    a NOTE saying "the liveChange round-trip keeps the Text …" satisfied it for
    `ColorPickerPopover.liveChange` @1.85. Only `POST_171` / `DROPPED_171` may
    now — that is what those types MEAN, and what moves a class to `src/02`.
    Tightening it found four ports filed in the wrong package.
  - `data-fidelity` was handed the bare FIELD NAME beside the values, so a
    deviation containing `text`, `name`, `title` or `icon` — ordinary English —
    cleared every mismatch in that field, across every row. App 269 had
    truncated a 1273-character mock string to 212 and the gate said 0 errors.
    A value still matches loosely; a field name counts only in a form that
    identifies it as a field.
  The same shape twice suggests the rule: **an escape hatch keyed on free prose
  should require the declaration to be unambiguous**, the way the icon branch
  of `declares( )` already required the full `sap-icon://` URI.
  The classes that repeat, worth checking first in any new port:
  - **a bound property that is not what the original's METHOD writes.** Apps
    344/138 bound `showSideContent` to reproduce `DynamicSideContent.toggle( )`,
    which never writes it — the toggle could not work on the one breakpoint
    where its button is enabled. When a port binds a property where the
    original calls a method, read that method.
  - **an event parameter that is declared and never fired.**
    `QuickSort.change` declares `key`/`sortOrder` and passes only `item`
    (`fireChange({item: oItem})`), so app 298's two args arrived empty and every
    sort fell through to its default. The linter's event-parameter check
    *prefers* the declared names here, so satisfying it breaks the port; that
    finding is a deliberate `unknown-event-parameter` budget entry now.
  - **an event parameter read with the wrong semantics.** `rowIndices` is the
    CHANGED set, not the selected set (app 361).
  - **an enum value the enum does not define.** App 356 offered `All` for
    `sap.ui.table.SelectionMode`, bound onto an enum-typed property:
    `validateProperty` throws. Where the original builds a list with
    `Object.keys(SomeEnum)`, compare members AND order.
  - **a flag baked per WIRE where the original decides per FIRING.** App 354's
    `check_prevent_default` vetoed all five columns for a handler that vetoes
    one, leaving four `filterProperty` columns and `enableCellFilter` inert.
    `prevent_default_expr` is the conditional form.
  - **an absent JSON key turned into an explicit `false`** — now
    `scripts/probes/absent-boolean-probe.mjs`.
  - **prose that outlived the code beside it.** The single most common finding:
    a correction applied to the deviation but not to the `audit.note` or the
    inline comment, a deviation declaring a difference the sample does not have
    (ten sidecars carried a phantom `{EMail}` entry), or a `POST_171` naming an
    `@since` the sources do not carry (app 356's, which alone held the class in
    `src/02`). Nothing validates these texts, and a deviation is also a GATE
    ESCAPE — a phantom one widens it for free.
  - **an interaction module that cannot fail, or that never reaches the branch
    its deviation closes.** Three modules were DOM dumps; four LIVE_TESTs were
    closed on modules that never executed the wire named. `validate-meta`
    rejects the first class now; the second needs a human reading the module
    against the deviation.
  Two more classes earned their own probes rather than a note, because each
  recurred: `absent-boolean-probe.mjs` (an `abap_bool` left unset serialises as
  a real `false` and overrides a UI5 default of `true` — app 291 lost both
  close buttons and, with them, its only backend wire) and
  `stale-impossibility-probe.mjs` (a deviation still declaring something the
  framework has since learned to do — five of those in one day, each TRUE when
  it was written).
  What is NOT done: the ~230 ports that were already `reviewed` or `checked`
  before this sweep have not been re-read against it, and the sweep's later
  waves found real defects in ports of every age — so age is not evidence.
  The highest-value re-read would be the `checked` ports, since a live check
  proves a port RUNS, not that it does what its original does.
  **That re-read has started and it was worth starting:** ports 001–034 have
  been read against their originals, and the first behavioural defect turned up
  in the very first batch — app 003 listed the six `BreadcrumbsSeparatorStyle`
  members with positions 3/4 and 5/6 swapped against
  `ui5/properties.json`, which no gate compares. The rest of that
  batch was documentation drift, the sweep's most common finding: a deviation
  naming a formatter the port stopped using (017), a garbled sentence (016), an
  undeclared handler-to-binding swap (022), inline comments citing apps that do
  not exist (010 cited app 534) or the wrong one (009 cited 401 for 022), and
  a `checked.note` claiming no interaction paths were open on a port that ships
  a press → Dialog → close wire (010). Ports 035–061 are still unread against
  their originals.

- [x] **CAPABILITIES.md's stale class citations — DONE.** Both halves of this
  are closed, and neither closed the way the entry predicted. The shared
  script's `PROSE` list now carries `CAPABILITIES.md` (and `E2E.md`) outright,
  so no one has to weigh "widening it in all three repositories at once"
  against leaving the file unchecked — the gate simply checks it. And the file
  no longer names a single `z2ui5_cl_demo_app_<n>`: it cites five classes, three
  `z2ui5_cl_smp_app_<n>` in samples and two `z2ui5_cl_smps_app_<n>` in
  samples-stack, all current. `node scripts/check-prose-names.mjs` resolves
  **36 class names across 8 prose files**, every one of them existing —
  including the foreign ones, which it looks up in the owning repository's
  generated `SAMPLES.md` rather than exempting. Re-verified from the source
  2026-08-21. The four names the entry expected to need a maintainer decision
  (038, 172, 369, 458) are simply not cited any more, so there is nothing left
  to decide.
- [ ] **Two open-abap defects are patched in the build and open upstream.**
  Both are written up in full — analysis, emitted JS, proposed change — in
  `abap2UI5/abap2UI5`'s
  [`backlog/OPEN-ABAP.md`](https://github.com/abap2UI5/abap2UI5/blob/main/backlog/OPEN-ABAP.md),
  which is where the ecosystem's upstream backlog lives now; what stays here is
  what THIS repository has to undo when they land.
  - `open-abap-xml-escaping` — `CALL TRANSFORMATION id … RESULT XML` writes
    character data unescaped, so any app whose model carries a `<` persists a
    draft its own `CL_IXML` cannot parse back (user report 2026-07-31 on the
    since-removed Pages demo; the journal has the analysis). The e2e build
    transpiles against a locally patched clone
    (`web/ci/patch_open_abap_xml.mjs` — kept there because
    abap2UI5/mcp-server executes that exact path). **On merge:** drop the
    patch script, its call sites in `scripts/e2e-build.mjs`, the
    `check-mcp-contract` entry and the `folder` lib entries.
  - `transpiler-returning-is-supplied` — `IF result IS SUPPLIED` is correct
    ABAP and always false transpiled, so every handler wired into a view
    attribute arrives empty (26 ports red in the nightly of 2026-08-13, and
    live on the since-removed Pages demo). The e2e build rewrites the 430
    consumed call sites back to `_event_client( )` **in the build copy**
    (`web/ci/patch_follow_up_action.mjs`); the committed corpus keeps
    `follow_up_action( )`, which is right on a real server. **On merge:** drop
    the patch script and its two call sites.
- [x] **Linter bump done — the corpus is green on `@abap2ui5/linter` 0.1.0,
  taken from npm instead of a git SHA.** Everything below was decided before
  the bump landed: the six icons carry `POST_171` deviations (042, 109, 128,
  376) or were changed where the file is ours, the `ToolbarSeparator` is out of
  `scripts/generate-overview.mjs`, and `node scripts/view-gates.mjs --strict`
  reports **416 ports, 0 failing, 4 skipped, 45 advisory** with the new rules
  live. Kept for the reasoning, which is the durable part. The
  linter grew icon rules (`unknown-icon` / `icon-too-new` / `icon-removed`,
  from a per-icon `since` scanned across every OpenUI5 minor since 1.71), a
  layout rule (`toolbar-control-in-bar`) and a severity split
  (`aggregation-too-new`, the aggregation-TAG half of `member-too-new`, now an
  error because UI5 resolves an unknown tag as a control class and the 404
  takes the whole view down). This repo is already prepared for it —
  `VERSION_TYPES` knows the two new version types and `declares()` now reads a
  finding's `value`, so an icon can be named in a deviation at all. Measured
  against the working linter over all 416 ports, the bump surfaces:
  **24 `aggregation-too-new`** — every one already carrying a `POST_171`
  deviation, so they pass untouched (without the `VERSION_TYPES` entry they
  would all have failed at once); **1 `toolbar-control-in-bar`**, in
  `z2ui5_cl_smpc_app_000`'s header — a real defect, not a port fidelity
  question: the separator in the `sap.m.Bar` deletes every icon after it on
  1.71–1.75, and the file is GENERATED, so the fix belongs in
  `scripts/generate-overview.mjs`; and **6 `icon-too-new`** — `information`
  (@1.80) in apps 042, 376 and the overview, `select-appointments` in 109,
  `people-connected` in 128, `da` in 134. Those six need the deviation-or-fix
  decision per port: a 1:1 port of a sample that uses a post-1.71 glyph is a
  legitimate `POST_171` deviation (changing the literal would be a
  data-fidelity question), while the overview is ours and should just use
  `message-information`. Such a deviation has to spell the **full
  `sap-icon://<name>`** — `declares()` matches by substring, and icon names go
  down to two letters, so the bare name would let a NOTE about "data" excuse a
  finding about `da` (which is exactly what app 134 did before the match was
  tightened). **0 `source-line-too-long`.**
- [ ] **LIVE_TEST debt → e2e interactions.** The open `LIVE_TEST` count (see
  the generated table) is the corpus' unverified-behaviour backlog. The
  systematic close path is the e2e harness: add a per-port interaction module
  under `meta/interactions/<class>.mjs` (one generic assertion per LIVE_TEST
  class — client-composed toast, popup/popover open, binding_call; the
  directory's README carries the coverage catalogue) and, after a green
  run, `node scripts/close-live-tests.mjs --close <nums>` converts the
  verified entries into `NOTE`s mechanically (text kept verbatim, so gate
  declarations keep matching). A red nightly opens/updates an issue instead of
  hiding in the Actions tab. Every green interaction is human live-check time
  saved.
  **2026-08-21: the interaction gap is closed and the backlog is down from 25
  ports to 7.** The 19 ports that shipped a LIVE_TEST without an interaction
  (apps 356–366, 401–417) have one now, all 19 run green under
  `--strict`, and 18 were converted to `NOTE`s. `validate-meta` reports no gap
  count any more.
  **App 359 is the one that stayed open, deliberately.** Its module closes the
  bound-`rowActionCount` half; the two-placeholder toast on a row-action press
  cannot be driven here, because the row actions never render in the smoke at
  all — calling `setRowActionCount(2)` + `invalidate()` DIRECTLY on the table
  through its own API, bypassing the port, still leaves every row without a
  `_rowAction`. That rules the port out as the cause and leaves the leg to the
  human live run.
  **The open set is now 301/348/350/353/354/359/362**, and the composition
  changed in both directions on 2026-08-21. 351 closed once its module was
  rewritten from a DOM dump into a real test. 362 was REOPENED: it had been
  closed as live-verified, but its module only presses the three toolbar
  buttons and never opens a column header menu, so the sort event and its
  prevented default were never fired — the toolbar legs it does drive are
  genuinely covered, and the deviation now says exactly that.
  Three of the seven are known not to be closable by this harness as it stands,
  and each says so in its own module rather than quietly asserting less:
  354's is the COLUMN filter's prevented default, which needs a `sap.ui.table`
  column header menu (its module reaches `filter_apply( )` instead); 359's is
  the row-action press, and the row actions never render here at all (proven by
  driving `setRowActionCount(2)` + `invalidate()` on the table directly);
  353's four drag & drop wires ride on HTML5 dnd, which Playwright's `dragTo`
  cannot produce for `sap.ui.table`'s pointer extension — dispatching the
  DataTransfer events by hand would test the harness, not the port.
  **A closure is only as good as the branch the module actually reaches.** Four
  were found resting on modules that never executed the wire their deviation
  named (341's refresh loop runs on a LATER press; 344's module asserted a Text
  was visible, which is true whether the toggle works or not; 362 and 356/361's
  modules sidestep the exact case their defect lives in). Before running
  `close-live-tests.mjs`, read the module against the deviation sentence by
  sentence.
- [x] **Post-1.71 declaration debt in the gate's blind spots — DONE, and it is
  a probe now.** Surfaced by the review sweep (2026-08-21), and NOT a
  batch-freshness problem: the same gap appeared in old ports and was correctly
  declared in others, so it was inconsistent policy application across the
  corpus. Every case sits where AGENTS §5 already says the property gate is
  blind, which is why a green `view_gates` said nothing: **a member relocated
  to a newer base class** (`NavigationListItem.expanded` reads @1.121 off
  `sap.tnt.NavigationListItemBase`), **an aggregation-level member**
  (`sap.m.IconTabFilter.items` @1.77), **an enum VALUE**
  (`CalendarDayType.NonWorking` @1.121), and a plain miss
  (`sap.tnt.SideNavigation.width` @1.120).
  The sweep read 30 ports; rather than promote that sample to a verdict, the
  four shapes became **`scripts/probes/post171-blindspot-probe.mjs`**, which
  scans all 416. It found **10 undeclared uses across 7 ports** — including
  241, 301 and 303, which the sweep never looked at. Every `@since` was
  re-verified against the OpenUI5 sources before declaring, all seven ports
  already sat in `src/02` with a `POST_171` (so no folder moved), and the probe
  now reports 0. It is a probe, not a gate: it reports, a human decides. **Add
  a row whenever a new blind-spot member turns up** — that table is what stops
  this from having to be rediscovered by the next review.
- [ ] **Property-gate residual limits** (documented in AGENTS §5): enum
  *values* newer than 1.71 are invisible at the attribute-name level; a
  member relocated to a newer base class reads as that base's version; and a
  **binding-info parameter** (`boundFilters` @1.146, apps 264/265) is not a
  control member at all, so it appears in no gate — declare it by policy. A
  green property-check still does not prove a port ≤ 1.71-clean — the
  control-level `scope-of` check plus by-policy POST_171 declarations remain
  required.
- [x] **Review-sweep rework backlog — DONE.** The last member, app 118, was
  closed by its own 2026-08-06 rebuild and the 2026-08-10 manifest fix without
  this entry being ticked — the same way apps 298 and 089 were, so it was
  re-verified from the source on 2026-08-21 rather than trusted: the sidecar
  carries no `IMPROVISED` any more, all five `action` wires transport
  `${$parameters>/parameters}.url` instead of a constant, and
  `node scripts/probes/faked-event-value-audit.mjs` reports **0 candidates**
  over the whole corpus (it found the two real cases, 133 and 100, when it was
  written). Re-run that probe after any batch that adds toast wires. What is
  NOT closed with it is the broader ladder: 209 sidecars still read
  `generated`, but those are ports awaiting their FIRST review, not ports with
  a known headline gap — a different piece of work from this one. The history
  below is kept because it is the record of what "rework" meant.
  The 2026-07-27 sweep
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
- [x] **App 298's dimensions — DONE.** The row type declares `Width`/`Depth`/
  `Height` as `TYPE string`, so the text template `{WIDTH} x {DEPTH} x
  {HEIGHT} {DIM_UNIT}` renders `30 x 18 x 3 cm` the way the original does. The
  fix landed without this entry being ticked, which is why it was re-verified
  from the source on 2026-08-17 rather than trusted.
- [x] **App 089's device path — DONE.** The port binds
  `{= !${device>/system/phone} }`, the same expression apps 030 and 378–381
  use; the demo kit's `isNoPhone` helper property is not bound anywhere. Also
  re-verified from the source on 2026-08-17.
