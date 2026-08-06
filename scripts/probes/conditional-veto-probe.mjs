#!/usr/bin/env node
/*
 * conditional-veto probe (STATUS.md open findings, PROBE family `event-veto`,
 * 2026-08-05)
 *
 * abap2UI5 can veto a control's built-in default for an event:
 * `s_ctrl-check_prevent_default` makes the backend emit `.eBP($event, …)`
 * instead of `.eB(…)`, and `eBP` calls `oEvent.preventDefault()` and then
 * round-trips (`app/webapp/controller/View1.controller.js`). App 241 uses it
 * 1:1, and it closed app 136's toggle veto.
 *
 * But the flag is a BOOLEAN baked per WIRE at render time, so the veto is
 * all-or-nothing for every firing of that event. App 247
 * (`sap.ui.table.sample.ColumnResizing`) needs the other shape: the sample
 * blocks resizing ONE column and lets the others through the SAME event
 * (`columnResize`, `allowPreventDefault: true`, carrying the resized
 * `sap.ui.table.Column` as a parameter). There is one wire, so today the
 * veto is dropped and the deviation stands as IMPROVISED.
 *
 * The proposal is small: let the veto be an EXPRESSION instead of a flag —
 * `eBP(oEvent, bVeto, …args)` prevents only when `bVeto` is truthy, and the
 * backend emits the condition as a `$`-prefixed argument, which UI5 resolves
 * through BindingParser.parseExpression like every other event arg (proven by
 * event-arg-expression-probe.mjs). This probe measures whether that actually
 * vetoes per firing: two columns, ONE wire, one predicate — the blocked
 * column must be prevented and the free one must not.
 *
 * Run:  node scripts/probes/conditional-veto-probe.mjs [--json]
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

/* The predicate a port would write: the blocked column carries an explicit id,
 * so the condition is a plain expression over the event's control parameter.
 * `fire` returns what fireEvent returns for an allowPreventDefault event —
 * false means the control's default was cancelled. */
const CASES = [
  {
    key: 'blocked-column',
    what: 'the column the sample blocks — the predicate is true, so the resize must be vetoed',
    fire: `c.fireColumnResize({ column: view.byId('blockcol'), width: '100px' })`,
    expect: 'vetoed (fireColumnResize returns false), handler still round-trips',
  },
  {
    key: 'free-column',
    what: 'any other column through the SAME wire — the predicate is false, so the resize must go through',
    fire: `c.fireColumnResize({ column: view.byId('freecol'), width: '100px' })`,
    expect: 'not vetoed (returns true), handler still round-trips',
  },
];

/* One wire, one condition — exactly what the backend would emit for a
 * `check_prevent_default` that carries an expression instead of abap_true. */
const VIEW = `<mvc:View xmlns="sap.m" xmlns:mvc="sap.ui.core.mvc" xmlns:t="sap.ui.table">
  <t:Table id="c" columnResize=".eBP($event, \${$parameters>/column}.getId().indexOf('blockcol') >= 0, 'COLUMN_RESIZE', \${$parameters>/width})">
    <t:columns>
      <t:Column id="blockcol" width="8rem"><Label text="Delivery Date"/><t:template><Text text="a"/></t:template></t:Column>
      <t:Column id="freecol" width="8rem"><Label text="Product"/><t:template><Text text="b"/></t:template></t:Column>
    </t:columns>
  </t:Table>
</mvc:View>`;

const HARNESS = `<!DOCTYPE html><html><head><meta charset="utf-8">
<script id="sap-ui-bootstrap" src="/resources/sap-ui-core.js"
  data-sap-ui-theme="sap_horizon" data-sap-ui-async="true"
  data-sap-ui-libs="sap.m,sap.ui.table,sap.ui.core"
  data-sap-ui-compatVersion="edge" data-sap-ui-preload=""></script>
<script>
window.uiReady = new Promise(function (resolve) {
  function boot() { sap.ui.getCore ? sap.ui.getCore().attachInit(resolve) : resolve(); }
  if (window.sap && sap.ui) boot(); else window.addEventListener('load', boot);
});
window.probe = async function (input) {
  await window.uiReady;
  var out = { roundTripped: null, defaultAllowed: null, error: null };
  try {
    var mods = await new Promise(function (res, rej) {
      sap.ui.require(['sap/ui/core/mvc/XMLView', 'sap/ui/core/mvc/Controller'],
        function () { res(arguments); }, rej);
    });
    var XMLView = mods[0], Controller = mods[1];
    // eBP as PROPOSED: the veto is the second argument, not a baked constant.
    // Everything after it is the existing eB payload, unchanged.
    var Ctl = Controller.extend('probe.Ctl', {
      eBP: function (oEvent, bVeto) {
        if (bVeto && oEvent && typeof oEvent.preventDefault === 'function') {
          oEvent.preventDefault();
        }
        this.eB.apply(this, Array.prototype.slice.call(arguments, 2));
      },
      eB: function () { out.roundTripped = Array.prototype.slice.call(arguments); },
      eF: function () {},
    });
    var view = await XMLView.create({ definition: input.xml, controller: new Ctl() });
    view.placeAt('content');
    await new Promise(function (r) { setTimeout(r, 200); });
    var c = view.byId('c');
    try {
      out.defaultAllowed = eval(input.fire);   // the probe's own fixture code
    } catch (e) { out.error = 'FIRE: ' + (e && e.message ? e.message : String(e)); }
    await new Promise(function (r) { setTimeout(r, 50); });
    view.destroy();
  } catch (e) {
    out.error = 'CREATE: ' + (e && e.message ? e.message : String(e));
  }
  return out;
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

const roots = libRoots();
if (!roots.length) {
  console.error('no @openui5/* packages found — run npm ci first (they come with the linter)');
  process.exit(2);
}
const server = await startServer(roots);
const browser = await launchBrowser();
const page = await browser.newPage();
const consoleErrors = [];
page.on('console', (m) => { if (m.type() === 'error') consoleErrors.push(m.text()); });
await page.goto(`http://127.0.0.1:${server.address().port}/harness.html`);

const results = [];
for (const c of CASES) {
  const before = consoleErrors.length;
  const out = await page.evaluate((input) => window.probe(input), { xml: VIEW, fire: c.fire });
  results.push({ ...c, ...out, consoleErrors: consoleErrors.slice(before) });
}
await browser.close();
server.close();

if (process.argv.includes('--json')) {
  console.log(JSON.stringify(results, null, 1));
} else {
  console.log('conditional-veto probe — real OpenUI5, ONE columnResize wire, two columns\n');
  for (const r of results) {
    const vetoed = r.defaultAllowed === false;
    const verdict = r.error ? 'ERROR' : `${vetoed ? 'VETOED' : 'ALLOWED'}`;
    console.log(`${verdict.padEnd(9)} ${r.key}`);
    console.log(`          ${r.what}`);
    console.log(`          expected:     ${r.expect}`);
    console.log(`          default kept: ${r.defaultAllowed}`);
    console.log(`          round-trip:   ${JSON.stringify(r.roundTripped)}`);
    if (r.error) console.log(`          error:        ${r.error}`);
    for (const e of r.consoleErrors) console.log(`          console:      ${e.slice(0, 200)}`);
    console.log('');
  }
}
