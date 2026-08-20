/*
 * Does a change reach the ABAP? — the question `abap-702` and `auto-downport`
 * ask before they spend forty minutes.
 *
 * `npm run downport` is `abaplint --fix` iterated to a fixpoint over the whole
 * corpus, and at 400+ ports that is the longest thing this repository does by
 * an order of magnitude: every other gate finishes inside a minute. It used to
 * run on every pull request, so a change to the Pages site, a README or a
 * sidecar waited out the full downport to learn what nobody was in doubt
 * about - the ABAP it lints is byte for byte the ABAP on main.
 *
 * So the two workflows that run it ask this first. It answers from the list of
 * changed files alone, and the two lists below are the whole answer:
 *
 *   REACHES   what the 702 verdict is computed from. Any of these and the
 *             downport runs.
 *   INERT     what provably cannot move it: the site, the sidecars, the demo
 *             kit archive, the tooling around the corpus, prose.
 *
 * A path in NEITHER list runs the downport. That is the point of having two
 * lists rather than one: a new top-level folder, a new config, a file nobody
 * thought about is unclassified, and unclassified means run - so the way this
 * goes stale is a slow pull request, never a gate that quietly stopped
 * gating. Adding a path to INERT is a claim that the 702 lint cannot see it;
 * make that claim deliberately, and the fixture tests in
 * scripts/test/tooling.test.mjs will hold you to the shape of it.
 *
 * Used as a module by the tests and as a CLI by the two workflows:
 *
 *   git diff --name-only <range> | node scripts/abap-scope.mjs >> "$GITHUB_OUTPUT"
 *
 * which writes `run=true|false` and a one-line `reason=…`. With no file list
 * on stdin - a range CI could not work out - it answers `run=true`, for the
 * same reason unclassified paths do.
 */

/** Prefixes and exact paths the 702 verdict is computed from. */
const REACHES = [
  'src/',                       // the ABAP itself
  '.github/abaplint/',          // the 702 config the downport iterates and lints with
  '.github/workflows/abap-702.yaml',
  '.github/workflows/auto-downport.yaml',
  'abaplint.jsonc',             // the standard config; `downport` copies the 702 one over it
  'package.json',               // the `downport` script and the abaplint version
  'package-lock.json',
  'A2UI5_PIN',                  // which abap2UI5 the 702 build resolves against
];

/** Prefixes and exact paths that provably cannot move it. */
const INERT = [
  'web/',                       // the Pages site
  'ui5/',                       // the demo kit archive the ports are diffed against
  'meta/',                      // the sidecars
  'scripts/',                   // the gate and generator tooling
  'docs/',
  '.claude/',
  '.githooks/',
  '.github/badges/',
  '.github/workflows/',         // every OTHER workflow - the two above matched first
  '.github/dependabot.yml',
  '.gitattributes',
  '.gitignore',
  '.abapgit.xml',
  'abap2ui5lint-collection.jsonc',
  'LICENSE',
];

const matches = (file, entry) =>
  entry.endsWith('/') ? file.startsWith(entry) : file === entry;

/**
 * @param {string[]} files paths as `git diff --name-only` prints them
 * @returns {{run: boolean, reason: string}}
 */
export function reachesAbap(files) {
  const list = files.map((f) => f.trim()).filter(Boolean);
  if (!list.length) return { run: true, reason: 'no file list - cannot tell, so running' };

  for (const file of list) {
    if (REACHES.some((e) => matches(file, e))) {
      return { run: true, reason: `${file} is ABAP the 702 lint reads` };
    }
    if (INERT.some((e) => matches(file, e))) continue;
    if (file.endsWith('.md')) continue;                 // prose, wherever it sits
    return { run: true, reason: `${file} is in neither list - running to be safe` };
  }
  return {
    run: false,
    reason: `${list.length} file(s) changed, none of them ABAP the 702 lint reads`,
  };
}

/* ------------------------------------------------------------------ cli */

if (import.meta.url === `file://${process.argv[1]}`) {
  const stdin = await new Promise((resolve) => {
    let buf = '';
    if (process.stdin.isTTY) return resolve('');
    process.stdin.setEncoding('utf8');
    process.stdin.on('data', (d) => { buf += d; });
    process.stdin.on('end', () => resolve(buf));
  });
  const { run, reason } = reachesAbap(stdin.split('\n'));
  console.log(`run=${run}`);
  console.log(`reason=${reason}`);
}
