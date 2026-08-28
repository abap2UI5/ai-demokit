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
| Ports | **622** sidecars in `meta/` (src/01 OpenUI5 <= 1.71: 403 · src/02 OpenUI5 > 1.71: 219) |
| Per library | sap.f: 36 · sap.m: 393 · sap.tnt: 17 · sap.ui: 131 · sap.uxap: 45 |
| Status ladder | 208 `generated` · 355 `reviewed` · 59 `checked` (live-verified) |
| Deviations | 10 DROPPED_171 · 165 IMPROVISED · 1902 NOTE · 292 POST_171 |
| Open LIVE_TESTs | **0 ports** carry at least one `LIVE_TEST` deviation — the automated close path is the e2e interaction harness (AGENTS §6 `e2e_smoke`) |
| Declared gate skips | 2 structural-diff · 6 render-smoke · 0 data-fidelity · 2 property-gate (each re-verified per run — a stale skip FAILS) |
| Out-of-scope ported samples | `z2ui5_cl_smpc_app_121 (sap.m.sample.UploadSet — deprecated)` · `z2ui5_cl_smpc_app_136 (sap.f.sample.SidePanelSingle — control @since 1.107)` · `z2ui5_cl_smpc_app_141 (sap.ui.core.sample.InvisibleMessage — control @since 1.78)` · `z2ui5_cl_smpc_app_165 (sap.f.sample.ProductSwitchNavigation — control @since 1.72)` · `z2ui5_cl_smpc_app_203 (sap.m.sample.OverflowToolbarTokenizer — control @since 1.139)` — all decided KEEP permanently 2026-07-30 (per-app rationale in ui5/scope-exceptions.json, revertible); the source-backed scope gate stays hard for NEW undecided entries |

_Coverage per library (ported / in scope) is generated into the [README](README.md#coverage); one row per sample in [api.md](api.md)._

<!-- state:end -->

## Open findings (backlog)

- [x] **Apps 612 and 613 now build their tokens on the client — closed
  2026-08-23.** `z2ui5.cc.MultiInputExt` gained `TokenKeyCell` /
  `TokenTextCells` upstream (see the Implemented table in
  [docs/upstream-requests.md](docs/upstream-requests.md)), the linter's render
  harness learned the two properties in `@abap2ui5/linter` 0.3.0 (its
  companion-control mirrors moved into `lib/cc-controls.mjs` and
  `check-upstream` compares them against `app/webapp/cc/<Name>.js`, so they
  cannot rot again). The pin here does NOT automatically follow, and that is
  the one thing this entry used to get wrong: `A2UI5_PIN` moves only when
  `bump-a2ui5.yaml` runs and its full-corpus e2e is green, so between the
  upstream landing and that run the reproducible builds — and any local
  checkout — still resolve a framework without the two properties, where these
  two ports can produce nothing but `Property "TokenKeyCell" does not exist`.
  That is what kept both `LIVE_TEST`s open while everything else about them was
  closed. Both were verified and closed on 2026-08-26 without waiting for the
  pin, by building the backend the way the nightly does — `A2UI5_BRANCH=main`,
  the canary path, which bypasses `A2UI5_PIN` rather than changing it — against
  main tip `ddbdd13`; four consecutive green runs each. That was a statement
  about the reproducible builds, not about these two ports, and it has since
  expired: `bump-a2ui5` advanced `A2UI5_PIN` to `2567ee10` on 2026-08-28, and
  that commit carries `TokenKeyCell` / `TokenTextCells`, so the pinned path now
  resolves a framework with both properties too. Both ports drop the `tokens`
  binding, the `tokens` aggregation and the `suggestionItemSelected` wire, and
  carry one `MultiInputExt` per tabular input (`TokenKeyCell="0"`,
  `TokenTextCells="3"` — Name and the Price cell, the `Name(Price Currency)`
  shape the original builds in JavaScript). 613 handles no event at all any
  more; 612 keeps only its Link toast. Both `IMPROVISED` deviations became
  NOTEs, and the render gate accepts both on the published linter: **637 files,
  0 failing**.

- [x] **`generate-keywords.mjs` sees both builder call shapes — found and
  fixed 2026-08-23.** The control matcher only accepted the POSITIONAL form
  `)->tag( \`Label\` )`, never `)->tag( n = \`Label\` ns = \`z2ui5\` )` — the named
  one, and the only shape that can carry a namespace, so a companion control
  could never reach a keyword line at all. Measured before the fix: **469 of
  622 ports** write the named form somewhere and **7051 control occurrences**
  were invisible. The matcher now takes an optional `n =`, `npm run keywords`
  rewrote **431 of 636** lines, and `multiinputext` reaches apps 040, 612 and
  613. The 12-word cap is unchanged, so a few lines traded a weaker term for a
  control that is actually built.

- [ ] **UI5 version skew forces app 611's two escape hatches, and no bump can
  close them yet (measured 2026-08-28).** `ui5/universe.json` is 1.152.0,
  `ui5/properties.json` 1.152.0-SNAPSHOT, and the `@openui5/*` /`@sapui5/*`
  runtime packages 1.151.0 — so `sap.ui.unified.DateTypeRange.ariaHasPopup`
  (@since 1.152.0), which is the whole point of `sap.ui.unified.sample.CalendarAriaHasPopup`,
  does not exist for either half of `view_gates`. That is not a version
  verdict a `POST_171` deviation can excuse: an unknown member reads as
  `unknown-property` ("typo?") plus a view that fails to load, which is the
  shape a real typo has. Hence `property_gate.skip` **and**
  `render_smoke.skip` on one port.
  **Neither is closable today, for two different reasons.** `@openui5/*`
  1.152.0 is **not published** — npm's newest is 1.151.0 — so the render half
  has no bump to take. And the property half would not move with one anyway:
  the property gate judges against `@abap2ui5/linter`'s own
  `data/properties.json`, which ships inside that package and changes only
  with a linter release regenerated at 1.152. So this needs an upstream
  OpenUI5 release AND a linter release, in that order.
  What is done: the runtime packages are pinned EXACTLY (half of them carried
  `^1.151.0`, which would have moved the render harness the day 1.152 publishes
  with no diff to read), `check_pins` policy 5 holds the runtime packages and
  the linter's metadata to one version and NOTES when the universe is ahead of
  them, and both skip reasons say which release each is waiting on. The skips
  are re-verified against the real render on every run, so they cannot outlive
  the gap.

- [~] **Two ports gave up on a capability that already exists — 607 done,
  600 awaiting its live check (found 2026-08-22, reworked 2026-08-23).**
  Neither was a framework gap; both sidecars reasoned from an older state of
  the framework than the one they were written against.
  - **App 607 (`OverflowToolbarFooter`) — done.** Its `IMPROVISED` said
    "abap2UI5 has no client-side grouping function, so the port sorts by
    SupplierName instead" and the grey group headers went with it. But
    `BINDING_CALL`'s `sort` takes THREE parameters — `[path, descending, group]`
    → `new Sorter(path, descending, group)` — and UI5's DEFAULT group function
    returns `{ key, text }` of the sorted property, which is exactly what the
    sample's `_fnGroup` returns. `filters_apply` now hands the sorter to the
    live binding instead of ordering the ABAP table; the Name filter stays
    server-side. The deviation is a NOTE, and the interaction module asserts
    the `sap.m.GroupHeaderListItem`s appear on Group and are gone after Reset.
  - **App 600 (`TreeDnD`) — written, parked, patch kept.** Its `DROPPED_171`
    reads "the veto itself is expressible (`s_ctrl-check_prevent_default`) but
    its condition is not: the flag is baked per wire at RENDER time". That was
    true until `s_ctrl-prevent_default_expr` landed — the same veto decided per
    FIRING — and the wire is written:
    `${$parameters>/target}.getParent().getSelectedItems()…`, since a tree
    item's parent IS the Tree. Two things stopped it shipping, and both are the
    same objection from different directions. `_event_client` takes no `s_ctrl`,
    so this veto only exists on a wire that ALSO round-trips, and nothing on the
    backend wants that event — which `view_gates` then named on its own:
    `event-without-handler` went 4 → 5 and broke the advisory ratchet. Raising
    the budget is the sanctioned answer for a deliberate round trip, but not
    before the round trip is shown to be harmless: whether it disturbs the drag
    it just allowed is a browser question. The change is parked as
    `600-drag-veto.patch` with its three-case interaction assertion (no
    selection, dragging outside it, dragging the selected row) and comes back
    with the e2e result, or not at all.

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
  a press → Dialog → close wire (010).
  **Ports 035–061 were read on 2026-08-23** — all 27, each against its archived
  original (view, controller, fragments, manifest, mock) and against the pinned
  OpenUI5 sources wherever a claim rested on UI5 behaviour. **20 came back
  clean** (035–037, 039, 041, 043–048, 050–059) and **7 carried a finding**, all
  of them documentation drift and not one of them a behavioural defect — which
  is itself the result worth recording, since the first batch of this re-read
  found a real one in app 003 and the fear was that `checked` ports hid more.
  What the seven were: a deviation justifying its choice with a framework
  limitation that had been lifted two days after the sentence was written (038,
  the `message>` write half — `z2ui5.cc.MessageManager` does it, and app 065
  here uses it) *and* citing a class in the retired `z2ui5_cl_demo_app_*` scheme that
  exists nowhere — see the gate gap below; an `@since` the sources do not carry (040, "the
  tokens aggregation is public since 1.16" — `MultiInput.js` tags it not at all,
  and `Tokenizer`, which renders it, is @since 1.22; the figure was in
  CAPABILITIES.md too); a declared extra control the port does not build (042
  claimed two content Texts and a "Close Button"; it builds one Text and an OK
  button, exactly as the original's controller does); an e2e claim its own
  interaction module contradicts (049 promised ArrowUp + Enter and "the quotes
  intact", while the module records that the keyboard route stopped firing
  `change` on the pinned UI5, falls back to the control API, and asserts the
  text without the quoted value); a mis-scoped `POST_171` (061 said
  `beforeMenuOpen` sits on "the split-mode buttons", one button short — the
  `menuPosition="RightBottom"` one carries it with no `buttonMode` at all); an
  inline comment quoting the original as something it is not (060 said the
  sample toasts `item.getText()`, where it actually walks the parent chain); and
  an interaction module whose header named the wrong wire (061 said `{0}
  Pressed`, asserts `Action triggered on item: Save`). All seven are corrected.
  **Two of the findings were not in the ports at all**, and both left this
  repository: 060/061's breadcrumb reasoning ("an expression has no loop") is no
  longer the operative reason — the framework has `$controller.textPath`, which
  *does* loop — and the sidecars now carry the real one, that `getTextPath`
  breaks at the first ancestor without `getText` and `sap.m.Menu` puts a
  `MenuWrapper` (@since 1.136, no `getText`) exactly there, so it returns the
  leaf text and rewiring would be a no-op. The framework's own comment on that
  helper promised the opposite and is fixed upstream.
  A **gate gap** explains why 038's dead class name outlived the 2026-08-21
  sweep that removed the others: `check-prose-names` reads eight markdown files
  and no `meta/` sidecar, although a deviation is prose, is what agents read,
  and is baked verbatim into the generated overview app. The script is shared
  with `samples` and `samples-stack`, so it is filed as
  `prose-gate-blind-to-sidecars` in abap2UI5's backlog rather than changed in
  one consumer.
  A second corpus-wide drift surfaced from the same reading and is fixed:
  **ten CAPABILITIES.md rows still said "LIVE-TEST pending" for apps that are
  now `checked`** (007, 013, 022, 026, 028, 030, 033, 039, 040, 044, 046, 047 —
  all live-verified between 2026-07-15 and 2026-07-20), and four rows pointed at
  `app/webapp/core/Messages.js`, a module that no longer exists (the toast and
  message-box hooks live in `core/actions/ControlCall.js`). Understating a
  capability in the file whose whole job is to stop a port from improvising is
  the more expensive of the two.
  **The `checked` re-read is now complete for the whole corpus (2026-08-23).**
  The 20 remaining `checked` ports above 061 — 065, 066, 084, 085, 108, 140,
  164, 171, 256, 257, 272–281 — were read the same way. **Four came back clean** (066, 085,
  276, 278) and sixteen carried a finding — **and this time three were
  BEHAVIOURAL**, which is exactly what a re-read of human-signed-off ports
  existed to find out:
  - **App 084's tel and sms could never have worked.** Both were wired
    `t_arg = ( 'TRIGGER_TEL' ) ( <number as a plain string> )`, but
    `evUrlHelper` reads `args[2]` as an OBJECT and takes `params.TEL`, so
    `URLHelper` got `undefined` and `formatTel` returned `''` — the items
    navigated to a bare `tel:`/`sms:`. Its `checked.note` said "tel/sms/email
    and REDIRECT all fire correctly", `CAPABILITIES.md` documented the plain
    string as the API, and app 528 had copied the shape. All four are fixed;
    the check is retired and the port is back to `generated`. **The key is
    `TEL` for sms too** — the handler reads `params.TEL` for both.
  - **App 065 showed two invented message texts.** Only two of the original's
    four Save messages are authored by hand; the ZIP and Email ones are UI5's
    own type messages ("Enter a number with no decimal places", "Enter a valid
    value"). The port had paraphrased both, which also made it disagree with
    itself — typing the same bad value makes abap2UI5's auto-collection emit
    the real bundle text. Corrected to the strings the sample shows.
  - **App 272's four toasts ran 3000 ms instead of the original's 500**, on a
    deviation claiming `message_toast_display` has no `duration` parameter. It
    has one, at the pinned commit, and five ports here were already passing it.
  A third class is new and worth naming: **a `checked` stamp that outlived the
  code it certified.** App 108 was signed off 2026-07-27 for "interactions
  toast as declared", but the port raises no toast at all (both handlers open a
  MessageBox, faithfully), and its interactions were only built on 2026-08-05 —
  so the run can only have covered rendering. App 084's is the same shape.
  AGENTS §10 already rules on this, and both are now `generated` with the
  historical check kept as a `LIVE_TEST`. **App 277's e2e close was withdrawn**
  for the neighbouring reason: `close-live-tests` stamps a deviation only when
  the module drives the wire it names, and 277's module asserts the strip is
  VISIBLE on a desktop viewport while the deviation is about the phone-portrait
  branch — which nothing rotates. It is a `LIVE_TEST` again.
  The rest were documentation drift of the shapes the 001–061 wave established:
  a mis-scoped declaration (065's ColumnElementData, 140's "every cell", 275's
  "four tiles", 281's `getSelectedItems`), an `@since` the sources do not carry
  (281's `showSelectAll` 1.111), an undeclared drop (108's `icon="{pic}"`,
  164's `TableExampleUtils` info button, which six sibling ports declare), a
  stale sentence asking for a check the same deviation records (171), a
  justification that is the opposite of the truth (279 — "no gate sees it",
  when the linter reports four version findings and that declaration is the
  only thing keeping the port green; 274 — a residual blamed on UI5 1.149 when
  the harness serves 1.151), and an e2e claim wider than its module (273, 280,
  281).
  **The `reviewed` re-read has started (2026-08-23), and the first block of 20
  changed the picture again.** Ports 062–064, 067–083 were read the same way.
  **Ten came back clean** (062, 063, 064, 068, 069, 070, 071, 075, 078, 079,
  082) and ten carried findings — including the worst defect the whole sweep
  has produced:
  - **App 077's close button silently did nothing on 11 of its 15 handlers.**
    The original resolves the parent per item (`oItem.getParent()`), and
    `sap.m.NotificationListGroup` declares its own `items` aggregation, so a
    NESTED item's parent is the GROUP. All fifteen wires were hard-coded to the
    outer list id: right for the four group closes, and for the eleven item
    closes `ManagedObject.removeAggregation` looped the list's four groups,
    matched nothing and returned `null` — no error, no log, the item stayed on
    screen and only the toast fired. Every gate was green because the call
    fails silently, and the sidecar called it "reproduced 1:1". The groups now
    carry ids and each nested item removes itself from its own group. Note the
    same wire is CORRECT in app 076, where every item is a direct child — which
    is why the probe it leaned on (a flat Tokenizer) never covered this.
  - **App 067 dropped a user-visible toast on a false justification.** Its
    deviation said `setAsyncDescriptionHandler` and the `longtextLoaded` toast
    both never fire because no mock row has a `longtextUrl`. That is true of
    the first and false of the second: `longtextLoaded` is ungated —
    `_navigateToDetails` fires it on every drill-down — so in the original
    clicking any message toasts "Description validation has been performed."
    Now wired.
  - **App 073 lost the Cancel button's `type="Reject"`** (Submit's `Accept` was
    there, so the pair was asymmetric) **and toasted with every default** where
    the original shows the toast ON the still-open dialog for 2 s, centre
    docked, and closes it from `onClose`. Both fixed; only `of` stays dropped,
    because the framework hands that option to MessageToast unresolved so a
    control id cannot travel in it.
  A corpus-wide claim also turned out false and is now closed rather than just
  corrected: 22 sidecars asserted the asset-path rewrite was "declared by all
  77 ports that do it". Re-counted: **126 ports do it and 17 declared it
  nowhere** — exactly the condition the sentence claimed to have closed. The 17
  now carry the declaration and the sentence names the date its count was
  taken, since a bare absolute count is what went stale.
  The remaining findings are the familiar shapes: an undeclared substitution
  (072's twelve client toasts, 076's `onErrorPress` losing a persistent
  MessageStrip and its link, 077's `onAcceptErrors` inventing a toast the
  original does not have), a version floor that is understated (072 needs
  1.110 for `sapMObjectNumberLongText`, not the 1.86 it claimed), a member
  declared POST_171 that carries no `@since` at all (067's
  `markupDescription`), a leftover comment the code below it contradicts (077),
  a justification that is simply not how UI5 behaves (077's "UI5 boolean
  parsing rejects `falseue`" — it coerces), a dead `LIVE_TEST` pointer (074),
  and e2e claims wider than their modules (067, 074, 080 — 074's module now
  asserts the whole composed toast instead of its prefix).
  **Block 2 (2026-08-23) read ports 086–105** (103 excepted, reworked the same
  day). **Six clean** (086, 087, 088, 089, 090, 095, 098) and the rest carried
  findings — and the behavioural share keeps rising as the sweep moves into
  ports that actually wire things:
  - **App 101 had two step texts silently TRUNCATED to roughly half** — 475 of
    955 characters and 385 of 575, each a clean prefix stopping mid-paragraph —
    and had quietly corrected the original's own typo "Donec ppellentesque".
    Restored. No gate in this repo compares long text bodies, which is exactly
    why it survived three sweeps. Its navigation also used `to` for all three
    legs where the original uses `backToPage` for two (a reverse transition
    that unwinds the NavContainer stack rather than pushing onto it), its
    weight check demanded all digits where the original tests `parseInt() is
    NaN` (so `12.5`, `-5` and `12abc` are valid there — on an `Input
    type="Number"`, where a decimal is what a user types), and it dropped the
    `setCurrentStep` both failing branches call. All fixed.
  - **App 105 and its siblings 106/107 printed the wrong text in 36 toasts.**
    The original strips the LIBRARY name, and the library of a
    `sap.m.semantic.*` control is `sap.m` — so it prints
    `Pressed: semantic.AddAction`. All three ports passed the bare action name,
    stripping the namespace too.
  - **App 099 dropped the navigate toast's identity and its whole back-button
    branch**, on the justification that `navOrigin` "is a control reference not
    transportable as an event arg" — which its own twin, app 100, had recorded
    as a corrected defect three weeks earlier. The correction never reached
    099; it has now.
  - **App 102 does not reproduce the guard its sidecar says it does, and the
    handler is worse than the "no-op" it was called.** `sap.m.Input` writes its
    value binding on change, not per keystroke, so the delta carries nothing
    and the comparison can only ever be true; and every round-trip clears all
    pending timers *before* running, so one keystroke cancels the armed rebind
    entirely, where the original's `dataReceived` always fires and is merely
    declined. Declared precisely rather than reworked — the fix needs the value
    transported AND the timer problem solved together.
  - **App 104 kept its search filter across a close**, where `handleClose`
    resets it first on confirm and cancel alike (`open()` clears the search
    field but never the binding filter). Fixed.
  Two twin-port lessons came out of this block and are worth carrying forward:
  a correction applied to one port of a pair does not reach the other by
  itself (096→097, 100→099), and the same wire can be right in one port and
  silently wrong in the next when the aggregation nests one level deeper
  (076 vs 077 in block 1).
  The rest are the established documentation shapes: a deviation declaring a
  wire the port does not have (094, 096, 097 — all three claimed a `setMode`
  frontend action where the handler only assigns a two-way bound field), a
  limitation the framework lifted (093's aggregation-item addressing, available
  since 2026-08-06 and already used by app 012), a dead pointer (092's
  "core:require dropped" — the sample has none), a mis-stated moment rather
  than mechanism (092's popin re-flow happens per tick, not on picker close),
  an undeclared content difference (093's added tab), a dropped
  `templateShareable` (099, 100), a dropped a11y override (100), and e2e claims
  wider than their modules (091, 093, 096, 097, 101, 104).
  **Block 3 (2026-08-23) read ports 106–126.** **Nine clean** (110, 111, 113,
  117, 119, 120, 122, 124, 125) and the block produced the sweep's first
  outright CRASH plus several dead wires:
  - **App 115 threw a TypeError on every token ADD.** `MultiInput` fires
    `tokenUpdate` with `type: "added"` and `removedTokens: []`, and the wire's
    unguarded `${$parameters>/removedTokens}[0].getKey()` raised in the
    expression parser *before* the round-trip started — so picking a suggestion
    produced a console exception instead of the original's model write. Guarded
    now. Its `removed` branch was a no-op besides: the original REWRITES the
    whole token list from the post-update aggregation and that write is the
    only thing that ever fills the model, so the port's bound table is empty for
    all 123 rows and its `DELETE` matches nothing.
  - **App 126's `uploadComplete` could never fire.** Nothing called `upload()`
    and `uploadOnChange` defaults to `false`, so both firing paths were
    unreachable, while the press raised an invented toast the original does not
    have. `upload` is an ordinary public method and is not on the frontend
    denylist; the press calls it now.
  - **App 121's remove only toasted** — the file came back on the next render —
    **and its version button was hard-coded off**, so the button the sample's
    selection logic exists to demonstrate was permanently dead. Both wired; the
    five invented toasts are gone (the original raises none).
  - **App 118 printed "URL: undefined" on every date click.** The original
    guards on the action TYPE and only toasts for `Navigation`; the Calendar
    card fires a `DateChange` whose parameters carry no `url`. Guarded — a
    view-wired client action always fires, so suppressing it entirely would need
    a per-firing veto that form does not have, and that residue is declared.
  - **Apps 106/107 lost half of the SortSelect toast**, the same derivation
    fixed for the button literals earlier the same day: the original prints
    `Selected: semantic.SortSelect by <text>`. A reminder that fixing one
    handler does not fix its sibling.
  Documentation drift, same shapes as before: a rendering claim wrong on
  desktop (112 — declaring the two button aggregations at all makes
  `ResponsivePopover._setButton` create a footer Toolbar that `visible=false`
  cannot remove), an `@since` the sources do not carry (109's MonthView is
  1.69), a deviation typed `NOTE` where the recipe requires `IMPROVISED` (116,
  the canonical two-view BlockBase case), counts and classes that do not match
  the code (115, 116, 126), and e2e claims wider than their modules (123).
  One difference was declared rather than "fixed": app 114 renders 13
  tab-indented lines where the original's literal newlines collapse to spaces
  through XML attribute-value normalisation — the port is the source-faithful
  side, and matching the original's RENDERING would mean writing spaces where
  the sample wrote newlines.
  **What is left: 275 `reviewed` and 206 `generated` ports above 061.**

  **Block 4 (2026-08-23) read ports 127–147.** **Six clean** (127, 129, 131,
  142, 144, 146). The block's finds were fewer dead wires and more claims that
  did not survive being checked:
  - **App 130 lost the sample's only behaviour.** The original presses once and
    the busy state clears itself after 5s (`setTimeout`); the port toggled, so
    busy stayed until a second press. `cs_event-start_timer` has expressed this
    since 2026-07-30 and app 147 — the *other* BusyIndicator sample — already
    used it. Now `busy = abap_true` plus a `CLEAR_BUSY` timer.
  - **App 136 threw the panel's state away on every toggle.** The `TOGGLE`
    branch ended in `view_display( )`, and `SidePanel.selectedItem` is an
    association and `sideContentExpanded` a hidden property, so the side content
    the user had just opened came back collapsed. The re-render existed only to
    re-bake the render-time veto flag — which was itself one toggle late,
    because the two Switches carry no event. `s_ctrl-prevent_default_expr`
    decides per firing and reads both Switch states, so the re-render is gone
    and both defects with it.
  - **App 137's sort and filter menus operated on paths that do not exist.**
    `sortProperty`/`filterProperty` were copied lowercase from the original
    while the cells bind `{SUPPLIER}`/`{STREET}`/`{CITY}`/`{PHONE}` — abap2UI5
    derives model paths from the ABAP component names. UI5 generates the menu
    entries off the property being *set*, so sorting was a no-op and filtering
    returned nothing.
  - **App 141 dropped the announce the sample exists for**, justified by "no
    control_global entry" — `ControlCall.js` has defined
    `INVISIBLE_MESSAGE.announce` since 2026-08-05, CAPABILITIES marks it ✅ and
    apps 289/435 use it. Sharper still: `ui5/scope-exceptions.json` keeps this
    post-1.71 sample precisely because the accessibility-announcement idiom
    exists nowhere else in the corpus.
  - **Two e2e claims were vacuous, in two different ways.** App 133's mode leg
    clicked the segment the port already loads in, and `SegmentedButton` returns
    early there — no `selectionChange`, both assertions true at page load. App
    147's asserted that the busy overlay appears and later disappears, which the
    *framework* satisfies on its own (it shows the same global singleton on
    every request and hides it before the port's follow-up JS runs). 133 now
    clicks a different segment and asserts the sentence the backend composes;
    147 measures how long the overlay stays up.
  - **App 297, found while checking 136's framework contract:** its
    `prevent_default_expr` was built as `|${ client->_bind( path = abap_true ) }
    === 'Error'|`, and an ABAP template treats the following brace as an
    embedded expression — what reached the wire was `$/DATE_VALUE_STATE`, which
    the UI5 event-handler parser does not know. That veto could never have
    fired.
  - **App 145's archive was incomplete while its sidecar said the gap was
    closed.** `RevealGrid/RevealGrid.js` — the controller's only dependency — was
    missing, though `manifest.json` lists it and two sibling samples archive it
    byte-identically. That named a whole gate class: `scripts/check-archive.mjs`
    now checks every manifest-listed file against the archive on disk (0 errors
    after this fix; the 57 `../SharedBlocks` files 30 sap.uxap samples pull from
    sibling folders are reported as a standing advisory, since backfilling them
    needs a harvest run).
  - **App 135 was in the wrong category folder.** `formatOptions
    { showNumber: false }` is `@since 1.89` — a binding-info parameter no gate
    can see — so the port owed a `POST_171` and, with it, `src/02`.
  - Documentation-only corrections: 128 (two justifications that were false
    against the files in the repo today — the property gate is *not* blind to
    sap.tnt, and it *does* check controls as well as members), 132 (the floor is
    1.149, the `tag` aggregation's, not the group's 1.121), 134 (the dropped
    device handler also toasts, and `onInit` calls it — the original shows a
    message on every load), 138 (two residuals now stated: the dropped
    `if (iValue)` guard and the initial toggle-button state the
    `breakpointChanged` wire provably cannot cover), 139 (a phone rule dropped
    as "not used by the view" — `sapUiCal` is written by the renderer, not the
    author), 143 (the sidecar's `entity` named a foreign library, which put the
    port under `sap.f` in the generated catalogue; `validate-meta` now
    cross-checks the entity's library against the universe).
  **What is left: 255 `reviewed` and 206 `generated` ports above 147.**

  **Blocks 5-7 (2026-08-23) read ports 148-271** — 124 ports in three waves of
  parallel readers. The pattern of the whole sweep changed here: fewer dead
  wires per port, and more claims that did not survive being checked against the
  sources. Wires that could not work:
  - **A raw-argument rule, found the hard way.** `get_t_arg` leaves a `t_arg`
    entry unquoted only when it starts with `$` or `{` (or is an `.eB`/`.eF`
    call); everything else becomes a single-quoted JS string. App 250's
    `liveChange` composed `'rgba(' + ${…}` and handed it to the `css` setter,
    where CSSOM dropped the text — the icon never changed colour. The
    value-help pre-filter added to app 233 *earlier in this same sweep* had the
    identical shape and was corrected before it could ship as a fix that fixed
    nothing.
  - **165** wrote its URLHELPER payload in a backtick literal, where `\{` is a
    real backslash: the expression never evaluated and the user got "Invalid
    redirect URL" instead of the redirect.
  - **168** gave `class=` an expression binding. `XMLTemplateProcessor`
    intercepts `class` before the property branch and hands the raw string to
    `addStyleClass`, which drops any value containing a quote — so the control
    got no class at all, losing the original's static one too.
  - **252** bound an int property to a field the Input writes back as a string;
    every keystroke threw out of the binding. The binding carries a type now,
    which is where the original's `Number( )` went.
  - **241** left the nested `items` aggregation unbound on a row template, so
    one row's children never rendered and every row grew a spurious child.
  - **167** computed `false` where the original's expression THROWS and UI5
    falls back to the declared default `true` — one whole page was unreachable.
  - **163** froze five media flags at their desktop values, which left the
    overflow button permanently invisible and its ActionSheet branch dead code,
    in the sample about device-dependent toolbars.
  - **246** cleared a bound field beside `clear( )`: the model push runs before
    the queued follow-up actions, so `upload( )` posted an empty form.
  - **148** hit ABAP's `INSERT … INDEX` where JS `splice` clamps — dropping the
    last card onto itself lost the row on a real system.
  Two sweeps of one defect across ports: mixed-case `sortProperty`/
  `filterProperty` against upper-cased model paths (164/174/247/353, after 137),
  and the `.sap-phone .sapUiCal` rule dropped as "not used by the view" in six
  calendar ports — it is written by the renderer, not the author.
  The **framework** fix of the day came out of app 196: `CONTROL_GLOBAL
  FORMATTING` asked for `sap/ui/core/Formatting`, a module UI5 does not have,
  and both unit tests stubbed the same wrong id. The gate that should have
  caught it read only `sap.ui.define` arrays; it checks probed ids now.
  Documentation: 26 uxap sidecars typed the block substitution `NOTE` where
  CAPABILITIES and the recipe both say `IMPROVISED`, ten e2e stamps claimed
  more than their modules assert, and a dozen justifications named framework
  limitations that do not exist.
  **What is left: 136 `reviewed` and 206 `generated` ports above 271.**

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
- [x] **LIVE_TEST debt → e2e interactions — reached zero 2026-08-26.** The open `LIVE_TEST` count (see
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
  **The open set is EMPTY since 2026-08-26** - the backlog went 122 ports to 0,
  and the generated table at the top of this file is the live count. The last
  two, 612 and 613, were never blocked by their modules: A2UI5_PIN predated the
  TokenKeyCell / TokenTextCells properties they need, so a pinned checkout could
  only produce `Property "TokenKeyCell" does not exist`. They were closed on the
  canary path (A2UI5_BRANCH=main against ddbdd13), four consecutive green runs
  each - see the 612/613 entry above. The sentence below records the state this
  paragraph described while the backlog was still open, and the composition
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
