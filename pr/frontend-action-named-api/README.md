# pr/frontend-action-named-api — named wrappers for the positional `t_arg` wire

**Status: open** — proposal for
[abap2UI5/abap2UI5](https://github.com/abap2UI5/abap2UI5), surfaced by the
2026-08-11 corpus review. Purely additive API sugar: the wire and the frontend
stay byte-identical, so the thin-frontend principle is untouched.

## Motivation

The frontend-action surface (`follow_up_action` and `_event_client`) is the
single most error-prone API in the corpus, because everything is a positional
`string_table`:

```abap
client->_event_client( val   = client->cs_event-control_global
                       t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                        ( `show` )
                                        ( `Item selected: {0}` )
                                        ( `${$parameters>/item}.getText()` ) ) )
```

Measured over this corpus: **425 `_event_client` + 99 `follow_up_action`
calls in 130 of 365 ports**. The tuple order (object, method, template, args…
— different per event kind), the wire tokens (`MESSAGE_TOAST`, not
`MessageToast`), and the unvalidated id slot are all things the compiler
cannot check. The project history shows what that costs:

- the `idiom-lookup` guide needs dedicated rows just to document tuple order
  per event kind;
- two linter rules exist only to catch mistakes this API invites
  (`frontend-action-unknown-id`; the `CONTROL_METHODS` arg-kind audits);
- four of the recent framework rounds were argument-shape incidents on this
  wire (`control-method-args` → #2535, `control-method-null-arg`,
  `aggregation-item-address`, `table-set-sticky` — see `pr/README.md`
  Implemented table).

## Current behavior

`z2ui5_if_client` (src/02/z2ui5_if_client.intf.abap) offers exactly two
entries for every frontend action:

```abap
METHODS follow_up_action IMPORTING val TYPE string
                                   view TYPE clike DEFAULT cs_view-main
                                   t_arg TYPE string_table OPTIONAL.
METHODS _event_client    IMPORTING val TYPE clike
                                   view TYPE clike DEFAULT cs_view-main
                                   t_arg TYPE string_table OPTIONAL
                         RETURNING VALUE(result) TYPE string.
```

The per-kind argument contracts live only in the (long) ABAP Doc comment and
in `app/webapp/core/FrontendAction.js`.

## Proposed change

Add named convenience methods that build the same `t_arg` internally and
delegate to the existing pair — one per high-frequency kind, both in a
round-trip (`follow_up_…`) and a wire (`…_client`, returns the handler
string) flavor where both exist:

```abap
" control_by_id — today: t_arg = id / method / params
client->control_call( id = `carousel` method = `setActivePage`
                      t_arg = VALUE #( ( `carousel/pages/2` ) ) ).

" client-composed toast — today: MESSAGE_TOAST / show / template / args
)->a( n = `press` v = client->toast_client(
          template = `Item selected: {0}`
          t_arg    = VALUE #( ( `${$parameters>/item}.getText()` ) ) )

" binding_call filter — today: id / aggregation / `filter` / path / op / v1 / v2
client->binding_filter( id = `list` aggregation = `items`
                        path = client->_bind( val = t_items path = abap_true )
                        operator = `Contains` value1 = search ).
```

Design points:

- **Additive only.** `follow_up_action` / `_event_client` stay as the generic
  escape hatch (new frontend capabilities always land there first); nothing
  is deprecated.
- **Same wire.** The wrappers emit exactly the `t_arg` the frontend already
  parses — `FrontendAction.js` is not touched, so no behavior can drift.
- The candidates worth a named form, by corpus frequency: client-composed
  toast, `control_by_id` method call, `binding_call` filter/sort,
  `keyboard_shortcut`. Rare kinds stay on the generic API.
- IDE discoverability: the argument names document the contract that today
  lives in a 190-line ABAP Doc comment.

## Example

App 092's popinChanged toast today vs. proposed:

```abap
" today
)->a( n = `popinChanged` v = client->_event_client(
        val   = client->cs_event-control_global
        t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` )
                         ( `Number of hidden pop-ins: {0}` )
                         ( `${$parameters>/hiddenInPopin}.length` ) ) )

" proposed
)->a( n = `popinChanged` v = client->toast_client(
        template = `Number of hidden pop-ins: {0}`
        t_arg    = VALUE #( ( `${$parameters>/hiddenInPopin}.length` ) ) )
```
