#!/usr/bin/env node
/*
 * control-valued event-arg probe (2026-08-08)
 *
 * A UI5 event parameter is not always a scalar. Several events hand over a
 * CONTROL, or a whole ARRAY of controls:
 *   ViewSettingsDialog.confirm      -> filterItems (array), sortItem, groupItem
 *   SinglePlanningCalendar.selected -> an array of DateRange controls (app 109)
 *   Menu.itemSelected               -> item (app 060)
 *
 * The `event-arg-expression-probe` measured that the expression grammar can
 * reach INTO such a value (indexed access, chained calls) - but it has no loop
 * and no lambda, so a whole array cannot be projected by the app. Two claims
 * were therefore carried in CAPABILITIES without a measurement:
 *   (a) the raw value cannot travel at all, because JSON.stringify walks a
 *       ManagedObject into its circular parent/aggregation graph and throws -
 *       which would kill the whole roundtrip body, not just that one argument
 *   (b) projecting each control to its metadata PROPERTIES yields the values a
 *       backend actually needs (key/text/selected), so the app never has to
 *       parse the localized display string (ViewSettingsDialog.filterString)
 *
 * abap2UI5 implements (b) as Lib.normalizeEventArgs. This probe measures both
 * against REAL OpenUI5: it wires the handler exactly as the framework emits it
 * (a `$`-prefixed t_arg raw inside .eB('EVT', ...)), fires the event with real
 * controls as parameters, and reports what arrived, whether the raw value
 * survives JSON.stringify, and what the projection produces.
 *
 * Run:  node scripts/probes/control-valued-event-arg-probe.mjs [--json]
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

const VSD = (handler) => `
  <mvc:dependents>
    <ViewSettingsDialog id="c" ${handler}>
      <sortItems>
        <ViewSettingsItem key="TITLE" text="Title"/>
        <ViewSettingsItem key="INFO" text="Info"/>
      </sortItems>
      <filterItems>
        <ViewSettingsFilterItem key="INFO" text="Info" multiSelect="true">
          <items>
            <ViewSettingsItem key="INFO:completed" text="Completed"/>
            <ViewSettingsItem key="INFO:working" text="Working"/>
          </items>
        </ViewSettingsFilterItem>
      </filterItems>
    </ViewSettingsDialog>
  </mvc:dependents>
  <Button text="anchor"/>`;

const CANDIDATES = [
  {
    key: 'filterItems-array',
    what: 'ViewSettingsDialog.confirm -> filterItems: an ARRAY of the selected ViewSettingsItem controls',
    consumer: 'samples 099 (was parsing the localized filterString with SPLIT/CONDENSE)',
    xml: VSD(`confirm=".eB('EVT', \${$parameters>/filterItems})"`),
    fire: `(function () {
      var items = c.getFilterItems()[0].getItems();
      items[0].setSelected(true);
      items[1].setSelected(true);
      c.fireConfirm({ filterItems: [items[0], items[1]], filterString: 'Filter: Info (Completed, Working)' });
    })()`,
    expect: 'two controls, each projecting to key/text/selected',
  },
  {
    key: 'sortItem-single',
    what: 'ViewSettingsDialog.confirm -> sortItem: a SINGLE ViewSettingsItem control',
    consumer: 'samples 099 (was reaching into UI5 internals: .../mProperties/key)',
    xml: VSD(`confirm=".eB('EVT', \${$parameters>/sortItem})"`),
    fire: `(function () {
      var item = c.getSortItems()[1];
      c.fireConfirm({ sortItem: item, sortDescending: true });
    })()`,
    expect: 'one control projecting to key=INFO',
  },
  {
    key: 'dateRange-array',
    what: 'Calendar.select -> getSelectedDates(): an ARRAY of sap.ui.unified.DateRange controls whose startDate is a DATE OBJECT, not a string',
    consumer: 'apps 307 (31 index-guarded expression args, capped) and 109 (toast reduced to the event name)',
    xml: `<u:Calendar id="c" intervalSelection="false" singleSelection="false" select=".eB('EVT', $event.oSource.getSelectedDates())"/>`,
    fire: `(function () {
      var DateRange = sap.ui.require('sap/ui/unified/DateRange');
      // LOCAL midnight of two days - what the Calendar itself puts in the
      // aggregation when the user clicks a day
      c.addSelectedDate(new DateRange({ startDate: new Date(2018, 6, 9) }));
      c.addSelectedDate(new DateRange({ startDate: new Date(2018, 6, 10) }));
      c.fireSelect();
    })()`,
    expect: 'two entries - and the point of the candidate: whether startDate survives as the LOCAL day 2018-07-09, or is serialized through UTC and lands a day early east of Greenwich',
  },
  {
    key: 'filterString-display',
    what: 'the OLD route for comparison: filterString, a localized display string',
    consumer: 'what samples 099 used to parse - shown here to document why it is not a contract',
    xml: VSD(`confirm=".eB('EVT', \${$parameters>/filterString})"`),
    fire: `(function () {
      var items = c.getFilterItems()[0].getItems();
      items[0].setSelected(true);
      c.fireConfirm({ filterItems: [items[0]], filterString: 'Filter: Info (Completed)' });
    })()`,
    expect: 'a human-readable string whose format depends on the logon language',
  },
];

const VIEW = (inner) => `<mvc:View xmlns="sap.m" xmlns:mvc="sap.ui.core.mvc" xmlns:u="sap.ui.unified">${inner}</mvc:View>`;

// The browser timezone the page runs in. It matters for one candidate only,
// and decisively: a Date property is serialized by JSON.stringify through
// toISOString(), which is UTC, so a LOCAL-midnight day lands on the previous
// date everywhere east of Greenwich. Default to a positive offset so the
// shift is visible - a probe run in UTC would report a false all-clear.
const TZ = (process.argv.find((a) => a.startsWith('--tz=')) || '--tz=Europe/Berlin').slice(5);

const HARNESS = `<!DOCTYPE html><html><head><meta charset="utf-8">
<script id="sap-ui-bootstrap" src="/resources/sap-ui-core.js"
  data-sap-ui-theme="sap_horizon" data-sap-ui-async="true"
  data-sap-ui-libs="sap.m,sap.ui.core,sap.ui.unified"
  data-sap-ui-compatVersion="edge" data-sap-ui-preload=""></script>
<script>
window.uiReady = new Promise(function (resolve) {
  function boot() { sap.ui.getCore ? sap.ui.getCore().attachInit(resolve) : resolve(); }
  if (window.sap && sap.ui) boot(); else window.addEventListener('load', boot);
});

// --- mirror of abap2UI5 app/webapp/core/Lib.js normalizeEventArgs ----------
// Kept in sync by hand on purpose: this probe measures the CONCEPT against
// real UI5 (does a control carry the properties a backend needs?), it is not
// a unit test of the shipped function - that lives in the framework repo
// (node/tests/eventArgs.spec.js).
function isManagedObject(v) {
  return v !== null && typeof v === 'object' && typeof v.isA === 'function'
    && v.isA('sap.ui.base.ManagedObject');
}
function projectControl(c) {
  var out = { ID: c.getId() };
  var props = c.getMetadata().getAllProperties();
  for (var n in props) {
    try { var v = c.getProperty(n); if (v !== undefined) out[n] = v; } catch (e) { /* skip */ }
  }
  return out;
}
function normalize(v, depth) {
  var d = depth || 0;
  if (d > 4) { return v; }
  if (isManagedObject(v)) { return projectControl(v); }
  if (Array.isArray(v)) { return v.map(function (e) { return normalize(e, d + 1); }); }
  return v;
}
function describe(v) {
  if (v === null || v === undefined) { return { kind: String(v) }; }
  if (Array.isArray(v)) {
    return { kind: 'array', length: v.length, entries: v.map(describe) };
  }
  if (isManagedObject(v)) {
    return { kind: 'control', className: v.getMetadata().getName(), id: v.getId() };
  }
  return { kind: typeof v, value: v };
}
function stringifyOutcome(v) {
  try { return { ok: true, length: JSON.stringify(v).length }; }
  catch (e) { return { ok: false, error: e && e.message ? e.message : String(e) }; }
}

window.probe = async function (input) {
  await window.uiReady;
  var out = { called: false, raw: null, rawStringify: null, projected: null, projectedStringify: null, error: null };
  try {
    var mods = await new Promise(function (res, rej) {
      sap.ui.require(['sap/ui/core/mvc/XMLView', 'sap/ui/core/mvc/Controller'],
        function () { res(arguments); }, rej);
    });
    var XMLView = mods[0], Controller = mods[1];
    var Ctl = Controller.extend('probe.Ctl', {
      eB: function () {
        out.called = true;
        // the framework passes the event name first, then the resolved args
        var args = Array.prototype.slice.call(arguments, 1);
        out.raw = args.map(describe);
        out.rawStringify = stringifyOutcome(args);
        var projected = args.map(function (a) { return normalize(a, 0); });
        out.projected = projected;
        out.projectedStringify = stringifyOutcome(projected);
      },
      eF: function () {},
    });
    var view = await XMLView.create({ definition: input.xml, controller: new Ctl() });
    view.placeAt('content');
    await new Promise(function (r) { setTimeout(r, 100); });
    var c = view.byId('c');
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
  console.error('no @openui5/* packages found - run npm ci first');
  process.exit(2);
}
const server = await startServer(roots);
const browser = await launchBrowser();
const context = await browser.newContext({ timezoneId: TZ });
const page = await context.newPage();
const consoleErrors = [];
page.on('console', (m) => { if (m.type() === 'error') consoleErrors.push(m.text()); });
await page.goto(`http://127.0.0.1:${server.address().port}/harness.html`);

const results = [];
for (const cand of CANDIDATES) {
  const before = consoleErrors.length;
  const out = await page.evaluate((input) => window.probe(input), { xml: VIEW(cand.xml), fire: cand.fire });
  results.push({ ...cand, ...out, consoleErrors: consoleErrors.slice(before) });
}
await browser.close();
server.close();

if (process.argv.includes('--json')) {
  console.log(JSON.stringify(results, null, 1));
} else {
  console.log(`control-valued event-arg probe - real OpenUI5, ${CANDIDATES.length} candidates, browser timezone ${TZ}\n`);
  for (const r of results) {
    const verdict = r.error ? 'ERROR' : !r.called ? 'NOT CALLED' : 'ARRIVED';
    console.log(`${verdict.padEnd(11)} ${r.key}`);
    console.log(`            ${r.what}`);
    console.log(`            consumer:  ${r.consumer}`);
    console.log(`            expected:  ${r.expect}`);
    console.log(`            arrived:   ${JSON.stringify(r.raw)}`);
    console.log(`            raw JSON:  ${r.rawStringify ? (r.rawStringify.ok ? `ok (${r.rawStringify.length} chars)` : `THROWS - ${r.rawStringify.error}`) : 'n/a'}`);
    console.log(`            projected: ${JSON.stringify(r.projected)}`);
    console.log(`            proj JSON: ${r.projectedStringify ? (r.projectedStringify.ok ? `ok (${r.projectedStringify.length} chars)` : `THROWS - ${r.projectedStringify.error}`) : 'n/a'}`);
    if (r.error) console.log(`            error:     ${r.error}`);
    for (const e of r.consoleErrors) console.log(`            console:   ${e.slice(0, 200)}`);
    console.log('');
  }
}
