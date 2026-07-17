# Broaden the `control_call_by_id` whitelist to a few more imperative methods

## Summary

`z2ui5_if_client=>control_call_by_id( id method … )` calls a **whitelisted**
method on a control after render (the whitelist is the safety boundary). The
first release ships a deliberately small set:

```js
// app/webapp/core/FrontendAction.js
const CONTROL_METHODS = {
  to: ["controlId"],
  back: [],
  focus: [],
  scrollToIndex: ["int"],
  scrollTo: ["int", "int"],
};
```

Its own comment states the scope: *"imperative methods that have no binding
equivalent."* A few common demo-kit controller actions fall exactly in that
scope but are not yet on the list, so 1:1 ports still have to work around them.

## Motivation

Two ports in [abap2UI5/api](https://github.com/abap2UI5/api) carry an
`IMPROVISED` deviation only because the imperative method they need is not
whitelisted:

- **[PDFViewerPopup](https://sdk.openui5.org/entity/sap.m.PDFViewer/sample/sap.m.sample.PDFViewerPopup)**
  (`z2ui5_cl_ai_app_469`) — the original opens a **popup-mode**
  `sap.m.PDFViewer` with `oPDFViewer.open()`. `open` is not whitelisted, so the
  port instead embeds the viewer in a `core:FragmentDefinition` → `Dialog` and
  adds its own Close button. Not the same control, and more view scaffolding
  than the original.
- **[PanelExpanded](https://sdk.openui5.org/entity/sap.m.Panel/sample/sap.m.sample.PanelExpanded)**
  (`z2ui5_cl_ai_app_471`) — the original toggles a panel with
  `oPanel.setExpanded(!oPanel.getExpanded())`. `setExpanded` is not whitelisted,
  so the port routes the toggle through a two-way bound `expanded` flag and a
  `TOOLBAR_PRESSED` event round-trip. (A pure expression binding cannot flip a
  value, so a round-trip is unavoidable without the client-side call.)

Both are precisely *"imperative methods with no binding equivalent"* — the
category the whitelist already targets.

## Current behavior

`control_call_by_id` resolves the id via `ViewSlots.resolveById`, checks the
method against `CONTROL_METHODS`, casts each positional argument to the declared
kind, and calls it. An un-whitelisted method is logged and skipped
(`control_call_by_id: method '<m>' not allowed`). The safety model is sound;
only the list is narrow.

## Proposed change

Add the following entries to `CONTROL_METHODS` in
`app/webapp/core/FrontendAction.js` (and regenerate the embedded frontend via
`npm run app2abap`):

```js
open:        [],          // PDFViewer / Dialog / Popover popup-mode open
close:       [],          // symmetric close
setExpanded: ["bool"],    // Panel, Tree nodes, expandable containers
```

Each has zero or one scalar argument, so the existing arg-kind casting covers
them; `bool` already exists as a kind (used by nothing on controls yet, but the
caster handles `X`/`''`). No new resolution or security surface — the same
`resolveById` + whitelist gate applies. Keep the list curated: only add methods
that (a) are imperative, (b) have no binding equivalent, and (c) take
scalar/id/no arguments.

## Example

```abap
" 471: toggle a panel client-side, no round-trip
client->control_call_by_id(
  id     = `panel3`
  method = `setExpanded`
  params = VALUE #( ( `X` ) ) ).   " or read the current state and invert

" 469: open the PDF viewer in popup mode, 1:1 with the original
client->control_call_by_id( id = `pdfViewer` method = `open` ).
```

## Notes

- Once shipped, update
  [CAPABILITIES.md](https://github.com/abap2UI5/api/blob/main/CAPABILITIES.md)
  (the "Post-render actions" row) and drop the `IMPROVISED` deviations on
  ports 469 and 471.
- `addValidator` (needed by
  [MultiInput](https://sdk.openui5.org/entity/sap.m.MultiInput/sample/sap.m.sample.MultiInput),
  `z2ui5_cl_ai_app_454`) is intentionally **out of scope** here: it registers a
  client-side callback (free text + Enter → token), not a one-shot imperative
  call, so it does not fit the `control_call` model and needs a separate
  mechanism.
