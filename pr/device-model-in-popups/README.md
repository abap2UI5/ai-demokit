# Set the `device>` model on popup/popover/nested view slots too

> **Status: implemented upstream.** The shared device model (created once
> in `Component.js`, never destroyed) is now bound on every view slot at
> creation — `displayFragment` (popup), `displayPopover` (popover) and
> `displayNestedView` (nest/nest2) in `View1.controller.js` — so
> `{device>...}` bindings work everywhere, not just the main view.

## Summary

The client sets the `device>` named model (a JSONModel over `sap.ui.Device`)
on the **main** view only. Bindings like `{device>/system/phone}` therefore
work in main views but silently resolve to nothing inside popups, popovers
and nested views.

## Motivation

Demo kit samples use device bindings for responsive behavior (e.g.
[IconTabBarStretchContent](https://sdk.openui5.org/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarStretchContent)
`expanded="{device>/isNoPhone}"`). The 1:1 ports in
[abap2UI5/api](https://github.com/abap2UI5/api) (`z2ui5_cl_ai_app_433`,
`z2ui5_cl_ai_app_473`) now use `{device>...}` expressions in main views —
but the same pattern inside a popup fragment would break, which is a trap
for anyone reusing the pattern.

## Current behavior

`z2ui5_cl_app_view1_js`: the device model is created once
(`Models.createDeviceModel()`) and set on the Component and the MAIN view
(`oView.setModel(AppState.state.oDeviceModel, "device")`). The popup,
popover and nested view slots only receive their default view model.

## Proposed change

Set the shared device model on every view slot when it is created (popup,
popover, nest, nest2) — one `setModel(..., "device")` call per slot factory.
No API change, no payload cost (the model is client-only).

## Workaround today

Mirror the needed flag server-side from `client->get( )-s_device` into the
default model before opening the popup — an extra round-trip-coupled copy of
purely client-side data.
