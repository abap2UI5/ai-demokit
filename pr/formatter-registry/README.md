# App-supplied client-side formatter functions

> **Status: open.** An eval-based first design (`register_formatter`
> shipping JS strings compiled with the `Function` constructor) was
> implemented upstream on 2026-07-18 and **reverted the same day as a
> security decision**: it required `unsafe-eval` in the CSP - against the
> framework's strict-CSP direction (security headers, deprecation of the
> follow-up custom-JS path) - and an official register-a-JS-string API
> invites apps to build formatter bodies from data, a server-mediated XSS
> foot-gun. Any future implementation must deliver formatters **without
> runtime code generation** (see the design constraint below).

## Summary

Demo kit samples routinely bind with **custom JS formatter functions**
(`Formatter.js` modules, `formatter: '.fn'` controller methods,
`groupHeaderFactory`, list-item factories). abap2UI5 has no way for an app to
supply such a function, so ports must reproduce the logic another way or
preformat in ABAP.

## What already works today (no framework change)

**Simple value formatters are often expressible as expression bindings.**
UI5's expression parser evaluates `{= … }` with a fixed whitelist of globals
(`parseFloat`, `parseInt`, `isNaN`, `Math`, `Number`, `String`, `JSON`, …) -
no eval, CSP-safe. The `weightState` formatter of
[sap.m.sample.Table](https://sdk.openui5.org/entity/sap.m.Table/sample/sap.m.sample.Table)
is reproduced behavior-identically this way in `z2ui5_cl_ai_app_401`:

```abap
)->a( n = `state` v = `{= isNaN(parseFloat(${WEIGHT_MEASURE})) ? 'None' :`                                                       &&
                      ` (${WEIGHT_UNIT} === 'G' ? parseFloat(${WEIGHT_MEASURE}) / 1000 : parseFloat(${WEIGHT_MEASURE})) < 1 ? 'Success' :` &&
                      ...
```

This covers every formatter whose logic fits the whitelist (arithmetic,
comparisons, string/number conversions, ternaries). It does not cover
formatters needing UI5 modules, locale data, dates beyond `Date`, regexes
with state, or reuse across many views without repetition.

## The remaining gap

- Formatter logic beyond the expression whitelist (module access, shared
  helpers, complex branching kept readable).
- `groupHeaderFactory` / list-item factories - these return **controls**,
  not values, and are out of scope for any formatter mechanism.

## Design constraint for a future implementation

No runtime code generation. A CSP-clean route would deliver formatter
modules as **same-origin script resources**, the way the framework already
serves its own embedded modules (preload mechanics, `z2ui5.Util` global /
`core:require`):

- the app (or an exit/config step) contributes a real JS module at
  deployment/bootstrap time, served like the embedded frontend classes;
- views reference it via `core:require` or a published global - identical
  binding syntax to `z2ui5.Util` today;
- nothing is compiled from strings at runtime, so a strict CSP without
  `unsafe-eval` keeps working.

Trade-off to discuss upstream: registration becomes per-deployment instead
of per-response, and the contribution path (exit class? repository object?
config?) needs a proper design - which is exactly why this stays a request
rather than a quick PR.

## Workaround today

Expression binding where the whitelist suffices (app 401); otherwise
preformat the value in ABAP and bind the result, noted as a deviation.
