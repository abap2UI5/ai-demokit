/*
 * lib-a2ui5 — locate the abap2UI5 checkout the Node backend builds and serves.
 *
 * Preference order:
 *   1. A2UI5_HOME            explicit override
 *   2. <repo>/.abap2UI5      the in-repo clone that `npm run node:setup` writes
 *   3. <repo>/../abap2UI5    a sibling checkout
 *   4. /home/user/abap2UI5   the sandbox default
 * The first candidate that actually contains the express shim wins.
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
    '/home/user/abap2UI5',
  ];
  for (const c of cands) {
    if (c && fs.existsSync(path.join(c, 'node/srv/express.mjs'))) return path.resolve(c);
  }
  return null;
}
