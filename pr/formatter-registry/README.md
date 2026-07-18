# App-level formatter functions for XML binding strings

> **Status: implemented upstream (2026-07-18) — as a curated module, after
> a security detour.** An eval-based first design (`register_formatter`
> shipping JS strings compiled with the `Function` constructor) was
> implemented and **reverted the same day**: it required `unsafe-eval` in
> the CSP - against the framework's strict-CSP direction - and a
> register-a-JS-string API invites building formatter bodies from data, a
> server-mediated XSS foot-gun. The shipped design instead follows what an
> original UI5 app does: a **formatter file in the standard app layout** -
> `app/webapp/model/formatter.js`, next to `model/models.js`. It is a
> real, served script resource, wired into views via
> `core:require="{Formatter: 'z2ui5/model/formatter'}"` (UI5 ≥ 1.74) and
> additionally published as the `z2ui5.Formatter` global for older
> releases; first entries `weightState` plus re-exports of the
> `z2ui5.Util` date helpers - Util stays the stable legacy alias and can
> fold in fully over time. No ABAP API change involved.

## Summary

Demo kit samples routinely bind with **custom JS formatter functions**
(`Formatter.js` modules, `formatter: '.fn'` controller methods). abap2UI5
apps had no formatter file to reference, so ports had to preformat in ABAP
or rebuild the logic as expression bindings.

## How it works now

The framework ships the formatter file all abap2UI5 apps share, in the
standard location an original app keeps it (`webapp/model/formatter.js`).
A view wires it exactly like an original app wires its formatter - the
original requires `./Formatter` in the controller and binds
`.formatter.weightState`; here the module is required into the view:

```abap
)->a( n = `xmlns:core`   v = `sap.ui.core`
)->a( n = `core:require` v = `{Formatter: 'z2ui5/model/formatter'}`
...
" the original: state="{ parts: [...], formatter: '.formatter.weightState' }"
)->a( n = `state` v = |\{ parts: [\{path: 'WEIGHT_MEASURE'\}, \{path: 'WEIGHT_UNIT'\}], formatter: 'Formatter.weightState' \}|
```

`core:require` needs UI5 ≥ 1.74 (declare POST_171 in a port); on older
releases the published `z2ui5.Formatter` global serves as the reference.

- **CSP-clean by construction**: the functions are part of the served
  frontend (embedded/preloaded like every other framework module) - no
  runtime code generation, no `unsafe-eval`, nothing compiled from strings.
- **Curated growth**: new formatters are added via framework PRs (the same
  model as the `control_call_by_id` whitelist). Scope: general-purpose value
  formatters; app-specific one-offs stay in expression bindings.
- **One module perspective**: the formatter module re-exports the
  `z2ui5.Util` date helpers, so new code references a single module;
  `z2ui5.Util` remains the unchanged legacy alias.

## What still lands in expression bindings

Truly app-specific logic that does not belong in a shared curated module -
UI5's expression parser evaluates `{= … }` with whitelisted globals
(`parseFloat`, `isNaN`, `Math`, …), CSP-safe, and covers most one-off
threshold/concat/ternary formatters. `groupHeaderFactory` / list-item
factories return **controls**, not values, and stay out of scope entirely
(unroll statically, note it).

## Evidence

`z2ui5_cl_ai_app_401` requires the module on its view root and binds the
appended table's weight state with the original parts+formatter structure
as `Formatter.weightState` (LIVE-TEST pending); the render-smoke harness
mirrors the module's fixed contract. Source: abap2UI5
`app/webapp/model/formatter.js`, published in `Component.js`, specs in
`node/tests/formatter.spec.js`.
