# scope-since-from-source — make scope gating see `@since` from source

**Status: partially addressed** — a standalone reporter (`scripts/scope-of.mjs`)
now resolves the authoritative verdict from source; wiring the coverage gate's
`scopeOf` to use it is the open ask below. From demo-kit batches around apps
230–235 (2026-07-25), flagged independently by two porting agents.

## Motivation

A sample is out of scope when its control is newer than UI5 1.71 or deprecated
in the current release (AGENTS.md §1), and out-of-scope samples must **never be
ported**. But the offline scope check is **blind**: `ui5/universe.json` carries
`since: null` for most controls (the shallow OpenUI5 fork has no generated
`designtime/api.json`, so `loadApi()` finds nothing and the snapshot stores
null). `generate-coverage.mjs`'s `scopeOf` then does `sinceLeq171(null) === true`
— i.e. treats every unknown-since control as in-scope.

Concrete failures this caused:
- **`sap.f.AvatarGroup`** is `@since 1.73` (out of scope), but the pre-check and
  the out-of-scope gate both passed it. It was built and only caught by a manual
  source read, then dropped.
- **`sap.f.SidePanel`** is `@since 1.107`. **App 136 (`SidePanelSingle`) already
  sits in the repo as a `generated` port that no gate flags** — a standing §1
  violation, same class as the known `UploadSet` (app 121) deprecated-control
  debt.

### Full out-of-scope debt (audit 2026-07-25, `scope-of.mjs` over all 171 ported entities)

Running the new authoritative checker over every ported sidecar surfaces **four**
out-of-scope ports the blind gate admitted — all `status: generated` (none
human-checked). **Left in place pending a maintainer decision** (drop, or
document as an accepted exception; 1.72/1.78 are borderline just over the line):

| App | Sample | Entity | Why out of scope |
|-----|--------|--------|------------------|
| 121 | `UploadSet` | `sap.m.upload.UploadSet` | deprecated |
| 136 | `SidePanelSingle` | `sap.f.SidePanel` | control @since 1.107 |
| 141 | `InvisibleMessage` | `sap.ui.core.InvisibleMessage` | control @since 1.78 |
| 165 | `ProductSwitchNavigation` | `sap.f.ProductSwitch` | control @since 1.72 |

Once `scopeOf` consults source `@since` (below), these four would light up the
out-of-scope gate automatically. (`scope-of.mjs` reports UNRESOLVED for the
`*Pattern` composite samples and for controls in a sub-package — `widgets/Card`,
`upload/UploadSet` — whose entity name omits the sub-package; those need the
api-metadata mapping, not a source path, and are not scope violations per se.)

The deprecation half is only partly covered too: the snapshot happens to carry
`deprecated` for some controls (e.g. ActionSheet 1.149) but not `since`, so the
two halves of the rule are enforced inconsistently.

## What is already done (this change)

`scripts/scope-of.mjs` — a standalone reporter that reads the control-level
`@since` / `@deprecated` JSDoc straight from the OpenUI5 source (the
authoritative record) and prints an IN/OUT verdict, exit 1 if any queried entity
is out of scope. It does **not** touch any gate.

```
$ node scripts/scope-of.mjs sap.f.AvatarGroup sap.f.SidePanel sap.m.ActionSheet
sap.f.AvatarGroup    OUT_OF_SCOPE (control @since 1.73 > 1.71)
sap.f.SidePanel      OUT_OF_SCOPE (control @since 1.107 > 1.71)
sap.m.ActionSheet    OUT_OF_SCOPE (deprecated since 1.149 — use sap.m.Menu / sap.m.MenuItem instead.)
$ node scripts/scope-of.mjs --sample FlexibleColumnLayoutSimple   # resolve entity via universe.json
```

The porting pre-check now uses this instead of the blind `universe.json` read.

## Proposed change (open)

Teach `generate-coverage.mjs`'s `scopeOf` (and the universe build) to resolve a
null `since`/`deprecated` from source `@since`/`@deprecated` — exactly the way
the property gate already resolves per-member versions from `ui5/properties.json`
(walking `X.extend(...)`). Then:

- the out-of-scope table and the `WARNING: … out of scope` gate become
  authoritative offline, matching what a CI universe rebuild (with real
  `api.json`) would produce; and
- **app 136 (`SidePanelSingle`) surfaces as an out-of-scope port** and can be
  removed or given a documented exception like UploadSet.

Lowest-effort form: have `generate-properties.mjs` also emit a control-level
`since` alongside the existing per-member map, and have `scopeOf` fall back to it
when `universe.json.since` is null. `scope-of.mjs` already contains the
source-resolution logic to lift.

## Example

```
# today (blind): scopeOf(sap.f.SidePanel) -> 'in'  (since=null -> sinceLeq171(null)=true)
# proposed:      scopeOf(sap.f.SidePanel) -> 'newer' (source @since 1.107 > 1.71)
```
