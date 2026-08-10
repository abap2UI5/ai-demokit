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
const SCRIPTS = ['structural-diff.mjs', 'data-fidelity.mjs', 'generate-coverage.mjs', 'lib-universe.mjs'];

function makeFixtureRoot() {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'demokit-tooling-test-'));
  fs.cpSync(FIXTURE, root, { recursive: true });
  for (const s of SCRIPTS) {
    fs.copyFileSync(path.join(REPO, 'scripts', s), path.join(root, 'scripts', s));
  }
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
    assert.match(r.out, /z2ui5_cl_dmo_app_002: asset `wrong-HT-9999\.jpg` appears nowhere/);
    assert.match(r.out, /z2ui5_cl_dmo_app_002: table row 2 field `city` = "Atlantis"/);
    assert.ok(!r.out.includes('z2ui5_cl_dmo_app_001:'), 'the verbatim port must produce no finding');
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
