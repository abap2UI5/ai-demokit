# ui5/mock/ — shared demo kit mock data (`sap/ui/demo/mock`)

Local snapshots of the shared OpenUI5 demo kit mock data that the sample
controllers in `../sap.m/` load via
`sap.ui.require.toUrl("sap/ui/demo/mock/…")` (that namespace maps to
`test-resources/sap/ui/documentation/sdk/` in the demo kit).

Snapshots were taken from **UI5/openui5, branch `master`, on 2026-07-16**, path
`src/sap.ui.documentation/test/sap/ui/documentation/sdk/` — fetched through a
text-extraction proxy (direct raw download is blocked in this environment), so
JSON formatting and key order are normalized, not byte-identical to upstream.
Data values were verified instead:

- `products.json` — `ProductCollection` (123 products, upstream order) and
  `ProductCollectionStats` (`Counts`, `Groups`, `Filters`).
  Verified: complete 123-entry ProductId sequence against the upstream ID list;
  every overlapping row (HT-1000, HT-1001, HT-1003, HT-1007, HT-1010, HT-1020)
  field-by-field against the verbatim ABAP port
  `src/01/b01/z2ui5_cl_ai_app_440.clas.abap`, and the name/quantity rows of
  `src/01/b04/z2ui5_cl_ai_app_433.clas.abap`; the stats `SupplierName` group
  against per-supplier counts recomputed from the 123 rows (exact match);
  `Counts` weight classes sum to 123. Odd-looking Description strings such as
  `Discontinued-Sub`, `Music-on-Available-Stick`, `feels like Available PC`
  are present upstream (confirmed by two independent extraction passes) — an
  artifact of upstream's own data generation, kept verbatim. The stats
  `Category` group is stale upstream (e.g. `Telekommunikation`,
  `Graphics Card`, sums to 119) and intentionally does not match the products'
  `Category` values — also kept verbatim.
  Used by most product-list samples (List*, Table*, ObjectHeader*, Popover,
  IconTabBar*, SelectDialog, Link*, …).
- `countriesExtendedCollection.json` — `CountriesCollection` (70 countries),
  fetched the same way; verified 1:1 (all 70 text/key pairs) against
  `src/01/b02/z2ui5_cl_ai_app_423.clas.abap`. Used by the ComboBox samples.
- `img.json` — image URL model (`products/pic1..3`, `images`, …), fetched the
  same way. Referenced by the Carousel-style samples; the port resolves these
  bindings to static URLs (see `meta/z2ui5_cl_ai_app_420.json`).

Like everything under `ui5/`, these files are reference material outside the
abapGit / abaplint scope and are never edited to fit ABAP.
