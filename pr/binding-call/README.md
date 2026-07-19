# Declarative binding_call — filter/sort an aggregation binding

**Status: implemented upstream 2026-07-18** in
[abap2UI5/abap2UI5](https://github.com/abap2UI5/abap2UI5)
(`app/webapp/core/FrontendAction.js` `evBindingCall`, public API
`z2ui5_if_client~binding_call_by_id` + `cs_event-binding_call`), demoed by
the beta samples `z2ui5_cl_demo_app_454`/`_455` in abap2UI5/samples
(`src/00/08`).

## Summary

The single most common demo kit controller pattern —
`oList.getBinding("items").filter([new Filter(...)])` /
`oBinding.sort(...)` — had no abap2UI5 equivalent: ports had to filter the
**model data** in ABAP (backup table + destructive `DELETE` +
`view_model_update`), which changes the mechanics (selection state on
filtered-out rows is lost, full model re-serialization per keystroke) and
forces an IMPROVISED deviation per port.

## Motivation

**61 controllers in the sap.m demo kit call `getBinding(...)`** (census
2026-07-18, OpenUI5 checkout). Directly affected in-scope backlog families:
SearchField, SelectDialog, TableSelectDialog, ViewSettingsDialog,
ListSelectionSearch, MultiComboBox/Input custom filtering,
TableViewSettingsDialog — conservatively 15–20 samples.

## Implemented design

Sister action to `control_call_by_id`, same safety boundary: whitelisted
binding methods (`filter`, `sort`), whitelisted filter operators
(`Contains`, `EQ`, `BT`, `StartsWith`, …), the `Filter`/`Sorter` objects
are built client-side **from data** (path/operator/values) — no code
strings, CSP-clean.

Arg order `[id, aggregation, method, ...params]`; all optionals sit at the
end because the backend arg serializer drops empty strings. An empty/omitted
filter `value1` **clears** the filter (the demo kit search pattern).

Two usage modes:

```abap
" 1. after a backend event (server logic sees the query first)
client->binding_call_by_id( id     = `productList`
                            params = VALUE #( ( `NAME` ) ( `Contains` ) ( lv_query ) ) ).

" 2. roundtrip-free: wired straight to the control event, the value
"    resolved client-side - behaviorally identical to the original
livechange = client->_event_client(
    val   = z2ui5_if_client=>cs_event-binding_call
    t_arg = VALUE #( ( `productList` ) ( `items` ) ( `filter` )
                     ( `NAME` ) ( `Contains` ) ( `${$parameters>/newValue}` ) ) )
```

The `_event_client` + `${…}` combination was source-verified: `get_t_arg`
passes `$`-prefixed args raw and UI5's `EventHandlerResolver` resolves them
against the event before `eF(...)` runs — sample 455 exercises exactly this
path (live check pending, first LIVE_TEST candidate).

## Out of scope (v1)

- Multi-filter AND/OR trees, `Filter` test functions, custom comparators —
  add operators/shapes when a port needs them (whitelist growth model).
- `binding.refresh` / growing manipulation — no demo kit driver yet.
