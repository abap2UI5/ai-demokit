# ui5/ — original UI5 demo kit templates

The untouched OpenUI5 demo kit samples (JavaScript / XML view / `manifest.json` /
controllers / resources) that the abap2UI5 ports in `../src/` were rebuilt from.

Each folder is **named after its abap2UI5 port class** and filed by source
library:

```
ui5/<library>/<z2ui5_cl_api_app_n>/
```

The folder name is the join key to the port at `src/NN/<z2ui5_cl_api_app_n>.clas.abap`.
`../api.md` and `../OVERVIEW.md` link every template to its class, the demo kit app, and (overview) a system launch link.

These files are held verbatim for reference and to feed the generator — they are
outside the abapGit / abaplint scope (`src/` only) and are never edited to fit ABAP.
