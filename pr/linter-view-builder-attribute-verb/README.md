# pr/linter-view-builder-attribute-verb — read the view builder's attribute verb as `a( )`, not `att( )`

**Target repo: [abap2UI5/linter](https://github.com/abap2UI5/linter)** (not
abap2UI5 core). Status: open.

## Motivation

This corpus migrated all 416 ports from the frozen `z2ui5_cl_ai_xml` to its
successor `z2ui5_cl_ui5_view_builder` — the migration the linter's own
`non-released-api` rule demands, one finding per port:

> `z2ui5_cl_ai_xml` is not part of abap2UI5's released API (src/02) — the
> superseded view builders and entry point (src/99): frozen legacy, kept only
> so existing installations keep compiling; use `z2ui5_cl_ui5_view_builder`

After the migration the linter reconstructs the element tree correctly but
**loses every attribute**, because it still spells the new builder's attribute
verb `att( )`. Upstream renamed it to `a( )` in
[abap2UI5#2580](https://github.com/abap2UI5/abap2UI5/pull/2580) (commit
`6c5c5aa`, 2026-08-14) — the same one-letter verb the old builder always used,
so both dialects now agree on it.

The failure is not subtle: with the attributes gone, so are the `xmlns`
declarations, and every port fails with

```
namespace prefix 'm' is used but never declared (xmlns:m)
```

416 of 416 ports, for a reason that has nothing to do with the port.

## Current behavior

`lib/builders.mjs` carries the pre-rename spelling:

```js
export const VIEW_BUILDER = Object.freeze({
  class: 'z2ui5_cl_ui5_view_builder',
  open: 'ele', leaf: 'tag', att: 'att', shut: 'end',
  bool: 'b',
  boolFix: 'pass it as att( b = … ), which renders true/false itself',
});
```

`dialectOf( )` picks the dialect from the factory the source names, so a class
on `z2ui5_cl_ui5_view_builder=>factory( )` gets `att: 'att'` and its `a( )`
calls match no verb at all. `KIND_BY_VERB` already maps `'a' → 'att'`, so the
rest of the reconstructor needs no change.

## Proposed change

One line, plus the fix hint that quotes the verb:

```js
export const VIEW_BUILDER = Object.freeze({
  class: 'z2ui5_cl_ui5_view_builder',
  open: 'ele', leaf: 'tag', att: 'a', shut: 'end',
  bool: 'b',
  boolFix: 'pass it as a( b = … ), which renders true/false itself',
});
```

Both builders then spell the attribute verb `a`, which `builderOfVerb( )`
resolves to `AI_XML` for that token alone. That only matters for the boolean
fix hint, so if the distinction is worth keeping, resolve `a( )` by the
factory the source names rather than by the verb — the element verbs
(`open`/`leaf`/`shut` vs `ele`/`tag`/`end`) still tell the two apart on their
own.

The module header table wants the same update:

```
 *   a( n v )          att( n v )                  set an attribute
```

becomes

```
 *   a( n v )          a( n v )                    set an attribute
```

## Verification

Patching the single line in an installed `node_modules/@abap2ui5/linter` takes
this corpus from **416 failing** to **415 passing** — the one remaining
failure is `z2ui5_cl_smpc_app_298` on the vendored AJSON copy
(`z2ui5_cl_ajson`), an unrelated `non-released-api` finding.
