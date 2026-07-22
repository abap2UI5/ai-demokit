# urlhelper-abap-api — make the `URLHELPER` frontend action callable from ABAP

**Priority: high** — blocks a whole family of ports (external links, phone,
SMS, e-mail) and reveals that `open_new_tab` is unusable for external URLs.

## Motivation

Several `sap.m` demo kit samples trigger the platform URL helpers or open an
external site:

- `sap.m.sample.UrlHelper` (port app **084**) — a `DisplayListItem` list whose
  items call `URLHelper.triggerTel` / `triggerSms` / `triggerEmail` / `redirect`.
- `sap.m.sample.ObjectAttributes` (app **073**) and `ObjectHeader` (app **041**)
  — an active attribute / link that opens `http://www.sap.com`.

None of these can be ported 1:1 today.

## Current behavior

The **frontend already has the right action**. `app/webapp/core/FrontendAction.js`
defines `evUrlHelper`, wired into the `ACTIONS` map as `URLHELPER`:

```js
function evUrlHelper(oController, args) {
  const params = args[2] ?? {};
  const actions = {
    REDIRECT:      () => { /* isSafeRedirectProtocol → _URLHelper.redirect(params.URL, params.NEW_WINDOW) */ },
    TRIGGER_EMAIL: () => _URLHelper.triggerEmail(params.EMAIL, params.SUBJECT, params.BODY, params.CC, params.BCC, params.NEW_WINDOW),
    TRIGGER_SMS:   () => _URLHelper.triggerSms(params),
    TRIGGER_TEL:   () => _URLHelper.triggerTel(params),
  };
  const fn = actions[args[1]];
  if (fn) fn();
}
```

and the ABAP client interface even exposes the event id
(`z2ui5_if_client=>cs_event-urlhelper VALUE 'URLHELPER'`).

**But there is no ABAP-side way to invoke it.** `evUrlHelper` expects
`args[1]` = the sub-action (`TRIGGER_TEL` / `REDIRECT` / …) and **`args[2]` = a
params _object_** (`{ URL, EMAIL, SUBJECT, NEW_WINDOW, … }`). The `_event_client`
/ `follow_up_action` `t_arg` mechanism only carries a flat `string_table`, so
`args[2]` arrives (at best) as a string, and `params.URL` / `params.EMAIL` are
`undefined`. There is no helper method and no example port in the repo.

The obvious fallback — `cs_event-open_new_tab` — **does not work for external
URLs**: `evOpenNewTab` gates the URL through `Lib.isValidRedirectURL`, which
rejects any different-origin target:

```js
function isValidRedirectURL(url) {
  const parsed = parseUrl(url);
  if (parsed.origin !== window.location.origin) { /* blocked */ return false; }
  return hasSafeProtocol(parsed);            // http/https only
}
```

So `open_new_tab` is **same-origin-only** and additionally can never carry a
`tel:` / `sms:` / `mailto:` scheme. Confirmed by a live check of app 084: the
tel/sms/email items only produce a toast, and an external `open_new_tab` is
blocked. Ports 041/073 that use `open_new_tab` for `http://www.sap.com` are
affected by the same origin gate.

## Proposed change

Expose `URLHELPER` from the ABAP client with a typed helper that serialises the
params object, e.g.

```abap
client->url_helper_redirect( url = `http://www.sap.com` new_window = abap_true ).
client->url_helper_trigger_tel( `+49 6227 747474` ).
client->url_helper_trigger_sms( `+49 173 123456` ).
client->url_helper_trigger_email( email = `john.smith@sap.com` subject = `Info Request` ).
```

Implementation options (any one is enough):

1. **Client helper methods** (preferred) that build the `URLHELPER` action with a
   JSON params object as the trailing `t_arg`, and have `evUrlHelper`
   `JSON.parse` `args[2]` when it is a string.
2. Or document a `t_arg` contract — `t_arg = ( sub_action ) ( params_json )` —
   and JSON-parse `args[2]` in `evUrlHelper`.

`isSafeRedirectProtocol` (already used by `REDIRECT`) permits cross-origin
http/https, so external links keep their security gate while finally working.

## Result once implemented

- app 084 becomes a 1:1 port (tel/sms/email/redirect) — its `IMPROVISED`
  toast deviation drops.
- apps 041 / 073 external links switch from the broken `open_new_tab` to
  `url_helper_redirect` — a correctness fix, and a CAPABILITIES.md note that
  `open_new_tab` is same-origin-only.
