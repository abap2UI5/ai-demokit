# `ui5/sap.ui.comp/` — Smart Controls templates

Originals of the **SAPUI5 Smart Controls tutorial** (`sap.ui.comp.tutorial.smartControls`),
the demo kit's sample set for the smart controls. They are archived here exactly
like every other template folder (AGENTS §4) so a port's structural diff has an
original to compare against.

## Provenance — why these do not come from an OpenUI5 checkout

`sap.ui.comp` is **not part of OpenUI5**. It ships only with SAPUI5, and its
demo kit lives on the commercial host, which the scaffolder's OpenUI5 checkout
(`OPENUI5_SRC`) does not contain. The files below were therefore taken from the
**public SAPUI5 documentation sources**, where SAP publishes each tutorial step
including its full `view.xml`, controller, `metadata.xml` and mock data:

<https://github.com/SAP-docs/sapui5/tree/main/docs/03_Get-Started>

| Folder | Tutorial step | Source document |
|--------|---------------|-----------------|
| `SmartField/`             | Step 1 — Smart Field                                        | `step-1-smart-field-ed8fda6.md` |
| `SmartForm/`              | Step 4 — Smart Form                                         | `step-4-smart-form-f712d30.md` |
| `SmartTable/`             | Step 5 — Smart Filter Bar and Smart Table                   | `step-5-smart-filter-bar-and-smart-table-1daa462.md` |
| `PageVariantManagement/`  | Step 8 — Page Variant Management                            | `step-8-page-variant-management-b1d4d26.md` |
| `SmartChart/`             | Step 9 — Smart Chart with Chart Personalization and View Management | `step-9-smart-chart-with-chart-personalization-and-view-management-0219b11.md` |

The files are held **verbatim** as published (tabs, attribute order and all),
same rule as every other template folder — never edited to fit ABAP.

## What is deliberately not archived

- **`Products.json` of `SmartTable/` and `SmartChart/`** — the documentation
  elides those mock arrays (`.` `.` `.` after the first row), so there is no
  verbatim file to hold. Both ports read their data from OData, not from an
  inlined mock, so nothing depends on it.
- **`metadata.xml` of `PageVariantManagement/`** — step 8 reuses the service of
  steps 5–7; the documentation does not republish it. See
  `SmartTable/metadata.xml` for that service.
- The tutorial's `Component.js` / `manifest.json` / `index.html` scaffolding is
  the same for every step and carries no sample-specific information.

## Steps that are not ported

Steps 2, 3, 6 and 7 are **view-level near-duplicates** of the steps above and
are not ported (AGENTS §1, "skip true near-duplicates"):

| Step | Difference to the ported step |
|------|-------------------------------|
| 2 — Smart Field with Value Help | view identical to step 1; the value help comes from a `ValueList` annotation in `metadata.xml` |
| 3 — Smart Field with Smart Link | step 1's view with `value="{Name}" editable="false"`; the link comes from a `SemanticObject` annotation |
| 6 — Table Personalization       | step 5's view with `useTablePersonalisation="true"` |
| 7 — View Management             | step 5's view plus `persistencyKey` and `useVariantManagement="true"` — fully covered by the ported step 8, which adds the page variant on top |
