# pr/table-set-sticky — an array-valued control property needs a whitelist entry (`sap.m.Table.sticky`)

**Status: open** — found by the IMPROVISED harvest 2026-08-05
(`node scripts/probes/improvised-cluster.mjs --family array-property`),
3 deviations in apps **009 · 022 · 235**.

## Motivation

`sap.m.Table.sticky` (`sap.m.Sticky[]`) decides which parts of a table stay
fixed while scrolling — `ColumnHeaders`, `HeaderToolbar`, `InfoToolbar`. Three
demo kit samples let the user toggle them with CheckBoxes, and each does it the
same way: build a JS array and call `oTable.setSticky(aSticky)`.

The corpus reproduced this **twice, differently, both times worse**:

- app **009** (`sap.m.sample.Column`) mirrors the array server-side: every
  CheckBox `select` round-trips `${$source>/text}` and `${$parameters>/selected}`,
  the ABAP handler inserts/removes that option in a string table and pushes the
  whole model back via `view_model_update`. One full round-trip per click for a
  purely client-side toggle.
- apps **022 · 235** (`sap.m.sample.FacetFilter`) **dropped the feature**: the
  sticky options Label and all three CheckBoxes are gone from the port,
  because "neither an array property binding nor a `setSticky` whitelist entry
  is a proven path".

So the same UI5 property produced a heavy improvisation in one port and a
structural deletion in two others.

## Current behavior (source)

`app/webapp/core/FrontendAction.js` resolves an unlisted control method through
the generalized allowlist with **inferred** argument kinds:

```js
function castArgAuto(raw) {
  if (raw === "X" || raw === "true") return true;
  if (raw === "" || raw === " " || raw === "false") return false;
  return raw;                      // everything else stays a string
}
```

`setSticky` therefore receives the string `"ColumnHeaders,HeaderToolbar"`
instead of an array, and UI5 rejects it. The mechanism for exactly this case
already exists one line up — `setHiddenInPopin` declares the `object` kind and
its argument is parsed as JSON:

```js
setHiddenInPopin: ["object"],   // sap.m.Table: hide columns by importance (JSON array of Priority keys)
…
case "object":
  try { return JSON.parse(raw); } catch { return {}; }
```

App 092 uses that path today for the pop-in demo. `sticky` is the identical
shape: an array of enum keys on the same control.

## Proposed change

One line in `CONTROL_METHODS`:

```js
setSticky: ["object"],   // sap.m.Table/sap.m.List: JSON array of sap.m.Sticky keys
```

No new arg kind, no new dispatch path — the `object` cast, the JSON parse and
the allowlist guard are all in place. `sap.m.ListBase.setSticky` is public and
does not match `CONTROL_METHOD_DENY`, so today it is *reachable but broken*
(it silently gets a string); the entry turns it into a working, declared wire.

## Example (app 022/235, `sap.m.sample.FacetFilter`)

```abap
" the three CheckBoxes stay in the view 1:1 and are two-way bound;
" one roundtrip-free wire pushes the resulting array to the table:
client->_event_client(
  val   = client->cs_event-control_by_id
  t_arg = VALUE #( ( `idProductsTable` )
                   ( `setSticky` )
                   ( `["ColumnHeaders","HeaderToolbar"]` ) ) ).
```

App 009 loses its per-click round-trip and its server-side array mirror; apps
022 and 235 get their dropped Label + three CheckBoxes back, so the ports stop
deviating structurally from the original view.

## Affected ports

| App | Sample | Today |
|-----|--------|-------|
| 009 | `sap.m.sample.Column` | array mirrored server-side, one round-trip per CheckBox click |
| 022 | `sap.m.sample.FacetFilter` | Label + 3 CheckBoxes dropped from the view |
| 235 | `sap.m.sample.FacetFilter` (2nd) | Label + 3 CheckBoxes dropped from the view |
