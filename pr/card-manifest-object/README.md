# pr/card-manifest-object — a model value cannot carry a raw JSON object, so an inline card manifest is unreachable

**Status: open** — filed against
[abap2UI5/abap2UI5](https://github.com/abap2UI5/abap2UI5), raised while porting
`sap.ui.integration.sample.CardsLoading` (`z2ui5_cl_dmo_app_341`, 2026-08-10).

## Motivation

`sap.ui.integration.widgets.Card` accepts its manifest in exactly two shapes,
and it tells them apart by JS type
([`Card.js`](https://github.com/SAP/openui5/blob/master/src/sap.ui.integration/src/sap/ui/integration/widgets/Card.js),
`createManifest`):

```js
Card.prototype.createManifest = function (vManifest, sBaseUrl) {
    var mOptions = {};

    if (typeof vManifest === "string") {
        mOptions.manifestUrl = vManifest;      // <- a STRING is a URL
        vManifest = null;
    }
    …
```

So an **inline** manifest has to reach the control as a JS **object**; a string
is always read as a URL to fetch the manifest from.

abap2UI5 has no way to produce that object. Every model value is typed ABAP
data serialized by RTTI, and a card manifest's keys are not valid ABAP field
names:

```json
{ "_version": "1.81.0", "sap.app": { "type": "card" }, "sap.card": { … } }
```

`sap.app` / `sap.card` cannot be structure components, so the manifest cannot be
modelled as a nested structure either — and `_bind( )` has no "pass this string
through as raw JSON" option. The value therefore always arrives as a JSON
*string* and the Card tries to `fetch()` it as a URL.

## Effect on a port

`CardsLoading` keeps all eleven card manifests inside one combined
`manifests/cardManifests.json` and the controller pushes them into the Cards
with `oCard.setManifest(oModelData[manifest])` — an object each. There is no
per-card URL upstream to bind instead, so `z2ui5_cl_dmo_app_341` carries each
manifest as a bound JSON string, which UI5 will read as a URL. The port is
structurally 1:1 and data-faithful, but the eleven Cards cannot render until
this gap closes.

Where the sample happens to keep one manifest per file the URL branch is a
clean 1:1 port — `sap.ui.integration.sample.LazyLoading`
(`z2ui5_cl_dmo_app_342`) binds the ten manifest **URLs** and needs nothing from
this request. Only the bundled-manifest shape is blocked.

`sap.ui.integration.sample.CardsLayout` (`z2ui5_cl_dmo_app_118`) has the same
shape and the same latent problem: it binds seven inline manifests as strings
from `model/cardManifests.json`, and only its eighth ('component') card — whose
manifest genuinely is a URL — is unaffected.

## Proposed change

An opt-in on the bind that marks a string model value as **raw JSON**, so the
serializer emits its content as a JSON node instead of a quoted string:

```abap
)->a( n = `manifest` v = client->_bind( val = manifest_timeline json = abap_true )
```

Serialization side: where `main_json_stringify` writes the attribute today,
splice the value in unquoted when the flag is set (ajson can already carry a
subtree — `z2ui5_cl_ajson=>parse( )` on the string and setting it as the node
would do it without any new parser). The value is app-authored ABAP, not user
input, so no new trust boundary is opened; an unparseable string should raise
rather than emit broken JSON.

Two-way binding is not required for this case: a manifest is read-only
configuration, so a raw-JSON field may legitimately be one-way only.

## Alternatives considered

- **Escaping the JSON into the view attribute** (`manifest="\{…\}"`) — the
  XMLView parser then hands the control a *string* again, so it lands in the
  same URL branch. No.
- **Modelling the manifest as an ABAP structure with an ajson `custom_mapper`**
  renaming `sap_app` → `sap.app` — a manifest is deeply nested with
  heterogeneous arrays; the mapper would have to encode each manifest's whole
  shape as ABAP types. Not tractable, and it would put frontend configuration
  into the type system.
- **Serving each manifest from the ABAP backend under its own URL** — abap2UI5
  serves one endpoint for the app protocol; a second content endpoint per card
  is a much larger change than a serializer flag.
