# pr/control-inline-style — set a CSS value on a control that has no matching property

**Status: open** — found by the IMPROVISED harvest 2026-08-05
(`node scripts/probes/improvised-cluster.mjs --family dom-style`),
4 deviations in apps **138 · 250 · 267 · 269**.

## Motivation

Four samples do the same thing: a controller writes a **CSS value** straight
onto a control's rendered DOM node, because the control has no property for it.

- apps **138 · 267 · 269** (`sap.ui.layout.DynamicSideContent`,
  `sap.ui.layout.Grid`): a Slider's `liveChange` resizes the container with
  `this.byId('sideContentContainer').$().width(iValue + '%')`. The container is
  a `sap.m.Page` — **`sap.m.Page` has no `width` property**, so there is
  nothing to two-way bind and no control method to call. All three ports keep
  the Slider in the view (structurally 1:1) and it does nothing.
- app **250** (`sap.m.ColorPalette`): `handleLiveChange` paints the pressed
  button's icon via
  `getDomRef().firstChild.firstChild.style.color = rgba(...)`.

Where the same jQuery-width idiom targets a control that *does* have `width`
(apps 053 · 146 · 176 · 213 · 214), abap2UI5 already reproduces it roundtrip-free
with a two-way bound Slider value plus a `{= ${VALUE} + '%' }` expression
binding — that is the preferred path and stays the preferred path. This request
is only about the residue: the target control has no such property.

## Current behavior (source)

`app/webapp/core/FrontendAction.js` can address a control by id and call a
whitelisted method. For CSS it offers the class-level trio only:

```js
addStyleClass:    ["string"],  // sap.ui.core.Control: add a CSS style class
removeStyleClass: ["string"],
toggleStyleClass: ["string"],
```

A class name carries no **value**, so a live percentage from a Slider cannot go
through it. The generalized allowlist does not help either: an unlisted public
method runs (`isSafeControlMethod`), but `sap.m.Page` simply has no
`setWidth`, so there is no method to call. Custom CSS *is* expressible in a
port (a `core:HTML` `<style>` leaf, CAPABILITIES "Custom CSS", apps 026 · 028 ·
119 · 169) — but a stylesheet is static, and these four samples need a value
that changes per drag step.

## Proposed change

A `css` entry in `CONTROL_METHODS`, dispatched like the existing style-class
methods but taking a property/value pair and writing it to the control's own
DOM ref:

```js
css: ["string", "string"],   // [cssProperty, value] on the control's DOM node
```

```js
// dispatch (same guard shape as addStyleClass)
const el = control.getDomRef();
if (el) el.style.setProperty(prop, value);
```

Two properties of the design keep it inside the thin-frontend rule:

- the payload is **data** (`"width"`, `"60%"`), not code — the frontend stays a
  data-driven executor;
- the write is the same class of client-side effect `addStyleClass` already
  performs, so it introduces no new capability category. A `setProperty` on the
  element's inline style is also re-applied by nothing on re-render, which
  matches the sample's own behaviour (the original loses it on re-render too).

An allowlist of settable properties (`width`, `height`, `color`,
`background-color`, `font-size`, …) is the natural guard if an open property
name is unwanted; the four ports here need `width` and `color`.

Optional second half, only if the ColorPalette case should be closed as well:
a third argument naming a **child selector** relative to the control's DOM ref
(app 250 walks `firstChild.firstChild`). This is the weaker half of the request
— reaching into a control's internal DOM structure is exactly what abap2UI5
avoids elsewhere, and app 250's loss is one icon's tint. Filed as optional on
purpose.

## Example (app 267, `sap.ui.layout.sample.DynamicSideContent`)

```abap
" the Slider's value is two-way bound anyway; the liveChange wire adds:
client->follow_up_action( val = client->_event_client(
  val   = client->cs_event-control_by_id
  t_arg = VALUE #( ( `sideContentContainer` )
                   ( `css` )
                   ( `width` )
                   ( |{ ms_view-slider_value }%| ) ) ) ).
```

and the sample's footer Slider resizes the page live, as in the original.

## Affected ports

| App | Sample | What is lost today |
|-----|--------|--------------------|
| 138 | `sap.ui.layout.sample.DynamicSideContent…` | Slider drags do nothing (`sap.m.Page` has no `width`) |
| 267 | `sap.ui.layout.sample.DynamicSideContent…` | same |
| 269 | `sap.ui.layout.sample.DynamicSideContent…` | same |
| 250 | `sap.m.sample.ColorPalette` | the pressed button's icon is not recoloured (optional half) |
