/*
 * Fixture tests for the gate/generator tooling (node:test, no dependencies).
 *
 * Each test copies the tiny fixture corpus (scripts/test/fixtures/repo — two
 * ported samples, one open backlog row) into a temp directory, copies the
 * script under test next to it (the scripts resolve everything relative to
 * their own location, ROOT = <scripts>/..), spawns it as a black box and
 * compares stdout / generated files against the golden files under
 * scripts/test/fixtures/golden/.
 *
 *   node --test scripts/test/            (or: npm test)
 *   UPDATE_GOLDEN=1 npm test             rewrite the goldens after an
 *                                        INTENDED output change — review the
 *                                        golden diff like any other diff
 *
 * The fixture is built to exercise both verdicts of each gate:
 *   app_001 (FixtureGood) — a clean port: its one structural diff (dropped
 *     Text.wrapping) is declared in a deviation; its seeded values match the
 *     archived mock verbatim.
 *   app_002 (FixtureBad)  — the failure classes: an UNDECLARED missing attr
 *     (List.headerText), an UNDECLARED extra control (Button), a lost binding
 *     (title {title} -> literal), an invented table value (city "Atlantis")
 *     and an asset the sample never mentions (wrong-HT-9999.jpg).
 */

import { test } from 'node:test';
import assert from 'node:assert/strict';
import fs from 'fs';
import os from 'os';
import path from 'path';
import { spawnSync } from 'child_process';
import { fileURLToPath } from 'url';

const HERE = path.dirname(fileURLToPath(import.meta.url));
const REPO = path.join(HERE, '..', '..');
const FIXTURE = path.join(HERE, 'fixtures', 'repo');
const GOLDEN = path.join(HERE, 'fixtures', 'golden');

// scripts under test (plus their only local import); copied into the fixture
// root so their ROOT resolution lands on the fixture corpus
const SCRIPTS = ['structural-diff.mjs', 'data-fidelity.mjs', 'generate-coverage.mjs', 'lib-universe.mjs',
  'generate-summary.mjs'];

function makeFixtureRoot() {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'demokit-tooling-test-'));
  fs.cpSync(FIXTURE, root, { recursive: true });
  for (const s of SCRIPTS) {
    fs.copyFileSync(path.join(REPO, 'scripts', s), path.join(root, 'scripts', s));
  }
  /* The scripts under test import from scripts/lib/, so the fixture needs it
   * too — copying only the entry point made them fail to RESOLVE, which the
   * assertions then reported as wrong output rather than as a missing file. */
  fs.cpSync(path.join(REPO, 'scripts', 'lib'), path.join(root, 'scripts', 'lib'), { recursive: true });
  return root;
}

function run(root, script, ...args) {
  const r = spawnSync(process.execPath, [path.join(root, 'scripts', script), ...args], { encoding: 'utf8' });
  return { code: r.status, out: r.stdout, errout: r.stderr };
}

function assertGolden(name, actual) {
  const p = path.join(GOLDEN, name);
  if (process.env.UPDATE_GOLDEN) {
    fs.mkdirSync(GOLDEN, { recursive: true });
    fs.writeFileSync(p, actual);
    return;
  }
  assert.ok(fs.existsSync(p), `golden ${name} missing — run UPDATE_GOLDEN=1 npm test once and review it`);
  assert.equal(actual, fs.readFileSync(p, 'utf8'), `${name} differs from its golden (UPDATE_GOLDEN=1 npm test to regenerate after an INTENDED change)`);
}

test('structural-diff: declared vs undeclared diffs on the fixture corpus', () => {
  const root = makeFixtureRoot();
  try {
    const plain = run(root, 'structural-diff.mjs');
    assert.equal(plain.code, 0, 'advisory run must exit 0');
    assertGolden('structural-diff.out', plain.out);
    // app_001's dropped wrapping is declared; app_002's three diffs are not
    assert.match(plain.out, /declared\s+attr missing\s+Text\.wrapping/);
    assert.match(plain.out, /! UNDECLARED\s+attr missing\s+List\.headerText/);
    assert.match(plain.out, /! UNDECLARED\s+control extra\s+Button/);
    assert.match(plain.out, /! UNDECLARED\s+binding value\s+Page\.title/);
    const strict = run(root, 'structural-diff.mjs', '--strict');
    assert.equal(strict.code, 1, '--strict must fail on the undeclared diffs');
    assert.equal(strict.out, plain.out, 'strict changes only the exit code, not the report');
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});

test('data-fidelity: invented value and unknown asset fail, verbatim data passes', () => {
  const root = makeFixtureRoot();
  try {
    const r = run(root, 'data-fidelity.mjs');
    assert.equal(r.code, 1, 'the invented fixture data must fail the gate');
    assertGolden('data-fidelity.out', r.out);
    assert.match(r.out, /z2ui5_cl_smpc_app_002: asset `wrong-HT-9999\.jpg` appears nowhere/);
    assert.match(r.out, /z2ui5_cl_smpc_app_002: table row 2 field `city` = "Atlantis"/);
    assert.ok(!r.out.includes('z2ui5_cl_smpc_app_001:'), 'the verbatim port must produce no finding');
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});

test('generate-coverage: golden api.md and README coverage block', () => {
  const root = makeFixtureRoot();
  try {
    const r = run(root, 'generate-coverage.mjs');
    assert.equal(r.code, 0, `coverage must succeed on the in-scope fixture\n${r.errout}`);
    assertGolden('generate-coverage.out', r.out);
    assertGolden('api.md', fs.readFileSync(path.join(root, 'api.md'), 'utf8'));
    assertGolden('README.md', fs.readFileSync(path.join(root, 'README.md'), 'utf8'));
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});

test('generate-coverage: a ported out-of-scope sample without an exception is a hard failure', () => {
  const root = makeFixtureRoot();
  try {
    const uniPath = path.join(root, 'ui5', 'universe.json');
    const uni = JSON.parse(fs.readFileSync(uniPath, 'utf8'));
    const bad = uni.libs[0].samples.find((s) => s.name === 'FixtureBad');
    bad.deprecated = { since: '1.100', text: 'gone' };
    fs.writeFileSync(uniPath, JSON.stringify(uni, null, 1) + '\n');
    const r = run(root, 'generate-coverage.mjs');
    assert.equal(r.code, 1, 'the scope gate must exit 1');
    assert.match(r.errout, /ported sample sap\.m\.sample\.FixtureBad is out of scope \(deprecated\)/);
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});

/* generate-summary — the fixture carries both sources: FixtureGood is described
 * by the (fixture) demo kit snapshot, FixtureBad only by a `written` entry. */

test('generate-summary: writes the demo kit sentence, under the keywords line, cut at a sentence', () => {
  const root = makeFixtureRoot();
  try {
    const app = path.join(root, 'src', '01', 'z2ui5_cl_smpc_app_001.clas.abap');
    fs.writeFileSync(app, `" @keywords page list fixture\n${fs.readFileSync(app, 'utf8')}`);

    const r = run(root, 'generate-summary.mjs');
    assert.equal(r.code, 0, `writing must succeed\n${r.errout}`);
    assert.match(r.out, /summary: 2 written, 0 already current/);
    assert.match(r.out, /1 from the demo kit, 1 written by hand \(with a reason\), 0 derived/);

    const [first, second] = fs.readFileSync(app, 'utf8').split('\n');
    assert.equal(first, '" @keywords page list fixture', 'the keywords line stays first');
    assert.match(second, /^" @summary A Page with a list, used by the tooling tests\./, 'markup stripped');
    assert.ok(second.length <= 255, `one line, ${second.length} characters`);
    assert.ok(second.endsWith('.'), `cut at a sentence, not mid-word: ${second}`);
    assert.ok(!second.includes('filler'), 'the sentence that does not fit is dropped whole');

    // an app with no keywords line gets the summary as its first line
    const bad = fs.readFileSync(path.join(root, 'src', '01', 'z2ui5_cl_smpc_app_002.clas.abap'), 'utf8');
    assert.match(bad, /^" @summary The failure fixture, described here rather than upstream\.\n/);

    // and running again is a no-op: the line is what the snapshot implies
    const again = run(root, 'generate-summary.mjs', '--check');
    assert.equal(again.code, 0, `the check must pass on what the generator just wrote\n${again.out}${again.errout}`);
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});

test('generate-summary: a missing line, an edited line and an undescribed sample all fail the check', () => {
  const root = makeFixtureRoot();
  const app = path.join(root, 'src', '01', 'z2ui5_cl_smpc_app_001.clas.abap');
  try {
    run(root, 'generate-summary.mjs');

    const written = fs.readFileSync(app, 'utf8');
    fs.writeFileSync(app, written.replace(/^" @summary .*\n/m, ''));
    const missing = run(root, 'generate-summary.mjs', '--check');
    assert.equal(missing.code, 1, 'a removed line must fail');
    assert.match(missing.errout, /z2ui5_cl_smpc_app_001: no `" @summary` line/);

    fs.writeFileSync(app, written.replace(/^" @summary .*$/m, '" @summary something a human typed'));
    const edited = run(root, 'generate-summary.mjs', '--check');
    assert.equal(edited.code, 1, 'an edited line must fail — the sentence is the demo kit\'s');
    assert.match(edited.errout, /z2ui5_cl_smpc_app_001: the @summary line is out of date/);

    fs.writeFileSync(app, written);
    const dPath = path.join(root, 'ui5', 'descriptions.json');
    const d = JSON.parse(fs.readFileSync(dPath, 'utf8'));
    delete d.demokit['sap.m.sample.FixtureGood'];
    fs.writeFileSync(dPath, `${JSON.stringify(d, null, 2)}\n`);
    const gone = run(root, 'generate-summary.mjs', '--check');
    assert.equal(gone.code, 1, 'a sample nothing describes must fail rather than be skipped');
    assert.match(gone.errout, /z2ui5_cl_smpc_app_001: nothing describes sap\.m\.sample\.FixtureGood/);
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});

/* ------------------------------------------------------- abap-scope.mjs */

// No fixture corpus: the decision is a pure function of a list of paths, so
// the tests are the list. What they hold is the SHAPE of the answer - that
// the ABAP runs the downport, that the site does not, and above all that an
// unclassified path runs it. The last one is what keeps a new folder from
// silently switching the gate off.

test('abap-scope: the ABAP and what the 702 lint reads run the downport', async () => {
  const { reachesAbap } = await import('../abap-scope.mjs');

  for (const file of [
    'src/01/sap.m/z2ui5_cl_smpc_app_001.clas.abap',
    '.github/abaplint/abap_702.jsonc',
    '.github/workflows/abap-702.yaml',
    '.github/workflows/auto-downport.yaml',
    'package.json',
    'package-lock.json',
    'abaplint.jsonc',
    'A2UI5_PIN',
  ]) {
    const { run } = reachesAbap([file]);
    assert.equal(run, true, `${file} must run the downport`);
  }
});

test('abap-scope: the page, the sidecars and prose do not', async () => {
  const { reachesAbap } = await import('../abap-scope.mjs');

  const inert = [
    'web/search/index.html',
    'web/search/favicon.ico',
    'web/README.md',
    'meta/z2ui5_cl_smpc_app_001.json',
    'catalogue.json',
    'ui5/descriptions.json',
    'scripts/generate-search-index.mjs',
    '.github/workflows/deploy-web.yaml',
    '.claude/skills/run-the-gates/SKILL.md',
    'README.md',
    'AGENTS.md',
  ];
  const { run, reason } = reachesAbap(inert);
  assert.equal(run, false, `none of these reach the ABAP:\n${inert.join('\n')}`);
  assert.match(reason, /none of them ABAP/);

  // one ABAP file among them is enough
  const mixed = reachesAbap([...inert, 'src/01/sap.m/z2ui5_cl_smpc_app_001.clas.abap']);
  assert.equal(mixed.run, true, 'a single changed class must run the downport');
});

test('abap-scope: a path in neither list, and an empty list, run the downport', async () => {
  const { reachesAbap } = await import('../abap-scope.mjs');

  const unknown = reachesAbap(['tools/whatever.mjs']);
  assert.equal(unknown.run, true, 'an unclassified path must run the gate, not skip it');
  assert.match(unknown.reason, /neither list/);

  assert.equal(reachesAbap([]).run, true, 'no file list means CI could not tell - run');
  assert.equal(reachesAbap(['']).run, true, 'an empty line is not a file list either');
});

/* ------------------------------------------- form-family-to-abap.mjs */

/*
 * AGENTS §6 states a machine-checkable property in prose and asks for it to be
 * re-checked BY HAND: "Regenerating 312..337 with it is byte-identical below
 * the two generated header lines — re-verify that after any corpus-wide
 * sweep". A manual re-verify is a re-verify that gets skipped, and this one
 * did: between 2026-08-16 and 2026-08-21 the emitter rotted through FOUR
 * sweeps and emitted `open( )`/`leaf( )`, builder methods that no longer
 * exist, so the sentence pointed at 26 classes that could not activate.
 *
 * So it is a test. All 26, against the real corpus, into a temp directory —
 * the property is about THESE ports and this emitter, not about a fixture, and
 * a fixture would only prove the emitter reproduces itself. 1.7 s for the set.
 *
 * The first two lines are excluded because the emitter deliberately does not
 * write them: `npm run keywords` and `npm run summary` own `" @keywords` and
 * `" @summary`, and two generators writing one file would fight.
 */
test('form-family-to-abap: all 26 ports regenerate byte-identically below their header lines', () => {
  const out = fs.mkdtempSync(path.join(os.tmpdir(), 'demokit-form-family-'));
  try {
    const emitter = path.join(REPO, 'scripts', 'form-family-to-abap.mjs');
    assert.ok(fs.existsSync(emitter), 'the emitter must exist — AGENTS §6 names it');

    const family = [];
    for (let n = 312; n <= 337; n++) {
      const cls = `z2ui5_cl_smpc_app_${n}`;
      const sidecar = path.join(REPO, 'meta', `${cls}.json`);
      if (!fs.existsSync(sidecar)) continue;
      const meta = JSON.parse(fs.readFileSync(sidecar, 'utf8'));
      if (!/^sap\.ui\.layout\.sample\./.test(meta.sample)) continue;
      family.push({ cls, meta });
    }
    assert.equal(family.length, 26,
      `the family is apps 312..337 — found ${family.length}. If a port left it, move the range with it.`);

    for (const { cls, meta } of family) {
      const name = meta.sample.split('.').pop();
      const template = path.join(REPO, 'ui5', 'sap.ui.layout', name);
      assert.ok(fs.existsSync(template), `${cls}: ${template} is not archived`);

      const emitted = path.join(out, `${cls}.abap`);
      const r = spawnSync(process.execPath, [emitter, template, cls, meta.sample, emitted], { encoding: 'utf8' });
      assert.equal(r.status, 0,
        `${cls}: the emitter failed — it has rotted behind a corpus sweep\n${r.stderr}`);

      const committed = fs.readFileSync(path.join(REPO, meta.file), 'utf8').split('\n').slice(2).join('\n');
      assert.equal(fs.readFileSync(emitted, 'utf8'), committed,
        `${cls}: regenerating it does NOT reproduce the committed class.\n`
        + 'Either a sweep moved the ports and left the emitter behind (fix the emitter — this is the\n'
        + 'case that shipped open( )/leaf( ) in 2026-08), or the class was edited by hand in a way the\n'
        + 'emitter cannot express (then say so in AGENTS §6, because the claim there stops being true).');
    }
  } finally {
    fs.rmSync(out, { recursive: true, force: true });
  }
});

/* ---------------------------------------------- the sidecar-shaped scripts */

/*
 * A second, SMALLER fixture, built in code rather than committed.
 *
 * scripts/test/fixtures/repo files its two ports at `src/01/<class>` — one
 * level — which is all structural-diff, data-fidelity and generate-summary
 * look at. The scripts below judge the PACKAGE SCHEME itself
 * (`src/<category>/<library>/`, AGENTS §3), so that corpus would fail them for
 * the wrong reason. Writing this one in the test keeps both readable: the
 * committed fixture stays a two-port corpus with a declared diff, and every
 * file here is visible next to the assertion that depends on it.
 */
function writeJson(at, value) {
  fs.mkdirSync(path.dirname(at), { recursive: true });
  fs.writeFileSync(at, `${JSON.stringify(value, null, 2)}\n`);
}

const PORT_ABAP = (cls) => `" @keywords page sap.m fixture page text
" @summary A fixture port.
CLASS ${cls} DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS ${cls} IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = \`View\` ns = \`mvc\`
        )->a( n = \`xmlns:mvc\` v = \`sap.ui.core.mvc\`
        )->a( n = \`xmlns\`     v = \`sap.m\`

        )->ele( \`Page\`
            )->tag( \`Text\`
                )->a( n = \`text\` v = \`hello\` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
`;

/** A minimal, VALID two-level corpus: one sap.m port, filed where §3 says. */
function makeMetaRoot(scripts = []) {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'demokit-meta-test-'));
  const cls = 'z2ui5_cl_smpc_app_001';

  fs.mkdirSync(path.join(root, 'src', '01', '01'), { recursive: true });
  fs.writeFileSync(path.join(root, 'src', '01', '01', `${cls}.clas.abap`), PORT_ABAP(cls));

  writeJson(path.join(root, 'meta', `${cls}.json`), {
    class: cls,
    sample: 'sap.m.sample.FixtureGood',
    entity: 'sap.m.Page',
    file: 'src/01/01/z2ui5_cl_smpc_app_001.clas.abap',
    batch: 'b01',
    audit: { frontend_action: false, event_t_arg: false },
    status: 'generated',
    checked: null,
    deviations: [{ type: 'NOTE', what: 'the fixture port declares nothing interesting' }],
  });

  writeJson(path.join(root, 'ui5', 'universe.json'), {
    release: '1.152.0',
    libs: [{ lib: 'sap.m', samples: [{ name: 'FixtureGood', entity: 'sap.m.Page', since: '1.12', deprecated: null }] }],
  });
  writeJson(path.join(root, 'ui5', 'holdout.json'), { samples: [] });
  writeJson(path.join(root, 'ui5', 'descriptions.json'), {
    source: { version: '1.152.0-SNAPSHOT' },
    demokit: { 'sap.m.sample.FixtureGood': { name: 'Fixture Good', description: 'A fixture port.' } },
    written: {},
  });
  fs.mkdirSync(path.join(root, 'ui5', 'sap.m', 'FixtureGood'), { recursive: true });
  fs.writeFileSync(path.join(root, 'ui5', 'sap.m', 'FixtureGood', 'V.view.xml'), '<mvc:View/>\n');

  fs.mkdirSync(path.join(root, 'scripts'), { recursive: true });
  for (const s of ['lib-packages.mjs', 'lib-universe.mjs', ...scripts]) {
    fs.copyFileSync(path.join(REPO, 'scripts', s), path.join(root, 'scripts', s));
  }
  fs.cpSync(path.join(REPO, 'scripts', 'lib'), path.join(root, 'scripts', 'lib'), { recursive: true });
  return { root, cls, sidecar: path.join(root, 'meta', `${cls}.json`) };
}

/* ------------------------------------------------------ lib-packages.mjs */

/*
 * The module that decides the folder every port is filed under. A wrong
 * verdict does not break anything visibly — it MISFILES a class, and
 * `src/01` vs `src/02` is the level an installer reads as "runs on the oldest
 * supported stack". App 443 sat in the wrong half for two weeks on a wrong
 * POST_171 (AGENTS §6), which is the same fact reached from the other side.
 *
 * Pure functions over a sidecar, so no fixture: import and ask.
 */
test('lib-packages: the library comes from the SAMPLE, not from the entity', async () => {
  const { sampleLib, libFolder, portPath } = await import('../lib-packages.mjs');

  assert.equal(sampleLib('sap.m.sample.ContainerNoPadding'), 'sap.m');
  // the FULL library of the sample; libFolder is what folds sap.ui.* onto one
  // package number, and keeping those two steps apart is what lets
  // generate-overview group by the real library name
  assert.equal(sampleLib('sap.ui.layout.sample.Form354'), 'sap.ui.layout');
  assert.equal(libFolder(sampleLib('sap.ui.layout.sample.Form354')), '02');
  assert.equal(sampleLib('sap.uxap.sample.ObjectPageHeader'), 'sap.uxap');

  // the case AGENTS §3 names: a sap.ui.core ENTITY in a sap.m sample stays sap.m
  assert.equal(
    portPath({ class: 'x', sample: 'sap.m.sample.ContainerNoPadding', entity: 'sap.ui.core.CSSSize', deviations: [] }),
    'src/01/01/x.clas.abap',
  );
  assert.equal(libFolder('sap.m'), '01');
  assert.equal(libFolder('sap.ui'), '02');
  assert.equal(libFolder('sap.uxap'), '03');
  assert.equal(libFolder('sap.f'), '04');
  assert.equal(libFolder('sap.tnt'), '05');
  assert.equal(libFolder('sap.nonesuch'), null, 'an unknown library has no folder — the caller must say so');
});

test('lib-packages: the FIRST POST_171 deviation moves a port from src/01 to src/02', async () => {
  const { catFolder, portPath } = await import('../lib-packages.mjs');

  const base = { class: 'z2ui5_cl_smpc_app_001', sample: 'sap.m.sample.FixtureGood', entity: 'sap.m.Page' };

  const clean = { ...base, deviations: [{ type: 'NOTE', what: 'nothing' }] };
  assert.equal(catFolder(clean), '01');
  assert.equal(portPath(clean), 'src/01/01/z2ui5_cl_smpc_app_001.clas.abap');

  const post = { ...base, deviations: [{ type: 'NOTE', what: 'nothing' }, { type: 'POST_171', what: 'Text.renderWhitespace is @since 1.51' }] };
  assert.equal(catFolder(post), '02', 'a kept post-1.71 member raises the release requirement');
  assert.equal(portPath(post), 'src/02/01/z2ui5_cl_smpc_app_001.clas.abap');

  // and dropping the last one moves it back — the property that makes the
  // path DERIVED rather than chosen
  assert.equal(portPath({ ...post, deviations: post.deviations.filter((d) => d.type !== 'POST_171') }),
    'src/01/01/z2ui5_cl_smpc_app_001.clas.abap');
});

test('lib-packages: a SAPUI5-only library lands in the collection half', async () => {
  const { isSapui5Only, catFolder } = await import('../lib-packages.mjs');

  assert.equal(isSapui5Only('sap.suite.ui.microchart'), true);
  assert.equal(isSapui5Only('sap.ui.comp'), true);
  assert.equal(isSapui5Only('sap.m'), false);
  assert.equal(isSapui5Only('sap.ui.layout'), false);

  const sapui5 = { class: 'x', sample: 'sap.suite.sample.Chart', entity: 'sap.suite.ui.microchart.BulletMicroChart', deviations: [] };
  assert.equal(catFolder(sapui5), '03');
});

/* ------------------------------------------------------ validate-meta.mjs */

/*
 * 19 KB, and the schema gate everything else trusts: the overview app, the
 * coverage tables, SAMPLES.md and catalogue.json all read `meta/` and assume
 * it is well-formed because this ran. It had no test at all.
 *
 * The cases below are the ones whose absence has actually cost something —
 * a misfiled port (AGENTS §3), a drifted audit flag (the 2026-08-03 sweep
 * found 24), an e2e module that cannot fail (three recon scripts sat in
 * meta/interactions/ for weeks) and a sidecar paragraph that breaks the
 * generated ABAP (2026-08-28).
 */
function runIn(root, script, ...args) {
  const r = spawnSync(process.execPath, [path.join(root, 'scripts', script), ...args], { encoding: 'utf8' });
  return { code: r.status, out: r.stdout, errout: r.stderr };
}

test('validate-meta: the minimal valid corpus passes', () => {
  const { root } = makeMetaRoot(['validate-meta.mjs']);
  try {
    const r = runIn(root, 'validate-meta.mjs');
    assert.equal(r.code, 0, `the fixture corpus must be valid\n${r.out}${r.errout}`);
    assert.match(r.out, /validate-meta: 1 sidecars, 1 ports, 0 error\(s\)/);
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});

test('validate-meta: a port filed in the wrong package fails, naming the folder it belongs in', () => {
  const { root, sidecar } = makeMetaRoot(['validate-meta.mjs']);
  try {
    // the class moves to src/02/01 without gaining a POST_171 — the exact
    // shape "declaring the first POST_171 moves a port" exists to prevent
    const meta = JSON.parse(fs.readFileSync(sidecar, 'utf8'));
    fs.mkdirSync(path.join(root, 'src', '02', '01'), { recursive: true });
    fs.renameSync(path.join(root, meta.file), path.join(root, 'src', '02', '01', `${meta.class}.clas.abap`));
    meta.file = `src/02/01/${meta.class}.clas.abap`;
    writeJson(sidecar, meta);

    const r = runIn(root, 'validate-meta.mjs');
    assert.equal(r.code, 1, 'a misfiled port must fail');
    assert.match(r.out, /must be "src\/01\/01\/z2ui5_cl_smpc_app_001\.clas\.abap"/);
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});

test('validate-meta: the audit flags are derived from the class, not believed', () => {
  const { root, sidecar } = makeMetaRoot(['validate-meta.mjs']);
  try {
    const meta = JSON.parse(fs.readFileSync(sidecar, 'utf8'));
    meta.audit.frontend_action = true;          // the class calls neither
    writeJson(sidecar, meta);

    const r = runIn(root, 'validate-meta.mjs');
    assert.equal(r.code, 1, 'a drifted audit flag must fail');
    assert.match(r.out, /audit\.frontend_action is true but the class does NOT call/);
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});

test('validate-meta: `checked` is required, as null while the port is not live-verified', () => {
  const { root, sidecar } = makeMetaRoot(['validate-meta.mjs']);
  try {
    const meta = JSON.parse(fs.readFileSync(sidecar, 'utf8'));
    delete meta.checked;
    writeJson(sidecar, meta);
    const missing = runIn(root, 'validate-meta.mjs');
    assert.equal(missing.code, 1, 'an absent `checked` must fail');
    assert.match(missing.out, /missing field "checked" — write `"checked": null`/);

    meta.checked = null;
    writeJson(sidecar, meta);
    assert.equal(runIn(root, 'validate-meta.mjs').code, 0, 'an explicit null is the documented shape');

    meta.status = 'checked';
    writeJson(sidecar, meta);
    const promoted = runIn(root, 'validate-meta.mjs');
    assert.equal(promoted.code, 1, 'status checked with checked:null must fail');
    assert.match(promoted.out, /requires a checked \{date, note\}/);
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});

test('validate-meta: a newline in sidecar text fails — it cannot survive an ABAP literal', () => {
  const { root, sidecar } = makeMetaRoot(['validate-meta.mjs']);
  try {
    const meta = JSON.parse(fs.readFileSync(sidecar, 'utf8'));
    meta.deviations[0].what = 'first paragraph\n\nsecond paragraph';
    writeJson(sidecar, meta);

    const r = runIn(root, 'validate-meta.mjs');
    assert.equal(r.code, 1, 'a multi-line deviation must fail');
    assert.match(r.out, /deviations\[0\]\.what carries a control character \(\\u000a\)/);
    assert.match(r.out, /baked into an ABAP string literal, which cannot span lines/);
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});

test('validate-meta: an interaction module that cannot fail is rejected, comments do not count', () => {
  const { root, cls } = makeMetaRoot(['validate-meta.mjs']);
  const at = path.join(root, 'meta', 'interactions');
  try {
    fs.mkdirSync(at, { recursive: true });

    // the recon-script shape: reads the DOM, asserts nothing
    fs.writeFileSync(path.join(at, `${cls}.mjs`),
      'export default async (page) => {\n  console.log(await page.content());\n};\n');
    const recon = runIn(root, 'validate-meta.mjs');
    assert.equal(recon.code, 1, 'a module that only logs must fail');
    assert.match(recon.out, /asserts nothing — it can never fail/);

    // the tightened rule: a COMMENT mentioning a wait is not an assertion.
    // `waitFor` used to satisfy CAN_FAIL as a bare substring of the source.
    fs.writeFileSync(path.join(at, `${cls}.mjs`),
      'export default async (page) => {\n  // waitFor the popover to settle\n  console.log(await page.content());\n};\n');
    const commented = runIn(root, 'validate-meta.mjs');
    assert.equal(commented.code, 1, 'a comment about waiting is not an assertion');
    assert.match(commented.out, /asserts nothing/);

    // and a real one passes
    fs.writeFileSync(path.join(at, `${cls}.mjs`),
      "export default async (page, expect) => {\n  await expect(page.locator('body'), 'the page').toContainText('hello');\n};\n");
    assert.equal(runIn(root, 'validate-meta.mjs').code, 0, 'an expect( ) is an assertion');

    // an orphan module is a renamed port's leftover and would never run again
    fs.writeFileSync(path.join(at, 'z2ui5_cl_smpc_app_999.mjs'),
      "export default async (page, expect) => { await expect(page, 'x').toContainText('y'); };\n");
    const orphan = runIn(root, 'validate-meta.mjs');
    assert.equal(orphan.code, 1, 'an orphan module must fail');
    assert.match(orphan.out, /matches no port sidecar .* orphan interaction module/);
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});

test('validate-meta: interaction coverage is reported over the PORT set, split by rung', () => {
  const { root, cls } = makeMetaRoot(['validate-meta.mjs']);
  try {
    // no LIVE_TEST deviation anywhere — the advisory this replaced would have
    // been silent here, which is exactly how it went dead when the backlog
    // reached 0
    const bare = runIn(root, 'validate-meta.mjs');
    assert.equal(bare.code, 0);
    assert.match(bare.out, /1 of 1 port\(s\) \(100%\) have no meta\/interactions\/<class>\.mjs — 1\/1 generated · 0\/0 reviewed · 0\/0 checked/);

    fs.mkdirSync(path.join(root, 'meta', 'interactions'), { recursive: true });
    fs.writeFileSync(path.join(root, 'meta', 'interactions', `${cls}.mjs`),
      "export default async (page, expect) => {\n  await expect(page.locator('body'), 'the page').toContainText('hello');\n};\n");
    const covered = runIn(root, 'validate-meta.mjs');
    assert.equal(covered.code, 0);
    assert.ok(!covered.out.includes('have no meta/interactions'), 'a covered corpus reports no gap');
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});

/* ---------------------------------------------------------- check-pins.mjs */

/*
 * The whole pin policy, and every clause of it was written after something
 * went wrong: a stale `"branch"` shadowing the intended one (2026-08-10), a
 * property snapshot behind its universe (sap.f.HeroBanner), a description
 * snapshot six weeks behind with no refresh path, `^1.151.0` on half the
 * runtime packages, and seven documents left claiming the old pin after a
 * bump. Each gets a case, because a policy nothing tests is a policy that
 * loosens by accident.
 */
function makePinRoot() {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'demokit-pins-test-'));
  const pin = 'a'.repeat(40);
  fs.writeFileSync(path.join(root, 'A2UI5_PIN'), `${pin}\n`);
  const dep = (branch) => `{
  // a fixture config
  "dependencies": [
    { "url": "https://github.com/abap2UI5/abap2UI5", "branch": "${branch}", "files": "/src/**/*.*" }
  ]
}
`;
  fs.writeFileSync(path.join(root, 'abaplint.jsonc'), dep('main'));
  fs.mkdirSync(path.join(root, '.github', 'abaplint'), { recursive: true });
  fs.writeFileSync(path.join(root, '.github', 'abaplint', 'abap_cloud.jsonc'), dep('main'));
  fs.writeFileSync(path.join(root, '.github', 'abaplint', 'abap_702.jsonc'), dep('702'));

  writeJson(path.join(root, 'ui5', 'universe.json'), { release: '1.152.0', libs: [] });
  writeJson(path.join(root, 'ui5', 'properties.json'), { ui5Version: '1.152.0-SNAPSHOT', controls: {} });
  writeJson(path.join(root, 'ui5', 'descriptions.json'), { source: { version: '1.152.0-SNAPSHOT' }, demokit: {}, written: {} });
  writeJson(path.join(root, 'package.json'), {
    name: 'fixture',
    devDependencies: { '@openui5/sap.m': '1.151.0', '@sapui5/sap.viz': '1.151.0' },
  });
  fs.mkdirSync(path.join(root, 'meta'), { recursive: true });
  fs.mkdirSync(path.join(root, 'scripts'), { recursive: true });
  fs.copyFileSync(path.join(REPO, 'scripts', 'check-pins.mjs'), path.join(root, 'scripts', 'check-pins.mjs'));
  return { root, pin };
}

test('check-pins: the fixture pin policy passes, and a malformed pin does not', () => {
  const { root } = makePinRoot();
  try {
    const ok = runIn(root, 'check-pins.mjs');
    assert.equal(ok.code, 0, `the fixture must satisfy the policy\n${ok.out}`);
    assert.match(ok.out, /A2UI5_PIN well-formed/);
    assert.match(ok.out, /on main/);

    fs.writeFileSync(path.join(root, 'A2UI5_PIN'), 'main\n');
    const bad = runIn(root, 'check-pins.mjs');
    assert.equal(bad.code, 1, 'a branch name is not a commit');
    assert.match(bad.out, /not a well-formed 40-hex commit SHA/);

    fs.writeFileSync(path.join(root, 'A2UI5_PIN'), `${'a'.repeat(40)}\n${'b'.repeat(40)}\n`);
    const two = runIn(root, 'check-pins.mjs');
    assert.equal(two.code, 1, 'two SHAs are two pins');
    assert.match(two.out, /more than one non-empty line/);
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});

test('check-pins: a duplicate branch key, a stray branch and a release pin all fail', () => {
  const { root } = makePinRoot();
  try {
    // the 2026-08-10 incident: a deleted branch left NEXT to the intended one.
    // JSON.parse takes the last, so every consumer sees only one.
    const at = path.join(root, 'abaplint.jsonc');
    fs.writeFileSync(at, fs.readFileSync(at, 'utf8')
      .replace('"branch": "main"', '"branch": "some-merged-branch", "branch": "main"'));
    const dup = runIn(root, 'check-pins.mjs');
    assert.equal(dup.code, 1);
    assert.match(dup.out, /carries 2 "branch" keys/);

    fs.writeFileSync(at, fs.readFileSync(at, 'utf8')
      .replace('"branch": "some-merged-branch", "branch": "main"', '"branch": "my-feature"'));
    const stray = runIn(root, 'check-pins.mjs');
    assert.equal(stray.code, 1, 'a feature-branch re-point must fail after the merge');
    assert.match(stray.out, /resolve the framework's "main"/);

    // the pre-2026-08-31 policy value: a release tag no longer belongs here -
    // releases are monthly snapshots and never gate a merge
    fs.writeFileSync(at, fs.readFileSync(at, 'utf8').replace('"branch": "my-feature"', '"branch": "1.144.0"'));
    const tag = runIn(root, 'check-pins.mjs');
    assert.equal(tag.code, 1, 'a release tag is the OLD policy and must fail');
    assert.match(tag.out, /releases are monthly snapshots/);
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});

test('check-pins: either snapshot behind the universe fails, with the cost named', () => {
  const { root } = makePinRoot();
  try {
    writeJson(path.join(root, 'ui5', 'properties.json'), { ui5Version: '1.151.0-SNAPSHOT', controls: {} });
    const props = runIn(root, 'check-pins.mjs');
    assert.equal(props.code, 1);
    assert.match(props.out, /ui5\/properties\.json is 1\.151\.0-SNAPSHOT, older than the universe/);
    assert.match(props.out, /scopeOf lets those controls through/);

    writeJson(path.join(root, 'ui5', 'properties.json'), { ui5Version: '1.152.0-SNAPSHOT', controls: {} });
    writeJson(path.join(root, 'ui5', 'descriptions.json'), { source: { version: '1.151.0-SNAPSHOT' }, demokit: {}, written: {} });
    const desc = runIn(root, 'check-pins.mjs');
    assert.equal(desc.code, 1, 'the description snapshot is held to the same line');
    assert.match(desc.out, /ui5\/descriptions\.json is 1\.151\.0-SNAPSHOT, older than the universe/);
    assert.match(desc.out, /check:summary fails HARD/);
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});

test('check-pins: the UI5 runtime packages must be one EXACT version', () => {
  const { root } = makePinRoot();
  const pkg = path.join(root, 'package.json');
  try {
    writeJson(pkg, { name: 'fixture', devDependencies: { '@openui5/sap.m': '^1.151.0', '@sapui5/sap.viz': '1.151.0' } });
    const ranged = runIn(root, 'check-pins.mjs');
    assert.equal(ranged.code, 1, 'a caret moves the render harness with no diff to read');
    assert.match(ranged.out, /carry a RANGE, not a pin/);

    writeJson(pkg, { name: 'fixture', devDependencies: { '@openui5/sap.m': '1.152.0', '@sapui5/sap.viz': '1.151.0' } });
    const split = runIn(root, 'check-pins.mjs');
    assert.equal(split.code, 1, 'a partial bump splits the render gate from scope-of');
    assert.match(split.out, /name 2 different versions/);

    // the universe ahead of the runtime is a NOTE, not a failure: the universe
    // comes from a checkout and legitimately runs ahead of npm
    writeJson(pkg, { name: 'fixture', devDependencies: { '@openui5/sap.m': '1.151.0', '@sapui5/sap.viz': '1.151.0' } });
    const ok = runIn(root, 'check-pins.mjs');
    assert.equal(ok.code, 0);
    assert.match(ok.out, /note: the sample universe is 1\.152\.0, ahead of the runtime/);
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});

test('check-pins: prose asserting a stale pin fails; past-tense prose is history and passes', () => {
  const { root, pin } = makePinRoot();
  const status = path.join(root, 'STATUS.md');
  try {
    fs.writeFileSync(status, `# fixture\n\n\`A2UI5_PIN\` is \`${pin.slice(0, 8)}\`, which carries the fix.\n`);
    assert.equal(runIn(root, 'check-pins.mjs').code, 0, 'prose naming the real pin passes');

    fs.writeFileSync(status, '# fixture\n\n`A2UI5_PIN` is still `bf92a79c` (2026-08-14), so the port is blocked.\n');
    const stale = runIn(root, 'check-pins.mjs');
    assert.equal(stale.code, 1, 'a stale pin claim must fail');
    assert.match(stale.out, /STATUS\.md: says the pin is `bf92a79c`/);
    assert.match(stale.out, /write it in the past tense so it reads as history/);

    // the same SHA in a sentence about a state that has PASSED is a true
    // record of a run and must NOT fail — that is what bump-a2ui5.yaml's
    // header carries about three runs that died in 2026-08
    fs.writeFileSync(status, '# fixture\n\nA2UI5_PIN sat at bf92a79c while abap2UI5 main moved 61 commits.\n');
    assert.equal(runIn(root, 'check-pins.mjs').code, 0, 'past tense is history, not drift');

    // a sidecar deviation is prose too — six of the seven stale claims were there
    fs.writeFileSync(status, '# fixture\n');
    writeJson(path.join(root, 'meta', 'z2ui5_cl_smpc_app_001.json'), {
      class: 'z2ui5_cl_smpc_app_001',
      deviations: [{ type: 'NOTE', what: 'not wired yet: `A2UI5_PIN` is `bf92a79c`, which predates the fix.' }],
    });
    const sidecar = runIn(root, 'check-pins.mjs');
    assert.equal(sidecar.code, 1, 'a sidecar deviation is in scope');
    assert.match(sidecar.out, /deviations\[0\]\.what: says the pin is `bf92a79c`/);
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});

/* ----------------------------- generate-status / -catalogue / -keywords /
                                                          pattern-lint       */

test('generate-status: the state block counts every escape hatch, not two of them', () => {
  const { root, sidecar } = makeMetaRoot(['generate-status.mjs']);
  try {
    fs.writeFileSync(path.join(root, 'STATUS.md'),
      '# fixture\n\n<!-- state:start -->\nstale\n<!-- state:end -->\n\ntail\n');

    const meta = JSON.parse(fs.readFileSync(sidecar, 'utf8'));
    meta.render_smoke = { skip: true, reason: 'the fixture cannot render' };
    meta.property_gate = { skip: true, types: ['unknown-property'], reason: 'the fixture member is newer than the snapshot' };
    writeJson(sidecar, meta);

    const r = runIn(root, 'generate-status.mjs');
    assert.equal(r.code, 0, `${r.out}${r.errout}`);
    const out = fs.readFileSync(path.join(root, 'STATUS.md'), 'utf8');

    // the narrowest hatch is the one that most needs to be visible, and it was
    // the one missing: property_gate names the finding TYPES it suppresses
    assert.match(out, /\| Declared gate skips \| 0 structural-diff · 1 render-smoke · 0 data-fidelity · 1 property-gate \(each re-verified per run/);
    assert.match(out, /\| Ports \| \*\*1\*\* sidecars/);
    assert.match(out, /\| Status ladder \| 1 `generated` · 0 `reviewed` · 0 `checked`/);
    assert.ok(out.startsWith('# fixture\n'), 'only the marked block is rewritten');
    assert.ok(out.trimEnd().endsWith('tail'), 'the hand-maintained backlog below survives');
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});

test('generate-catalogue: --check is a real gate, and the entry carries the joined facts', () => {
  const { root, cls } = makeMetaRoot(['generate-catalogue.mjs']);
  try {
    const write = runIn(root, 'generate-catalogue.mjs');
    assert.equal(write.code, 0, `${write.out}${write.errout}`);

    const cat = JSON.parse(fs.readFileSync(path.join(root, 'catalogue.json'), 'utf8'));
    const entry = cat.ports.find((a) => a.class === cls);
    assert.ok(entry, 'the port must be in the catalogue');
    assert.equal(entry.sample, 'sap.m.sample.FixtureGood');
    assert.equal(entry.entity, 'sap.m.Page');
    assert.equal(entry.status, 'generated');
    assert.equal(entry.category, 'src/01', 'the category is derived from the path, not stored');
    assert.equal(entry.library, 'sap.m');
    assert.equal(entry.file, 'src/01/01/z2ui5_cl_smpc_app_001.clas.abap');
    assert.equal(entry.summary, 'A fixture port.', 'the summary is read off the class');

    assert.equal(runIn(root, 'generate-catalogue.mjs', '--check').code, 0, 'freshly written is current');

    // the drift the gate exists for: a sidecar changes and nobody regenerates
    const meta = JSON.parse(fs.readFileSync(path.join(root, 'meta', `${cls}.json`), 'utf8'));
    meta.status = 'reviewed';
    writeJson(path.join(root, 'meta', `${cls}.json`), meta);
    const stale = runIn(root, 'generate-catalogue.mjs', '--check');
    assert.equal(stale.code, 1, 'a stale catalogue must fail');
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});

/*
 * generate-keywords is the script with the documented 7051-occurrence blind
 * spot: its control matcher accepted only the POSITIONAL `)->tag( \`Label\` )`
 * and never the NAMED `)->tag( n = \`Label\` ns = \`z2ui5\` )` — the only shape
 * that can carry a namespace, so a companion control could not reach a keyword
 * line at all. 469 of 622 ports wrote the named form somewhere. A golden-file
 * test would have caught it the day the named form arrived, so here it is.
 */
test('generate-keywords: both builder call shapes reach the line', () => {
  const { root, cls } = makeMetaRoot(['generate-keywords.mjs']);
  const at = path.join(root, 'src', '01', '01', `${cls}.clas.abap`);
  try {
    // the port builds a POSITIONAL Text and a NAMED, namespaced companion
    fs.writeFileSync(at, fs.readFileSync(at, 'utf8')
      .replace('    )->tag( `Text`', '    )->tag( n = `MultiInputExt` ns = `z2ui5`\n            )->tag( `Text`'));

    const r = runIn(root, 'generate-keywords.mjs');
    assert.equal(r.code, 0, `${r.out}${r.errout}`);
    const line = fs.readFileSync(at, 'utf8').split('\n')[0];
    assert.match(line, /^" @keywords /);
    assert.match(line, /\btext\b/, 'the POSITIONAL )->tag( `Text` ) must reach the line');
    assert.match(line, /\bmultiinputext\b/,
      'the NAMED )->tag( n = `…` ns = `…` ) must reach the line too — this is the shape the matcher '
      + 'could not see until 2026-08-23, which hid 7051 control occurrences across 469 ports');
    assert.match(line, /\bsap\.m\b/, "the sidecar's entity library is a term");
    assert.ok(!/\bpage\b/.test(line), '`page` is in NOISE — a term every port carries separates none of them');

    assert.equal(runIn(root, 'generate-keywords.mjs', '--check').code, 0, 'the check passes on what it wrote');

    fs.writeFileSync(at, fs.readFileSync(at, 'utf8').replace(/^" @keywords .*$/m, '" @keywords whatever'));
    const edited = runIn(root, 'generate-keywords.mjs', '--check');
    assert.equal(edited.code, 1, 'a hand-edited line must fail — the terms come from the sources');
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});

test('pattern-lint: an ABAP Doc header on a port is an error, and the clean fixture passes', () => {
  const { root } = makeMetaRoot(['pattern-lint.mjs']);
  const at = path.join(root, 'src', '01', '01', 'z2ui5_cl_smpc_app_001.clas.abap');
  try {
    const clean = runIn(root, 'pattern-lint.mjs');
    assert.equal(clean.code, 0, `the fixture port must be clean\n${clean.out}`);
    assert.match(clean.out, /pattern-lint: 0 error\(s\)/);

    // AGENTS §5: a port carries NO ABAP Doc header — everything that
    // identifies it lives in meta/<class>.json
    fs.writeFileSync(at, `"! <p>A port with a header</p>\n${fs.readFileSync(at, 'utf8')}`);
    const header = runIn(root, 'pattern-lint.mjs');
    assert.equal(header.code, 1, 'a "! header on a port must fail');
    assert.match(header.out, /header-in-port|abapdoc/);
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});

/* ------------------------------------------------------- e2e-changed.mjs */

/*
 * Which ports a pull request boots. Same shape as abap-scope.mjs and the same
 * safety property: a change the map cannot attribute to a subset answers
 * `all`, never "nothing" — a subset that quietly misses the change it should
 * have caught is worse than no PR job.
 */
test('e2e-changed: a port, its sidecar and its interaction module all name the port', async () => {
  const { portsToRun } = await import('../e2e-changed.mjs');

  assert.deepEqual(
    portsToRun(['src/01/01/z2ui5_cl_smpc_app_462.clas.abap']).classes,
    ['z2ui5_cl_smpc_app_462'],
  );
  assert.deepEqual(portsToRun(['meta/z2ui5_cl_smpc_app_101.json']).classes, ['z2ui5_cl_smpc_app_101']);
  assert.deepEqual(
    portsToRun(['meta/interactions/z2ui5_cl_smpc_app_350.mjs']).classes,
    ['z2ui5_cl_smpc_app_350'],
  );

  // deduplicated and sorted, so the --only list is stable
  assert.deepEqual(
    portsToRun([
      'meta/interactions/z2ui5_cl_smpc_app_350.mjs',
      'src/02/02/z2ui5_cl_smpc_app_350.clas.abap',
      'meta/z2ui5_cl_smpc_app_101.json',
    ]).classes,
    ['z2ui5_cl_smpc_app_101', 'z2ui5_cl_smpc_app_350'],
  );

  // the overview app is a port for this purpose — it sits directly under src/
  assert.deepEqual(portsToRun(['src/z2ui5_cl_smpc_app_000.clas.abap']).classes, ['z2ui5_cl_smpc_app_000']);
});

test('e2e-changed: prose and generated artefacts boot nothing', async () => {
  const { portsToRun } = await import('../e2e-changed.mjs');

  const inert = ['README.md', 'AGENTS.md', 'api.md', 'catalogue.json', 'SAMPLES.md',
    'ui5/sap.m/FixtureGood/V.view.xml', 'docs/history.md', 'scripts/generate-overview.mjs'];
  const r = portsToRun(inert);
  assert.equal(r.all, false);
  assert.deepEqual(r.classes, []);
  assert.match(r.reason, /no port, sidecar or interaction module changed/);
});

test('e2e-changed: a corpus-wide change answers `all` rather than a subset', async () => {
  const { portsToRun } = await import('../e2e-changed.mjs');

  for (const f of ['A2UI5_PIN', 'package.json', 'package-lock.json', 'scripts/e2e-build.mjs',
    'scripts/e2e-smoke.mjs', 'scripts/lib-e2e.mjs', 'web/ci/patch_open_abap_xml.mjs',
    '.github/workflows/e2e-pr.yaml']) {
    assert.equal(portsToRun([f]).all, true, `${f} reaches every port`);
  }

  // and it wins over a port that happens to be in the same change: the subset
  // would be a guess about which ports the pin moved
  const mixed = portsToRun(['A2UI5_PIN', 'src/01/01/z2ui5_cl_smpc_app_462.clas.abap']);
  assert.equal(mixed.all, true);
  assert.match(mixed.reason, /A2UI5_PIN reaches every port/);
});
