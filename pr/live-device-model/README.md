# pr/live-device-model — the shared `device>` model must refresh on resize, and expose the media range

**Status: open** — filed against
[abap2UI5/abap2UI5](https://github.com/abap2UI5/abap2UI5). Measured, not
argued: `node scripts/probes/device-model-live-probe.mjs` (real OpenUI5,
Playwright, viewport 1400px → 420px).

## Motivation

abap2UI5 binds a shared `device>` model on every view slot, and it is the
framework's answer to the demo kit's device branches: **eleven** ports express
their original controller's `sap.ui.Device` logic declaratively over it instead
of round-tripping — `visible="{= !${device>/system/phone}}"` (apps 112/267/269),
`expanded="{device>/isNoPhone}"`, `showHeader="{device>/system/phone}"`. That is
the thin frontend working exactly as intended: no event, no round-trip, the
control reacts to the device itself.

It reacts **once**. Three ports record the consequence in their sidecars:

- app **012** (`sap.m.sample.ComparisonPattern`) drops the sample's
  `ResizeHandler`-driven `_onResize`/`_getPagesCount` recalculation and computes
  `pagesCount`/`isDesktop` once, at COMPARE time, from
  `client->get( )-s_device-resize-width` — *"no live recalculation on window
  resize"* (IMPROVISED, the `window-resize-event` probe family).
- app **112** binds `visible="{= !${device>/system/phone} ||
  ${device>/orientation/landscape} }"`, and its e2e note says the landscape
  branch *"needs a real device rotation"* — it has never been verifiable,
  because rotating does not move the binding.
- the overview app records the general form: *"a class swap on a live
  breakpoint change, for which no wire exists (the `device>` model is read per
  round-trip, not per resize)"*.

The interesting part is that the DATA is already live. `sap.ui.Device` mutates
itself — `Device.resize.width/height` and `Device.orientation.landscape/portrait`
are current at every moment. Only the model never says so.

## Current behavior

`app/webapp/model/models.js`, in full:

```js
createDeviceModel() {
  const oModel = new JSONModel(Device);
  oModel.setDefaultBindingMode("OneWay");
  return oModel;
}
```

`new JSONModel(Device)` wraps the live `Device` object, but a `JSONModel` only
notifies its bindings when something calls `setProperty`/`setData`/`refresh`.
`Device` mutates its own fields from its internal resize handler, behind the
model's back, so no binding is ever told. (This is inherited from the standard
UI5 app template, where it is equally silent.)

The probe measures it against the real thing — same model, same paths the
corpus binds, viewport driven from 1400px to 420px:

| binding | as shipped | with a `refresh` on `Device.resize`/`orientation` |
|---|---|---|
| `{device>/resize/width}` | `1400` → **`1400`** | `1400` → **`420`** |
| `{= ${device>/orientation/landscape} ? 'landscape' : 'portrait' }` | `landscape` → **`landscape`** | `landscape` → **`portrait`** |
| `{= ${device>/system/phone} …}` | `not-phone` → `not-phone` | `not-phone` → `not-phone` |
| `{device>/media/range}` | `""` → `""` | `""` → `""` |

Two findings, and the second and third rows matter as much as the first:

1. **The staleness is a missing notification, nothing more.** One `refresh(true)`
   from `Device`'s own handlers makes every existing binding live. No new API,
   no round-trip, no protocol change.
2. **`system/phone` is correctly static** — `Device.system` is UA/screen based
   and does not change when a desktop window narrows. So the eleven ports that
   bind it are *right as they are*; this request does not change their
   behaviour and must not pretend to. What those ports' originals branch on for
   a live breakpoint is the media RANGE.
3. **The media range is not bindable at all.** `Device.media` exposes only
   methods (`RANGESETS`, `attachHandler`, `initRangeSet`, `getCurrentRange`, …)
   — there is no property a binding can address. After
   `Device.media.initRangeSet()` the probe reads
   `getCurrentRange('Std') = {from: 0, to: 600, unit: 'px', name: 'Phone'}`,
   i.e. the value exists, it just has no path.

## Proposed change

In `app/webapp/model/models.js`, both halves in one place:

```js
createDeviceModel() {
  const oModel = new JSONModel(Device);
  oModel.setDefaultBindingMode("OneWay");

  // Device mutates itself on resize/rotation, but a JSONModel only notifies
  // its bindings when something tells it to — so tell it.
  Device.media.initRangeSet();                       // the standard Std range set
  const refresh = () => {
    const range = Device.media.getCurrentRange("Std");
    // the current range NAME has no path on Device; publish it as one
    oModel.setProperty("/media/range", range ? range.name : "");
    oModel.refresh(true);
  };
  Device.resize.attachHandler(refresh);
  Device.orientation.attachHandler(refresh);
  Device.media.attachHandler(refresh, null, "Std");
  refresh();                                          // seed before first render

  return oModel;
}
```

Notes on the shape:

- **`OneWay` stays.** The model is still read-only to the view; this only adds
  the change notification that was missing.
- **`/media/range`** is the one added path (`Phone` / `Tablet` / `Desktop` for
  the `Std` set), which is what a live breakpoint branch actually wants:
  `class="{= ${device>/media/range} === 'Phone' ? 'sapUiTinyMargin' : 'sapUiSmallMargin' }"`.
  It is written onto the model, not onto `Device`, so nothing global is
  mutated.
- **No round-trip is introduced.** Everything happens in the client; the
  backend's `s_device` snapshot per round-trip is unchanged and still the right
  tool for a decision ABAP has to make.
- The handlers live for the lifetime of the model (one per component), so there
  is no detach bookkeeping — but if the model is ever disposed, detach in the
  same place.

## Example

App 012's dropped recalculation, expressed with no controller and no
round-trip:

```abap
" pagesCount: 1 below 600px, 2 below 1024px, 3 above - the original's
" _getPagesCount thresholds, live on the client instead of frozen at
" COMPARE time
)->a( n = `visiblePagesCount`
      v = |\{= $\{device>/resize/width\} < 600 ? 1 : ($\{device>/resize/width\} < 1024 ? 2 : 3) \}| )
```

and app 112's landscape branch becomes testable, because rotating the device
now moves the binding:

```abap
)->a( n = `visible` v = |\{= !$\{device>/system/phone\} || $\{device>/orientation/landscape\}\}| )
```

## Tests

`node/tests/` has no models.js spec yet; the natural one asserts that a
simulated `Device.resize` firing reaches a bound control, and that
`/media/range` is seeded before the first render. The measurement harness in
`scripts/probes/device-model-live-probe.mjs` (this repo) is a working
reference — it drives a real viewport change through Playwright and reads the
rendered text back, so it can be lifted into a browser test.
