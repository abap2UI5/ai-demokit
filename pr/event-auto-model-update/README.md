# pr/event-auto-model-update — push the model automatically when an event round-trip changed it

**Status: open** — proposal for
[abap2UI5/abap2UI5](https://github.com/abap2UI5/abap2UI5), surfaced by the
2026-08-11 corpus review ("can the samples get simpler?"). No workaround
needed here — `view_model_update( )` works; this is about removing a
mandatory line and, more importantly, a silent-failure class.

## Motivation

After changing bound data in an event handler, every app must remember to call
`client->view_model_update( )` — or the UI silently shows stale data. Measured
over this corpus: **230 calls in 125 of 365 ports**, and in the minimal ports
the call is half of the handler body, e.g. app 348
(`src/02/b19/z2ui5_cl_dmo_app_348.clas.abap`):

```abap
WHEN `LAYOUT_CHANGE`.
  currentbreakpoint = client->get_event_arg( ).
  client->view_model_update( ).
```

The real cost is not the line — it is the failure mode of forgetting it.
A handler that mutates bound state without the call is syntactically clean,
passes every gate (the render gate mocks the model, structural-diff never sees
behaviour), and simply renders stale. That is the same silent-failure shape
that motivated the `dead-event-wire` and `relative-binding-without-context`
linter rules — except this one is not statically detectable in general (the
mutation can happen behind any method call).

## Current behavior

The decision to send the model is a manual flag:

- `z2ui5_cl_core_client=>z2ui5_if_client~view_model_update` sets
  `ms_next-s_set-s_view-check_update_model = abap_true` (src/01/02/z2ui5_cl_core_client.clas.abap).
- `z2ui5_cl_core_handler=>check_view_update_needed` returns true when a slot
  ships new XML or one of the three `check_update_model` flags is set;
  otherwise `main_end` responds with `ms_response-model = '{}'`
  (src/01/02/z2ui5_cl_core_handler.clas.abap).

So on an event round-trip that displays nothing and sets no flag, the app's
model changes stay on the server until the next full render.

## Proposed change

Detect the mutation instead of asking the app to declare it. In
`main_process` / `main_end`, for an event round-trip that ships no view XML:

1. serialize the model once **after** the incoming model deltas are applied
   but **before** `app->main( )` runs (`model_json_stringify( )` — the same
   call `main_end` already uses),
2. serialize again after `main( )` returned,
3. if the two strings differ, respond with the second one exactly as if
   `view_model_update( )` had been called.

Nothing changes on the wire or in the frontend — the response is
byte-identical to today's explicit call, so the thin-frontend contract is
untouched; the backend only becomes the authority on *whether* its own state
changed, which it arguably should be.

Costs and options, honestly:

- The diff costs one extra `model_json_stringify( )` per event round-trip
  (the "after" one is the response payload itself when a change is detected;
  when no change is detected today's `'{}'` short-circuit is lost). For large
  models that is measurable CPU — worth a benchmark against `db_save( )`,
  which already XML-serializes the full app state every round-trip anyway.
- If default-on is judged too invasive, an **opt-in** keeps it free for
  everyone else: `client->set_model_auto_update( )` once in `check_on_init`
  (mirroring `set_nav_routing`), or a marker on `z2ui5_if_app`.
  `view_model_update( )` stays supported either way — existing apps are
  unaffected.

## Example

App 007 (`sap.m.CheckBox` tri-state, `src/01/b02/z2ui5_cl_dmo_app_007.clas.abap`) today:

```abap
WHEN `PARENT_CLICKED`.
  child1 = client->get_event_arg( ).
  child2 = client->get_event_arg( ).
  child3 = client->get_event_arg( ).
  client->view_model_update( ).
```

with auto-detection the last line disappears — and a new app that forgets it
can no longer render stale.
