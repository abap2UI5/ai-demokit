# pr/app-lifecycle-base-class — optional base class for the app lifecycle dispatch

**Status: open** — proposal for
[abap2UI5/abap2UI5](https://github.com/abap2UI5/abap2UI5), surfaced by the
2026-08-11 corpus review. Backend-only structure; the frontend and the wire
are untouched.

## Motivation

Every app hand-writes the same dispatcher. Measured over this corpus: **all
366 classes** (365 ports + overview) carry the identical block

```abap
METHOD z2ui5_if_app~main.

  me->client = client.
  IF client->check_on_init( ).
    model_init( ).
    view_display( ).
  ELSEIF client->check_on_event( ).
    on_event( ).
  ENDIF.

ENDMETHOD.
```

plus the `DATA client TYPE REF TO z2ui5_if_client.` member — roughly 12 lines
× 366 ≈ **4,400 lines of pure ceremony in this corpus alone**, and the same
shape repeats in the samples repo and in the `building-apps.md` template. The
corpus even needs a pattern-lint rule (main-first, model_init-last) purely to
keep this hand-written block uniform.

## Current behavior

`z2ui5_if_app` (src/02/z2ui5_if_app.intf.abap) declares a single method
`main( client )`; the framework calls it on every round-trip and every app
re-implements the lifecycle branching itself.

## Proposed change

Ship an **optional** abstract convenience class in `src/02/` next to the
interface — the interface stays the contract, nothing existing changes:

```abap
CLASS z2ui5_cl_app DEFINITION PUBLIC ABSTRACT.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.                " default: empty
    METHODS on_event.               " default: empty
    METHODS on_navigated.           " default: re-display is app's choice

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_app IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ELSEIF client->check_on_navigated( ).
      on_navigated( ).
    ENDIF.

  ENDMETHOD.

  " on_init / on_event / on_navigated: empty default implementations

ENDCLASS.
```

An app then subclasses and overrides only the hooks it needs:

```abap
CLASS z2ui5_cl_my_app DEFINITION PUBLIC INHERITING FROM z2ui5_cl_app.
  PUBLIC SECTION.
    DATA name TYPE string.
  PROTECTED SECTION.
    METHODS on_init  REDEFINITION.
    METHODS on_event REDEFINITION.
  PRIVATE SECTION.
ENDCLASS.
```

Design points:

- **Optional.** Implementing `z2ui5_if_app` directly stays fully supported —
  apps that need the raw `main` (sticky sessions, custom branching) keep it.
  No framework code ever tests for the class; it only saves the subclass the
  dispatch.
- **Serialization-neutral.** The protected `client` reference is exactly what
  every port already declares today; the draft serializer handles the shape
  unchanged.
- **Downport-friendly.** Plain inheritance + `REDEFINITION`, available on
  every supported release including 7.02.
- For this corpus: adopting it is a separate maintainer decision (365-port
  diff + recipe/pattern-lint update); the proposal stands on the framework's
  own app-developer experience regardless.

## Example

App 001 (`src/01/b05/z2ui5_cl_dmo_app_001.clas.abap`) shrinks from 54 to
~40 lines: the class definition keeps only `INHERITING FROM z2ui5_cl_app` +
`METHODS on_init REDEFINITION`, and the implementation is just the
view-building method.
