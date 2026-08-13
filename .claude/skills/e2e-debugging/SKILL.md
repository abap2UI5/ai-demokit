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
- **A control with no theme CSS has a zero-size box, and playwright will not
  click or focus it** — the e2e harness serves the UI5 *sources*, not the
  themes, so `sapUiIcon` (an Input's value-help icon, app 268) and
  `sapMSliderHandle` (apps 270/271) measure 0×0 and every actionability check
  fails with *"not visible"*, which reads like a broken port. Both have a real
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
  time by `web/ci/patch_open_abap_xml.mjs`, which both transpiled builds apply
  (`web/` and `scripts/e2e-build.mjs`), and forwarded upstream as
  `pr/open-abap-xml-escaping`. Prefer `READ TABLE` over `tab[ … ]` in an app
  that must run there.
- **Type with a delay when the wire round-trips.** A per-keystroke round-trip
  is lossy, not queued (events fired mid-flight are dropped) — a no-delay
  `pressSequentially` asserts a value the wire never promised. Full rule (app
  280) in the `port-a-sample` guide's porting gotchas.
