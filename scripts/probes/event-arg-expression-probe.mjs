#!/usr/bin/env node
/*
 * event-arg expression probe (STATUS.md open findings, PROBE family
 * `event-value-unreachable`, 2026-08-05)
 *
 * Seven IMPROVISED deviations rest on one claim: the value the original
 * controller reads is NOT transportable, because it sits in an array or in a
 * control reference on the event —
 *   getSelectedDates()[0].getStartDate()   (apps 139/151/177/220)
 *   oEvent.getParameter("tokens")[0]       (app 109's selectedDatesChange)
 *   oldSizes/newSizes                      (app 186)
 *   oItem.getMetadata().getName() === "…"  (app 228)
 *
 * But an event arg is a FULL UI5 expression (CAPABILITIES, proven by the
 * pr/menu-item-selected-path investigation): abap2UI5 emits a `$`-prefixed
 * t_arg RAW into the handler string, and EventHandlerResolver hands the whole
 * string to BindingParser.parseExpression. The open question is what that
 * grammar actually supports — indexed access `[0]`, chained method calls,
 * a class-name ternary.
 *
 * This probe measures it instead of arguing about it: it boots the REAL
 * OpenUI5 (the @openui5/* packages the linter installs), creates a view whose
 * controls carry `.eB('EVT', <candidate expression>)` handlers exactly as the
 * framework emits them, fires the event, and reports what the handler
 * RECEIVED. A candidate that throws or arrives undefined is not transportable;
 * one that arrives with the expected value is a rework, not a framework gap.
 *
 * Run:  node scripts/probes/event-arg-expression-probe.mjs [--json]
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

/* The candidates. `xml` is the control under test with its event wire; the
 * handler shape is what get_t_arg emits for a `$`-prefixed t_arg: raw, inside
 * .eB('EVENT', …). `fire` runs in the page and triggers the event the way the
 * user would; `expect` describes what the port needs to receive. */
const CANDIDATES = [
  {
    key: 'concat',
    what: "string concatenation on an event parameter — ${$parameters>/value} + '%'",
    ports: '138/267/269 (already shipped on it)',
    xml: `<Slider id="c" value="50" liveChange=".eB('EVT', \${$parameters>/value} + '%')"/>`,
    fire: `c.fireLiveChange({ value: 60 })`,
    expect: "60%",
  },
  {
    key: 'array-index',
    what: 'indexed access into an array-valued getter — $event.oSource.getSelectedDates()[0].getStartDate()',
    ports: '139/151/177/220 — the four calendar ports showing the SERVER date',
    xml: `<u:Calendar id="c" xmlns:u="sap.ui.unified" select=".eB('EVT', $event.oSource.getSelectedDates()[0].getStartDate())"/>`,
    fire: `(function () {
      var DateRange = sap.ui.require('sap/ui/unified/DateRange');
      c.addSelectedDate(new DateRange({ startDate: new Date(2026, 2, 17) }));
      c.fireSelect();
    })()`,
    expect: 'the picked day (2026-03-17), not the server date',
  },
  {
    key: 'array-index-param',
    what: 'indexed access into an array-valued event PARAMETER — ${$parameters>/tokens}[0].getKey()',
    ports: "109's selectedDatesChange, 085's token delete",
    xml: `<Tokenizer id="c" tokenDelete=".eB('EVT', \${$parameters>/tokens}[0].getKey())"><Token key="k1" text="T1"/></Tokenizer>`,
    fire: `c.fireTokenDelete({ tokens: c.getTokens() })`,
    expect: 'k1',
  },
  {
    key: 'class-ternary',
    what: "branch on the control class — a ternary over getMetadata().getName()",
    ports: "228 (MenuTextFieldItem 'entered' vs MenuItem 'pressed')",
    xml: `<Button id="c" text="B" press=".eB('EVT', $event.oSource.getMetadata().getName() === 'sap.m.Button' ? $event.oSource.getText() + ' pressed' : 'other')"/>`,
    fire: `c.firePress()`,
    expect: 'B pressed',
  },
  {
    key: 'calendar-date-parts',
    what: 'the shape the calendar ports use: THREE args, each an expression, carrying the LOCAL date parts (a UTC toISOString() would shift the day east of Greenwich)',
    ports: '139/151/177/220',
    xml: `<u:Calendar id="c" xmlns:u="sap.ui.unified" select=".eB('EVT', $event.oSource.getSelectedDates()[0].getStartDate().getFullYear(), $event.oSource.getSelectedDates()[0].getStartDate().getMonth() + 1, $event.oSource.getSelectedDates()[0].getStartDate().getDate())"/>`,
    fire: `(function () {
      var DateRange = sap.ui.require('sap/ui/unified/DateRange');
      c.addSelectedDate(new DateRange({ startDate: new Date(2026, 2, 17) }));
      c.fireSelect();
    })()`,
    expect: '2026, 3, 17 — the month already +1',
  },
  {
    key: 'array-join',
    what: 'a whole array parameter joined into one string — ${$parameters>/newSizes}.join(",")',
    ports: "186 (ResponsiveSplitter resize oldSizes/newSizes)",
    xml: `<Button id="c" text="B" press=".eB('EVT', \${$parameters>/sizes}.join(','))"/>`,
    fire: `c.firePress({ sizes: [30, 70] })`,
    expect: '30,70',
  },
];

const VIEW = (inner) => `<mvc:View xmlns="sap.m" xmlns:mvc="sap.ui.core.mvc" xmlns:u="sap.ui.unified">${inner}</mvc:View>`;

const HARNESS = `<!DOCTYPE html><html><head><meta charset="utf-8">
<script id="sap-ui-bootstrap" src="/resources/sap-ui-core.js"
  data-sap-ui-theme="sap_horizon" data-sap-ui-async="true"
  data-sap-ui-libs="sap.m,sap.ui.unified,sap.ui.core"
  data-sap-ui-compatVersion="edge" data-sap-ui-preload=""></script>
<script>
window.uiReady = new Promise(function (resolve) {
  function boot() { sap.ui.getCore ? sap.ui.getCore().attachInit(resolve) : resolve(); }
  if (window.sap && sap.ui) boot(); else window.addEventListener('load', boot);
});
window.probe = async function (input) {
  await window.uiReady;
  var out = { received: null, error: null };
  try {
    var mods = await new Promise(function (res, rej) {
      sap.ui.require(['sap/ui/core/mvc/XMLView', 'sap/ui/core/mvc/Controller',
        'sap/ui/unified/DateRange'], function () { res(arguments); }, rej);
    });
    var XMLView = mods[0], Controller = mods[1];
    // the same entry point the framework's views call: .eB(event, args…)
    var Ctl = Controller.extend('probe.Ctl', {
      eB: function () { out.received = Array.prototype.slice.call(arguments); },
      eF: function () {},
    });
    var view = await XMLView.create({ definition: input.xml, controller: new Ctl() });
    view.placeAt('content');
    await new Promise(function (r) { setTimeout(r, 100); });
    var c = view.byId('c') || view.getContent()[0];
    try {
      eval(input.fire);            // the probe's own fixture code, not user input
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
for (const cand of CANDIDATES) {
  const before = consoleErrors.length;
  const out = await page.evaluate((input) => window.probe(input), { xml: VIEW(cand.xml), fire: cand.fire });
  results.push({
    ...cand,
    received: out.received,
    error: out.error,
    consoleErrors: consoleErrors.slice(before),
  });
}
await browser.close();
server.close();

if (process.argv.includes('--json')) {
  console.log(JSON.stringify(results, null, 1));
} else {
  console.log(`event-arg expression probe — real OpenUI5, ${CANDIDATES.length} candidates\n`);
  for (const r of results) {
    // the framework passes the event name first, then the resolved args
    const args = Array.isArray(r.received) ? r.received.slice(1) : null;
    const got = args === null ? 'HANDLER NOT CALLED' : JSON.stringify(args);
    const verdict = r.error ? 'ERROR' : args && args.length && args[0] !== undefined && args[0] !== null ? 'RESOLVES' : 'EMPTY';
    console.log(`${verdict.padEnd(9)} ${r.key}`);
    console.log(`          ${r.what}`);
    console.log(`          ports:    ${r.ports}`);
    console.log(`          expected: ${r.expect}`);
    console.log(`          got:      ${got}`);
    if (r.error) console.log(`          error:    ${r.error}`);
    for (const e of r.consoleErrors) console.log(`          console:  ${e.slice(0, 200)}`);
    console.log('');
  }
}
