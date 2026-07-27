# nav-app-call-caller-draft — Back must restore the caller as the user LEFT it

**Status: IMPLEMENTED (2026-07-27)** — abap2UI5 branch
`claude/ai-demokit-state-loss-cyz42a`. From the overview app of this repo:
search a term / flip the Shell switch, start a listed app, press the browser
Back button — the overview came back in its *rendered* state, with the search
box empty and the Shell switch back on.

## Motivation

The overview enables hash routing (`client->set_nav_routing( )`, mode `KEEP`)
and starts a port with `client->nav_app_call( )`, so the port replaces the
overview in the same tab and the browser Back button returns to it (#36). KEEP
mode promises the **exact preserved state** — "all user input" — but everything
the user had changed on the client since the overview last rendered was gone
after Back.

The lost state is not exotic: the Shell / Tree-view switches and the three
filter checkboxes are two-way bound, and the frontend ships them with the very
event (`START_APP`) that triggers the navigation. They *do* reach the backend
and they *are* saved. They just are not what Back restores.

## Current behavior (source refs)

Each roundtrip stores the app under a **fresh** draft id:

* `z2ui5_cl_core_action=>factory( )` — `ms_draft-id = uuid_get_c32( )`, then
  `model_json_parse( )` applies the frontend's model delta to the app object.
* `prepare_app_stack( )` (`factory_stack_call`) — `mo_app->db_save( )` saves the
  **calling** app, including that delta, under the new id (call it `ID2`).
* `View1._updateBrowserHistory` (`app/webapp/controller/View1.controller.js`) —
  on `CHECK_NAV_APP_CALL` it only *pushes* the called app's route. The caller's
  history entry is left untouched, and it still carries `ID1`, the draft of the
  render the user was looking at *before* touching any switch.

Back therefore navigates to `#/app/<CALLER>/ID1`, `Server.onHashChange` posts a
restore roundtrip, `factory_first_start` loads draft `ID1` — the caller as it
was **rendered**, not as the user **left** it. `ID2` is never routed to.

## Proposed change

Tell the frontend where the caller was just saved, and let it repoint that one
history entry before pushing the callee's route (`replaceHash` — the entry is
still the top one, so the history depth is unchanged):

* `z2ui5_if_core_types=>ty_s_next_frontend` — two new fields
  `nav_app_call_prev_app` / `nav_app_call_prev_id`.
* `z2ui5_cl_core_action=>factory_stack_call` — fill them with the calling app's
  class and its just-saved draft id; only on the **first** hop of a request, so
  a chain `A -> B -> C` keeps `A`, the app the user actually navigated away from.
* `View1._repointCallerEntry( )` — `replaceHash` the caller's route with the
  fresh draft, adopting `currentDraftId` first so `Server.onHashChange` still
  reads the write as our own echo and does not fire a restore roundtrip. KEEP
  mode only; a FRESH route carries no draft and restarts the app by design.

## Example (this repo's overview app)

```abap
" the two-way bound flags travel with the START_APP event ...
client->nav_app_call( li_app ).
" ... and Back now returns to the overview with the Shell switch, the tree
" toggle and the filter checkboxes exactly as they were left
```

Client-side state that never reaches the model still needs an app-side fix — the
overview binds its search query two-way (`search_query`) and re-applies the
frontend filter with `follow_up_action( cs_event-binding_call )` on rebuild.
