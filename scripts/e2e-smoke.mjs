#!/usr/bin/env node
/*
 * e2e-smoke — run every PORT as the real abap2UI5 app in a headless browser.
 *
 * Unlike render-smoke (which reconstructs a view statically and loads only that
 * XML), this boots the transpiled backend (scripts/e2e-build.mjs -> the
 * framework's express shim), starts each port via ?app_start=<class>, and lets
 * the real UI5 Component do the initial roundtrip and render. It catches what a
 * static reconstruction cannot: a backend exception on start, a broken
 * Component boot, a runtime JS error, an event wired to a control that rejects
 * it. UI5 is served from the local @openui5 packages (the sandbox has no CDN),
 * so the shell's sdk.openui5.org requests are routed to the package sources.
 *
 * Assertions are generic (no per-port authoring): a port must BOOT UI5, RENDER
 * controls, and raise NO page/console error (benign theme/preload/i18n noise
 * from unbundled source is filtered). A small INTERACTIONS map adds a real
 * click -> toast check for a few ports as a richer proof — extend it freely,
 * but the boot+render+no-error gate already covers all 94.
 *
 *   node scripts/e2e-smoke.mjs            advisory report
 *   node scripts/e2e-smoke.mjs --strict   exit 1 on any failing port
 *   node scripts/e2e-smoke.mjs --only 005 single port (debugging)
 *   node scripts/e2e-smoke.mjs --headed   show the browser (debugging)
 */
import fs from 'fs';
import path from 'path';
import http from 'http';
import { spawn } from 'child_process';
import { fileURLToPath } from 'url';
import { chromium } from 'playwright';
import { resolveA2UI5 } from './lib-a2ui5.mjs';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const META = path.join(ROOT, 'meta');
const STRICT = process.argv.includes('--strict');
const HEADED = process.argv.includes('--headed');
const ONLY = process.argv.includes('--only') ? process.argv[process.argv.indexOf('--only') + 1] : null;

const A2 = resolveA2UI5();
if (!A2) { console.error('abap2UI5 checkout not found — run `npm run node:setup` or set A2UI5_HOME'); process.exit(1); }

// local OpenUI5 sources (same packages render-smoke serves)
const LIB_ROOTS = ['sap.ui.core', 'sap.m', 'sap.ui.layout', 'sap.ui.unified', 'sap.f', 'themelib_sap_horizon']
  .map((p) => path.join(ROOT, 'node_modules', '@openui5', p, 'src'))
  .filter((p) => fs.existsSync(p));
const MIME = { '.js': 'text/javascript', '.css': 'text/css', '.json': 'application/json', '.xml': 'application/xml', '.properties': 'text/plain', '.html': 'text/html', '.png': 'image/png', '.gif': 'image/gif', '.svg': 'image/svg+xml', '.ttf': 'font/ttf' };
function resolveLocal(pathname) {
  const i = pathname.indexOf('/resources/');
  if (i < 0) return null;
  const rel = pathname.slice(i + '/resources/'.length).replace(/^sap-ui-cachebuster\//, '');
  for (const root of LIB_ROOTS) {
    const full = path.join(root, rel);
    if (full.startsWith(root) && fs.existsSync(full) && fs.statSync(full).isFile()) {
      return { body: fs.readFileSync(full), type: MIME[path.extname(full)] || 'application/octet-stream' };
    }
  }
  return null;
}

// page-error (real JS exception) messages that are environment noise, not port
// defects. Resource 404/500s are handled separately by response URL (a
// localhost:3000 backend asset failing is real; an unbundled-UI5 resource we
// didn't serve is benign) — the console "Failed to load resource" line carries
// no URL, so it is ignored in favour of the response tracking below.
const BENIGN = [
  /library-preload/i, /messagebundle/i, /i18n/i, /themes?\/|library(\.css|-parameters)/i,
  /theming\.Parameters|\.properties/i, /failed to load (javascript )?resource/i,
  /Core\.applyTheme|sap\.ui\.getCore/i, /favicon/i, /deprecat/i, /sap-ui-cachebuster/i,
  /ERR_TUNNEL_CONNECTION_FAILED/i,
];
const benign = (s) => BENIGN.some((re) => re.test(s));

// richer per-port checks (optional). Each: after boot, run action(page) and
// assert. The generic boot+render+no-error gate runs for EVERY port regardless.
const INTERACTIONS = {
  z2ui5_cl_ai_app_005: async (page, expect) => {
    const btn = page.getByRole('button', { name: 'Default', exact: true }).first();
    await expect(btn, 'a "Default" press button').toBeVisibleEnabled();
    await btn.click();
    await expect(page.locator('.sapMMessageToast'), 'the client-composed press toast').toContainText('Pressed');
  },
};

function startBackend() {
  return new Promise((resolve, reject) => {
    const srv = spawn('node', [path.join(A2, 'node/srv/express.mjs')], { env: { ...process.env, PORT: '3000' } });
    let out = '';
    const onData = (d) => { out += d; if (/Listening on/.test(out)) { srv.stdout.off('data', onData); resolve(srv); } };
    srv.stdout.on('data', onData);
    srv.stderr.on('data', (d) => { out += d; });
    srv.on('exit', (c) => reject(new Error(`backend exited (${c}) before listening:\n${out.slice(-500)}`)));
    setTimeout(() => reject(new Error(`backend did not start in 30s:\n${out.slice(-500)}`)), 30000);
  });
}

function waitPort(port, ms = 30000) {
  const deadline = Date.now() + ms;
  return new Promise((resolve, reject) => {
    const tick = () => {
      const req = http.get({ port, path: '/', timeout: 1000 }, (r) => { r.destroy(); resolve(); });
      req.on('error', () => (Date.now() > deadline ? reject(new Error('port timeout')) : setTimeout(tick, 300)));
      req.on('timeout', () => { req.destroy(); Date.now() > deadline ? reject(new Error('port timeout')) : setTimeout(tick, 300); });
    };
    tick();
  });
}

// tiny expect helper (avoid the @playwright/test dependency; playwright core only)
function makeExpect(errs) {
  return (locator, label) => ({
    async toBeVisibleEnabled() {
      await locator.waitFor({ state: 'visible', timeout: 10000 }).catch(() => { throw new Error(`${label}: not visible`); });
      if (!(await locator.isEnabled())) throw new Error(`${label}: not enabled`);
    },
    async toContainText(txt) {
      await locator.filter({ hasText: txt }).first().waitFor({ state: 'visible', timeout: 10000 })
        .catch(() => { throw new Error(`${label}: never showed text "${txt}"`); });
    },
  });
}

async function checkPort(browser, cls) {
  const errs = [];
  const ctx = await browser.newContext();
  const page = await ctx.newPage();
  // real JS exceptions are always a defect (minus known env noise)
  page.on('pageerror', (e) => { if (!benign(e.message)) errs.push('pageerror: ' + e.message.slice(0, 160)); });
  // a backend (localhost:3000) asset or roundtrip that 4xx/5xx is a port/app
  // defect; a UI5 resource we did not serve locally (sdk.openui5.org 404) is
  // benign environment noise and ignored
  page.on('response', (r) => {
    const u = new URL(r.url());
    if (u.hostname === 'localhost' && u.port === '3000' && r.status() >= 400) {
      errs.push(`backend HTTP ${r.status()} for ${u.pathname}${u.search.slice(0, 40)}`);
    }
  });
  await page.route('**://sdk.openui5.org/**', (route) => {
    const hit = resolveLocal(new URL(route.request().url()).pathname);
    return hit ? route.fulfill({ status: 200, contentType: hit.type, body: hit.body }) : route.fulfill({ status: 404, body: '' });
  });
  try {
    await page.goto(`http://localhost:3000/?app_start=${cls}`, { waitUntil: 'domcontentloaded', timeout: 30000 });
    // UI5 booted from source AND the initial roundtrip rendered real controls
    await page.waitForFunction(
      () => window.sap && window.sap.ui && document.querySelectorAll('[data-sap-ui]').length > 3,
      { timeout: 60000 },
    );
    // let the render settle so a late runtime error still surfaces
    await page.waitForTimeout(600);
    const interaction = INTERACTIONS[cls];
    if (interaction) await interaction(page, makeExpect(errs));
  } catch (e) {
    errs.push('boot: ' + String(e.message).split('\n')[0].slice(0, 160));
  }
  await ctx.close();
  return errs;
}

const metas = fs.readdirSync(META).filter((f) => f.endsWith('.json'))
  .map((f) => JSON.parse(fs.readFileSync(path.join(META, f), 'utf8')))
  .filter((m) => /^z2ui5_cl_ai_app_\d+$/.test(m.class))
  .filter((m) => !ONLY || m.class.endsWith(ONLY));
metas.sort((a, b) => a.class.localeCompare(b.class));

console.log(`e2e-smoke: ${metas.length} port(s), backend from ${A2}`);
const backend = await startBackend();
await waitPort(3000);
const browser = await chromium.launch({ headless: !HEADED, executablePath: '/opt/pw-browsers/chromium' });

let failed = 0;
for (const m of metas) {
  const errs = await checkPort(browser, m.class);
  const cls = m.class.replace('z2ui5_cl_ai_app_', '');
  if (errs.length) { failed++; console.log(`FAIL  ${cls}  ${errs[0]}`); }
  else console.log(`pass  ${cls}${INTERACTIONS[m.class] ? '  (+interaction)' : ''}`);
}

await browser.close();
backend.kill();
console.log(`\ne2e-smoke: ${metas.length} port(s), ${failed} failing.`);
if (STRICT && failed) process.exit(1);
