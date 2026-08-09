# pr/linter-openui5-1151 — the linter's own OpenUI5 pin blocks every sample built on a 1.151 control

**Status: open upstream** — filed against
[abap2UI5/linter](https://github.com/abap2UI5/linter), raised 2026-08-09 while
porting `sap.tnt.sample.SideNavigationSearch`.

## Motivation

The scope rule is control-level: a sample is in scope when its **owning
control** exists since UI5 1.71 and is not deprecated. Members the sample then
uses that are newer are kept 1:1 and declared as `POST_171` (AGENTS §5) — that
is the corpus-wide fidelity-first policy, and `view_gates` implements it: the
finding types `control-too-new`, `member-too-new`, `event-parameter-too-new`
and `enum-value-too-new` are excused by a deviation naming the member
(`VERSION_TYPES` in `scripts/view-gates.mjs`).

That mechanism only works while the linter's control metadata **knows** the
member. It resolves against its own dependency block, which pins exact
versions:

```json
"@openui5/sap.tnt": "1.150.0",
```

A member introduced **after** that pin is not "too new" to the gate — it does
not exist at all, and reports as

```
! sap.tnt.SideNavigation has no aggregation filterSection — typo?
! control sap.tnt.SideNavigationSearchField does not exist in UI5 — typo?
! sap.tnt.NavigationList has no property/event/association highlightedText — typo?
! render: CREATE: failed to load 'sap/tnt/filterSection.js' … script load error
```

Those types are **not** in `VERSION_TYPES`, so no `POST_171` deviation can
excuse them and the port cannot be committed green.

Bumping the *consuming* repo's `@openui5` dev dependencies does not help: the
linter's pins are exact, so npm keeps a matching tree for it and the gate still
resolves 1.150 (verified 2026-08-09 in ai-demokit).

## Affected

`sap.tnt.sample.SideNavigationSearch` is in scope (owning control
`sap.tnt.SideNavigation`, @since 1.34, not deprecated) but is built entirely on

| member | @since | verified in |
|---|---|---|
| `sap.tnt.SideNavigationSearchField` | 1.151 | `src/sap.tnt/src/sap/tnt/SideNavigationSearchField.js:35` |
| `sap.tnt.SideNavigation.filterSection` | 1.151 | same file's owning aggregation |
| `sap.tnt.NavigationList.highlightedText` | 1.151 | `src/sap.tnt/src/sap/tnt/NavigationList.js:92` |

`@openui5/sap.tnt` 1.151.0 is published, so the metadata exists — only the pin
is behind. Every future sample on a post-1.150 control hits the same wall.

## Proposed change

Bump the linter's `@openui5/*` dependencies to the latest published line
(1.151.0 at the time of writing) and keep them moving with the demokit's
`Control metadata from OpenUI5` release, so "newer than the floor" stays a
*version* verdict instead of degrading into "unknown control". The 1.71 target
floor the gate checks against is a separate parameter (`minUi5`) and is not
affected by the bump — measured on the ai-demokit corpus, a local bump to
1.151 produced **0 new findings across 339 ports**.

## Until then

The port is not committed: a red `view_gates` is not an acceptable trade for
one sample. Re-port `sap.tnt.sample.SideNavigationSearch` (the last open
sap.tnt backlog row) once the linter bump lands.
