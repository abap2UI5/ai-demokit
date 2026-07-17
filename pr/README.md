# pr/ — forwardable framework requests

Every gap in the **abap2UI5 framework** that porting a UI5 demo kit sample
reveals is written up here as a ready-to-forward request — **one folder per
request, one README.md each**, self-contained (motivation, current behavior
with source references, proposed change, example) so it can be pasted
directly into an issue/PR at
[abap2UI5/abap2UI5](https://github.com/abap2UI5/abap2UI5).

Convention (see AGENTS.md §10 / TRAINING.md "Distill"): whenever porting or
reviewing surfaces an improvement idea for the framework — a missing API
parameter, a capability marked ❌ in CAPABILITIES.md that upstream could
close, a behavior gap — add or extend a request folder here **in the same
change**. When a request is implemented upstream, note the release in its
README and update CAPABILITIES.md.

| Request | Status |
|---------|--------|
| [message-box-dependent-on](message-box-dependent-on/README.md) | open |
| [named-json-models](named-json-models/README.md) | open |
| [device-model-in-popups](device-model-in-popups/README.md) | open |
