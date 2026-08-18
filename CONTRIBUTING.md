_This project is open source and developed alongside other projects or during free time. Contributions are greatly appreciated!_

Check out the contribution guidelines [here.](https://abap2ui5.github.io/docs/resources/contribution.html)

## Working in this repository

This repository is **generated**: every class under `src/01` and `src/02` is an
AI-built 1:1 rebuild of one official UI5 demo kit sample, and the coverage
tables, `api.md`, `SAMPLES.md`, `STATUS.md` and the in-system overview app are
all written by generators from the `meta/<class>.json` sidecars. So a change
here is usually a change to a **rule or a generator**, not to a file.

Everything specific to it — the folder scheme, the sidecar shape, the porting
recipe, the deviation types and what each CI gate checks — is in
**[AGENTS.md](AGENTS.md)**. It is written for agents and for people; read it
before changing anything under `src/`, `meta/` or `scripts/`.

The short version:

```sh
npm ci
npm run gates        # the offline gate set, fail-fast
npm run gates:full   # + abaplint and the view gates (needs the browser)
npm test             # fixture tests for the gate/generator tooling itself
```

Three things worth knowing before the first change:

- **Never hand-edit a generated file.** `README.md`'s coverage block, `api.md`,
  `SAMPLES.md`, `STATUS.md`'s state block and
  `src/z2ui5_cl_smpc_app_000.clas.abap` are rewritten by the generators, and
  the `meta_valid` gate fails a pull request whose tree they would change.
  Change the generator, or the sidecar it reads.
- **A port deviating from its original is fine; drifting is not.** Declare the
  difference in the port's sidecar and `structural_diff` accepts it — undeclared
  differences fail.
- **Every gate is one workflow**, named after the gate. When one goes red, the
  badge names the concern; `.claude/skills/run-the-gates/SKILL.md` says what
  the failure means and which escape hatches are legitimate.

Bug reports and feature requests for abap2UI5 itself belong in the
[abap2UI5 repository](https://github.com/abap2UI5/abap2UI5/issues).
