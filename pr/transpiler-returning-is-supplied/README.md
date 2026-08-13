# `IS SUPPLIED` on a RETURNING parameter is always false in transpiled ABAP

**Target: [abaplint/transpiler](https://github.com/abaplint/transpiler)** (not
abap2UI5 — the framework code this breaks is correct ABAP).

## What happens

`z2ui5_if_client~follow_up_action( )` is two calls in one and tells them apart
by whether its own return value is consumed
(`src/01/02/z2ui5_cl_core_client.clas.abap`):

```abap
METHOD z2ui5_if_client~follow_up_action.
  ...
  IF result IS SUPPLIED.                                  " v = client->follow_up_action( … )
    result = mo_srv_event->get_event_client( val   = val  "   → the roundtrip-free wire
                                             view  = view
                                             t_arg = t_arg ).
    RETURN.
  ENDIF.
  ...
  mo_action_front->queue_app_event( … ).                  " client->follow_up_action( … ).
ENDMETHOD.
```

On a real ABAP server that is exactly right: for a RETURNING parameter,
`IS SUPPLIED` is true when the method is called functionally. Transpiled, the
wired branch is dead code — so every handler an app writes into a **view
attribute** reaches the browser as the empty string, and the control ends up
with no handler at all.

## Why — the emitted JS

The predicate compiles to a lookup of the parameter in the caller's input
object, but the caller never puts the return value there. Minimal repro:

```abap
METHOD wire.
  IF result IS SUPPLIED.
    result = |wired:{ val }|.
    RETURN.
  ENDIF.
  WRITE / |queued:{ val }|.
ENDMETHOD.

METHOD run.
  lv = wire( `a` ).   " consumed
  wire( `b` ).        " statement
ENDMETHOD.
```

```js
async wire(INPUT) {
  let result = new abap.types.String({qualifiedName: "STRING"});
  ...
  if ((INPUT && INPUT.result)) {            // <-- never true
    result.set(new abap.types.String().set(`wired:${abap.templateFormatting(val)}`));
    return result;
  }
  abap.statements.write(new abap.types.String().set(`queued:${abap.templateFormatting(val)}`),{newLine: true});
  return result;
}
async run() {
  lv.set((await this.wire({val: new abap.types.String().set(`a`)})));   // no `result` key
  await this.wire({val: new abap.types.String().set(`b`)});             // same call shape
}
```

Both forms emit `{val: …}`; neither passes `result`, so `INPUT.result` is
`undefined` in both. Reproduced identically with `@abaplint/transpiler-cli`
**2.13.40** (the version abap2UI5 pins) and **2.13.59** (newest published at
the time of writing).

The comparison side is
`… IS SUPPLIED` → `(INPUT && INPUT.<name>)`, which is right for IMPORTING and
CHANGING parameters — only the RETURNING slot is missing from the call.

## Proposed change

When a method call's result is consumed, pass the returning slot in the input
object (e.g. `await this.wire({val: …, result: 1})`), so
`INPUT.result` is truthy exactly when the ABAP predicate is. The transpiler
already knows which call sites consume the value — it emits
`x.set((await …))` for them and a bare `await …` for the others.

## Impact here

Every `v = client->follow_up_action( … )` wire — the roundtrip-free press /
change / select / openBy handlers, the client-composed toasts, the anchored
popovers. 430 call sites in 106 port classes, plus one in the framework itself
(`z2ui5_cl_app_startup.clas.abap`, the `open_new_tab` wire).

26 ports went red in the e2e nightly of 2026-08-13 — the first nightly after
the corpus renamed its `_event_client( )` wires to `follow_up_action( )` — and
the GitHub Pages demo carries the same breakage for its users. App 049's
failure states it plainly: *"no StepInput carries a change handler"*.

## Interim workaround in this repo

`web/ci/patch_follow_up_action.mjs` rewrites the **consumed** form back to
`_event_client( )` in the build COPY only (both transpiled builds: the browser
bundle and the Node e2e backend). `_event_client( )` is the same wire without
the second role — the framework's own interface documentation calls it "the
identical roundtrip-free wire, byte for byte" — so it has nothing to detect
and transpiles correctly. The committed corpus keeps `follow_up_action( )`:
it is correct ABAP and needs no fix on a real server.

When this lands: delete the patch script, its two call sites
(`web/package.json` assemble, `scripts/e2e-build.mjs`) and this folder.
