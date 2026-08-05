# pr/model-empty-vs-default — an initial ABAP field must be able to stay ABSENT from the model

**Status: open** — found by the IMPROVISED harvest 2026-08-05
(`node scripts/probes/improvised-cluster.mjs --family empty-vs-default`),
5 deviations in apps **010 · 012 · 018 · 049 · 289**.

## Motivation

A UI5 control property has a **default**. The XML view leaves the attribute
out, or the JSON model does not carry the key, and the control keeps that
default. Several demo kit samples depend on it — the same aggregation template
renders rows where a property is set and rows where it is not
(`sap.m.StepInput`, app 049), and an enum-typed property must never receive an
empty string (`sap.m.MessageStrip.type`, app 289).

abap2UI5 serializes an ABAP structure into that model, and an ABAP field is
never "absent" — it is `''`, `0` or `abap_false`. Today every one of them
reaches the client as an explicit value, so:

- **an enum property gets `""` and UI5 rejects it** (app 289: `MessageStrip.type`
  is left at the control default until the first press, because binding an
  empty type is not possible; app 018: every change-firing DateTimePicker got
  an added `valueState` seeded `'None'` so no empty string reaches the enum);
- **a set default silently overrides the control's own default** (app 010's
  `popinLayout` expression binding is written so it "can never emit an empty
  enum value"; app 012 seeds `pagesCount = 1`, the `CarouselLayout`
  `visiblePagesCount` default, where the original leaves it undefined);
- **a bound template stops being usable**: app 049 (`sap.m.StepInput`) unrolled
  the sample's bound List into static list items, "because every row sets a
  different subset of the StepInput properties — an empty ABAP model field
  would bind as `""` instead of leaving the property at its default, so a bound
  template would not render 1:1". That is a *structural* loss caused purely by
  the serializer.

The corpus rule that came out of this ("absent JSON properties must not
serialize as empty strings … fill the UI5 default explicitly or split the
aggregation into per-shape templates", README generation prompt) is a
workaround for every port, forever.

## Current behavior (source)

`z2ui5_cl_core_srv_model->main_json_stringify` writes every bound attribute
with `iv_ignore_empty = abap_false`
(`src/01/02/z2ui5_cl_core_srv_model.clas.abap`):

```abap
ajson->set( iv_ignore_empty = abap_false
            iv_path         = `/`
            iv_val          = <val> ).

IF lr_attri->custom_filter IS BOUND.
  ajson = ajson->filter( lr_attri->custom_filter ).
ENDIF.
```

`abap_false` is the deliberate opposite of ajson's own default: ajson skips an
initial value when `iv_ignore_empty = abap_true`
(`z2ui5_cl_ajson`, `IF iv_val IS INITIAL AND iv_ignore_empty = abap_true …`).
The reason is sound — a field the client never receives is also a field
two-way binding cannot carry back, so blanket omission would break the model
contract. This request is therefore **not** "flip the flag".

An escape hatch already exists and is one line away from what the ports need:
`z2ui5_if_client~_bind( … custom_filter = … )`
(`src/02/z2ui5_if_client.intf.abap`) is applied exactly at the point above, and
`z2ui5_cl_ajson_filter_lib=>create_empty_filter( )` drops every empty node of
the value tree. **No port in this corpus uses it** — it is not discoverable
from the app-facing API, and it is all-or-nothing: it would also drop the empty
*strings* an app legitimately wants (an empty `text`, a cleared `value`), and
those fields are exactly the ones a user then types into.

## Proposed change

1. **A per-bind opt-in on the app-facing API**, wiring the existing filter:

   ```abap
   client->_bind( val          = mt_rows
                  omit_initial = abap_true ).   " initial fields stay absent
   ```

   Implementation is the `custom_filter` slot that is already evaluated —
   `create_empty_filter( )` when the flag is set and no custom filter was
   passed, `create_and_filter( )` of both when one was.

2. **Path scoping**, so the opt-in can be narrowed to the properties that need
   it instead of the whole bound value:

   ```abap
   client->_bind( val          = mt_rows
                  omit_initial = VALUE #( ( `MAX` ) ( `MIN` ) ( `TYPE` ) ) ).
   ```

   `z2ui5_cl_ajson_filter_lib=>create_path_filter( )` already carries the path
   matching; the new filter is the intersection of "initial" and "in this path
   list".

Both keep today's behaviour as the default, so nothing existing changes.

## Example (app 049, `sap.m.sample.StepInput`)

The sample binds one `CustomListItem` template over `/modelData`, and each row
sets a different subset (`min`, `max`, `step`, `description`, `valueState`).
With the flag the port becomes the faithful 1:1 rebuild:

```abap
" model_init - only the fields a row actually sets are filled
mt_rows = VALUE #( ( description = `Default`                    )
                   ( description = `With min/max` min = 0 max = 10 )
                   ( description = `With step`    step = 5        ) ).

" view: ONE bound template instead of five unrolled static items
xml->open( `CustomListItem` )->…
   ->leaf( `StepInput` )->a( n = `min`  v = `{MIN}`  )
                          ->a( n = `max`  v = `{MAX}`  )
                          ->a( n = `step` v = `{STEP}` )

" bind: rows 1 and 3 carry no MIN/MAX, so the StepInput keeps its own defaults
client->_bind( val = mt_rows omit_initial = abap_true )
```

Today row 1 would receive `min = ""`, `max = ""`, and the control renders
neither the sample's defaults nor a usable spinner.

## Affected ports

| App | Sample | What the deviation says |
|-----|--------|-------------------------|
| 049 | `sap.m.sample.StepInput` | bound template unrolled into static items — the structural loss |
| 289 | `sap.m.sample.MessageStrip` | `type` cannot be bound empty, stays at the control default until the first press |
| 018 | `sap.m.sample.DateTimePicker` | six pickers gained a bound `valueState` seeded `'None'` |
| 010 | `sap.m.sample.ColumnListItem` | `popinLayout` expression written so it can never emit an empty enum |
| 012 | `sap.m.sample.ComparisonPattern` | `pagesCount` seeded to the UI5 default where the original leaves it undefined |
