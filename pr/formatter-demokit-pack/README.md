# Demo kit pack for the curated formatter module

**Status: implemented upstream 2026-07-18** in
[abap2UI5/abap2UI5](https://github.com/abap2UI5/abap2UI5)
(`app/webapp/model/formatter.js`): Option A shipped — flat module, suffixed
names (`weightStateByValue`, `stockStatusState`, `stockStatusIcon`,
`round2DP`, `dimensions`, `deliveryStatusState`), unit specs extended.
Demoed by the beta sample `z2ui5_cl_demo_app_453` in abap2UI5/samples
(`src/00/08`). Ports referencing a renamed function declare a `NOTE`
deviation for the changed reference string (see "Naming" below).

## Summary

Extend the curated formatter module (`app/webapp/model/formatter.js`,
implemented 2026-07-18 via [formatter-registry](../formatter-registry/README.md))
with the handful of value formatters the sap.m demo kit samples actually
ship — so the whole formatter-using part of the porting backlog is covered
by **one framework PR** instead of per-sample workarounds.

## Motivation — a census of every formatter in the sap.m demo kit

A full scan of all 446 `sap.m` demo kit samples (OpenUI5 checkout,
`src/sap.m/test/sap/m/demokit/sample`, 2026-07-18) shows:

- **~45 samples** reference a formatter at all; **35 of them are in the
  in-scope porting backlog** (the DynamicDateRange and UploadCollection
  families are out of scope anyway — control too new / deprecated).
- **19 samples ship a dedicated `Formatter.js`/`formatter.js` file** — but
  they dedupe to a *tiny* function set, dominated by one name:
  `weightState` appears in 12 of the 19 files.
- Crucially, `weightState` is **three different functions sharing one
  name** across the demo kit:

| Variant | Signature / thresholds | Samples (in-scope) |
|---|---|---|
| V1 `weightState(measure, unit)` | KG/G aware, `< 1` Success, `< 5` Warning | `Table` (ported, app 401), `TableAutoPopin`, `TableTest`, `IconTabBar`, `IconTabBarBackgroundDesign`, `IconTabBarProcess`, `IconTabBarResponsivePadding` |
| V2 `weightState(value)` | `< 1000` Success, `< 2000` Warning | `TableBreadcrumb`, `TableEditable`, `TableVerticalAlignment`, `TableViewSettingsDialog`, `TableSelectDialog`, `TableSelectDialogGrowing` |
| V3 `weightState(value)` | `< 10` Success, `< 20` Warning | `TableMergeCells` |

- The remaining file-based functions are small one-liners:
  `status`/`statusIcon` (stock status → ValueState / icon;
  `StandardListItemInfo`, `ObjectListItem` — identical logic),
  `round2DP` + `dimensions` (`TableBreadcrumb`),
  `deliveryStatusState` (`InitialPagePattern`),
  `formatType`/`listItemType` (trivial ternaries),
  `randomBoolean` (`ListUnread`), `url` (`ComparisonPattern`),
  `listProductsSelected`/`isProductSelected` (`TableBreadcrumb`,
  context-reading — see "Out of scope").

## Current behavior

`z2ui5/model/formatter.js` contains the date helpers (the `z2ui5.Util`
legacy contract) and exactly one value formatter: `weightState` —
variant V1. Ports of the 13 other formatter-file samples would each have
to fall back to expression bindings or ABAP preformatting, losing the
original `formatter:` binding structure and producing a deviation per
sample.

## Proposed change

Add the missing **pure, deterministic value formatters** to the curated
module (same file, same contract — served script resource, CSP-clean, no
runtime code generation):

```js
// weightState variant V2 (thresholds 1000/2000), the most common
// demo kit shape after V1 — sap.m.sample.TableEditable Formatter.js
weightStateByValue(value) {
  const v = parseFloat(value);
  if (isNaN(v) || v < 0) return "None";
  if (v < 1000) return "Success";
  if (v < 2000) return "Warning";
  return "Error";
},
// stock status → ValueState / icon — sap.m.sample.StandardListItemInfo
stockStatusState(status) { /* Available/Out of Stock/Discontinued → Success/Warning/Error */ },
stockStatusIcon(status)  { /* … → accept/alert/decline icons */ },
// sap.m.sample.TableBreadcrumb
round2DP(n) { return (Math.round(n * 100) / 100).toFixed(2); },
dimensions(width, depth, height, unit) { /* join non-empty with " x ", append unit */ },
// sap.m.sample.InitialPagePattern
deliveryStatusState(status) { /* Shipped/Failed Shipping → Success/Error */ },
```

### Naming: curated names differ from the originals — two options

The originals all bind `formatter: 'Formatter.weightState'` /
`'Formatter.status'`; a flat curated module cannot export three
`weightState`s, so the reference string in a port's view deviates from
the original (e.g. `Formatter.weightStateByValue`).

- **Option A (recommended, minimal):** suffixed names in the flat module
  as above; each affected port declares a `NOTE` deviation for the renamed
  reference (the structural diff flags the binding-value difference, the
  declaration covers it).
- **Option B (byte-identical binding strings):** per-variant submodules
  (`z2ui5/model/formatter/tableByValue.js`, …) so the view's
  `core:require` alias absorbs the difference and the binding string stays
  exactly `Formatter.weightState`. More files, same CSP story; only worth
  it if binding-string fidelity is valued over a declared rename.

## Out of scope (deliberately not in the module)

- `listProductsSelected` / `isProductSelected` (`TableBreadcrumb`) — not
  pure value formatters: they read the binding **context** and a second
  named `Order` model; blocked on
  [named-json-models](../named-json-models/README.md) and a formatter-
  with-context story. The sample's other columns port fine without them.
- `randomBoolean` (`ListUnread`) — nondeterministic; seed the random flags
  in ABAP at `model_init` instead (IMPROVISED note in the port).
- `url` (`ComparisonPattern`) — rewrites demo-kit-relative asset paths;
  ports serve assets differently anyway.
- The MessagePopover controller trio (`buttonIconFormatter` /
  `buttonTypeFormatter` / `highestSeverityMessages`, 4–5 samples) —
  coupled to the MessageManager auto-collection model, which is a separate
  ❌ (CAPABILITIES.md); adding the formatters alone unlocks nothing.
- `formatDate` in the calendar samples — covered 1:1 by standard
  `sap.ui.model.type.Date/DateTime` binding types (CAPABILITIES.md ✅)
  and the module's existing date helpers.
- Trivial ternaries (`listItemType`, `formatType`, V3's 10/20 thresholds)
  — expression bindings express them 1:1-adjacent; per the module's own
  policy ("keep app-specific one-offs out") they stay out unless a port
  proves the expression form insufficient.

## Impact

With `weightState` (V1, already shipped) + the six functions above, **all
13 unported in-scope samples with a dedicated formatter file** either port
with their original `formatter:` binding structure (11) or need only an
expression binding for a trivial ternary (2). The formatter topic then
stops being a per-sample decision for the rest of the backlog.

## Example

```abap
view->open( n = `View` ns = `mvc`
    )->a( n = `xmlns:core`     v = `sap.ui.core`
    )->a( n = `core:require`   v = `\{Formatter: 'z2ui5/model/formatter'\}`
    " …
    )->leaf( `ObjectNumber`
        )->a( n = `number` v = `{WEIGHT}`
        )->a( n = `state`  v = `{ path: 'WEIGHT', formatter: 'Formatter.weightStateByValue' }` ).
```

(`core:require` needs UI5 ≥ 1.74 → declare `POST_171` in the port, as
app 401 already does; the `z2ui5.Formatter` global covers older releases.)
