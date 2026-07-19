# Request: compound (nested) filters for `cs_event-binding_call`

## Motivation

Porting `sap.m.sample.FacetFilterLight` (this repo's `z2ui5_cl_ai_app_401`)
hit the limit of the declarative `BINDING_CALL` filter: the sample's
controller builds a **nested** filter —

```js
// FacetFilterSimple/FacetFilter.controller.js, _filterModel
var oFilter = new Filter(mFacetFilterLists.map(function(oList) {
    return new Filter(oList.getSelectedItems().map(function(oItem) {
        return new Filter(oList.getTitle(), "EQ", oItem.getText());
    }), false);          // OR inside each facet group
}), true);               // AND across the groups
oTable.getBinding("items").filter(oFilter);
```

— i.e. `(Category EQ a OR Category EQ b) AND (SupplierName EQ x OR …)`.
This AND-of-ORs shape is the standard multi-facet filter pattern
(FacetFilter, ViewSettingsDialog multi-key filters, combined
SearchField + facet filtering), so more backlog samples will hit it.

## Current behavior

`app/webapp/core/FrontendAction.js`, `BINDING_METHODS.filter` builds exactly
**one** `sap.ui.model.Filter` from positional args `[path, operator, value1,
value2]`; both empty values clear the filter. There is no way to pass more
than one path/value, let alone grouped OR/AND semantics. Port 401 therefore
filters the model ABAP-side (a full-copy rebuild per event), losing the
model-untouched advantage the binding filter exists for (client-side
selection on filtered-out rows survives a binding filter, not a model
rebuild).

## Proposed change

Extend the declarative payload so a filter *tree* can be expressed from
data, keeping the whitelist boundary (paths/operators/values only, never
code strings). Suggested shape — the trailing params carry a JSON array of
groups, each group a list of `[path, operator, value1, value2?]` rows:

```
t_arg = id / aggregation / 'filter' / json
json = [ [ ["Category","EQ","Accessories"], ["Category","EQ","Laptops"] ],
         [ ["SupplierName","EQ","Technocom"] ] ]
```

Client-side: `new Filter(groups.map(g => new Filter(g.map(row => new
Filter(row[0], FilterOperator[row[1]], row[2], row[3])), false)), true)` —
OR inside a group, AND across groups, operators validated against the
existing `FILTER_OPERATORS` set, empty array clears. The single-filter form
stays as-is for compatibility.

## Example (port 401 after the change)

```abap
client->follow_up_action(
    val   = client->cs_event-binding_call
    t_arg = VALUE #( ( `idProductsTable` ) ( `items` ) ( `filter` )
                     ( json_groups ) ) ).
```

with `json_groups` built from the two facet lists' selected flags — the
ABAP-side `t_products_all` mirror and the per-event model rebuild disappear.
