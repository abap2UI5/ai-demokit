#!/usr/bin/env node
/*
 * e2e-build — assemble the transpiled abap2UI5 backend that serves the PORTS.
 *
 * render-smoke reconstructs a view statically; this build runs the REAL app:
 * the abap2UI5 framework + the ai-demokit ports (+ the z2ui5_cl_ai_xml builder)
 * are transpiled to JS by @abaplint/transpiler and served by the framework's
 * express shim (node/srv/express.mjs -> ZCL_SICF -> z2ui5_cl_http_handler),
 * i.e. the same open-abap runtime the framework's own e2e uses. An app is then
 * started in a browser via ?app_start=<class> (see e2e-smoke.mjs).
 *
 * The abap2UI5 checkout supplies the transpiler + express + runtime libs; point
 * at it with A2UI5_HOME (default ../abap2UI5, then /home/user/abap2UI5). The
 * framework must have its node_modules installed. The framework SOURCE is never
 * mutated — a COPY is downported in node/downport (its normal build dir), the
 * transpiler writes node/output, and express serves that.
 *
 * The transpiler cannot take the framework's modern ABAP directly (e.g.
 * COND ... LET ...), so the copy is downported to v702 first, exactly like the
 * framework's own `npm run auto_downport` — but on the copy, so the working
 * tree stays clean.
 */
import { execSync } from 'child_process';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { resolveA2UI5 } from './lib-a2ui5.mjs';

const AIDEMOKIT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');

const A2 = resolveA2UI5();
if (!A2) {
  throw new Error('abap2UI5 checkout not found — run `npm run node:setup` (clones it into .abap2UI5) or set A2UI5_HOME to a checkout with node_modules installed');
}
const sh = (cmd, opts = {}) => execSync(cmd, { cwd: A2, stdio: 'inherit', ...opts });
// abaplint --fix exits non-zero while issues remain (expected during iterative
// downport); run it for its side effect and ignore the status
const fix = (cmd) => { try { execSync(cmd, { cwd: A2, stdio: ['ignore', 'ignore', 'ignore'] }); } catch { /* remaining issues are fixed across passes */ } };

// classes that don't transpile (excluded from the served backend, logged so the
// skip is never silent). Add a port here only with a reason if the transpiler
// chokes on it. The overview app IS served — it is the local front door,
// listing every port with a ?app_start= launch link (open
// ?app_start=z2ui5_cl_ai_app_overview). It is not a numbered port, so
// e2e-smoke never picks it up.
const EXCLUDE = new Set([]);

function main() {
  console.log(`e2e-build: abap2UI5 at ${A2}`);
  const downport = path.join(A2, 'node/downport');
  const output = path.join(A2, 'node/output');
  fs.rmSync(downport, { recursive: true, force: true });
  fs.rmSync(output, { recursive: true, force: true });
  fs.mkdirSync(downport, { recursive: true });

  // 1. framework src (modern copy) + the express shim handler + transpile setup
  sh(`cp -r src/. ${downport}/`);
  sh(`cp node/srv/*.abap ${downport}/`);

  // 2. ai-demokit ports + the z2ui5_cl_ai_xml builder (both .abap and .clas.xml)
  let ports = 0;
  for (const f of walk(path.join(AIDEMOKIT, 'src'))) {
    if (!/\.(abap|xml)$/.test(f)) continue;
    const base = path.basename(f);
    const cls = base.replace(/\.(clas|intf)\..*$/, '');
    if (EXCLUDE.has(cls)) continue;
    fs.copyFileSync(f, path.join(downport, base));
    if (/^z2ui5_cl_ai_app_\d+\.clas\.abap$/.test(base)) ports++;
  }
  console.log(`e2e-build: copied ${ports} ports + framework into node/downport`);
  if (EXCLUDE.size) console.log(`e2e-build: excluded (not served): ${[...EXCLUDE].join(', ')}`);

  // 3. downport the copy to v702 (in place, on the copy) — abaplint --fix, a few
  //    passes to settle, then the framework's two sed fixups
  // the config's `files` glob is relative to the config file's directory, so
  // the config sits at the abap2UI5 root and points at /node/downport. Use the
  // framework's FULL 702 rule set (check_syntax:true + definitions_top etc.) —
  // downport can only split inline DATA(x) into a top DATA + assignment when it
  // can resolve the type, so a minimal config produces broken JS (undefined
  // vars). Base it on .github/abaplint/abap_702.jsonc, override only `files`.
  const base = JSON.parse(fs.readFileSync(path.join(A2, '.github/abaplint/abap_702.jsonc'), 'utf8'));
  base.global = { files: '/node/downport/**/*.*' };
  const cfg = path.join(A2, 'e2e-downport.jsonc');
  fs.writeFileSync(cfg, JSON.stringify(base, null, 2));
  console.log('e2e-build: downporting the copy to v702 …');
  for (let i = 0; i < 3; i++) fix(`npx abaplint e2e-downport.jsonc --fix`);
  // the framework's two fixups, done in Node so they are portable (BSD/macOS sed
  // differs from GNU sed on -i and \+): the transpiler can't emit
  // `RAISE EXCEPTION TYPE cx_sy_itab_line_not_found`, so map it to `ASSERT 1 = 0`;
  // then strip trailing whitespace the downport may leave behind.
  for (const f of walk(downport)) {
    if (!f.endsWith('.abap')) continue;
    const fixed = fs.readFileSync(f, 'utf8')
      .replace(/ RAISE EXCEPTION TYPE cx_sy_itab_line_not_found/g, ' ASSERT 1 = 0')
      .replace(/[ \t]+$/gm, '');
    fs.writeFileSync(f, fixed);
  }
  fs.rmSync(cfg, { force: true });

  // 4. transpile the downported copy with the framework's own config
  console.log('e2e-build: transpiling → node/output …');
  sh(`npx abap_transpile ./node/setup/abap_transpile.json`);

  const built = fs.readdirSync(output).filter((f) => /^z2ui5_cl_ai_app_\d+\.clas\.mjs$/.test(f)).length;
  console.log(`e2e-build: done — ${built} ports transpiled into node/output`);
}

function* walk(dir) {
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) yield* walk(p);
    else yield p;
  }
}

main();
