# ui5/ — original UI5 demo kit templates

The untouched OpenUI5 demo kit samples (JavaScript / XML view / `manifest.json` /
controllers / resources) that the abap2UI5 ports in `../src/` were rebuilt from.

Each folder is **named after the sample** and filed by source library:

```
ui5/<library>/<SampleName>/     e.g. ui5/sap.m/Button/
```

The join key between a port and its template is `meta/<class>.json` →
`sample` (`sap.m.sample.<SampleName>`). Only **ported** samples are archived —
each new generation batch copies its samples over from the OpenUI5 checkout
(everything the sample's `manifest.json` lists under `sap.ui5 > config >
sample > files`, resolving `../<OtherSample>/` references into that sample's
own folder — which is why a few unported folders like `Table/` exist: they are
referenced by a ported sample). Shared demo kit mock data is snapshotted once
in [`mock/`](mock/) (provenance in its README), and [`universe.json`](universe.json)
is the committed snapshot of the full demo kit sample universe (entity, Since,
deprecation per sample) that coverage regenerates from offline (AGENTS §7).

These files are held verbatim for reference and to feed the generator and the
structural diff — they are outside the abapGit / abaplint scope (`src/` only)
and are never edited to fit ABAP. `../api.md` links every sample to its
upstream source in the [OpenUI5 repository](https://github.com/SAP/openui5);
the overview app `../src/z2ui5_cl_ai_app_overview.clas.abap` starts each port
in the system.
