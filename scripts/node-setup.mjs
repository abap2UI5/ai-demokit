#!/usr/bin/env node
/*
 * node-setup — one-time setup to run the ports on the Node backend.
 *
 * Clones abap2UI5 into .abap2UI5 (in-repo, gitignored), installs its deps and
 * this repo's deps, then builds the backend. After this, `npm run node:serve`
 * starts the server on http://localhost:3000.
 *
 * Re-runnable: if .abap2UI5 already exists it is updated (git pull) instead of
 * re-cloned. Override the source with A2UI5_REPO / A2UI5_BRANCH env vars.
 */
import { execSync } from 'child_process';
import fs from 'fs';
import { IN_REPO_A2UI5, REPO_ROOT } from './lib-a2ui5.mjs';

const REPO = process.env.A2UI5_REPO || 'https://github.com/abap2UI5/abap2UI5';
const BRANCH = process.env.A2UI5_BRANCH || '';

const run = (cmd, cwd = REPO_ROOT) => {
  console.log(`\n$ ${cmd}   (in ${cwd})`);
  execSync(cmd, { cwd, stdio: 'inherit' });
};

// 1. clone (or update) abap2UI5 into .abap2UI5
if (fs.existsSync(`${IN_REPO_A2UI5}/node/srv/express.mjs`)) {
  console.log('node-setup: .abap2UI5 already present — updating');
  try { run('git pull --ff-only', IN_REPO_A2UI5); } catch { console.log('node-setup: git pull skipped (local changes / detached) — using existing checkout'); }
} else {
  fs.rmSync(IN_REPO_A2UI5, { recursive: true, force: true });
  const branch = BRANCH ? `--branch ${BRANCH} ` : '';
  run(`git clone --depth 1 ${branch}${REPO} .abap2UI5`);
}

// 2. install deps — the framework (transpiler, express, runtime) and this repo
run('npm ci', IN_REPO_A2UI5);
run('npm ci');

// 3. build the backend (downport + transpile framework + all ports)
run('node scripts/e2e-build.mjs');

console.log('\nnode-setup: done ✔');
console.log('Start the server with:   npm run node:serve');
console.log('Then open:               http://localhost:3000/?app_start=z2ui5_cl_ai_app_overview');
