# pr/model-empty-vs-default — the remaining half: **path-scoped** omission of initial values

**Status: half implemented.** The per-bind opt-in
`client->_bind( val = … omit_initial = abap_true )` is **merged upstream**
(2026-08-05) and app 049 is rebuilt on it — the sample's bound
`CustomListItem` template is back instead of 14 unrolled static items. What is
still open is the **scoping** the same rebuild immediately ran into.

## What already works

`z2ui5_cl_core_srv_model->main_json_stringify` serializes with
`iv_ignore_empty = abap_false`, so an initial ABAP field used to arrive as an
explicit `""`/`0` and override the control's own default. `omit_initial` wires
ajson's empty filter into the `custom_filter` slot the serializer already
evaluates (a caller-supplied filter is kept — both must pass), so an initial
field now stays **absent** and the control keeps its UI5 default.

App 049 (`sap.m.sample.StepInput`) is the proof: its 14 rows each fill a
different subset of `min`/`max`/`step`/`largerStep`/`displayValuePrecision`,
and the port binds one template over them again. The template property
`valueState` — dropped before because no row sets it — is back too.

## What is still missing

`omit_initial` is **all-or-nothing per bind**, and one column type cannot live
with that: a **boolean that must send `false`**.

`abap_false` *is* the initial value, so the filter drops it — and the control
falls back to its default `true`. In app 049 that is precisely the
`enabled = false` row (Disabled) and the `editable = false` row (Read only):
with the flag on, both would render as ordinary editable inputs.

The port works around it by typing those two columns as **strings** carrying
the original's literal and converting them in the view:

```abap
enabled  TYPE string,   " `false` on the disabled row, empty elsewhere
```

```abap
)->a( n = `enabled`  v = `{= ${ENABLED} !== 'false' }`
)->a( n = `editable` v = `{= ${EDITABLE} !== 'false' }`
```

That is the **only** place where the port's binding value differs from the
original's plain `{enabled}` / `{editable}` — a declared deviation that exists
purely because the omission cannot be scoped.

## Proposed change

Let `omit_initial` name the paths it applies to, so a column that must keep its
initial value stays untouched:

```abap
client->_bind( val          = modeldata
               omit_initial = VALUE #( ( `MIN` ) ( `MAX` ) ( `STEP` )
                                       ( `LARGERSTEP` ) ( `VALUE` )
                                       ( `DISPLAYVALUEPRECISION` ) ) ).
```

Implementation shape (both halves already exist in ajson):
`z2ui5_cl_ajson_filter_lib=>create_path_filter( )` carries the path matching,
`create_empty_filter( )` the initial test — the new filter is their
intersection ("drop this node when it is initial **and** its name is in the
list"). The boolean parameter keeps working as the "every path" case, so
nothing that ships today changes.

With it, app 049 binds `enabled`/`editable` as plain `{ENABLED}`/`{EDITABLE}`
`abap_bool` columns, the two expression bindings disappear, and the port has no
binding-value deviation left at all.

## Affected ports

| App | Sample | Residual today |
|-----|--------|----------------|
| 049 | `sap.m.sample.StepInput` | two boolean columns as strings + expression bindings instead of `{enabled}`/`{editable}` |

Any future port whose bound template mixes "leave at default" numeric/enum
columns with "must be false" boolean columns hits the same wall.
