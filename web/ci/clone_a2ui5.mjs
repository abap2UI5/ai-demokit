/*
 * clone_a2ui5 — clone the abap2UI5 framework for the web build, fixed at the
 * commit in A2UI5_PIN (repo root) so the Pages deploy is reproducible and a
 * breaking upstream change lands via a reviewed pin bump, not via the daily
 * cron. Without a pin file (or with A2UI5_BRANCH set) the branch tip is used,
 * matching the old behaviour.
 */
import { execSync } from 'child_process';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const WEB_ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const REPO_ROOT = path.join(WEB_ROOT, '..');
const REPO = process.env.A2UI5_REPO || 'https://github.com/abap2UI5/abap2UI5';
const BRANCH = process.env.A2UI5_BRANCH || '';

let pin = null;
if (!BRANCH) {
  try {
    const sha = fs.readFileSync(path.join(REPO_ROOT, 'A2UI5_PIN'), 'utf8').trim();
    if (/^[0-9a-f]{40}$/.test(sha)) pin = sha;
  } catch { /* no pin file — track the branch tip */ }
}

const run = (cmd, cwd = WEB_ROOT) => {
  console.log(`$ ${cmd}`);
  execSync(cmd, { cwd, stdio: 'inherit' });
};

const branch = BRANCH ? `--branch ${BRANCH} ` : '';
run(`git clone --depth=1 ${branch}${REPO} abap2UI5`);
if (pin) {
  const dir = path.join(WEB_ROOT, 'abap2UI5');
  run(`git fetch --depth 1 origin ${pin}`, dir);
  run(`git checkout --detach ${pin}`, dir);
  console.log(`clone_a2ui5: framework fixed at A2UI5_PIN ${pin}`);
}
