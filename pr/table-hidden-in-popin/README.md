# table-hidden-in-popin — whitelist `setHiddenInPopin` (+ `setContextualWidth`)

**Priority: medium** — makes the auto-pop-in demo interactive; matches the
established `CONTROL_METHODS` extension pattern.

> **Status: IMPLEMENTED.** `setHiddenInPopin` is whitelisted in
> `CONTROL_METHODS` (`["object"]`, both the webapp `FrontendAction.js` and the
> ABAP generator mirror) on branch `claude/ai-demokit-edge-cases-ftv30b` of
> abap2UI5. App 092 is wired: the `MultiComboBox` `selectedKeys` are two-way
> bound to `t_hidden` and its `selectionFinish` forwards them as a JSON
> Priority array through `follow_up_action( cs_event-control_by_id,
> setHiddenInPopin )`. The `Slider` `setWidth` (`setContextualWidth`) part is
> not implemented — the Slider still renders inert.

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

- `setHiddenInPopin: ["object"]` — `sap.m.Table.setHiddenInPopin(aKeys)`
  (the importance keys `None|Low|Medium|High`, passed as a JSON array the
  client `JSON.parse`s — the same `object` arg kind `setContextualWidth`-style
  payloads and `binding_call` filter groups already use);
- optionally `setContextualWidth: ["string"]` — `sap.m.Table.setContextualWidth`
  (for the slider-driven width, or a documented boundary if width-by-slider is
  considered cosmetic).

Then app 092 wires:

```abap
" MultiComboBox selectionFinish → hide the selected importances
client->follow_up_action( val   = client->cs_event-control_by_id
                          t_arg = VALUE #( ( `idProductsTable` ) ( `setHiddenInPopin` ) ( selected_keys_json ) ) ).
```

> **As shipped:** `setHiddenInPopin` is whitelisted as `["object"]` (JSON array
> parsed on the client), exactly the form above.

## Result once implemented

- app 092's `MultiComboBox` becomes functional (hide-by-importance), its
  `IMPROVISED` deviation reduces to the (cosmetic) slider width only or drops
  entirely.
- covers any future `sap.m.Table` responsive-pop-in sample.
