# event-prevent-default — conditional `preventDefault()` for a client event

**Status: open** — genuine framework gap. From demo-kit app 241
(`sap.tnt.sample.SideNavigationPressEvent`, 2026-07-25).

## Motivation

Several controls let the app cancel an event's **default behaviour** at runtime
via `oEvent.preventDefault()`. `sap.tnt.SideNavigation`'s `NavigationListItem.press`
is the canonical case: the sample gates item **selection** on a checkbox — when
"prevent selection" is ticked, `onItemPress` calls `oEvent.preventDefault()` so
the pressed item does not become selected. The thin frontend forwards the press
but cannot conditionally cancel the client-side default, so the sample's whole
point (app 241) is only partially expressible and is declared IMPROVISED.

## Current behavior (source refs)

abap2UI5 forwards a named event and runs the control's default behaviour; there
is no declarative "preventDefault" hook (verified against `FrontendAction.js` /
the event wiring — no `preventDefault` path). `NavigationListItem.press` is
`@since 1.133`, its `ctrlKey/shiftKey/altKey/metaKey` params `@since 1.137`
(`fork-openui5/.../NavigationListItemBase.js`), so the sample already needs a
recent runtime; the missing piece is only the cancel.

## Proposed change

An opt-in flag on the event wire that makes the handler shim call
`oEvent.preventDefault()` before (or instead of) the round-trip — e.g.
`client->_event( val = 'ITEM_PRESS' prevent_default = abap_true )`, or a
`$event.preventDefault` marker the client resolves. When set, the shim cancels
the built-in default (selection here) while still transporting the event +
params to the backend, so the app can re-apply selection server-side when it
decides to.

## Example (app 241)

```abap
" press cancels the built-in selection; backend decides whether to select
press = client->_event( val = `ITEM_PRESS` prevent_default = abap_true
                        t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
```
