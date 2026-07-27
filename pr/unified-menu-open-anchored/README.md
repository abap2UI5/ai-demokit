# unified-menu-open-anchored — anchored open for `sap.ui.unified.Menu`

**Status: IMPLEMENTED (2026-07-27)** — exactly the proposed fallback: the
`openBy` dispatch in `FrontendAction.js` now calls
`open(false, anchor, "begin top", "begin bottom", anchor)` when the resolved
control has no own `openBy` (abap2UI5 branch `claude/ai-demokit-review-qavjtr`).
Apps 227/228 kept their existing `openBy` wires — the declared no-op became
functional; keyboard flag + explicit dock constants stay dropped (NOTE).
Originally from demo-kit batch b10 apps 227 (`MenuItemEventing`) and 228
(`MenuMenuEventing`).

## Motivation

`sap.ui.unified.Menu` is a popup control opened imperatively from a controller,
anchored to a button:

```js
// sap.ui.unified.sample.MenuItemEventing / MenuMenuEventing controller
oMenu.open(bWithKeyboard, oButton, Popup.Dock.BeginTop, Popup.Dock.BeginBottom, oButton);
```

The abap2UI5 anchored-open family (`control-methods-openby-setactivepage`,
implemented 2026-07-20) whitelisted **`openBy: [domRef]`**, which covers
`sap.m.Menu`, `TimePicker`, `DatePicker` — every control that *has* an `openBy`
method. `sap.ui.unified.Menu` does **not**: it exposes only

```
Menu.prototype.open = function(bWithKeyboard, oOpenerRef, my, at, of, offset, collision)
```
(`src/sap.ui.unified/src/sap/ui/unified/Menu.js:428` in the OpenUI5 fork — no
`openBy` anywhere on the class or its `MenuItemBase` ancestors).

So the two whitelisted paths both fail on this control:

- **`openBy`** → `control.openBy(anchor)` throws `typeof control.openBy !== "function"`;
  the dispatch fails closed with a `logError`, so the press is a silent no-op.
- **`open`** is typed `["string"]` — the single string arg lands in the first
  positional (`bWithKeyboard`), so the opener/`of` element can never be passed.
  Worse, `sap.ui.unified.Menu.open` **closes itself immediately when `of` is
  absent** (`Menu.js:445-448`: `oOfDom = getPopup()._getOfDom(of); if (!oOfDom
  || …) { … this.close(); }`), so even a bare `open` would flash-and-dismiss.

Net: the sample's anchored open is **not expressible today**. The ports wire the
intent-correct `openBy` (so the view is 1:1 and every static/render gate passes —
render-smoke never fires the press), but the Menu does not open at runtime. Both
ports declare this as an `IMPROVISED` deviation pointing here.

## Proposed change

Teach the anchored-open dispatch to fall back to `open(...)` when the target
control has no `openBy`, supplying the resolved anchor as **both** `oOpenerRef`
and `of`:

```js
// in the control-method dispatch (app/webapp/core/FrontendAction.js), when
// resolving an anchored open for a control that lacks openBy:
if (typeof control.openBy !== "function" && typeof control.open === "function") {
  control.open(false, anchorControl, "begin top", "begin bottom", anchorControl);
} else {
  control.openBy(anchorControl);
}
```

i.e. a new `open`-with-anchor kind (or making `openBy` degrade to `open` when the
method is missing), keyed off the same `domRef` arg already used for `openBy`.
That single change makes **every** `sap.ui.unified.Menu` sample fully faithful.

The keyboard flag (`bWithKeyboard`, driven by the sample controller's
`attachBrowserEvent("tab keyup", …)` tracking) and the explicit
`Popup.Dock.BeginTop`/`BeginBottom` docking constants are still dropped — they
have nowhere to go in a bindable frontend action, and the default docking is
visually equivalent. That is an acceptable, already-known limitation
(AGENTS.md §10); only the *open itself* is the blocker.

## Example (app 227)

```abap
" button press -> open the fragment Menu anchored to the button
client->_event_client( val   = client->cs_event-control_by_id
                       t_arg = VALUE #( ( `theMenu` ) ( `openBy` ) ( `$event.oSource.sId` ) ) )
```

The `theMenu` control is a `sap.ui.unified.Menu` declared in the button's
`dependents` aggregation. With the fallback above, `openBy` (or a new anchored
`open`) resolves `theMenu`, sees no `openBy` method, and calls
`theMenu.open(false, <button>, "begin top", "begin bottom", <button>)`.

## Related

- `menu-item-selected-path` (open, deferred) — the *breadcrumb* text of the
  selected item; orthogonal to opening the menu.
- `control-methods-openby-setactivepage` (implemented) — added `openBy`/`domRef`;
  this request is its `sap.ui.unified.Menu` follow-up.
