# pr/popup-within-area — expose `sap.ui.core.Popup.setWithinArea( )` to the backend

**Target: [abap2UI5/abap2UI5](https://github.com/abap2UI5/abap2UI5)** —
`app/webapp/core/FrontendAction.js`, the `CONTROL_GLOBAL` target list.

## Motivation

Porting **`sap.m.sample.PopoverWithinArea`** (ai-demokit app 285,
`src/01/b20/z2ui5_cl_ai_app_285.clas.abap`) reproduced the sample's three
popovers 1:1 — and lost the one thing the sample exists to demonstrate.

Its controller confines every popup to a *within area* before opening:

```js
// sap/m/sample/PopoverWithinArea/controller/PopoverWithinArea.controller.js
handlePopoverPress: function (oEvent) {
    Popup.setWithinArea(this.byId("withinArea"));   // <- the point of the sample
    …
    this._pPopover.then(function (oPopover) { oPopover.openBy(oButton); });
},

handleAfterClose: function () {
    Popup.setWithinArea(null);                      // released again on close
}
```

`sap.ui.core.Popup` is a **static module**, not a control, so neither call is
reachable from ABAP today:

* `cs_event-control_by_id` addresses a control **by id** — `Popup` has none.
* `cs_event-control_global` knows a closed set of global objects
  (`MESSAGE_TOAST`, `MESSAGE_BOX`, `BUSY_INDICATOR`, `THEMING`) — `Popup` is
  not among them.

The port therefore opens its popovers against the viewport and declares an
`IMPROVISED` deviation; the `afterClose` attribute of all three popovers is
dropped along with it, since resetting the area was its only job.

This is not a one-sample gap. A within area is how an app keeps a popup inside
a dashboard tile, a split-screen half or an embedded region instead of letting
it float over the whole shell — the kind of layout an ABAP app has just as
much reason to build as a UI5 one.

## Current behavior

`app/webapp/core/FrontendAction.js` resolves a `CONTROL_GLOBAL` wire against a
fixed map of global objects:

```js
const GLOBAL_OBJECTS = {
    MESSAGE_TOAST:  MessageToast,
    MESSAGE_BOX:    MessageBox,
    BUSY_INDICATOR: BusyIndicator,
    THEMING:        Theming,
};
```

Anything else is refused with a console log, and the wire silently does
nothing — which is exactly what an ABAP `POPUP`/`setWithinArea` attempt does
today.

## Proposed change

Add `sap/ui/core/Popup` as a fourth global target with a single allowed
method:

```js
POPUP: { obj: Popup, methods: ['setWithinArea'] }
```

`setWithinArea` takes a **DOM element or a control**, which the existing
`domRef` argument kind already produces (added for
`openBy`/`toggleBy`, see the implemented `control-methods-openby-setactivepage`
request): a control id is resolved to its element, with the control itself as
fallback. An **empty** argument must reach the method as `null` — that is the
documented "release the area again" form, and the same asymmetry that made an
empty association argument non-transportable before (see the
`sap.uxap.ObjectPageLayout.selectedSection` note in the porting guide), so it
needs to be explicit rather than inherited from `castArgs`' padding rules.

## Example (what the port would then write)

```abap
" confine every popup to the grey area before opening
client->follow_up_action( val   = client->cs_event-control_global
                          t_arg = VALUE #( ( `POPUP` ) ( `setWithinArea` ) ( `withinArea` ) ) ).

" …and release it again when the popover closes
client->follow_up_action( val   = client->cs_event-control_global
                          t_arg = VALUE #( ( `POPUP` ) ( `setWithinArea` ) ( `` ) ) ).
```

The port already gives the `sap.m.VBox` the sample's own id `withinArea`, so
closing this gap is a sidecar change plus two wires — no view rework.

## Downstream note

The abap2UI5-linter judges `CONTROL_GLOBAL` against a copy of this whitelist
(`lib/frontend-actions.mjs`, `GLOBAL_TARGETS`). When this lands, add
`POPUP: ['setWithinArea']` there in the same round, or the linter reports the
correct new wire as an `invalid-frontend-action`.
