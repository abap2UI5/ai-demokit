#!/usr/bin/env node
/*
 * node-serve — start the Node backend that serves the ports.
 *
 * Resolves the abap2UI5 checkout (the in-repo .abap2UI5 clone by default) and
 * launches its express shim on http://localhost:3000. Run `npm run node:setup`
 * once first; rebuild after changing ports with `npm run node:build`.
 */
import { spawn } from 'child_process';
import fs from 'fs';
import path from 'path';
import { resolveA2UI5 } from './lib-a2ui5.mjs';

const A2 = resolveA2UI5();
if (!A2) {
  console.error('abap2UI5 checkout not found — run `npm run node:setup` first (clones it into .abap2UI5).');
  process.exit(1);
}
if (!fs.existsSync(path.join(A2, 'node/output/init.mjs'))) {
  console.error(`backend not built at ${A2}/node/output — run \`npm run node:build\` (or \`npm run node:setup\`) first.`);
  process.exit(1);
}

console.log(`node-serve: abap2UI5 at ${A2}`);
console.log('open http://localhost:3000/?app_start=z2ui5_cl_ai_app_overview');
const child = spawn('node', [path.join(A2, 'node/srv/express.mjs')], { stdio: 'inherit', env: process.env });
child.on('exit', (code) => process.exit(code ?? 0));
