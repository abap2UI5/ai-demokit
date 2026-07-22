# popover-bind-element — open a popover/dialog bound to an aggregation item's context

**Priority: low** — an ergonomics/elegance enhancement, not a blocker: the
event-arg workaround already renders correctly (verified live in app 094).

## Motivation

A very common master-detail pattern: a list/table row has a control (link,
button) whose press opens a `Popover`/`Dialog` **bound to that row's binding
context**, so the fragment's relative bindings (`{Name}`, `{ProductPicUrl}`, …)
resolve against the pressed row. UI5 samples do:

```js
oPopover.bindElement(oEvent.getSource().getBindingContext().getPath());
```

Seen in `sap.m.sample.PopoverControllingCloseBehavior` (port app **094**), and
the same shape recurs for any row → detail-popover.

## Current behavior (works, but manual)

abap2UI5 has no "bind this popup to the pressed item's context" step. The port
works around it by transporting the row's fields as event args and rebuilding
the popover from them:

```abap
" Link press: carry the row values out
)->a( n = `press` v = client->_event( val   = `POPOVER`
                                      t_arg = VALUE #( ( `${PRODUCT_ID}` ) ( `${NAME}` ) ( `${PRODUCT_PIC_URL}` ) ( `$event.oSource.sId` ) ) )
...
" on_event: build the popover from the args, anchor by sId
client->popover_display( xml = ... by_id = client->get_event_arg( 4 ) ).
```

This **renders correctly** (live-checked: title, name and image are right, the
popover anchors to the link). The cost is boilerplate: every field the detail
view shows must be listed as an event arg and threaded through, instead of the
fragment simply binding `{Name}` against the row.

## Proposed change

An optional `bind_element` path on `popover_display` / `popup_display`, e.g.

```abap
client->popover_display( xml         = frag->stringify( )
                         by_id       = client->get_event_arg( )       " anchor
                         bind_element = |/T_PRODUCTS/{ idx }| ).       " row context
```

so the fragment can use relative bindings (`{NAME}`, `{PRODUCT_PIC_URL}`)
resolved against the given path — the direct analogue of `oPopover.bindElement`.
The pressed row index/path is already transportable (`$event.oSource.sId`, or a
row index arg), so no new client plumbing beyond setting the popup's binding
context after creation.

## Result once implemented

- app 094 drops the per-field event-arg transport and binds the fragment
  directly (fewer args, closer to the original), IMPROVISED note softened to a
  NOTE.
- benefits every future row → detail-popover/dialog port.
