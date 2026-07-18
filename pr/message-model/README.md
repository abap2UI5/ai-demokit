# message> model on every view slot (handleValidation)

**Status: implemented upstream 2026-07-18** in
[abap2UI5/abap2UI5](https://github.com/abap2UI5/abap2UI5): every view slot
(main, popup, popover, nested) carries the central UI5 message model as the
named `message` model and is registered for automatic validation-message
collection (`Lib.getMessaging` resolves `sap/ui/core/Messaging` since
1.118 / UI5 2.x with the `MessageManager` fallback before;
`ViewSlots.destroy` unregisters). Demoed by beta sample
`z2ui5_cl_demo_app_458` in abap2UI5/samples (`src/00/08`).

## Summary

The MessagePopover demo kit family (MessagePopover,
MessagePopoverMessageHandling, DialogWithMessagePopover,
MessageViewWithGrouping — 4–5 in-scope samples) binds `{message>/}`
against the MessageManager's model, which abap2UI5 did not expose — the
capability map carried "MessageManager auto-collection ❌". UI5 ships the
mechanism practically for free: `Messaging.registerObject(view, true)` +
`Messaging.getMessageModel()`.

## What ports get

- `items="{message>/}"` with a `MessageItem`/`StandardListItem` template
  works 1:1 in every slot — the original binding structure of the
  MessagePopover family.
- Failed control validations (binding **type**/constraint errors, e.g.
  `sap.ui.model.type.Integer` on a two-way `_bind_edit` path) collect and
  clear automatically, including the control's `valueState` — no app code,
  no roundtrip.

## Verification

Headless probe against the OpenUI5 runtime (real typing): invalid input →
message `Enter a number without decimals.` collected (Error) + rendered in
a `{message>/}`-bound list + `valueState=Error`; valid input clears all
three. Facade resolution unit-tested (Messaging / MessageManager / bare
bootstrap).
