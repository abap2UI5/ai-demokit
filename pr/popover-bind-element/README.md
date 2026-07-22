# popover-bind-element — element-bind a popup/popover to a row via `follow_up_action`

**Priority: medium** — concretely designed with the maintainer; an ergonomics
enhancement (the event-arg workaround already renders correctly in app 094).

## Motivation

A very common master-detail pattern: a list/table row has a control (link,
button) whose press opens a `Popover`/`Dialog` **bound to that row's binding
context**, so the fragment's relative bindings (`{Name}`, `{ProductPicUrl}`, …)
resolve against the pressed row. UI5 samples do:

```js
oPopover.bindElement(oEvent.getSource().getBindingContext().getPath());
```

Seen in `sap.m.sample.PopoverControllingCloseBehavior` (port app **094**); the
same shape recurs for any row → detail popover/dialog.

## Current behavior (works, but manual)

abap2UI5 has no "bind this popup to a row's context" step. app 094 works around
it by transporting the row's fields as event args and rebuilding the popover
from them (`t_arg = ( ${PRODUCT_ID} ) ( ${NAME} ) ( ${PRODUCT_PIC_URL} ) …`,
then `popover_display( … by_id = … )`). It **renders correctly** (live-checked),
but every field the detail view shows must be listed and threaded through by
hand.

## Proposed change — a `BIND_ELEMENT` `follow_up_action` (popup **and** popover)

Fits the existing `follow_up_action( val, view, t_arg )` signature — no new
method parameters, just a new frontend action value:

```abap
client->follow_up_action(
    val   = client->cs_event-bind_element               " new frontend action
    view  = client->cs_view-popover                     " or cs_view-popup
    t_arg = VALUE #( ( idx )                    " model-row index
                     ( client->_bind( mt_tab ) ) ) ).   " registered table binding
```

Then the fragment simply binds relative:

```abap
)->leaf( `Title` )->a( n = `text` v = `{NAME}` )
)->leaf( `Image` )->a( n = `src`  v = `{PRODUCT_PIC_URL}` )
```

### Why this shape

The second `t_arg` is **`client->_bind( mt_tab )`**, not a hand-written
`|/T_PRODUCTS/{ idx }|`. That call already:

- **registers** `mt_tab` into the model (so the popup/popover slot actually
  carries the table), and
- **returns its binding reference** (e.g. `{/MT_TAB}`), derived from the ABAP
  variable — rename-safe and model-consistent (the whole reason `_bind` exists
  instead of writing `{/VAR}` by hand). Renaming `mt_tab` moves the path with it;
  a text binding would silently break.

The `BIND_ELEMENT` action normalizes that reference (strips the `{ }`), appends
`/<idx>`, and sets it as the target slot's element binding (`bindElement` /
`setBindingContext`), routed to the `popup` / `popover` slot via the existing
`view` parameter (the same slot routing `control_by_id` already uses in
`get_event_client`).

## Implementation sketch (framework)

- ABAP: add `cs_event-bind_element VALUE 'BIND_ELEMENT'`; no new client method.
- JS `FrontendAction.js`: `BIND_ELEMENT: (c, args) => resolveSlotView(args).bindElement(stripBraces(binding) + '/' + idx)`,
  reading the slot from the injected `view` arg and `idx` + the `{…}` binding
  from `t_arg`.

## Note — `idx` is the model index

`idx` indexes `mt_tab` (the model row), not the visible position: app 094's
table has `sorter: { path: 'NAME' }`, so the displayed order differs from
`mt_tab`'s order. Pass the model index of the pressed row.

## Result once implemented

- app 094 drops the per-field event-arg transport and binds the fragment
  directly (fewer args, closer to the original); the `IMPROVISED` note softens
  to a `NOTE`.
- benefits every future row → detail-popover/dialog port, for both the popup
  and popover slots.
