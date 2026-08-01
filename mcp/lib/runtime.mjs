/*
 * runtime — the deploy/run half of the MCP loop, no SAP system needed.
 *
 * Wraps the repo's existing Node pipeline (the same one e2e-build/e2e-smoke
 * use): an app class is written into src/zz_dev/ (gitignored dev sandbox),
 * the transpiled backend is rebuilt (scripts/e2e-build.mjs), the framework's
 * express shim serves it on localhost, and Playwright boots the app via
 * ?app_start=<class> exactly like scripts/e2e-smoke.mjs does — collecting
 * real page errors and returning a screenshot.
 *
 * Nothing here re-invents the pipeline: build = e2e-build, serve = the
 * abap2UI5 express shim, boot/error rules = the e2e-smoke gate (UI5 booted,
 * >3 rendered controls, no non-benign page error, no backend HTTP >= 400).
 */
import fs from 'fs';
import http from 'http';
import path from 'path';
import { spawn, execSync } from 'child_process';
import { resolveA2UI5, REPO_ROOT } from '../../scripts/lib-a2ui5.mjs';

const DEV_DIR = path.join(REPO_ROOT, 'src', 'zz_dev');
const SHOT_DIR = path.join(REPO_ROOT, 'mcp', 'screenshots');
export const PORT = Number(process.env.A2UI5_MCP_PORT || 3000);

// ---------------------------------------------------------------- deploy ----

// class name rules: the repo's abaplint enforces the Z2UI5_ namespace, ABAP
// caps names at 30 characters
const CLASS_RE = /^z2ui5_cl_[a-z0-9_]+$/;

export function deployApp({ className, source, description }) {
  const cls = String(className || '').toLowerCase();
  if (!CLASS_RE.test(cls) || cls.length > 30) {
    throw new Error(
      `invalid class name '${className}' — must match ${CLASS_RE} and be <= 30 chars (abaplint enforces the Z2UI5_CL_ prefix)`,
    );
  }
  if (!/z2ui5_if_app/i.test(source)) {
    throw new Error('source does not implement z2ui5_if_app — an abap2UI5 app is a class with `INTERFACES z2ui5_if_app.`');
  }
  if (!new RegExp(`class\\s+${cls}\\s+definition`, 'i').test(source)) {
    throw new Error(`source does not define CLASS ${cls} DEFINITION — class name and file must match`);
  }
  fs.mkdirSync(DEV_DIR, { recursive: true });
  const abapPath = path.join(DEV_DIR, `${cls}.clas.abap`);
  fs.writeFileSync(abapPath, source.endsWith('\n') ? source : source + '\n');
  const desc = String(description || 'MCP dev app').slice(0, 60).replace(/[<>&]/g, ' ');
  const xml = [
    `<?xml version="1.0" encoding="utf-8"?>`,
    `<abapGit version="v1.0.0" serializer="LCL_OBJECT_CLAS" serializer_version="v1.0.0">`,
    ` <asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">`,
    `  <asx:values>`,
    `   <VSEOCLASS>`,
    `    <CLSNAME>${cls.toUpperCase()}</CLSNAME>`,
    `    <LANGU>E</LANGU>`,
    `    <DESCRIPT>${desc}</DESCRIPT>`,
    `    <STATE>1</STATE>`,
    `    <CLSCCINCL>X</CLSCCINCL>`,
    `    <FIXPT>X</FIXPT>`,
    `    <UNICODE>X</UNICODE>`,
    `   </VSEOCLASS>`,
    `  </asx:values>`,
    ` </asx:abap>`,
    `</abapGit>`,
    ``,
  ].join('\n');
  fs.writeFileSync(path.join(DEV_DIR, `${cls}.clas.xml`), xml);
  return { abapPath, class: cls };
}

export function removeApp(className) {
  const cls = String(className || '').toLowerCase();
  let removed = 0;
  for (const suffix of ['.clas.abap', '.clas.xml']) {
    const p = path.join(DEV_DIR, cls + suffix);
    if (fs.existsSync(p)) {
      fs.unlinkSync(p);
      removed++;
    }
  }
  return removed;
}

export function listDevApps() {
  if (!fs.existsSync(DEV_DIR)) return [];
  return fs
    .readdirSync(DEV_DIR)
    .filter((f) => f.endsWith('.clas.abap'))
    .map((f) => f.replace('.clas.abap', ''));
}

// ------------------------------------------------------------------ lint ----

// strip // and /* */ comments outside strings so the repo's abaplint.jsonc
// can be parsed and patched (a naive regex would eat the // in dependency URLs)
function stripJsonc(text) {
  let out = '';
  let inStr = false;
  let inLine = false;
  let inBlock = false;
  for (let i = 0; i < text.length; i++) {
    const c = text[i];
    const n = text[i + 1];
    if (inLine) {
      if (c === '\n') {
        inLine = false;
        out += c;
      }
    } else if (inBlock) {
      if (c === '*' && n === '/') {
        inBlock = false;
        i++;
      }
    } else if (inStr) {
      out += c;
      if (c === '\\') {
        out += n;
        i++;
      } else if (c === '"') {
        inStr = false;
      }
    } else if (c === '"') {
      inStr = true;
      out += c;
    } else if (c === '/' && n === '/') {
      inLine = true;
    } else if (c === '/' && n === '*') {
      inBlock = true;
      i++;
    } else {
      out += c;
    }
  }
  return out.replace(/,\s*([}\]])/g, '$1');
}

// the repo config, relaxed for the dev sandbox: zz_dev is not excluded and
// object_naming accepts any Z2UI5_CL_/Z2UI5_IF_ name (the repo config demands
// the Z2UI5_CL_AI_ port prefix, which user apps must not be forced into)
function devLintConfig() {
  const cfg = JSON.parse(stripJsonc(fs.readFileSync(path.join(REPO_ROOT, 'abaplint.jsonc'), 'utf8')));
  if (cfg.global && Array.isArray(cfg.global.exclude)) {
    cfg.global.exclude = cfg.global.exclude.filter((e) => e !== 'zz_dev');
  }
  if (cfg.rules && cfg.rules.object_naming) {
    cfg.rules.object_naming.clas = '^Z2UI5_CL_';
    cfg.rules.object_naming.intf = '^Z2UI5_IF_';
  }
  // must sit in the repo root — the config's files glob resolves relative to
  // the config file's directory
  const p = path.join(REPO_ROOT, '.abaplint-mcp-dev.jsonc');
  fs.writeFileSync(p, JSON.stringify(cfg, null, 2));
  return p;
}

// abaplint with the relaxed dev config (dev sandbox included); returns only
// the findings for the given class file plus a total count
export function lintApp(className) {
  const cls = String(className || '').toLowerCase();
  return new Promise((resolve) => {
    const child = spawn('npx', ['abaplint', devLintConfig(), '--format', 'json'], { cwd: REPO_ROOT });
    let out = '';
    let err = '';
    child.stdout.on('data', (d) => (out += d));
    child.stderr.on('data', (d) => (err += d));
    child.on('close', () => {
      try {
        const start = out.indexOf('[');
        const issues = JSON.parse(out.slice(start));
        const mine = issues.filter((i) => (i.file || '').includes(`${cls}.clas`));
        resolve({
          ok: mine.length === 0,
          issues: mine.map((i) => ({
            rule: i.key,
            message: i.description,
            line: i.start && i.start.row,
          })),
          totalRepoIssues: issues.length,
        });
      } catch {
        resolve({ ok: false, issues: [{ rule: 'parse', message: (err || out).slice(-800) }], totalRepoIssues: -1 });
      }
    });
  });
}

// ----------------------------------------------------------------- build ----

let building = null;

/*
 * mode 'full'        — scripts/e2e-build.mjs: downport framework + all apps to
 *                      v702, then transpile. Slow (the 3 abaplint --fix passes
 *                      dominate), but handles any ABAP.
 * mode 'incremental' — copy only src/zz_dev/ into the EXISTING downport dir and
 *                      re-run just the transpile (~1-2 min). Skips the downport
 *                      fix passes, so the dev source must already be plain,
 *                      transpiler-friendly ABAP (which the framework style
 *                      guide prescribes anyway); a construct the transpiler
 *                      rejects fails the build with its message — fall back to
 *                      a full build or simplify the code.
 * mode 'auto'        — incremental when a prior full build exists, else full.
 */
export function buildBackend({ onLine, mode = 'auto' } = {}) {
  if (building) return building;
  const a2 = resolveA2UI5();
  const canIncrement = Boolean(a2 && fs.existsSync(path.join(a2, 'node/downport')) && backendBuilt());
  const incremental = mode === 'incremental' || (mode === 'auto' && canIncrement);
  if (incremental && !canIncrement) {
    return Promise.resolve({ ok: false, code: 1, tail: 'incremental build needs a prior full build (node/downport + node/output missing) — run mode:full first' });
  }
  building = new Promise((resolve) => {
    let child;
    if (incremental) {
      if (fs.existsSync(DEV_DIR)) {
        for (const f of fs.readdirSync(DEV_DIR)) {
          if (/\.(abap|xml)$/.test(f)) fs.copyFileSync(path.join(DEV_DIR, f), path.join(a2, 'node/downport', f));
        }
      }
      // the transpile depends on the locally patched open-abap-core clone that
      // e2e-build normally provides — restore it if it was cleaned away
      const lib = path.join(a2, 'node/open-abap-core');
      if (!fs.existsSync(path.join(lib, 'src'))) {
        fs.rmSync(lib, { recursive: true, force: true });
        execSync(`git clone --quiet --depth=1 https://github.com/open-abap/open-abap-core ${lib}`, { cwd: a2 });
        execSync(`node ${path.join(REPO_ROOT, 'web/ci/patch_open_abap_xml.mjs')} ${lib}`, { cwd: a2 });
      }
      // same transpile invocation e2e-build ends with: the framework's config,
      // retargeted at the locally patched open-abap-core clone
      const tcfg = JSON.parse(fs.readFileSync(path.join(a2, 'node/setup/abap_transpile.json'), 'utf8'));
      tcfg.libs = tcfg.libs.map((l) => (l.url && l.url.includes('open-abap-core') ? { folder: '/node/open-abap-core' } : l));
      const tcfgPath = path.join(a2, 'e2e-transpile.json');
      fs.writeFileSync(tcfgPath, JSON.stringify(tcfg, null, 2));
      child = spawn('npx', ['abap_transpile', './e2e-transpile.json'], { cwd: a2 });
      child.on('close', () => fs.rmSync(tcfgPath, { force: true }));
    } else {
      child = spawn('node', [path.join(REPO_ROOT, 'scripts', 'e2e-build.mjs')], { cwd: REPO_ROOT });
    }
    let tail = [];
    const keep = (d) => {
      const lines = String(d).split('\n').filter(Boolean);
      tail = tail.concat(lines).slice(-30);
      if (onLine) lines.forEach(onLine);
    };
    child.stdout.on('data', keep);
    child.stderr.on('data', keep);
    child.on('close', (code) => {
      building = null;
      resolve({ ok: code === 0, code, mode: incremental ? 'incremental' : 'full', tail: tail.join('\n') });
    });
  });
  return building;
}

export function backendBuilt() {
  const a2 = resolveA2UI5();
  return Boolean(a2 && fs.existsSync(path.join(a2, 'node/output/init.mjs')));
}

// ----------------------------------------------------------------- serve ----

let server = null;

export function backendStatus() {
  return {
    a2ui5: resolveA2UI5(),
    built: backendBuilt(),
    running: Boolean(server && server.exitCode === null),
    port: PORT,
  };
}

export async function startBackend() {
  if (server && server.exitCode === null) return backendStatus();
  const a2 = resolveA2UI5();
  if (!a2) throw new Error('abap2UI5 checkout not found — run `npm run node:setup` or set A2UI5_HOME');
  if (!backendBuilt()) throw new Error('backend not built — call the build tool (or `npm run node:build`) first');
  await new Promise((resolve, reject) => {
    const srv = spawn('node', [path.join(a2, 'node/srv/express.mjs')], {
      env: { ...process.env, PORT: String(PORT) },
    });
    let out = '';
    const onData = (d) => {
      out += d;
      if (/Listening on/.test(out)) {
        srv.stdout.off('data', onData);
        server = srv;
        resolve();
      }
    };
    srv.stdout.on('data', onData);
    srv.stderr.on('data', (d) => (out += d));
    srv.on('exit', (c) => {
      if (server !== srv) reject(new Error(`backend exited (${c}) before listening:\n${out.slice(-500)}`));
      server = null;
    });
    setTimeout(() => {
      if (server !== srv) {
        srv.kill();
        reject(new Error(`backend did not start in 30s:\n${out.slice(-500)}`));
      }
    }, 30000).unref();
  });
  await waitPort(PORT);
  return backendStatus();
}

export async function stopBackend() {
  await closeBrowser();
  if (server && server.exitCode === null) {
    server.kill();
    server = null;
  }
  return backendStatus();
}

function waitPort(port, ms = 30000) {
  const deadline = Date.now() + ms;
  return new Promise((resolve, reject) => {
    const tick = () => {
      const req = http.get({ port, path: '/', timeout: 1000 }, (r) => {
        r.destroy();
        resolve();
      });
      req.on('error', () => (Date.now() > deadline ? reject(new Error('port timeout')) : setTimeout(tick, 300)));
    };
    tick();
  });
}

// ------------------------------------------------------------------- run ----

// same benign-noise rules as scripts/e2e-smoke.mjs — a real JS exception is a
// defect, unbundled-UI5 resource noise is not
const BENIGN = [
  /library-preload/i,
  /messagebundle/i,
  /i18n/i,
  /themes?\/|library(\.css|-parameters)/i,
  /theming\.Parameters|\.properties/i,
  /failed to load (javascript )?resource/i,
  /Core\.applyTheme|sap\.ui\.getCore/i,
  /favicon/i,
  /deprecat/i,
  /sap-ui-cachebuster/i,
  /ERR_TUNNEL_CONNECTION_FAILED/i,
];
const benign = (s) => BENIGN.some((re) => re.test(s));

// serve UI5 from the local @openui5 packages (sandboxes have no CDN) — the
// same routing e2e-smoke uses
const MIME = {
  '.js': 'text/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.xml': 'application/xml',
  '.properties': 'text/plain',
  '.html': 'text/html',
  '.png': 'image/png',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.ttf': 'font/ttf',
};

function libRoots() {
  const base = path.join(REPO_ROOT, 'node_modules', '@openui5');
  if (!fs.existsSync(base)) return [];
  return fs
    .readdirSync(base)
    .map((p) => path.join(base, p, 'src'))
    .filter((p) => fs.existsSync(p));
}

function resolveLocal(pathname) {
  const i = pathname.indexOf('/resources/');
  if (i < 0) return null;
  const rel = pathname.slice(i + '/resources/'.length).replace(/^sap-ui-cachebuster\//, '');
  for (const root of libRoots()) {
    const full = path.join(root, rel);
    if (full.startsWith(root) && fs.existsSync(full) && fs.statSync(full).isFile()) {
      return { body: fs.readFileSync(full), type: MIME[path.extname(full)] || 'application/octet-stream' };
    }
  }
  return null;
}

let browserPromise = null;

// sandboxes often ship a system chromium instead of the playwright-managed
// download — honor A2UI5_MCP_CHROMIUM, else try the managed browser, else fall
// back to a known system binary
async function launchChromium() {
  const { chromium } = await import('playwright');
  const explicit = process.env.A2UI5_MCP_CHROMIUM;
  if (explicit) return chromium.launch({ executablePath: explicit });
  try {
    return await chromium.launch();
  } catch (e) {
    for (const cand of ['/opt/pw-browsers/chromium', '/usr/bin/chromium', '/usr/bin/chromium-browser']) {
      if (fs.existsSync(cand)) return chromium.launch({ executablePath: cand });
    }
    throw e;
  }
}

async function getBrowser() {
  if (!browserPromise) {
    browserPromise = launchChromium();
  }
  return browserPromise;
}

export async function closeBrowser() {
  if (browserPromise) {
    const b = await browserPromise.catch(() => null);
    browserPromise = null;
    if (b) await b.close().catch(() => {});
  }
}

/*
 * Boot <class> as the real app and look at it.
 *   - errors: non-benign page errors + backend HTTP >= 400 responses
 *   - booted: UI5 up and > 3 controls rendered (the e2e-smoke gate)
 *   - screenshotPath/base64: full-page PNG
 */
export async function runApp({ className, timeoutMs = 60000, fullPage = true }) {
  const cls = String(className || '').toLowerCase();
  if (!/^z2ui5_cl_[a-z0-9_]+$/.test(cls)) throw new Error(`invalid class name '${className}'`);
  if (!backendBuilt()) throw new Error('backend not built — deploy with build:true (or run the build tool) first');
  await startBackend();

  const browser = await getBrowser();
  const ctx = await browser.newContext({ viewport: { width: 1280, height: 800 } });
  const page = await ctx.newPage();
  const errors = [];
  page.on('pageerror', (e) => {
    if (!benign(e.message)) errors.push('pageerror: ' + e.message.slice(0, 300));
  });
  page.on('response', (r) => {
    try {
      const u = new URL(r.url());
      if (u.hostname === 'localhost' && u.port === String(PORT) && r.status() >= 400) {
        errors.push(`backend HTTP ${r.status()} for ${u.pathname}${u.search.slice(0, 60)}`);
      }
    } catch {
      /* ignore unparsable urls */
    }
  });
  // UI5 modules resolve from the local @openui5 packages; what they lack
  // (notably the BUILT theme css — the packages ship only .less sources) may
  // come from the real CDN so screenshots are styled. A2UI5_MCP_OFFLINE=1
  // forces the hermetic 404 behaviour of e2e-smoke.
  await page.route('**://sdk.openui5.org/**', (route) => {
    const hit = resolveLocal(new URL(route.request().url()).pathname);
    if (hit) return route.fulfill({ status: 200, contentType: hit.type, body: hit.body });
    return process.env.A2UI5_MCP_OFFLINE ? route.fulfill({ status: 404, body: '' }) : route.continue();
  });

  let booted = false;
  try {
    await page.goto(`http://localhost:${PORT}/?app_start=${cls}`, {
      waitUntil: 'domcontentloaded',
      timeout: 30000,
    });
    await page.waitForFunction(
      () => window.sap && window.sap.ui && document.querySelectorAll('[data-sap-ui]').length > 3,
      { timeout: timeoutMs },
    );
    booted = true;
    await page.waitForTimeout(600); // let the render settle so late errors surface
  } catch (e) {
    errors.push('boot: ' + String(e.message).split('\n')[0].slice(0, 300));
  }

  fs.mkdirSync(SHOT_DIR, { recursive: true });
  const screenshotPath = path.join(SHOT_DIR, `${cls}.png`);
  let base64 = null;
  try {
    const buf = await page.screenshot({ path: screenshotPath, fullPage });
    base64 = buf.toString('base64');
  } catch (e) {
    errors.push('screenshot: ' + String(e.message).slice(0, 200));
  }
  await ctx.close();
  return { class: cls, booted, ok: booted && errors.length === 0, errors, screenshotPath, base64 };
}
