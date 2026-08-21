# scripts/probes — the measurement scripts

A **probe is not a gate.** A gate is a yes/no the CI runs on every commit and
whose failure blocks a merge; a probe answers a question a gate cannot decide,
because the answer needs a judgement (is this class decorative, or is the
stylesheet missing?) or an experiment (does `CalendarAppointment.startDate`
accept a string?). Nothing here runs in `npm run gates`. Run a probe when its
question comes up, read its output, then decide.

They exist for one reason: **a claim in a sidecar, in CAPABILITIES or in
AGENTS.md should be something somebody measured, not something somebody
reasoned out.** Several deviations in this corpus were written on a plausible
inference — "the value cannot travel", "the device model is a per-round-trip
snapshot" — and the probe that finally asked the runtime found the opposite.
When a review turns up the same defect for the third time, it stops being a
lesson and becomes a probe.

Two families, distinguished by what they read:

## Corpus scanners — read `src/` and `meta/`, report ports

Fast, offline, no browser. Run any of these after a batch of edits.

| probe | the defect no gate can see |
|---|---|
| `backtick-escape-probe.mjs` | a text literal carrying `\n` inside **backticks**, where it is two visible characters and never a line break (found in 008, 186, 250 — 186 carried it twice) |
| `absent-boolean-probe.mjs` | a boolean the port asserts **false** where the sample's mock omits the key entirely, so UI5 would fall back on a control default of `true` (app 291: both notification items lost their close button, and the port's only backend wire with them) |
| `orphan-style-class-probe.mjs` | a custom style class kept in the port with no rule reaching the view: the sample's stylesheet was never archived, or archived and never injected |
| `post171-blindspot-probe.mjs` | post-1.71 members the property gate structurally cannot see — relocated to a newer base class, aggregations, enum *values*, plain misses |
| `faked-event-value-audit.mjs` | a toast or an imperative `setText`/`setValue` holding a **constant** where the sample composes it from event data |
| `improvised-cluster.mjs` | sorts every `IMPROVISED` deviation into GAP / policy / boundary / needs-REWORK, so the gap harvest is repeatable |

## Runtime experiments — drive real OpenUI5 in headless Chromium

Slower, and they need `node_modules/@openui5` present. Each one settles a
specific claim; the answer is quoted in the sidecar or in CAPABILITIES where
the claim lives.

| probe | the question it settled |
|---|---|
| `event-arg-expression-probe.mjs` | is an event arg a full UI5 expression? **Yes** — method calls, indexed access, ternaries all resolve, which retired seven IMPROVISED deviations |
| `control-valued-event-arg-probe.mjs` | can an event parameter that IS a control (or an array of them) travel? |
| `device-model-live-probe.mjs` | is the `device>` model a per-round-trip snapshot, or does it mutate live on resize? |
| `conditional-veto-probe.mjs` | `check_prevent_default` is baked per wire — can a veto be made conditional per firing? |
| `aggregation-item-probe.mjs` | a control cloned from an aggregation template has no id the backend knows; what can address it? |
| `date-object-probe.mjs` | does a `type: "object"` date property accept a model **string**, or does it need a real `Date`? |
| `calendar-empty-enddate-probe.mjs` | an empty `end` field becomes `Invalid Date`, which `DateRange.endDate` accepts and `Month._checkDateEnabled` then throws on |
| `p13n-panel-probe.mjs` | measures the out-of-scope `sap.m.p13n` family — the controls ship with OpenUI5 even though 1.71 cannot use them |

## Writing a new one

Copy the shape of `backtick-escape-probe.mjs`: a header comment that states
**what the defect looks like, why every existing gate misses it, and what a hit
means** (a hit is usually not automatically a defect — say what the innocent
case is), then a scan keyed off `meta/*.json` so it covers the whole corpus by
construction. Exclude `z2ui5_cl_smpc_app_000`: the overview app is prose *about*
the ports and quotes the very patterns a scanner looks for.

Add the row to the table above in the same commit. A probe nobody can find is a
probe nobody runs — this file exists because thirteen of them had accumulated
with no index at all.
