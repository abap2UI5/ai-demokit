# messagepopover-async-url — a declarable `MessagePopover.setAsyncURLHandler`

**Priority: low / niche** — filed for the record; the messages render and
navigate fine without it, so this is an enhancement, not a blocker.

## Motivation

`sap.m.sample.MessagePopoverMessageHandling` (port app **067**) wires an async
URL-validation gate in the controller:

```js
oMessagePopover.setAsyncURLHandler(function (config) {
  // config.url, config.id, config.promise
  // resolve({ allowed: true|false }) after (async) validation
});
```

It lets the app asynchronously decide, per message link, whether an absolute URL
may be followed (the sample allows relative `#` links and disables absolute
`http://…` links after "validation"). The callback is a live JS function with a
promise — there is no declarable ABAP equivalent, so app 067 drops it (declared
IMPROVISED deviation); the links still render, they just aren't gated.

## Why it is hard / why it is niche

- `setAsyncURLHandler` takes a **function** that returns a **promise** — the
  callback shape (async, per-URL, resolve-with-object) does not map onto the
  positional-`t_arg` frontend-action model, and a full round-trip per link hover
  would be the wrong ergonomics.
- The behaviour is a security/validation policy, not UI — most ports never need it.

## Possible shapes (for discussion)

1. A **declarative allow/deny policy** on the MessagePopover: e.g. a property
   like `asyncUrlPolicy = "relative-only"` that the framework turns into a
   built-in `setAsyncURLHandler` (allow relative, deny absolute), covering the
   sample's exact case without a custom callback.
2. A **registered custom-JS hook** (the existing `z2ui5` custom-control / `Z2UI5`
   event escape hatch) that installs an app-provided validator — powerful but
   drops back to hand-written JS, which the ports avoid.

Option 1 is the abap2UI5-idiomatic one (a bindable/declarable property over a JS
callback) and would make app 067 fully 1:1. Kept low priority until a second
sample needs it.
