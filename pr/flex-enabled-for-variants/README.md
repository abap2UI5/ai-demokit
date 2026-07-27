# `flexEnabled: true` — SAPUI5 flexibility for variant management

## Motivation

App 251 (`sap.ui.comp.sample.PageVariantManagement`, `src/06/b01`) rebuilds the
SAPUI5 Smart Controls tutorial step 8: a `SmartVariantManagement` page variant in
front of a `SmartFilterBar` + `SmartTable`. The view renders, filtering works —
but **saving a view fails** (live run 2026-07-27):

```
Log-dbg.js:497 '_newVariant' throws an exception:
Cannot read properties of undefined (reading 'getId')
```

The failure is client-side, inside `sap.ui.comp.smartvariants.SmartVariantManagement`,
before any backend call. A `getId()` on `undefined` in that path is the shape of a
flexibility lookup that found no **app component** to attach the variant change to
(`sap/ui/fl` resolves the app component for a control and then reads its id).

`sap.ui.comp` is closed source, so the exact line cannot be quoted here — what can
be quoted is the documented prerequisite.

## Current behavior

`app/webapp/manifest.json` declares:

```json
"sap.ui5": {
  "flexEnabled": false,
  ...
}
```

The SAPUI5 documentation names `flexEnabled` as the switch that makes an app's
flexibility services available, and `SmartVariantManagement` is explicitly the
control that "provides access to the SAPUI5 flexibility back end" — its whole
purpose is persisting variants there. Every other prerequisite the docs list for
the page variant is satisfied by the app: the `SmartVariantManagement` has its own
`persistencyKey`, each smart control has one, the `smartVariant` association is
assigned, and (since this finding) the `SmartFilterBar` also carries the
`pageVariantPersistencyKey` custom data the docs require for that combination.

Reference: [Smart Variant Management](https://github.com/SAP-docs/sapui5/blob/main/docs/10_More_About_Controls/smart-variant-management-06a4c3a.md)
(SAP-docs mirror of the SAPUI5 documentation).

## Proposed change

Set `"flexEnabled": true` in `app/webapp/manifest.json` (and regenerate the ABAP
mirror), so an abap2UI5 app can host the smart controls' variant management —
`SmartVariantManagement`, `SmartFilterBar`/`SmartTable` variants, and the
`sap.ui.fl.variants.VariantManagement` family — without every save crashing.

Open questions for the maintainer, deliberately not decided here:

- `flexEnabled: true` also advertises the app for **key user adaptation / RTA**.
  That is a framework-wide statement, not a per-app one; if it is unwanted, the
  alternative is a documented "variant management needs a flex-enabled host"
  boundary in `CAPABILITIES.md` instead of a manifest change.
- Variant persistence writes through the flexibility layer to the LREP under the
  app component's id (`z2ui5`). Whether that is acceptable — every abap2UI5 app
  shares one component id, so variants of different apps would land under the
  same reference unless the `persistencyKey`s differ — needs a call before this
  is switched on.

## How to confirm the diagnosis first

In a running app 251, before changing anything (browser console, `-dbg` sources):

```js
// 1) does the flexibility layer find an app component for the control?
sap.ui.require(["sap/ui/fl/Utils"], function (U) {
  var oSVM = sap.ui.getCore().byId("mainView--pageVariantId");
  console.log("app component:", U.getAppComponentForControl(oSVM));
});

// 2) are the personalizable controls registered and resolvable?
var oSVM = sap.ui.getCore().byId("mainView--pageVariantId");
console.log(oSVM.getPersonalizableControls().map(function (p) {
  return [p.getKeyName(), p.getControl(), !!sap.ui.getCore().byId(p.getControl())];
}));
```

`undefined` from (1) confirms this request. A `false` in (2) would point at the
association/id resolution in the view instead — a different fix, in the port.

## Status

Open — filed 2026-07-27 from app 251, together with the port-side half of the
finding (the `pageVariantPersistencyKey` custom data, already applied).
