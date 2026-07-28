# A null-safe `Formatter.DateCreateObject` (empty string → `null`, not Invalid Date)

**Priority: low** — every port can already guard the empty case itself with an
expression binding (app 220 does, and it is the documented convention now), so
this is a robustness improvement, not a blocker. Filed because the current
behaviour turns a missing optional date into a **whole-view crash** rather than
a missing value, and the failure gives no hint where it came from.

## Motivation

Date-object properties (`type: "object"`) are fed from ISO strings in the ABAP
model and converted at the point of use with the curated formatter — the
convention CAPABILITIES.md records:

```abap
)->a( n = `startDate` v = |\{ path: 'START', formatter: 'Formatter.DateCreateObject' \}|
```

That works as long as every row has a value. A **bound aggregation whose rows
carry an optional date** breaks it, because one template cannot omit an
attribute per row. App 220 (`sap.ui.unified.sample.CalendarMinMax`) is the
minimal case: its second disabled range is a *single day*, so the original
sample's row simply omits `end`:

```js
disabled: [
  {start: UI5Date.getInstance(2016, 0, 4), end: UI5Date.getInstance(2016, 0, 10)},
  {start: UI5Date.getInstance(2016, 0, 15)}          // <- no end
]
```

In ABAP that row serializes with `END` empty, and the formatter turns it into
an **Invalid Date**:

```js
// abap2UI5 app/webapp/model/formatter.js (mirrored in
// z2ui5_cl_app_formatter_js)
DateCreateObject(s) {
  return new Date(s);        // new Date('')  ->  Invalid Date
}
```

`DateRange.setEndDate()` accepts it — the property is typed `object` — and the
damage surfaces much later, in the consumer:

```js
// sap/ui/unified/calendar/Month.js  _checkDateEnabled
var oEndDate = oRange.getEndDate();
if (oEndDate) {                                       // Invalid Date is TRUTHY
  oEndDate = CalendarDate.fromLocalJSDate(oEndDate);  // throws
}
```

`MonthRenderer` calls `_checkDateEnabled` for every rendered day, so the throw
takes the whole view down.

## Evidence

`scripts/probes/calendar-empty-enddate-probe.mjs` in this repo, against the real
OpenUI5 runtime in headless Chromium, with the calendar focused on the month
that carries the disabled dates:

| Scenario | `endDate` per `DateRange` | Days rendered | Errors |
|---|---|---|---|
| A — formatter binding, empty `END` row present | — | **0** | `THROW: Date must be a JavaScript or UI5Date date object.` |
| B — formatter binding, empty row removed (control) | `Date(2016-01-10)` | 42 | none |
| C — expression binding with a falsy guard | `Date(2016-01-10)`, `null` | 42 | none |

## Current workaround (shipped)

Guard the conversion in the binding, written as a **backtick** literal so the
braces reach the attribute:

```abap
)->a( n = `endDate` v = `{= ${END} ? Formatter.DateCreateObject(${END}) : null }`
```

App 220 ships this, AGENTS §10 and CAPABILITIES.md document it, and the
pattern-lint rule `unguarded-date-formatter` fails any port that binds
`Formatter.DateCreateObject` over a field the same class seeds empty.

## Proposed change

Make the curated formatter return `null` for a falsy input, so a missing
optional date behaves like an absent one instead of an invalid one:

```js
DateCreateObject(s) {
  return s ? new Date(s) : null;
}
```

Both copies would change together — `app/webapp/model/formatter.js` and its
ABAP generator mirror `z2ui5_cl_app_formatter_js` — and the render-smoke
harness mirror (`scripts/render-smoke.mjs`) plus the probe above would follow.

The same argument applies to `DateAbapDateToDateObject` /
`DateAbapDateTimeToDateObject`, which build a date from `parseYmd()` slices: an
empty ABAP date field yields `new Date(NaN, NaN, NaN)`, the same truthy Invalid
Date.

### Compatibility

Any app relying on receiving an Invalid Date from an empty string would change
behaviour — but an Invalid Date is not a usable value for any UI5 date
property, so the realistic effect is turning a late crash into an unset
property. Apps that already carry the expression-binding guard keep working
unchanged (the guard short-circuits before the call).

### Why it is still worth doing with the workaround in place

The workaround only helps a port that *knows* the field can be empty. The
failure mode without it is maximally unhelpful: the exception names neither the
control nor the field, fires from the renderer rather than from the binding,
and takes the entire view with it — for what is, semantically, just an optional
value.

*From app 220 (`sap.ui.unified.sample.CalendarMinMax`), 2026-07-28.*
