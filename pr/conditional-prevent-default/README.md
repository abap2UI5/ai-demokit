# pr/conditional-prevent-default — the event veto must be expressible per firing, not only per wire

**Status: open** — filed against
[abap2UI5/abap2UI5](https://github.com/abap2UI5/abap2UI5). Measured, not
argued: `node scripts/probes/conditional-veto-probe.mjs` (real OpenUI5,
Playwright, one `columnResize` wire over two columns).

## Motivation

abap2UI5 can already veto a control's built-in default for an event, and it is
a genuinely good mechanism: `s_ctrl-check_prevent_default = abap_true` makes
the backend emit `.eBP($event, …)` instead of `.eB(…)`, and `eBP` calls
`oEvent.preventDefault()` before round-tripping, so the backend — not the
control — decides what happens. App **241** ports `sap.tnt.NavigationList`'s
`itemPress` veto 1:1 with it, and it closed app **136**'s toggle veto in the
2026-08-05 harvest.

It cannot express the other half of the family. App **247**
(`sap.ui.table.sample.ColumnResizing`) blocks resizing **one** column and lets
every other column through — the **same** `columnResize` event, on the **same**
table, one wire. The flag is a boolean baked per wire at render time, so it is
all-or-nothing: either no column can be resized or none is protected. The port
drops the veto and the deviation stands as `IMPROVISED`:

> *"Re-judged 2026-08-05 against the veto flag (`s_ctrl-check_prevent_default`)
> that closed app 136: it does NOT help here. The flag is baked per WIRE at
> render time, and this veto is per COLUMN — the sample blocks resizing one
> column while allowing the others through the same event."*

This is not an exotic shape. UI5 marks 40+ events `allowPreventDefault: true`,
and a controller that vetoes them almost always vetoes *conditionally* — the
condition is the point. `sap.ui.table.Table.columnResize` is declared

```js
columnResize: {
  allowPreventDefault: true,
  parameters: {
    column: { type: "sap.ui.table.Column" },   // <- the discriminator
    width:  { type: "sap.ui.core.CSSSize" }
  }
},
```

so the value the condition needs is right there on the event.

## Current behavior

`z2ui5_if_types=>ty_s_event_control` (`src/02/z2ui5_if_types.intf.abap`):

```abap
BEGIN OF ty_s_event_control,
  check_allow_multi_req TYPE abap_bool,
  check_prevent_default TYPE abap_bool,
END OF ty_s_event_control.
```

`z2ui5_cl_core_srv_event=>get_event` (`src/01/02/…srv_event.clas.abap`) turns
the flag into a different function name and one extra argument:

```abap
IF s_cnt-check_prevent_default = abap_true.
  lv_func = z2ui5_if_core_types=>cs_ui5-event_backend_prevent.   " eBP
  lv_event_arg = `$event,`.
ELSE.
  lv_func = z2ui5_if_core_types=>cs_ui5-event_backend_function.  " eB
ENDIF.
```

and `eBP` (`app/webapp/controller/View1.controller.js`) prevents
unconditionally:

```js
eBP(oEvent, ...args) {
  if (typeof oEvent?.preventDefault === "function") {
    oEvent.preventDefault();
  }
  this.eB(...args);
},
```

There is no route around it from the app side. The backend cannot decide
either: `preventDefault()` only has an effect synchronously inside the
control's own handler, which is precisely why `eBP` exists — by the time the
round-trip returns, the default has happened.

## Proposed change

Let the veto be a **condition** rather than a constant, using the mechanism
abap2UI5 already has for event arguments: a `$`-prefixed value is emitted RAW
into the handler string and resolved by UI5's
`EventHandlerResolver` → `BindingParser.parseExpression`, so it may be any UI5
expression (documented capability, proven by
`scripts/probes/event-arg-expression-probe.mjs`).

1. **ABAP** — one added field, no breaking change:

   ```abap
   BEGIN OF ty_s_event_control,
     check_allow_multi_req      TYPE abap_bool,
     check_prevent_default      TYPE abap_bool,
     " veto only when this client-side expression is truthy; when set it wins
     " over the flag, so one wire can protect one row/column and let the rest
     " through (e.g. `${$parameters>/column}.getId().indexOf('COL_DATE') >= 0`)
     prevent_default_expression TYPE string,
   END OF ty_s_event_control.
   ```

   In `get_event`, `eBP` is chosen when *either* is set, and the condition is
   emitted as the second argument — the literal `false` when only the flag form
   is used would change nothing, so the flag keeps emitting `true`:

   ```abap
   IF s_cnt-check_prevent_default = abap_true OR s_cnt-prevent_default_expression IS NOT INITIAL.
     lv_func      = z2ui5_if_core_types=>cs_ui5-event_backend_prevent.
     lv_event_arg = |$event,{ COND #( WHEN s_cnt-prevent_default_expression IS NOT INITIAL
                                      THEN s_cnt-prevent_default_expression
                                      ELSE `true` ) },|.
   ENDIF.
   ```

2. **Client** — `eBP` gains the parameter and is otherwise unchanged:

   ```js
   eBP(oEvent, bVeto, ...args) {
     if (bVeto && typeof oEvent?.preventDefault === "function") {
       oEvent.preventDefault();
     }
     this.eB(...args);
   },
   ```

The existing flag form keeps working byte-for-byte (it now sends the constant
`true`), and the round-trip payload is untouched in both forms.

### Measured

The probe wires **one** `columnResize` with **one** predicate over two columns
and fires each:

| firing | predicate | control default | round-trip |
|---|---|---|---|
| the blocked column | true | **vetoed** (`fireColumnResize` → `false`) | `["COLUMN_RESIZE", "100px"]` |
| any other column | false | **allowed** (`→ true`) | `["COLUMN_RESIZE", "100px"]` |

Same wire, same event, opposite outcomes — and the backend still receives its
event in both cases, which is the property the flag form guarantees today.

## Example

App 247's dropped veto, restored (the protected column carries an explicit id,
so the predicate is a plain expression over the event's own parameter):

```abap
)->a( n = `columnResize` v = client->_event(
          val    = `COLUMN_RESIZE`
          t_arg  = VALUE #( ( `${$parameters>/width}` ) )
          s_ctrl = VALUE #(
            prevent_default_expression = `${$parameters>/column}.getId().indexOf('COL_DELIVERY') >= 0` ) ) )
```

## Tests

`node/tests/` — extend the existing `eBP` spec with a conditional case (veto on
truthy, pass through on falsy, payload identical in both). ABAP side: the
existing `event_prevent_default` test in
`z2ui5_cl_core_srv_event.clas.testclasses.abap` gets a sibling asserting that
`prevent_default_expression` emits `eBP($event,<expr>,[…])` and that the plain
flag still emits `eBP($event,true,[…])`.
