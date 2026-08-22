---
name: e2e-debugging
description: Running and debugging the Playwright e2e smoke: build freshness and stale servers, zero-size unthemed controls, overflow popovers, viewport-dependent wires, HTTPS-only device APIs, ASSERTION_FAILED runtime causes. Use when running npm run e2e, adding a meta/interactions module, closing a LIVE_TEST deviation, or when an e2e failure looks like a broken port.
---

# E2E smoke — debugging guide

The harness itself (build, serve, run) is documented in `E2E.md`; the
per-port interactions live as one module each under `meta/interactions/`
(coverage catalogue in that directory's README, shared assertions in
`scripts/lib-e2e.mjs`); the `e2e_smoke` gate row is in the `run-the-gates`
guide. This guide
collects the lessons that make e2e failures readable — most "broken port"
verdicts below turned out to be harness effects.

- **An e2e verdict is only as fresh as the transpiled backend** —
  `e2e-smoke.mjs` runs the code in `.abap2UI5/node/output`, so a port edited
  after the last `npm run node:build` is NOT what the browser executes, and a
  leftover `node .abap2UI5/node/srv/express.mjs` from a debug run keeps port
  3000 (the harness' own spawn then fails silently and the browser talks to
  the stale server). The unmistakable symptom for a **brand-new** port is
  `backend HTTP 500` whose body reads *"The app 'Z2UI5_CL_SMPC_APP_nnn' does not
  exist in the system"* — that is a missing rebuild, never a port defect.
  Never run `e2e-smoke` while a build is in flight (`e2e-build` wipes
  `node/output` first, so the run dies with no output). **Never wait on or
  kill a process by grepping for a string your own command line also
  contains** — `pgrep -f e2e-build` matches the waiting shell itself and waits
  forever, and a `grep '[e]2e-build' | xargs kill` whose command line also
  names `e2e-build.mjs` kills your own shell (exit 144, no output). Grep the
  build log for `e2e-build: done`; kill by a PID noted in a SEPARATE, earlier
  command.
- **A PRIVATE instance attribute 500s every roundtrip.** The app's state is
  persisted with `CALL TRANSFORMATION id`, and the transpiled runtime's
  re-implementation walks the class's attributes with a dynamic
  `ASSIGN obj->(name)` — which reaches a PROTECTED attribute and **not** a
  PRIVATE one. `sy-subrc` is then 4, the serializer asserts, and every
  roundtrip answers `ASSERTION_FAILED` from `lcl_heap.add_object`
  (`kernel_call_transformation`) — with nothing in the message naming the
  attribute. Six ports carried it (604, 607, 617, 618, 619, 623, all a private
  `t_all`/`t_images` master copy) while the 53 ports with a PROTECTED one were
  fine, which is what isolated it (2026-08-22). **Declare app state PUBLIC and
  helpers PROTECTED; never PRIVATE.** To find the attribute when it happens
  again, log `ls_attribute-name` in front of that assert in
  `node/output/kernel_call_transformation.clas.locals.mjs`.
- **The transpiler HOISTS both branches of a `COND` / `SWITCH` and evaluates
  them unconditionally.** `COND string( WHEN … THEN f( x ) ELSE g( ) )` becomes
  `temp1.set(await f(x)); temp2.set(await g()); if (…)` — so a call that ABAP
  would never make on the taken branch runs anyway. App 609 read
  `get_event_arg( 2 )` in the THEN branch of a `COND` shared by two events, and
  the event that carries no arguments at all asserted on the missing row: every
  Create press 500'd while the ABAP was correct (2026-08-22). Write the branch
  as `IF`/`ELSE` whenever either side has a side effect or can fail.
- **The overview app's view chain overflows V8's parser stack.** A view-builder
  chain transpiles to ONE nested expression — `view->ele( )->a( )->end( )`
  becomes `await (await (await (…).get().a(…)).get().a(…))`, one level per
  call — and `z2ui5_cl_smpc_app_000` is 177 calls long in a 5 MB module. Node's
  default stack, already partly spent by the ESM loader walking the 2,340
  transpiled modules, dies inside `compileSourceTextModule` and the backend
  never listens: the smoke reports `backend exited (1) before listening`. The
  harness passes `--stack-size=10000` on argv (NODE_OPTIONS rejects V8 options).
  A real system never parses this, so it is a harness limit, not a corpus one.
- **An internal control of the same type is the most common wrong-assertion
  bug.** Every `sap.m.Input` builds a suggestion-popup `sap.m.Table`, every
  `sap.m.Breadcrumbs` an empty `sap.m.Link`, every `sap.ui.unified.Calendar` a
  `DateTypeRange` of its own — so a registry-wide `filter(byType)` counts one
  too many and a bare `find(byType)` can answer with the wrong control. Ask the
  OWNING control for its aggregation (`getLinks()`, `getSpecialDates()`,
  `getSuggestionItems()`) or address by id. Three ports read as broken on this
  in one sweep (2026-08-22).
- **A matcher this harness does not have fails as `… is not a function`, and
  the assertion never ran.** `expect(locator, label)` offers exactly
  `toBeVisible`, `toBeVisibleEnabled`, `toContainText`, `notToContainText` and
  `toHaveCountBelow` — not Playwright's full set. App 582 called `toContain`
  and app 516 `toBeVisible` (which did not exist until 2026-08-22); both threw
  before proving anything, and 516's assertion turned out to be for a control
  the sample never had. When adding a matcher, re-run every module that used it.
- **A typed binding is not written by `setValue` + `fireChange`.** The model is
  updated by `InputBase.onChange` → `updateModelProperty`, which runs the type
  and its constraints; firing the event directly leaves the CONTROL on the new
  value and the MODEL on the old one, so the roundtrip sends the old value
  (app 622, 2026-08-22). Type into `[id$="<id>-inner"]` and press Enter. And
  while a client-side constraint (`sap.ui.model.type.String` with
  `minLength`/`maxLength`) is violated the framework sends **no roundtrip at
  all** — measured one POST for a whole sequence, none for the Submit press —
  so drive the backend's own paths BEFORE putting a field into that state.
- **A control with no theme CSS has a zero-size box, and playwright will not
  click or focus it** — the e2e harness serves the UI5 *sources*, not the
  themes, so `sapUiIcon` (an Input's value-help icon, app 268) and
  `sapMSliderHandle` (apps 270/271) measure 0×0 and every actionability check
  fails with *"not visible"*, which reads like a broken port — so does a
  growing list's **"More" trigger** (`[id$="-trigger"]`, a CustomListItem with
  a null bounding box in the unthemed harness; `dispatchMouse` fires it,
  app 422). Both have a real
  gesture that still goes through the control's own handling:
  `locator.dispatchEvent('click')` for an icon, and
  `page.evaluate(() => el.focus())` + a key press for anything else — **the
  keyboard is the more general of the two**: focus+`Enter` picks a
  `ColorPalette` swatch (app 008), focus+`F4` opens a value help (app 233),
  focus+`ArrowLeft` moves a slider through its two-way binding. Reach for
  focus+key before giving a control up. Do not "fix" this by setting the
  property through the UI5 API — that bypasses the binding the test exists to
  prove. Same family: assert the *effect* (a bound property, a rendered
  class), not the pixels (apps 207/130).
- **OverflowToolbar controls ARE drivable headless — open the overflow
  popover first.** In the harness' 1280 px viewport a toolbar folds almost
  everything into its `Additional Options` button, so a direct
  `getByRole('button', …)` for a toolbar control fails with *"not visible"*.
  Clicking `Additional Options` opens the associative popover and the controls
  inside it click normally, round-trip and all (app 174). Two details: an
  **overflowed `SegmentedButton` renders as a `Select`** in that popover
  (app 247), and the binding **template** of an aggregation sits in
  `Element.registry` next to the real rows with no binding context, so filter
  on `getBindingContext()` before asserting a property over "all items"
  (app 207).
- **An interaction may create the state it needs** — app 267's whole
  `breakpointChanged` wire only fires below 720 px, so its interaction calls
  `page.setViewportSize({ width: 400, height: 900 })` and then waits for the
  bound `enabled` flag. A responsive wire is testable; it just needs the
  viewport as an input.
- **Device APIs need a secure context (HTTPS)** — geolocation and the camera
  (`z2ui5.cc.Geolocation` / `CameraPicture`) silently do nothing over plain
  HTTP; `getCurrentPosition` / `getUserMedia` fail with a secure-origin error.
  Test over HTTPS or `localhost`, not `http://`.
- **`Network error: ASSERTION_FAILED` in a transpiled build ≠ an app defect** —
  an `ASSERT` cannot be caught in the JS runtime, so any assert inside a
  `TRY … CATCH cx_root` that a real system swallows becomes a 500 there. Two
  known sources, both in the *runtime*, not in the port: (a) the 702 downport
  turns a table expression `tab[ … ]` into `RAISE cx_sy_itab_line_not_found`,
  which the build maps to `ASSERT 1 = 0` — that is why a missing
  `get_event_arg( n )` 500s instead of returning initial; (b) open-abap's
  `CALL TRANSFORMATION id … RESULT XML` writes character data **unescaped**, so
  an app whose model carries a `<` saves a draft its own `CL_IXML` cannot parse
  back and **every** later round-trip dies in the parser — patched at build
  time by `web/ci/patch_open_abap_xml.mjs`, applied by `scripts/e2e-build.mjs`
  and by abap2UI5/mcp-server (which is why the script keeps that path even
  though the Pages build it was written for is gone), and forwarded upstream as
  `pr/open-abap-xml-escaping`. Prefer `READ TABLE` over `tab[ … ]` in an app
  that must run there.
- **Locate by what the DOM actually exposes, not by what the control is
  called.** Four shapes measured 2026-08-21, each of which fails as a plain
  30s locator timeout that reads like a broken port: a **Breadcrumbs link**
  carries `aria-labelledby` pointing at ITSELF plus the current-location text,
  so its accessible name is not its text and `getByRole('link', { name,
  exact })` matches nothing — `getByText` does; a **uxap
  ObjectPageHeaderActionButton** renders icon-only and takes its accessible
  name from the TOOLTIP, so app 408's "toggle title" button answers to
  "synchronize" — `pressHeaderAction` resolves it through the control registry;
  a **QuickView pageLink** has no accessible name at all and its text may
  repeat elsewhere in the popover, so match on `.sapMLnk`; and the uxap header
  **markers** (`-changes`, `-lock`, `-titleArrow`) are internal Buttons with a
  generated id suffix.
- **A dispatched `click` is not always a press.** The header markers DO get a
  layout box (123x22 unthemed), so a real `.click()` fires them while a
  dispatched `click` reaches the DOM node and dies there. Where a control
  genuinely has no box, one event may still not be enough: sap.ui.table's
  pointer extension acts on the mousedown/mouseup PAIR, so its 0-wide tree
  expand icon ignores a lone `click` — `dispatchMouse()` sends the whole
  sequence. Try a real click first; dispatch only what has no box.
- **Several OverflowToolbars can share one page.** App 357 has one on the table
  and one in the footer, so "the first Additional Options button" opens the
  wrong popover and the control still never shows; app 407's menu button hides
  in the ToolHeader's own overflow. `revealInOverflow(page, locator)` tries them
  in turn until the wanted control is on screen. A round-trip re-renders the
  toolbar and re-decides what overflows, so reveal and press TOGETHER rather
  than holding a locator across a round-trip.
- **A two-way bound live field fights the typist.** Where a `liveChange` wire
  round-trips AND the same field is bound two-way, the response echoes the
  server's value back and OVERWRITES anything typed since — so a fixed
  inter-key delay cannot fix it, only make the loss less likely (app 407: a
  300ms delay swallowed the "a" and the backend filtered on "Sles"). `typeLive()`
  presses one character, waits for the bound value to SETTLE on it, and retries
  the character if a late echo rolled it back.
- **Prove a missing control is the harness, not the port, by driving the UI5
  API directly.** App 359's row actions never render in the smoke; calling
  `setRowActionCount(2)` + `invalidate()` on the table itself — bypassing the
  port entirely — still left every row without a `_rowAction`. That is what
  turns "the port might be broken" into "the harness cannot show this", and it
  belongs in the module as a comment plus a "still open" line in
  `meta/interactions/README.md`, never a silently dropped assertion.
- **A binding TEMPLATE answers for no row.** Asserting `getVisible()` on the
  `RowAction` template (app 359) or on any aggregation template reads a state
  with no binding context — the app-207 trap in a different control.
- **An assertion that is already true waits for nothing.** App 362 waited for
  an Accessories row at the head of the model after a category sort, but
  name-ascending already put one there: the wait returned instantly and the
  module raced its next round-trip against the one still in flight. Wait on the
  state that CHANGES.
- **Type with a delay when the wire round-trips.** A per-keystroke round-trip
  is lossy, not queued (events fired mid-flight are dropped) — a no-delay
  `pressSequentially` asserts a value the wire never promised. Full rule (app
  280) in the `port-a-sample` guide's porting gotchas.
- **A predicate that THROWS is not a predicate that is false**, and the
  difference is the whole diagnosis. `waitForFunction` rejects either way, so a
  wrapper that reports its own message for any rejection accuses the port of a
  defect it does not have: app 351's Remove wire read as *"never shrank the
  bound contentAreas aggregation"* for three runs while a direct dump after the
  same press showed three areas — the predicate was calling `getDomRef()` on a
  control the re-render had already destroyed. `waitForUi5` now keeps a
  non-timeout reason, and the rule for the predicate is **test `bIsDestroyed`
  before touching a control at all**.
- **The outgoing control is still in the registry.** Every round-trip rebuilds
  the view, and `Element.registry` holds the previous control while it is torn
  down — so `ui5All().find(…)` can answer with the OLD one and its OLD state,
  and an assertion that the count went 4→3 fails against a 4 that no longer
  exists on screen. Filter on `!c.bIsDestroyed && c.getDomRef()`. (Going 3→4
  may pass by luck, which is what makes this look like a one-sided wire bug.)
- **Ask what index you are counting from, and scope it.** App 351's option-row
  Inputs are preceded by two Inputs with an empty value, so a page-wide
  `.sapMInputBaseInner` counted from zero lands on one of those — and because
  it also reads `"0"`, the locator passes its own starting-value check and
  fails later against a wire that works. Scope to the container id
  (`[id$="mainOptions"] …`). Reaching for the Element registry instead is not
  the fix: it holds the unbound aggregation template, and after a re-render its
  order is not the rows' order either.
- **A round-trip whose result the NEXT step needs, with nothing bound to wait
  on.** App 353 selects a row (`rowSelectionChange` → the backend records the
  index) and then presses Move; no control shows that index, so there is no
  bound value for `waitForUi5`. The round-trip itself is observable —
  `page.waitForResponse(r => r.request().method() === 'POST' && …)` in a
  `Promise.all` with the click. Without it the two raced and the move answered
  "Please select a row!", which reads exactly like a dead wire.
- **The RESPONSE is not the RE-RENDER.** `waitForResponse` tells you the
  backend answered; abap2UI5 rebuilds the view *after* that, so a locator
  resolved on the next line can point at a node about to be replaced. App
  351's Min-Size keystroke was silently dropped that way while a dump 2.5 s
  after the same keystroke showed it had landed — the module read as a dead
  wire through four debugging rounds. Give the rebuild a moment after every
  round-trip, including one triggered by `Enter` in a bound field.
- **`fill()` does not blur, and a two-way binding writes back on `change`.**
  So `fill('20')` leaves the CONTROL reading 20 and the MODEL holding the old
  value, and the next round-trip sends the old one (app 363: no clamp, no
  toast, and the port looked broken). Commit with `press('Enter')` — then
  remember that the commit is itself a round-trip, so an OverflowToolbar
  popover you opened to reach the field is now closed and the button you press
  next has to be revealed again.
- **`bIsDestroyed` is not enough — check the node is still in the document.**
  Between a round-trip's answer and the old control's teardown it is neither
  destroyed nor null-ref'd, just DETACHED, so `find(…)` keeps handing back the
  previous control with its previous state. App 351 passed in isolation and
  failed in a full run on exactly this. Use
  `!c.bIsDestroyed && c.getDomRef() && document.body.contains(c.getDomRef())`.
- **A predicate passed to `waitForUi5` runs in the PAGE.** It is stringified,
  so it cannot call another function from your module — `() => sideShown() === false`
  fails with `sideShown is not defined`. Inline the whole check. And remember
  `waitForUi5` waits for TRUE: to assert a state is absent *now*, read it with
  `page.evaluate` and compare, or the wait will sit there waiting for the very
  thing you meant to rule out (app 344's first draft did, and its message then
  described a failure the wait could never produce).
- **UI5 hides a grid cell with a CLASS, not inline display.**
  `DynamicSideContent._changeGridState` adds `sapUiHidden`; both cells report
  `style.display === ''` at every breakpoint, so a predicate reading inline
  display answers the same thing before and after a toggle (app 344).
- **An unthemed ShellBar button has no `sapFShellBar…` class.** It renders as a
  plain `<button>` with a generated id and the accessible name from its
  tooltip, so `getByRole('button', { name: 'Menu' })` finds it where a class
  locator finds nothing and dies in a 30 s timeout (app 301).
- **A row selector cell has a layout box and still cannot be clicked.**
  `sapUiTableRowSelectionCell` measures 1264×20 in the unthemed harness (it
  spans the whole row instead of its narrow column) but sits in the absolutely
  positioned row-header layer UNDER the data cells, so every actionability
  check reports the pointer intercepted and `.click()` dies in a 30 s timeout.
  `dispatchMouse()` is the answer — the same one the zero-size-icon rule gives,
  for the opposite reason.
- **A bound aggregation stops at 100 items — that is the JSONModel default
  `sizeLimit`, not a broken binding.** The model holds all 123 mock rows while
  `getSuggestionItems()`/`getItems()` answers 100, so an assertion on the full
  mock row count fails against a perfectly faithful port (app 420). Assert the
  cap (or `>= 100`), and remember the original sample is capped the same way.
- **A BOOLEAN event arg reaches the transpiled backend as the string
  `'false'`/`'true'`, not as abap_bool.** On a real system the framework's
  ajson path normalizes a JSON boolean `t_arg` to `X`/space (the
  `port-a-sample` rule), but in the e2e runtime the same arg lands verbatim —
  so `get_event_arg( ) = abap_false` never matches, the flag never flips, and
  the response carries no model delta: the wire reads as dead while the port
  is correct (app 099 still carries the latent form; app 421 hit it live).
  For a wire the smoke must drive, transport a string token instead
  (`${$parameters>/isTopPage} ? 'top' : 'sub'`) — deterministic on both
  runtimes. The divergence itself belongs upstream (open-abap/ajson boolean
  node handling); file it in the abap2UI5 backlog when touching this next.
