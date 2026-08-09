# pr/control-method-named-removeall — the `removeAll` deny prefix also blocks the *named* per-aggregation methods

**Status: open** — filed against
[abap2UI5/abap2UI5](https://github.com/abap2UI5/abap2UI5), raised while porting
`sap.ui.unified.sample.CalendarMultipleDaySelection`
(`z2ui5_cl_dmo_app_307`, 2026-08-09).

## Motivation

`CONTROL_METHOD_DENY_PREFIXES` in
[`app/webapp/core/FrontendAction.js`](https://github.com/abap2UI5/abap2UI5/blob/main/app/webapp/core/FrontendAction.js)
documents its own intent precisely:

> … and the GENERIC reflection aggregation mutators
> (`setAggregation`/`add`/`insert`/`remove*` and `removeAll*`) which reparent
> tracked controls behind the framework's back **(the named per-aggregation
> methods above remain allowed)**.

The comment's parenthesis is the rule everyone relies on: `addItem`,
`removeItem`, `setVisible` and friends are the API the backend legitimately
drives, and only the *generic*, aggregation-name-as-argument reflection
variants are denied.

The implementation does not match it. The denylist is a **prefix** regex, so

```js
"removeAll",            // meant: removeAllAggregation(sName)
```

matches every *named* method that starts with the same eight characters —
`removeAllSelectedDates`, `removeAllItems`, `removeAllContent`,
`removeAllSpecialDates`, … The same happens for `destroy`, which is meant to
guard `destroy()` itself but also blocks `destroySpecialDates()` and
`destroyItems()`.

## Effect on a port

`CalendarMultipleDaySelection`'s "Remove All Selected Dates" button is exactly
one call:

```js
handleRemoveSelection: function() {
    this.byId("calendar").removeAllSelectedDates();
    this._clearModel();
}
```

`sap.ui.unified.Calendar.selectedDates` cannot be driven from the model here
(the control writes the user's selection into that aggregation itself), so the
port has no bindable alternative: `z2ui5_cl_dmo_app_307` clears its own list
and the days stay highlighted in the calendar. The same gap will hit any port
whose original resets an aggregation it does not own — `removeAllItems`,
`removeAllContent`, `destroyItems`.

## Proposed change

Deny the *generic* reflection mutators by exact name instead of by prefix, and
keep the named per-aggregation variants allowed — i.e. what the comment already
says:

```js
const CONTROL_METHOD_DENY_EXACT = [
  "removeAllAggregation", "removeAggregation", "addAggregation",
  "insertAggregation", "setAggregation", "destroy", "exit", …
];
```

and keep only the prefixes that are genuinely framework-hostile in every
spelling (`_`, `bind`, `unbind`, `attach`, `detach`, `setBinding`, `setModel`,
`setParent`, `addDependent`, `placeAt`, `rerender`, `invalidate`, `clone`,
`applySettings`, `setAssociation`).

`destroy<Aggregation>()` and `removeAll<Aggregation>()` destroy or detach
controls the *control itself* owns — the same footprint `removeItem` already
has — so they carry no invariant the current allowlist does not already accept.

## Until then

`z2ui5_cl_dmo_app_307` declares the loss as an `IMPROVISED` deviation naming
this folder.
