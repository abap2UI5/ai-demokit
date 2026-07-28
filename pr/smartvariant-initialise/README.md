# A declarative `initialise()` for `sap.ui.comp` variant management

## Motivation

App 251 (`sap.ui.comp.sample.PageVariantManagement`, `src/06/b01`) rebuilds the
SAPUI5 Smart Controls tutorial step 8: a `SmartVariantManagement` page variant in
front of a `SmartFilterBar` + `SmartTable`. The view renders, the table loads, the
filter bar filters — but **saving a view crashes** and, once forced through,
**nothing survives a restart**.

Measured in a running system (2026-07-28), with the sample's own 1:1 wiring
(`smartVariant="pageVariantId"` on both smart controls):

| Observation | Value |
|---|---|
| `oSVM.getPersonalizableControls().length` | `2` — both controls register themselves |
| each entry | resolvable id, right `type` (`filterBar` / `table`), right `persistencyKey` |
| `SmartVariantManagementApplyAPI.loadVariants({control: <filter bar>})` | resolves cleanly |
| `oSVM._oPersoControl` | **`null`** |
| Save As | `'_newVariant' throws an exception: Cannot read properties of undefined (reading 'getId')` |

The crash is in the open-source half and reads unambiguously
(`sap/ui/fl/write/api/SmartVariantManagementWriteAPI.js:26`):

```js
mPropertyBag.componentId = Utils.getAppComponentForControl(mPropertyBag.control).getId();
```

`mPropertyBag.control` is `null`, because `SmartVariantManagement.prototype._newVariant`
(SAPUI5 1.150, `-dbg` sources) passes its own field:

```js
var oVariant = this.oModel._flWriteAddVariant({
    control: this._oPersoControl,          // ← null
    changeSpecificData: mParams            // ← content: {} for the same reason
});
```

`_oPersoControl` is what `initialise(fnCallback, oPersoControl)` assigns. **Setting
it by hand in the console makes Save As work immediately** — the view appears under
*Meine Ansichten*. So exactly one call is missing, and it is one an app normally makes
from its controller. SAP's own documentation shows the pattern
([Smart Variant Management](https://github.com/SAP-docs/sapui5/blob/main/docs/10_More_About_Controls/smart-variant-management-06a4c3a.md)):

```js
oSmartVariantManagement.addPersonalizableControl(oPersInfo);
oSmartVariantManagement.initialise(function () { /* init done */ }, this);
```

## Current behavior

abap2UI5 has no controller, and no declarative way to make that call:

- `cs_event-control_by_id` calls a **whitelisted** method with **string** arguments.
  `initialise(fnCallback, oPersoControl)` takes a *function* and a *control instance*,
  so it does not fit the generic method call.
- The curated sample `z2ui5_cl_demo_app_111` (abap2UI5/samples, `src/00/07`) solves it
  today by shipping custom JS through `z2ui5_cl_pop_js_loader` — it builds the
  `PersonalizableInfo`, calls `addPersonalizableControl` and then `initialise`. That
  works, but it is app-authored JavaScript for something every smart-variant app needs.

Without the call, the whole variant feature is dead weight: saving crashes, and a
restart shows nothing, because the control never loads its variants either.

## Proposed change

A dedicated frontend action that performs the handshake from data only — no code
strings, in the spirit of the existing `control_by_id` / `binding_call` actions:

```abap
client->follow_up_action(
    val   = client->cs_event-smart_variant_init
    t_arg = VALUE #( ( `pageVariantId` )        " the SmartVariantManagement id
                     ( `smartFilterBar` ) ) ).  " the personalizable control id
```

Frontend side (sketch):

```js
evSmartVariantInit(aArgs) {
  const oSVM  = ViewSlots.byId(aArgs[0]);
  const oCtrl = ViewSlots.byId(aArgs[1]);
  if (oSVM && oCtrl && oSVM.initialise) {
    oSVM.initialise(function () {}, oCtrl);
  }
}
```

Both ids are resolved through the existing slot lookup, the callback is a no-op, and
nothing app-supplied is evaluated. A variant that fits the framework even better would
be for abap2UI5 to run the handshake **automatically** after view creation whenever the
view contains a `sap.ui.comp.smartvariants.SmartVariantManagement` — the personalizable
controls are already registered at that point (`getPersonalizableControls()` returns
them), so the framework only has to pick the first one and call `initialise`.

Open question for the maintainer: whether this belongs in the framework at all, or
whether smart-control variant management stays a documented boundary
(`CAPABILITIES.md`) with the `z2ui5_cl_demo_app_111` JS-loader pattern as the answer.

## Status

**Implemented** on the abap2UI5 branch `claude/smart-controls-samples-vdfr5y`
(2026-07-28), pending upstream merge: the `SMART_VARIANT_INIT` handler in
`app/webapp/core/FrontendAction.js`, the `cs_event-smart_variant_init` constant in
`z2ui5_if_client`, the regenerated ABAP mirror, and four specs in
`node/tests/frontendAction.spec.js` (the test sandbox also had to be given the timer
globals). App 251 calls it through `follow_up_action` after `view_display` — with the
action name still written out as a literal, because ai-demokit's abaplint resolves
abap2UI5 from its default branch. Switch that to the constant once merged.

The full evidence trail — five refuted hypotheses before this one — is in `STATUS.md`
and in the port's sidecar.
