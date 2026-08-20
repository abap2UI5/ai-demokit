/*
 * format-chain — put a builder chain into the house layout.
 *
 * A thin adapter over @abap2ui5/linter, NOT a formatter: the layout is decided
 * by the linter's `chain-house-layout` rule, which reports the deviation and
 * carries the edits that repair it. This asks the rule and applies what it
 * returns.
 *
 * It replaces `formatSource` from scripts/chain-format.mjs, which was the
 * whole algorithm written a second time. The gate half of that script is now
 * abap2ui5lint-chains.jsonc; this is the writer half, and the only consumer is
 * generate-overview.mjs — the overview class is machine-written and has to
 * come out in the same layout a human would have to write it in, or the
 * chain gate fails on a file no human touched.
 *
 * This makes the overview generator - and with it the pre-commit hook that
 * runs it - need node_modules. That is not a new requirement in practice:
 * the hook is installed by `prepare`, which only runs on `npm install`, so a
 * checkout that has the hook has the dependencies too.
 *
 * `applyFixes` defers an edit that overlaps one already applied, so a chain
 * whose repair needs two passes is reported by `deferred`. The generator runs
 * to a fixed point rather than silently emitting a half-formatted class.
 */
import { checkAbapSource } from '@abap2ui5/linter';
import { applyFixes, isFixable } from '@abap2ui5/linter/fix';

const RULES = { 'chain-house-layout': { severity: 'warning' } };
const MAX_PASSES = 5;

/**
 * @param {string} source ABAP source of a class that builds a view
 * @returns {string} the same source with every chain in the house layout
 */
export function formatSource(source) {
  let out = source;
  for (let pass = 0; pass < MAX_PASSES; pass++) {
    const { findings } = checkAbapSource(out, { rules: RULES, file: 'overview.clas.abap' });
    const fixable = findings.filter((f) => f.type === 'chain-house-layout' && isFixable(f));
    if (!fixable.length) return out;
    const { output, applied } = applyFixes(out, fixable);
    if (!applied) return out;
    out = output;
  }
  /* Loud rather than silent: reaching this means the rule keeps reporting a
   * chain it has already rewritten five times, which is a linter defect and
   * not something the overview app should ship around. */
  throw new Error(
    `format-chain: the chain layout did not settle after ${MAX_PASSES} passes — `
    + 'the generated overview would go out deviating from the gate that checks it',
  );
}
