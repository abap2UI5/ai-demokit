/*
 * lib-a2ui5 — locate the abap2UI5 checkout the Node backend builds and serves.
 *
 * Preference order:
 *   1. A2UI5_HOME            explicit override
 *   2. <repo>/.abap2UI5      the in-repo clone that `npm run node:setup` writes
 *   3. <repo>/../abap2UI5    a sibling checkout
 * The first candidate that actually contains the express shim wins.
 *
 * A2UI5_PIN (repo root) holds the framework commit the reproducible paths
 * build against: node-setup checks the in-repo clone out at that SHA. The pin
 * moves via .github/workflows/bump-a2ui5.yaml; the nightly e2e stays on main
 * tip as the upstream canary.
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

export const REPO_ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
export const IN_REPO_A2UI5 = path.join(REPO_ROOT, '.abap2UI5');

export function resolveA2UI5() {
  const cands = [
    process.env.A2UI5_HOME,
    IN_REPO_A2UI5,
    path.join(REPO_ROOT, '..', 'abap2UI5'),
  ];
  for (const c of cands) {
    if (c && fs.existsSync(path.join(c, 'node/srv/express.mjs'))) return path.resolve(c);
  }
  return null;
}

/** The pinned abap2UI5 commit (A2UI5_PIN at the repo root), or null. */
export function readA2UI5Pin() {
  try {
    const sha = fs.readFileSync(path.join(REPO_ROOT, 'A2UI5_PIN'), 'utf8').trim();
    return /^[0-9a-f]{40}$/.test(sha) ? sha : null;
  } catch {
    return null;
  }
}
