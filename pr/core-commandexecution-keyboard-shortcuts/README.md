# core-commandexecution-keyboard-shortcuts — declarative shortcuts

**Status: open — deliberately deferred 2026-07-27**: a real feature (client
shortcut registry + command bus bridge), too large to land alongside the
CONTROL_METHODS fixes; reviewed and kept current. From demo-kit app 232
(`sap.ui.core.sample.Commands`, 2026-07-25).

## Motivation

`sap.ui.core.sample.Commands` exists *entirely* to demonstrate
`sap.ui.core.CommandExecution` — declarative command objects bound to keyboard
shortcuts. abap2UI5 has no way to express any of it, so the port (app 232) drops
the sample's whole point and fakes the rest.

## Current behavior (source refs)

abap2UI5 is a thin frontend: it renders XML and forwards **named** events. There
is no `CommandExecution` control, no `$cmd>` command model, and no manifest-level
shortcut registry. `CAPABILITIES.md` has no `CommandExecution`/`shortcut`/
`keyboard` entry (verified), and the `follow_up_action` `CONTROL_METHODS`
whitelist has no command primitive.

The sample declares in `manifest.json`:
```json
"sap.ui5": { "commands": { "Save": { "shortcut": "Ctrl+S" }, "Delete": { "shortcut": "Ctrl+D" } } }
```
and binds them in the view:
```xml
<core:CommandExecution command="Save" execute=".onSave" enabled="{$cmd>Save/enabled}"/>
<Button text="Save" press="cmd:Save" enabled="{$cmd>Save/enabled}"/>
```

The port drops all three `core:CommandExecution` elements and the `Ctrl+S`/
`Ctrl+D` shortcuts (IMPROVISED), rewires the command buttons to normal
client-composed `MESSAGE_TOAST` presses, and models `$cmd>…/enabled|visible` as
plain default-model booleans two-way bound to the switches.

## Proposed change

Add a frontend capability to register a shortcut → named-event binding, e.g.
`client->_shortcut( key = 'Ctrl+S' event = 'SAVE' )` (or a builder path that
recognizes `core:CommandExecution` and installs a real
`sap.ui.core.CommandExecution` on the view, routing its `execute` to a normal
abap2UI5 event). Minimum viable: a document-level `keydown` → named-event bridge.

## Example

In app 232, `Ctrl+S` would fire event `SAVE` (toast "CTRL+S: save triggered on
controller"), `Ctrl+D` → `DELETE`, and the buttons' `enabled` would bind the
command's `$cmd>…/enabled` — reproducing the sample 1:1 instead of dropping the
shortcuts and faking the enabled state with model flags.
