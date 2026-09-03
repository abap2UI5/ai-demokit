# `web/` — two patch scripts, and no site any more

This directory used to hold this repository's GitHub Pages site: a searchable
catalogue of every port at `https://abap2ui5.github.io/samples-controls/`.
**That site is gone.** One catalogue over all three sample repositories is
published from the playground instead —
[abap2ui5.github.io/playground/samples/](https://abap2ui5.github.io/playground/samples/) —
and this repository feeds it rather than publishing its own.

What it feeds it with is [`catalogue-derived.json`](../catalogue-derived.json),
written by `scripts/generate-derived.mjs`: the two questions the sidecars
cannot answer — *"my system runs 1.84, which of these render on it"* and
*"which ports use `sap.m.Table` at all"* — resolved by the linter and committed
beside [`catalogue.json`](../catalogue.json), which keeps the facts that are
committed fact in the tree. The header of that script says how the two files
divide the work and why they are two.

Three pages that each had to explain that the other two existed were the
reason for the shared `<nav class="family">` block, its three copies, and
`check-family-nav` policing the copies. One page needs none of it, so all of
that went with the site: `web/search/`, `deploy-web.yaml`,
`check-family-nav.yaml`, `scripts/check-family-nav.mjs` and
`scripts/generate-screenshots.mjs`. The thumbnails the deploy used to
photograph are taken by the playground's deploy now, from the same linter
render harness.

## What is still here

| File | |
|---|---|
| `ci/patch_follow_up_action.mjs` | rewrites the demo kit's `FollowUpAction` for the e2e build |
| `ci/patch_open_abap_xml.mjs` | patches open-abap's XML lib at build time (the `ASSERTION_FAILED` in `E2E.md`) |

Both are executed by `scripts/e2e-build.mjs` **and by abap2UI5/mcp-server's
incremental build**, which is why they are at these exact paths and why
`scripts/check-mcp-contract.mjs` asserts they still are. They live under
`web/` for that historical reason alone — moving them is a change in another
repository, not this one.
