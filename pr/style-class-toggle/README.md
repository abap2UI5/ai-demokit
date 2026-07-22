# style-class-toggle — whitelist `add`/`remove`/`toggleStyleClass` in `CONTROL_BY_ID`

**Priority: medium** — a common controller idiom (toggle a CSS class on a
control) with no ABAP-callable equivalent; fits the existing `CONTROL_METHODS`
extension pattern.

> **Status: IMPLEMENTED** on branch `claude/ai-demokit-edge-cases-ftv30b` of
> abap2UI5 (folder kept until upstream-merged). `addStyleClass`,
> `removeStyleClass` and `toggleStyleClass` (each `["string"]`) are whitelisted
> in `CONTROL_METHODS` in both `app/webapp/core/FrontendAction.js` and the ABAP
> generator mirror `z2ui5_cl_app_frontendaction_js`; 3 node tests added (30 pass).

## Motivation

Many `sap.m` demo-kit controllers style a control imperatively:

```js
oControl.toggleStyleClass("cookiesDetailedView");   // or add/removeStyleClass
```

`sap.ui.core.Control.addStyleClass`/`removeStyleClass`/`toggleStyleClass` are
public, single-`string` methods with no binding equivalent. Before this change
they were not in the `CONTROL_BY_ID` whitelist, so a port had to drop the class
toggle (declared deviation).

Seen in `sap.m.sample.CookieSettingsDialogPattern` (port app **013**), whose
controller does `toggleStyleClass("cookiesDetailedView")` on the dialog.

## Change

Three entries added to `CONTROL_METHODS`:

```js
addStyleClass: ["string"],
removeStyleClass: ["string"],
toggleStyleClass: ["string"],
```

## Usage

```abap
client->follow_up_action( val   = client->cs_event-control_by_id
                          t_arg = VALUE #( ( `myDialog` ) ( `toggleStyleClass` ) ( `cookiesDetailedView` ) ) ).
```

or roundtrip-free, wired in the view via `_event_client( cs_event-control_by_id, … )`.

## Note on app 013

The capability is now available, but app 013's `cookiesDetailedView` CSS is not
part of the sample's shipped files (its `manifest` references `css/style.css`
which is not archived), so toggling the class has no visible effect there — 013
stays as-is. The whitelist unblocks any future sample whose class toggle has
shipped CSS.
