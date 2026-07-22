# split-container-nav — SplitApp/SplitContainer navigation + QuickView back

**Status: implemented** on the abap2UI5 branch
`claude/ai-demokit-next-batches-rq9sfy` (paired with this demo-kit batch b12),
pending upstream merge.

## Motivation

Porting the `sap.m.SplitApp` (app 097), `sap.m.SplitContainer` (app 096),
`sap.m.QuickView` (app 100) and `sap.m.QuickViewCard` (app 099) demo-kit samples
needs a handful of one-shot control methods that the samples call imperatively
from their controllers, none of which had a bindable equivalent:

- SplitApp/SplitContainer master-detail navigation: `toDetail(pageId)`,
  `toMaster(pageId)`, `backDetail()`, `backMaster()`, `setMode(SplitAppMode)`
  (only `to(pageId)` was already whitelisted).
- QuickView / QuickViewCard page navigation: `navigateBack()` (the external
  "Navigate Back" button in the QuickViewCard sample).

Before this change these methods failed closed at the `CONTROL_METHODS` lookup
in `app/webapp/core/FrontendAction.js`, so the ports could not reproduce the
navigation 1:1.

## Change

Whitelist the six methods in `CONTROL_METHODS` (both the runtime
`app/webapp/core/FrontendAction.js` and the ABAP generator mirror
`z2ui5_cl_app_frontendaction_js`), routed through the existing generic
`evControlCallById` dispatch (resolve control by id, cast args, call) — no
special-casing:

```js
toDetail: ["controlId"], // sap.m.SplitApp/SplitContainer: show a detail page
toMaster: ["controlId"], // sap.m.SplitApp/SplitContainer: show a master page
backDetail: [],          // back in the detail stack
backMaster: [],          // back in the master stack
setMode: ["string"],     // SplitAppMode
navigateBack: [],        // sap.m.QuickView/QuickViewCard: navigate one page back
```

## Example (app 096)

```abap
" master list item -> show a detail page
client->follow_up_action( val   = client->cs_event-control_by_id
                          t_arg = VALUE #( ( `SplitContDemo` ) ( `toDetail` ) ( `detailDetail` ) ) ).
" page navButtonPress -> back in the detail stack
client->follow_up_action( val   = client->cs_event-control_by_id
                          t_arg = VALUE #( ( `SplitContDemo` ) ( `backDetail` ) ) ).
```

Covered by 4 node tests in `node/tests/frontendAction.spec.js` (41 pass),
abaplint clean.
