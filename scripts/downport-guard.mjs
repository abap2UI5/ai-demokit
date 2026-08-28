#!/usr/bin/env node
/*
 * downport-guard — refuse to start `npm run downport` on a tree with work in it.
 *
 * `npm run downport` REWRITES THE WORKING TREE. It runs `abaplint --fix` over
 * every `src/**` file, `sed -i`s all of them again (`npm run syfixes`), and
 * `cp -f`s the 702 config over the root `abaplint.jsonc`. Nothing about that
 * is reversible except `git checkout -- .`, which throws away whatever else
 * was in the tree.
 *
 * AGENTS §10 documents it as a trap — "Never run it on the tree you intend to
 * commit; run it in a throwaway `git worktree` (or copy) … If you did run it
 * in place, `git checkout -- .` to restore before committing" — and a
 * documented trap is a trap with a footnote. The precondition it describes is
 * machine-checkable, so it is checked: on a clean tree the command is safe
 * (CI runs it exactly there, on a fresh checkout), and on a dirty one it is
 * destructive with no undo.
 *
 * The escape is deliberate and explicit, and it is an ENVIRONMENT VARIABLE
 * rather than a flag on purpose: npm appends `-- <args>` to the END of the
 * script string, so `npm run downport -- --force` would hand `--force` to
 * `npm run abaplintpathfix` and never to this guard.
 *
 *   DOWNPORT_FORCE=1 npm run downport   # yes, rewrite this dirty tree
 *
 * (`--force` still works when this script is invoked directly.)
 *
 * It reports the dirty paths rather than just refusing, because the usual
 * cause is a half-finished edit the caller had forgotten about — which is the
 * whole reason the trap exists.
 *
 * Only paths the downport can REACH count: `src/**` and `abaplint.jsonc`. An
 * edited sidecar or README cannot be damaged by it, and failing on those
 * would make the guard the thing people learn to pass with --force.
 */
import { execFileSync } from 'child_process';

const FORCE = process.argv.includes('--force') || process.env.DOWNPORT_FORCE === '1';

/** Paths the downport rewrites, as `git status --porcelain` prefixes. */
const REACHED = (p) => p === 'abaplint.jsonc' || p.startsWith('src/');

let out;
try {
  out = execFileSync('git', ['status', '--porcelain', '--', 'src', 'abaplint.jsonc'], { encoding: 'utf8' });
} catch {
  // not a git checkout (a tarball, a container copy): nothing to protect, and
  // refusing here would break the one case where the tree is provably fresh
  console.log('downport-guard: not a git checkout — nothing to compare against, proceeding');
  process.exit(0);
}

const dirty = out.split('\n')
  .map((l) => l.slice(3).trim())
  .filter(Boolean)
  .filter((p) => REACHED(p.split(' -> ').pop()));

if (!dirty.length) {
  console.log('downport-guard: tree is clean under src/ and abaplint.jsonc — safe to rewrite');
  process.exit(0);
}

if (FORCE) {
  console.log(`downport-guard: ${dirty.length} uncommitted path(s) under src/ — proceeding because --force was given`);
  process.exit(0);
}

console.error(`downport-guard: REFUSING — ${dirty.length} uncommitted change(s) the downport would rewrite:\n`);
for (const p of dirty.slice(0, 20)) console.error(`    ${p}`);
if (dirty.length > 20) console.error(`    … and ${dirty.length - 20} more`);
console.error(`
\`npm run downport\` runs \`abaplint --fix\` over every src/**/*.abap, sed -i's
them all again and overwrites abaplint.jsonc with the 702 config. On a dirty
tree that is destructive with no undo but \`git checkout -- .\`, which would
take the changes above with it.

Do one of:
    git stash                      # then run it, then \`git checkout -- . && git stash pop\`
    git worktree add ../dp HEAD    # run it there (what AGENTS §10 recommends)
    DOWNPORT_FORCE=1 npm run downport   # yes, rewrite this tree anyway
`);
process.exit(1);
