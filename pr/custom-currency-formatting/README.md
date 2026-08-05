# pr/custom-currency-formatting — register custom currencies (global `Formatting` config)

**Status: open** — found by the IMPROVISED harvest 2026-08-05
(`node scripts/probes/improvised-cluster.mjs --family formatting-config`),
1 deviation in app **196**.

## Motivation

UI5 formats a currency amount by the number of decimals its currency code
declares. An application that uses a code UI5 does not know — or one that needs
different decimals than the standard — registers it once:

```js
Formatting.setCustomCurrencies({ BGN4: { digits: 4 }, WWWW: { digits: 5 } });
```

App 196 (`sap.ui.unified.sample.Currency`) is built around this: its fifth list
demonstrates two custom currencies. The port renders those amounts with UI5's
default digit count instead of 4 and 5 — the sample's actual subject is the one
thing missing from it.

This is not sample-only exotica. Currency decimals differ from SAP's `TCURX`
handling, and any abap2UI5 app that displays a `CURR` field with a non-standard
`CURRDEC` hits the same wall: the value is correct in ABAP and displayed wrong
in the browser, with no way to correct it from the backend.

## Current behavior (source)

`sap/ui/core/Formatting` is a **module-level singleton with no control and no
id** (like `Theming`, which abap2UI5 already wires). `app/webapp/core/FrontendAction.js`
lists the global objects it will dispatch against:

```js
const GLOBAL_TARGETS = {
  MESSAGE_TOAST: …, MESSAGE_BOX: …, BUSY_INDICATOR: …,
  THEMING: { get: () => sap.ui.require("sap/ui/core/Theming"), methods: { setTheme: ["string"] } },
  POPUP:   { get: () => sap.ui.require("sap/ui/core/Popup"),   methods: { setWithinArea: ["within"] } },
};
```

There is no `FORMATTING` entry, so the configuration cannot be reached at all.
The corpus's usual fallbacks do not apply either: it is not a control property
(nothing to bind), and the curated formatter module
(`app/webapp/model/formatter.js`) formats one binding at a time — it cannot
register a currency for the standard `sap.ui.model.type.Currency` type that the
ports keep 1:1.

## Proposed change

A `FORMATTING` target, resolved lazily like `THEMING` (the module moved to
`sap/ui/core/Formatting` in 1.120; on older runtimes the require returns
`undefined` and the existing "not available" guard reports it):

```js
FORMATTING: {
  get: () => sap.ui.require("sap/ui/core/Formatting"),
  methods: {
    setCustomCurrencies: ["object"],   // JSON: { CODE: { digits: n }, … }
    addCustomCurrency:   ["string", "object"],
  },
},
```

`object` is the existing JSON-parsing argument kind (`setHiddenInPopin` uses
it), so the payload stays declarative data on the wire — a currency table the
backend owns anyway.

The same target is the natural home for the neighbouring global formatting
settings (`setLanguageTag`, `setUnitMappings`) if they are ever needed; only the
two currency methods are requested here, because only those are backed by a
sample.

## Example (app 196, `sap.ui.unified.sample.Currency`)

```abap
" on init, before the view is displayed:
client->follow_up_action( val = client->_event_client(
  val   = client->cs_event-control_global
  t_arg = VALUE #( ( `FORMATTING` )
                   ( `setCustomCurrencies` )
                   ( `{"BGN4":{"digits":4},"WWWW":{"digits":5}}` ) ) ) ).
```

and list five renders 4 and 5 decimals, as the sample intends.

## Affected ports

| App | Sample | Today |
|-----|--------|-------|
| 196 | `sap.ui.unified.sample.Currency` | the two custom currencies render with UI5's default digits |
