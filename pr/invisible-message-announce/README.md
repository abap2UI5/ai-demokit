# pr/invisible-message-announce — an accessibility announcement needs a global target

**Status: open** — found by the IMPROVISED harvest 2026-08-05
(`node scripts/probes/improvised-cluster.mjs --family a11y-announce`),
1 deviation in app **289**; the capability is general.

## Motivation

`sap.ui.core.InvisibleMessage` is UI5's screen-reader channel: an app calls
`announce(text, mode)` and the text is read out without appearing on screen.
Samples use it whenever content changes without a focus change — app 289
(`sap.m.sample.MessageStrip`) announces *"New Information Bar of type …"*
with `InvisibleMessageMode.Assertive` every time the strip is regenerated.

The port drops it. An abap2UI5 app that changes content from the backend has
**no way to announce anything** — which is a straight accessibility hole, not a
sample-fidelity detail: the whole point of the framework is that content
changes come from the server.

## Current behavior (source)

`InvisibleMessage` is a **singleton**, obtained with
`InvisibleMessage.getInstance()`. It renders no control, so it has no id — and
both abap2UI5 wires need one of those two things
(`app/webapp/core/FrontendAction.js`):

- `CONTROL_BY_ID` resolves an id through `ViewSlots` — there is no id;
- `CONTROL_GLOBAL` dispatches against `GLOBAL_TARGETS`, and the table has
  `MESSAGE_TOAST`, `MESSAGE_BOX`, `BUSY_INDICATOR`, `THEMING`, `POPUP` — no
  announcement target.

App 141 (`sap.ui.core.sample.InvisibleMessage`) covers the *control*-based
announcement idiom, which is why the corpus has partial coverage at all; the
singleton path has none.

## Proposed change

One entry in `GLOBAL_TARGETS`, resolved lazily like `THEMING`/`POPUP` because
`sap/ui/core/InvisibleMessage` is `@since 1.78` and must not become a hard
dependency on 1.71:

```js
INVISIBLE_MESSAGE: {
  get: () => {
    const IM = sap.ui.require("sap/ui/core/InvisibleMessage");
    return IM ? IM.getInstance() : undefined;
  },
  methods: { announce: ["string", "string"] },   // text, InvisibleMessageMode
},
```

The existing "not available" guard then reports the older runtime instead of
failing the component load — the exact pattern `POPUP.setWithinArea` (@since
1.89) already uses.

`announce` takes `(sText, sMode)` with `sMode` ∈ `Polite` | `Assertive`; both
are plain strings on the wire, so no new argument kind is needed. A default of
`Polite` when the second argument is missing matches UI5's own behaviour.

## Example (app 289, `sap.m.sample.MessageStrip`)

```abap
" the press handler already recomputes type + flags in ABAP; it then announces:
client->_event_client(
  val   = client->cs_event-control_global
  t_arg = VALUE #( ( `INVISIBLE_MESSAGE` )
                   ( `announce` )
                   ( |New Information Bar of type { ms_view-strip_type }| )
                   ( `Assertive` ) ) ).
```

roundtrip-free, exactly where the original calls it.

## Affected ports

| App | Sample | Today |
|-----|--------|-------|
| 289 | `sap.m.sample.MessageStrip` | the assertive announcement on every regenerate is dropped |

Beyond the corpus this is the only route to an ARIA live announcement for **any**
abap2UI5 app, which is why it is filed despite a single porting hit.
