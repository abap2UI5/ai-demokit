#!/usr/bin/env node
/*
 * device-model live probe (STATUS.md open findings, PROBE family
 * `window-resize-event`, 2026-08-05)
 *
 * abap2UI5 binds a shared `device>` model on every view slot
 * (`app/webapp/model/models.js`: `new JSONModel(Device)`, OneWay), and eleven
 * ports use it to express the original controller's device branches
 * declaratively — `visible="{= !${device>/system/phone}}"` (112/267/269),
 * `expanded="{device>/isNoPhone}"`, `showHeader="{device>/system/phone}"`.
 *
 * Several sidecars claim the model is a per-round-trip SNAPSHOT — "a class
 * swap on a live breakpoint change, for which no wire exists (the device>
 * model is read per round-trip, not per resize)" — and app 012's
 * ResizeHandler-driven recalculation is dropped on that claim. But
 * `sap.ui.Device` MUTATES ITSELF on resize (Device.resize.width/height,
 * Device.orientation.landscape), so the question is not whether the data is
 * fresh, it is whether the JSONModel wrapped around it ever tells its
 * bindings. Nobody measured that.
 *
 * This probe measures it: it boots the REAL OpenUI5, builds exactly the model
 * `models.js` builds, binds Texts to the paths the corpus binds, then resizes
 * the VIEWPORT from Node and reads the rendered text back. It runs the same
 * scenario twice — once as shipped, once with `refresh(true)` wired to
 * `Device.resize.attachHandler` — so the delta is the proposed change,
 * measured rather than argued. It also reports which paths the Device object
 * even offers (a media RANGE NAME is the one the class-swap ports want).
 *
 * Run:  node scripts/probes/device-model-live-probe.mjs [--json]
 * Exit: 0 (a probe reports, it does not gate)
 */
import fs from 'fs';
import path from 'path';
import http from 'http';
import { createRequire } from 'module';

const require = createRequire(import.meta.url);
const MIME = { '.js': 'text/javascript', '.json': 'application/json', '.css': 'text/css', '.html': 'text/html', '.properties': 'text/plain' };

function libRoots() {
  const roots = [];
  try {
    const base = path.dirname(path.dirname(require.resolve('@openui5/sap.ui.core/package.json')));
    for (const p of fs.readdirSync(base)) {
      const src = path.join(base, p, 'src');
      if (fs.existsSync(src)) roots.push(src);
    }
  } catch { /* not installed */ }
  return roots;
}

/* The paths the corpus actually binds, plus the two the ports WANT but cannot
 * reach today. `text` is the binding as a port would write it. */
const PATHS = [
  { key: 'resize-width', text: '{device>/resize/width}', what: 'the live viewport width — what app 012 recomputes pagesCount from' },
  { key: 'orientation', text: '{= ${device>/orientation/landscape} ? \'landscape\' : \'portrait\' }', what: "app 112's MessageStrip expression (its landscape branch is the one the e2e could never verify)" },
  { key: 'system-phone', text: '{= ${device>/system/phone} ? \'phone\' : \'not-phone\' }', what: 'the branch 11 ports bind — Device.system is UA/screen based, NOT viewport based' },
  { key: 'media-range', text: '{device>/media/range}', what: 'the S/M/L/XL range name the class-swap ports want — no such path exists on Device' },
];

const HARNESS = `<!DOCTYPE html><html><head><meta charset="utf-8">
<script id="sap-ui-bootstrap" src="/resources/sap-ui-core.js"
  data-sap-ui-theme="sap_horizon" data-sap-ui-async="true"
  data-sap-ui-libs="sap.m,sap.ui.core"
  data-sap-ui-compatVersion="edge" data-sap-ui-preload=""></script>
<script>
window.uiReady = new Promise(function (resolve) {
  function boot() { sap.ui.getCore ? sap.ui.getCore().attachInit(resolve) : resolve(); }
  if (window.sap && sap.ui) boot(); else window.addEventListener('load', boot);
});

// setup(opts) builds the model models.js builds and places one Text per path.
// opts.live wires the proposed change: refresh the model when Device changes.
window.setup = async function (opts) {
  await window.uiReady;
  var mods = await new Promise(function (res, rej) {
    sap.ui.require(['sap/ui/core/mvc/XMLView', 'sap/ui/model/json/JSONModel', 'sap/ui/Device'],
      function () { res(arguments); }, rej);
  });
  var XMLView = mods[0], JSONModel = mods[1], Device = mods[2];
  if (window.__view) { window.__view.destroy(); window.__view = null; }
  if (window.__detach) { window.__detach(); window.__detach = null; }

  // verbatim models.js
  var oModel = new JSONModel(Device);
  oModel.setDefaultBindingMode('OneWay');

  if (opts.live) {
    var onChange = function () { oModel.refresh(true); };
    Device.resize.attachHandler(onChange);
    Device.orientation.attachHandler(onChange);
    window.__detach = function () {
      Device.resize.detachHandler(onChange);
      Device.orientation.detachHandler(onChange);
    };
  }

  var inner = opts.paths.map(function (p, i) {
    return '<Text id="t' + i + '" text="' + p.text.replace(/"/g, '&quot;') + '"/>';
  }).join('');
  var view = await XMLView.create({
    definition: '<mvc:View xmlns="sap.m" xmlns:mvc="sap.ui.core.mvc">' + inner + '</mvc:View>',
  });
  view.setModel(oModel, 'device');
  view.placeAt('content');
  window.__view = view;
  window.__n = opts.paths.length;
  await new Promise(function (r) { setTimeout(r, 150); });
  return true;
};

// read() returns what each Text RENDERS right now — the binding's own answer,
// not a re-read of Device.
window.read = function () {
  var out = [];
  for (var i = 0; i < window.__n; i++) {
    var t = window.__view.byId('t' + i);
    out.push(t ? String(t.getText()) : null);
  }
  return out;
};

// what the Device object offers at all — the request needs to name the paths
window.describe = function () {
  var Device = sap.ui.require('sap/ui/Device');
  var ranges = null;
  try {
    Device.media.initRangeSet();                       // the Std range set
    ranges = Device.media.getCurrentRange('Std');
  } catch (e) { ranges = 'ERROR: ' + e.message; }
  return {
    topLevelKeys: Object.keys(Device),
    resize: { width: Device.resize.width, height: Device.resize.height },
    orientation: { landscape: Device.orientation.landscape, portrait: Device.orientation.portrait },
    system: { phone: Device.system.phone, tablet: Device.system.tablet, desktop: Device.system.desktop },
    mediaKeys: Object.keys(Device.media),
    currentStdRange: ranges,
  };
};
</script></head><body><div id="content"></div></body></html>`;

function startServer(roots) {
  const server = http.createServer((req, res) => {
    const u = new URL(req.url, 'http://x');
    if (u.pathname === '/harness.html') {
      res.writeHead(200, { 'content-type': 'text/html' });
      res.end(HARNESS);
      return;
    }
    if (u.pathname.startsWith('/resources/')) {
      const rel = u.pathname.slice('/resources/'.length);
      for (const root of roots) {
        const full = path.join(root, rel);
        if (full.startsWith(root) && fs.existsSync(full) && fs.statSync(full).isFile()) {
          res.writeHead(200, { 'content-type': MIME[path.extname(full)] || 'application/octet-stream' });
          res.end(fs.readFileSync(full));
          return;
        }
      }
    }
    res.writeHead(404);
    res.end();
  });
  return new Promise((resolve) => server.listen(0, '127.0.0.1', () => resolve(server)));
}

async function launchBrowser() {
  const { chromium } = await import('playwright');
  try {
    return await chromium.launch();
  } catch (e) {
    for (const exe of [process.env.CHROMIUM_BIN, '/opt/pw-browsers/chromium', '/usr/bin/chromium']) {
      if (exe && fs.existsSync(exe)) return chromium.launch({ executablePath: exe });
    }
    throw e;
  }
}

const WIDE = { width: 1400, height: 900 };
const NARROW = { width: 420, height: 900 };

const roots = libRoots();
if (!roots.length) {
  console.error('no @openui5/* packages found — run npm ci first (they come with the linter)');
  process.exit(2);
}
const server = await startServer(roots);
const browser = await launchBrowser();
const page = await browser.newPage({ viewport: WIDE });
await page.goto(`http://127.0.0.1:${server.address().port}/harness.html`);

async function run(live) {
  await page.setViewportSize(WIDE);
  await page.evaluate((opts) => window.setup(opts), { live, paths: PATHS });
  const before = await page.evaluate(() => window.read());
  await page.setViewportSize(NARROW);
  await page.waitForTimeout(600);              // Device.resize is debounced
  const after = await page.evaluate(() => window.read());
  return { before, after };
}

const shipped = await run(false);
const proposed = await run(true);
const device = await page.evaluate(() => window.describe());
await browser.close();
server.close();

const results = PATHS.map((p, i) => ({
  ...p,
  shipped: { before: shipped.before[i], after: shipped.after[i] },
  proposed: { before: proposed.before[i], after: proposed.after[i] },
  updatesToday: shipped.before[i] !== shipped.after[i],
  updatesWithRefresh: proposed.before[i] !== proposed.after[i],
}));

if (process.argv.includes('--json')) {
  console.log(JSON.stringify({ results, device }, null, 1));
} else {
  console.log(`device-model live probe — real OpenUI5, viewport ${WIDE.width}px -> ${NARROW.width}px\n`);
  for (const r of results) {
    const verdict = r.updatesToday ? 'LIVE TODAY'
      : r.updatesWithRefresh ? 'NEEDS REFRESH'
        : 'NOT BINDABLE';
    console.log(`${verdict.padEnd(14)} ${r.key}   ${r.text}`);
    console.log(`               ${r.what}`);
    console.log(`               as shipped:  ${JSON.stringify(r.shipped.before)} -> ${JSON.stringify(r.shipped.after)}`);
    console.log(`               with refresh: ${JSON.stringify(r.proposed.before)} -> ${JSON.stringify(r.proposed.after)}`);
    console.log('');
  }
  console.log('sap.ui.Device as the model sees it:');
  console.log(`  resize        ${JSON.stringify(device.resize)}`);
  console.log(`  orientation   ${JSON.stringify(device.orientation)}`);
  console.log(`  system        ${JSON.stringify(device.system)}`);
  console.log(`  media keys    ${device.mediaKeys.join(', ')}`);
  console.log(`  Std range     ${JSON.stringify(device.currentStdRange)}`);
}
