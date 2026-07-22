# message-toast-format — compose a `MessageToast`/`MessageBox` from a template + client args

**Priority: medium** — a very common demo-kit idiom (a toast whose text is
built from an event value on the client) that previously forced a server
round-trip; closes the gap with a small, backward-compatible change to the
existing `control_global` dispatch.

> **Status: IMPLEMENTED** on branch `claude/ai-demokit-edge-cases-ftv30b` of
> abap2UI5 (folder kept until upstream-merged). `evControlCall` in
> `app/webapp/core/FrontendAction.js` (and its ABAP generator mirror
> `z2ui5_cl_app_frontendaction_js`) now composes single-string
> `control_global` methods from a template; `get_t_arg`
> (`z2ui5_cl_core_srv_event`) quotes a leading `{0}` placeholder; 6 node tests
> added. Ports **005, 060, 061, 077** converted (each now init-only).

## Motivation

Most `sap.m` demo-kit controllers build a toast **on the client** from an event
value, e.g.:

```js
// sap.m.sample.Button (port 005)
MessageToast.show(evt.getSource().getId() + " Pressed");
// sap.m.sample.Menu (port 060)
MessageToast.show("Action triggered on item: " + oEvent.getParameter("item").getText());
```

The framework already dispatches static toasts roundtrip-free via
`cs_event-control_global` (`MESSAGE_TOAST.show`), but only with a **fixed
string**. A toast whose text depends on the event therefore had to fall back to
a full server round-trip (`message_toast_display( |… { get_event_arg( ) }| )`)
— even though the value is right there on the client. That is both a wasted
round-trip and *less* faithful than the original (which composes on the client).

## Change

A `control_global` method whose whitelist signature is a single `"string"`
(`MessageToast.show`, `MessageBox.show/information/warning/error/success`) now
accepts **extra positional values** after its text. When there is more than one
value, the first is treated as a **template** and its `{0}`,`{1}`,… placeholders
are replaced by the remaining (client-resolved) values:

```js
// evControlCall, FrontendAction.js
const raw = args.slice(3);
if (kinds.length === 1 && kinds[0] === "string" && raw.length > 1) {
  obj[method](formatTemplate(String(raw[0]), raw.slice(1)));
  return;
}
obj[method](...castArgs(kinds, raw));
// ...
function formatTemplate(tpl, values) {
  return tpl.replace(/\{(\d+)\}/g, (m, i) =>
    (Number(i) < values.length ? String(values[Number(i)]) : m));
}
```

A **lone** string is passed through unchanged, so every existing static toast
keeps working (backward compatible).

### `get_t_arg` refinement

Positional `t_arg` values are quoted as strings *unless* they start with `$`,
`{` or match `.eB(*` (bindings / object-literals emitted raw). A **value-first**
template like `{0} Pressed` starts with `{`, so it would have been emitted raw
and broken. `get_t_arg` now also quotes a value whose leading token is a bare
numeric placeholder (`^\{[0-9]+\}`) — unambiguously a template, never a binding
(`{/PATH}`, `{0/field}`) or object literal (`{ … }`), those still emit raw.

## Usage

```abap
" 005: each button toasts "<id> Pressed", composed on the client, roundtrip-free
)->a( n = `press` v = client->_event_client(
        val   = client->cs_event-control_global
        t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} Pressed` ) ( `$event.oSource.sId` ) ) )

" 060: menu item-selected toast, {0} filled by the resolved item text
)->a( n = `itemSelected` v = client->_event_client(
        val   = client->cs_event-control_global
        t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Action triggered on item: {0}` ) ( `${$parameters>/item}.getText()` ) ) )
```

Both apps lose their `on_event` entirely and become **init-only**.

## Scope / notes

- Text-only: the composed value is still a plain string — `MessageToast`
  docking options / `MessageBox` title+actions are unchanged and still use the
  round-trip `message_toast_display` / `message_box_display` when needed.
- Placeholders are substituted verbatim (`String(value)`); an out-of-range
  `{n}` is left in place.
- Converted so far (all init-only): **003, 005, 016, 060, 061, 074, 076, 077,
  091**. Kept on their round-trip on purpose: text computed server-side or
  driving a model mutation (008, 019, 024, 025's action branch, 047, 080, 085);
  and **049** — its template `Value changed to '{0}'` contains single quotes,
  which `get_t_arg`'s `'…'` JS-string wrapping does not escape, so it would emit
  broken JS. Escaping `'`/`\` in `get_t_arg`'s quoted branch is a small, general
  robustness fix that would unblock 049 (and any toast with an apostrophe) —
  filed here as the next framework step.
