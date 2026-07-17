# Serve a second, named JSON model from ABAP

## Summary

abap2UI5 serves exactly **one** ABAP-fed JSON model per view slot (the
default model). Demo kit samples frequently bind a second, named model —
`img>` for shared image data, small view models — and ports have to flatten
those into the default model or freeze them to literals.

## Motivation

In [abap2UI5/api](https://github.com/abap2UI5/api) the ports of
[Carousel](https://sdk.openui5.org/entity/sap.m.Carousel/sample/sap.m.sample.CarouselWithControls)
(`z2ui5_cl_ai_app_420`),
[Image](https://sdk.openui5.org/entity/sap.m.Image/sample/sap.m.sample.ImageModeBackground)
(`z2ui5_cl_ai_app_434`) and
[ScrollContainer](https://sdk.openui5.org/entity/sap.m.ScrollContainer/sample/sap.m.sample.ScrollContainer)
(`z2ui5_cl_ai_app_473`) all had to resolve `img>/...` bindings statically —
each carries an IMPROVISED deviation for it. The capability map of that repo
(CAPABILITIES.md) tracks "named JSON models fed from ABAP" as ❌.

## Current behavior

Named model slots do exist client-side — `device>` (sap.ui.Device),
`http>` (when `switch_default_model_path` moves the default to OData),
`template>` (XML templating), and named OData models via
`cs_event-set_odata_model` — but every `_bind/_bind_edit` path goes into the
single default JSONModel of the view slot (`z2ui5_cl_core_srv_bind`,
`z2ui5_cl_app_view1_js` `_createViewModel`).

## Proposed change (sketch)

An optional model name on the bind methods, mapping to a named JSONModel that
is serialized/deserialized alongside the default one:

```abap
client->_bind_edit( val = t_images model = `img` ).   " binds {img>/T_IMAGES}
```

One-way (`_bind`) support would already cover the demo kit cases (the named
models there are read-only reference data).

## Workaround today

Flatten into the default model (rename paths) or inline the values as
literals; both lose the 1:1 binding structure of the original.
