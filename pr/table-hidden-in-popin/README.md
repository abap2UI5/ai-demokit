# table-hidden-in-popin — whitelist `setHiddenInPopin` (+ `setContextualWidth`)

**Priority: medium** — makes the auto-pop-in demo interactive; matches the
established `CONTROL_METHODS` extension pattern.

## Motivation

`sap.m.sample.TableAutoPopin` (port app **092**) demonstrates a responsive
`sap.m.Table` with `autoPopinMode="true"`. Two interactions drive the demo:

- a `MultiComboBox` whose `selectionFinish` calls
  `oTable.setHiddenInPopin(aSelectedImportanceKeys)` — hide columns of a chosen
  importance from the pop-in area;
- a `Slider` whose `liveChange` calls `oTable.setWidth(value + "%")` to shrink
  the table and trigger the pop-in.

Both are imperative `byId(...).setX()` controller calls. `autoPopinMode` and
`Column.importance` themselves are declarative and port 1:1, but the two
setters have no ABAP-callable equivalent, so app 092 declares them dropped
(the Slider/MultiComboBox render but are inert).

## Current behavior

`app/webapp/core/FrontendAction.js` `CONTROL_METHODS` (the `CONTROL_BY_ID`
whitelist) already carries a growing set of safe setters/methods — `open`,
`close`, `setExpanded`, `openBy`, `toggleBy`, `setActivePage`, `expandToLevel`,
`collapseAll`, `to`, … added incrementally as ports needed them (see
`pr/README` Implemented table). `setHiddenInPopin` and `setContextualWidth`
are **not** in the list, so `follow_up_action( cs_event-control_by_id … )`
rejects them.

## Proposed change

Add to `CONTROL_METHODS`:

- `setHiddenInPopin: ["stringArray"]` — `sap.m.Table.setHiddenInPopin(aKeys)`
  (the importance keys `None|Low|Medium|High`);
- optionally `setContextualWidth: ["string"]` — `sap.m.Table.setContextualWidth`
  (for the slider-driven width, or a documented boundary if width-by-slider is
  considered cosmetic).

Then app 092 wires:

```abap
" MultiComboBox selectionFinish → hide the selected importances
client->follow_up_action( val   = client->cs_event-control_by_id
                          t_arg = VALUE #( ( `idProductsTable` ) ( `setHiddenInPopin` ) ( selected_keys_json ) ) ).
```

The `stringArray` arg kind (a JSON array of keys) already exists for
`binding_call` filter groups, so the payload shape is precedented.

## Result once implemented

- app 092's `MultiComboBox` becomes functional (hide-by-importance), its
  `IMPROVISED` deviation reduces to the (cosmetic) slider width only or drops
  entirely.
- covers any future `sap.m.Table` responsive-pop-in sample.
