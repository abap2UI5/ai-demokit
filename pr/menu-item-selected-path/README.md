# pr/menu-item-selected-path — the selected menu item's ancestor-text path in the event payload

## Motivation

Both menu demo kit samples build a **breadcrumb path** from the selected item
up its parent chain in the `itemSelected` handler:

- [`Menu`](https://github.com/SAP/openui5/tree/master/src/sap.m/test/sap/m/demokit/sample/Menu)
  and
  [`MenuButton`](https://github.com/SAP/openui5/tree/master/src/sap.m/test/sap/m/demokit/sample/MenuButton)
  `onMenuAction`:
  ```js
  var oItem = oEvent.getParameter("item"), sItemPath = "";
  while (oItem instanceof MenuItem) { sItemPath = oItem.getText() + " > " + sItemPath; oItem = oItem.getParent(); }
  // toast "Action triggered on item: Create New Site > Official Store"
  ```

This repo's **apps 060 and 061** transport the selected item via
`${$parameters>/item/text}` and toast **only the selected item's own text**
(e.g. `Official Store`, not `Create New Site > Official Store`). The
parent-chain walk happens on the client control tree and has no
server-reachable equivalent — recorded as an `IMPROVISED` deviation on both
ports.

## Current behavior

- Event args starting with `$` are resolved client-side before the round-trip
  (`z2ui5_cl_core_srv_event=>get_t_arg` / the `EventHandlerResolver`), so
  `${$parameters>/item/text}` delivers the clicked item's **own** `text`.
- There is no expression that yields the item's **ancestors' texts joined**,
  because that needs a loop over `getParent()` on the live control, not a
  single binding path.

## Proposed change

Provide a resolvable payload for the selected item's ancestor path — options,
lightest first:

1. **A documented expression** the client already supports, if one can walk
   the parent chain (e.g. a small registered resolver keyword like
   `${$menuItemPath}` that the frontend expands to the joined ancestor texts
   before the round-trip). Preferred: no ABAP API, no new control method.
2. Failing that, document that the path is **not** transportable and that the
   leaf text is the supported 1:1 (so ports stop trying) — turning the two
   `IMPROVISED` deviations into a documented capability boundary.

## Example (port side)

```abap
" today (leaf text only):
)->a( n = `itemSelected` v = client->_event(
        val = `MENU_ACTION`
        t_arg = VALUE #( ( `${$parameters>/item/text}` ) ) )
" wanted (full breadcrumb):
        t_arg = VALUE #( ( `${$menuItemPath}` ) ) )
```

## Scope / notes

- **Priority: low** — cosmetic (the toast text); no rendering/data impact. The
  leaf text is usually the informative part.
- Filed to record the gap per the pr/ convention. If option 2 is chosen this
  folder is closed by a CAPABILITIES.md boundary note rather than an upstream
  change.
