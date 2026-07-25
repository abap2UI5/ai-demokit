# feedinput-enable-post-button — whitelist `FeedInput.enablePostButton`

**Status: open** — small `CONTROL_METHODS` gap. From demo-kit app 236
(`sap.m.sample.FeedInput`, 2026-07-25).

## Motivation

The FeedInput sample's `onActionButtonPress` opens a Dialog whose begin/end
buttons call `oFeedInput.enablePostButton(true)` / `(false)` to toggle the
FeedInput's **Post** button independently of the control's `enabled` property.
The port (app 236) renders the Dialog 1:1, but the two buttons can only close it
— the post-button toggle is lost (declared IMPROVISED).

## Current behavior (source refs)

`enablePostButton(bEnabled)` is a public `sap.m.FeedInput` method
(`src/sap.m/src/sap/m/FeedInput.js`) but is **absent from the `CONTROL_METHODS`
whitelist** in abap2UI5 `app/webapp/core/FrontendAction.js`. There is no
bindable-property alternative: the `enabled` property disables the whole text
input, not just the Post button, so this cannot be expressed as a two-way bound
property (the usual prefer-a-bindable-property route does not apply).

## Proposed change

Add `enablePostButton` to `CONTROL_METHODS` with a single `bool` arg kind, routed
through the existing generic `control_by_id` dispatch — no special-casing:

```js
enablePostButton: ["bool"], // sap.m.FeedInput: toggle the Post button
```

## Example (app 236)

```abap
" dialog "enable" button -> re-enable the feed's Post button
client->follow_up_action( val   = client->cs_event-control_by_id
                          t_arg = VALUE #( ( feed_id ) ( `enablePostButton` ) ( `X` ) ) ).
```
