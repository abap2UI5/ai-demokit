# message_box_display: expose the MessageBox `dependentOn` option

> **Status: implemented upstream.** `z2ui5_if_client=>message_box_display`
> now carries `dependenton` and `contentwidth` importing parameters; the
> client resolves `dependenton` (a control id) to its `sap.ui.core.Element`
> before building the `MessageBox.show` options. See
> [abap2UI5/abap2UI5](https://github.com/abap2UI5/abap2UI5)
> (`src/02/z2ui5_if_client.intf.abap`, `src/01/02/z2ui5_cl_core_client`,
> `app/webapp/core/Messages.js`).

## Summary

`z2ui5_if_client=>message_box_display` maps most `sap.m.MessageBox` options
(actions, emphasizedAction, initialFocus, textDirection, icon, details,
closeOnNavigation, …) but not **`dependentOn`** (UI5 ≥ 1.124): an element the
message box is added to as a dependent, so it participates in that element's
lifecycle. `contentWidth` is missing in the same way.

## Motivation

The official demo kit sample
[sap.m.sample.MessageBoxInitialFocus](https://sdk.openui5.org/entity/sap.m.MessageBox/sample/sap.m.sample.MessageBoxInitialFocus)
passes `dependentOn` in both `MessageBox.show/confirm` calls. Its 1:1 rebuild
in [abap2UI5/api](https://github.com/abap2UI5/api)
(`z2ui5_cl_ai_app_447`) can restore every other option but has to declare
this one as not expressible (deviation in `meta/z2ui5_cl_ai_app_447.json`).

## Current behavior

`src/02/z2ui5_if_client.intf.abap`, `METHODS message_box_display` — parameters
today: `text, type, title, styleclass, onclose, actions, emphasizedaction,
initialfocus, textdirection, icon, details, closeonnavigation`. No
`dependenton`, no `contentwidth`.

## Proposed change

Add two optional importing parameters and pass them through to the
`MessageBox.show` options object on the client:

```abap
METHODS message_box_display
  IMPORTING
    ...
    dependenton       TYPE clike OPTIONAL   " control id; resolved to the element client-side
    contentwidth      TYPE clike OPTIONAL.  " CSS size
```

`dependenton` would take a control id and the client resolves it via
`Element.getElementById` before building the options (UI5 expects an
`sap.ui.core.Element`).

## Example (target usage)

```abap
client->message_box_display(
  text         = `The quantity you have reported exceeds the quantity planned.`
  type         = `confirm`
  initialfocus = `Custom Action`
  dependenton  = `myPage` ).
```

## Workaround today

None at the API level; the port omits the option. (The generic
`cs_event-display_message_box` frontend action forwards a raw options object,
but cannot resolve a control id to an element.)
