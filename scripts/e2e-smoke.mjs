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
 * from unbundled source is filtered). Per-port interaction modules under
 * meta/interactions/<class>.mjs add a real click -> assert check as a richer
 * proof — extend them freely, but the boot+render+no-error gate already covers
 * every port. The overview app (not a numbered port) is checked last, with its
 * info-popover round-trip.
 *
 *   node scripts/e2e-smoke.mjs            advisory report
 *   node scripts/e2e-smoke.mjs --strict   exit 1 on any failing port
 *   node scripts/e2e-smoke.mjs --only 005      single port (debugging)
 *   node scripts/e2e-smoke.mjs --only 005,270  a comma-separated list
 *   node scripts/e2e-smoke.mjs --headed   show the browser (debugging)
 *   node scripts/e2e-smoke.mjs --dump-interactions
 *                       print every loaded interaction (key + source) and exit
 */
import fs from 'fs';
import path from 'path';
import http from 'http';
import { spawn } from 'child_process';
import { fileURLToPath, pathToFileURL } from 'url';
import { chromium } from 'playwright';
import { resolveA2UI5 } from './lib-a2ui5.mjs';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const META = path.join(ROOT, 'meta');
const STRICT = process.argv.includes('--strict');
const HEADED = process.argv.includes('--headed');
const ONLY = process.argv.includes('--only')
  ? (process.argv[process.argv.indexOf('--only') + 1] || '').split(',').map((s) => s.trim()).filter(Boolean)
  : null;
if (ONLY && !ONLY.length) {
  console.error('e2e-smoke: --only needs a comma-separated class list (e.g. --only z2ui5_cl_smpc_app_001)');
  process.exit(2);
}
// the overview app is checked alongside the numbered ports (its interaction
// module sits in meta/interactions/ like every other)
const OVERVIEW = 'z2ui5_cl_smpc_app_000';

// richer per-port checks (optional): ONE MODULE PER PORT under
// meta/interactions/<class>.mjs, each default-exporting
// `async (page, expect) => { … }` (shared assertions in scripts/lib-e2e.mjs).
// After boot the driver runs the port's module when one exists; the generic
// boot+render+no-error gate runs for EVERY port regardless.
//
// GROW THE DIRECTORY — it is the automated close path for the LIVE_TEST
// backlog; the per-class coverage catalogue lives in
// meta/interactions/README.md. Keying the map by FILENAME makes a duplicate
// key impossible by construction (the old in-file map carried two
// z2ui5_cl_smpc_app_133 entries — the last one silently won).
const INTERACTIONS_DIR = path.join(META, 'interactions');
const INTERACTIONS = {};
for (const f of fs.readdirSync(INTERACTIONS_DIR).sort()) {
  if (!f.endsWith('.mjs')) continue;
  const cls = path.basename(f, '.mjs');
  const mod = await import(pathToFileURL(path.join(INTERACTIONS_DIR, f)).href);
  if (typeof mod.default !== 'function') {
    console.error(`meta/interactions/${f}: default export is not a function`);
    process.exit(2);
  }
  INTERACTIONS[cls] = mod.default;
}
// --dump-interactions: print every loaded interaction (key + source) and
// exit — needs neither the backend nor a browser; the migration/refactor
// proof is diffing this dump before and after a change
if (process.argv.includes('--dump-interactions')) {
  for (const cls of Object.keys(INTERACTIONS).sort()) {
    console.log(`=== ${cls} ===`);
    console.log(INTERACTIONS[cls].toString());
    console.log('');
  }
  process.exit(0);
}

const A2 = resolveA2UI5();
if (!A2) { console.error('abap2UI5 checkout not found — run `npm run node:setup` or set A2UI5_HOME'); process.exit(1); }

// local OpenUI5 sources — ALL installed @openui5 packages, discovered from
// node_modules (a hand-kept list silently starves any library it forgets:
// sap.tnt ports "passed" the generic gate on their Application Error popup
// until 2026-07-30, when the 241 interaction exposed the hollow pass)
const LIB_ROOTS = fs.readdirSync(path.join(ROOT, 'node_modules', '@openui5'))
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

// benign-noise contract shared with the MCP server — see lib-smoke.mjs
import { benign } from './lib-smoke.mjs';

function startBackend() {
  return new Promise((resolve, reject) => {
    // --stack-size: the view builder's chain transpiles to ONE deeply nested
    // expression - `view->ele( )->a( )->a( )->end( )` becomes
    // `await (await (await (…).get().a(…)).get().a(…))`, one level per call -
    // and the generated overview app's view is 177 calls long. Node's default
    // parser stack, already partly spent by the ESM loader walking the 2,340
    // transpiled modules, overflows on it: `RangeError: Maximum call stack
    // size exceeded` inside compileSourceTextModule, before the server ever
    // listens (2026-08-22, at 623 ports). It is a V8 parser limit, not an ABAP
    // one - a real system never parses this - so the harness raises the stack
    // rather than the corpus shortening its chains. --stack-size is a V8
    // option and NODE_OPTIONS rejects it, so it has to be passed on argv.
    const srv = spawn('node', ['--stack-size=10000', path.join(A2, 'node/srv/express.mjs')], { env: { ...process.env, PORT: '3000' } });
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
    async toBeVisible() {
      await locator.first().waitFor({ state: 'visible', timeout: 10000 })
        .catch(() => { throw new Error(`${label}: not visible`); });
    },
    async toContainText(txt) {
      await locator.filter({ hasText: txt }).first().waitFor({ state: 'visible', timeout: 10000 })
        .catch(() => { throw new Error(`${label}: never showed text "${txt}"`); });
    },
    // count bound — for a bound `visible` flag that removes ONE of several
    // same-named entries (a plain absence check cannot see that)
    async toHaveCountBelow(n) {
      const deadline = Date.now() + 10000;
      for (;;) {
        if ((await locator.count()) < n) return;
        if (Date.now() > deadline) throw new Error(`${label}: count stayed >= ${n}`);
        await new Promise((r) => setTimeout(r, 250));
      }
    },
    // numeric bound — a MEASURED value (a duration, a count computed in the
    // page) that no locator matcher can express. app 147 needs it: only the
    // LENGTH of the busy overlay's visible episode separates the port's wire
    // from the framework's own per-round-trip show/hide.
    async toBeAtLeast(n) {
      const v = Number(locator);
      if (!(v >= n)) throw new Error(`${label}: ${v} is below ${n}`);
    },
    // negative form — a filter assertion needs it (the row that must be GONE).
    // Polls until the text is absent so an async re-filter is tolerated.
    async notToContainText(txt) {
      const deadline = Date.now() + 10000;
      for (;;) {
        if (!(await locator.filter({ hasText: txt }).count())) return;
        if (Date.now() > deadline) throw new Error(`${label}: still shows text "${txt}"`);
        await new Promise((r) => setTimeout(r, 250));
      }
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
      // carry the body along: a bare "backend HTTP 500" says nothing, and the
      // ABAP exception the backend answers with is the whole diagnosis
      // (2026-08-22 — three b50 ports 500'd and the message named no cause)
      r.text().then((b) => {
        // the ABAP side answers an HTML error page; what matters is the
        // exception name and the first transpiled frame under it
        const err = b.match(/Error:\s*([^\n<]{1,80})/);
        const frame = b.match(/at\s+([A-Za-z0-9_$.]+)\s*\((?:file:\/\/)?[^)]*?([A-Za-z0-9_.]+\.mjs:\d+)/);
        const why = err ? err[1].trim() + (frame ? ` @ ${frame[1]} (${frame[2]})` : '') : b.replace(/\s+/g, ' ').slice(0, 160);
        errs.push(`backend HTTP ${r.status()} for ${u.pathname}${u.search.slice(0, 40)} — ${why}`);
      }).catch(() => errs.push(`backend HTTP ${r.status()} for ${u.pathname}${u.search.slice(0, 40)}`));
      return;
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
    /* The framework catches a fatal error and RENDERS it, so nothing reaches
     * `pageerror` and the port passes while the user sees an overlay saying
     * the app terminated. This has bitten twice: the sap.tnt ports passed on
     * their Application Error popup until an interaction exposed it
     * (2026-07-30), and app 362 passed while dying on `"" is of type string,
     * expected sap.ui.core.SortOrder` (2026-08-17). Per-port interactions
     * caught both, one port at a time; this catches the class.
     *
     * Matched on the overlay's own heading rather than on a CSS class: the
     * heading is the framework's text and the dialog markup is UI5's, which
     * changes between releases. */
    const fatal = await page.evaluate(() => {
      const t = document.body.innerText || '';
      const m = t.match(/(Unexpected Error Occurred[^]{0,400})/);
      return m ? m[1].replace(/\s+/g, ' ').slice(0, 220) : null;
    });
    if (fatal) errs.push('fatal overlay: ' + fatal);
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
  .filter((m) => /^z2ui5_cl_smpc_app_\d+$/.test(m.class))
  .filter((m) => !ONLY || ONLY.some((o) => m.class.endsWith(o)));
metas.sort((a, b) => a.class.localeCompare(b.class));

console.log(`e2e-smoke: ${metas.length} port(s), backend from ${A2}`);
const backend = await startBackend();
await waitPort(3000);
/* prefer the sandbox's pinned Chromium when present, else the playwright-managed
 * one (CI). PW_CHROMIUM overrides the first: CI has no /opt/pw-browsers, so it
 * launches playwright's chrome-headless-shell while a sandbox run launches FULL
 * Chromium, and the two do not render this corpus identically. App 233's
 * unbounded-layout defect reached the browser only on the headless shell — a
 * full-corpus sandbox run passed it while bump-a2ui5 failed it twice — so
 * "green here, red in CI" is worth one re-run on CI's actual binary:
 *   PW_CHROMIUM=/opt/pw-browsers/chromium_headless_shell-*'/chrome-linux/headless_shell' \
 *     node scripts/e2e-smoke.mjs --only <class> --strict
 * (that shell also takes its locale from the environment and UI5 rejects the
 * sandbox default, so pass LANG=en_US.UTF-8 with it). */
const LOCAL_CHROMIUM = process.env.PW_CHROMIUM || '/opt/pw-browsers/chromium';
/* --disable-dev-shm-usage: Chromium's default /dev/shm is small in a container,
 * and the heaviest views in this corpus (app 233 boots in ~100 s, unthemed and
 * unbundled) are where the process dies. Measured 2026-08-25: 4 crashes in ~25
 * runs on that one port. */
const LAUNCH_ARGS = ['--disable-dev-shm-usage'];
const launchBrowser = () => (fs.existsSync(LOCAL_CHROMIUM)
  ? chromium.launch({ headless: !HEADED, executablePath: LOCAL_CHROMIUM, args: LAUNCH_ARGS })
  : chromium.launch({ headless: !HEADED, args: LAUNCH_ARGS }));
let browser = await launchBrowser();

/* A dead browser used to end the RUN, not the port. `checkPort` opens a
 * context on the first line, so when Chromium had gone the throw travelled out
 * of the loop uncaught and Node exited - one crash on port 233 could abort a
 * 623-port nightly mid-way, and the report showed neither the crash nor the
 * hundreds of ports that never ran. Now the port is failed with the reason and
 * the browser is relaunched for the next one. */
const BROWSER_GONE = /Target page, context or browser has been closed|Target closed|browser has been closed/i;
async function checkPortResilient(cls) {
  try {
    return await checkPort(browser, cls);
  } catch (e) {
    if (!BROWSER_GONE.test(String(e && e.message))) throw e;
    try { await browser.close(); } catch { /* already gone */ }
    browser = await launchBrowser();
    return [`the browser died on this view (relaunched for the next port): ${String(e.message).slice(0, 120)}`];
  }
}

let failed = 0;
for (const m of metas) {
  const errs = await checkPortResilient(m.class);
  const cls = m.class.replace('z2ui5_cl_smpc_app_', '');
  if (errs.length) { failed++; console.log(`FAIL  ${cls}  ${errs[0]}`); }
  else console.log(`pass  ${cls}${INTERACTIONS[m.class] ? '  (+interaction)' : ''}`);
}

// the overview app: same generic gate, plus the info-popover round-trip
let overviewChecked = 0;
if (!ONLY || ONLY.some((o) => OVERVIEW.endsWith(o))) {
  overviewChecked = 1;
  const errs = await checkPortResilient(OVERVIEW);
  if (errs.length) { failed++; console.log(`FAIL  overview  ${errs[0]}`); }
  else console.log('pass  overview  (+interaction)');
}

await browser.close();
backend.kill();
console.log(`\ne2e-smoke: ${metas.length + overviewChecked} app(s), ${failed} failing.`);
if (STRICT && failed) process.exit(1);
