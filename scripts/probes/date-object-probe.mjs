// Empirical probe: does CalendarAppointment.startDate (type "object") accept
// a string from a JSONModel, or does it need a real JS Date?
// Three scenarios against the real OpenUI5 runtime (headless Chromium):
//   A: model holds ISO strings, plain binding {start}
//   B: model holds real Date objects, plain binding {start}
//   C: model holds ISO strings, formatter binding -> new Date(s)
import fs from 'node:fs';
import http from 'node:http';
import path from 'node:path';

const ROOT = new URL("../..", import.meta.url).pathname;
const LIB_ROOTS = ['sap.ui.core', 'sap.m', 'sap.ui.layout', 'sap.ui.unified', 'themelib_sap_horizon']
  .map((p) => path.join(ROOT, 'node_modules', '@openui5', p, 'src'))
  .filter((p) => fs.existsSync(p));

const MIME = { '.js': 'text/javascript', '.css': 'text/css', '.json': 'application/json',
  '.xml': 'application/xml', '.properties': 'text/plain', '.html': 'text/html' };

const HARNESS = `<!DOCTYPE html>
<html><head><meta charset="utf-8"><title>date-probe</title>
<script>
  window.uiErrors = [];
  window.addEventListener('error', function (e) { window.uiErrors.push('PAGEERROR: ' + e.message); });
</script>
<script id="sap-ui-bootstrap" src="/resources/sap-ui-core.js"
  data-sap-ui-libs="sap.m,sap.ui.unified"
  data-sap-ui-theme="sap_hcb"
  data-sap-ui-async="true"
  data-sap-ui-compatversion="edge"></script>
<script>
  window.uiReady = new Promise(function (resolve) {
    function boot() {
      sap.ui.define('z2ui5/model/formatter', [], function () {
        return { DateCreateObject: function (s) { return new Date(s); } };
      });
      sap.ui.require(['sap/ui/core/Core', 'sap/base/Log'], function (Core, Log) {
        Log.addLogListener({ onLogEntry: function (e) {
          if (e.level <= Log.Level.ERROR) window.uiErrors.push('LOG: ' + e.message);
        } });
        Core.ready(resolve);
      });
    }
    if (window.sap && sap.ui) boot(); else window.addEventListener('load', boot);
  });

  window.probe = async function (scenario) {
    await window.uiReady;
    var from = window.uiErrors.length;
    var result = { scenario: scenario, errors: [], startDateType: null, rendered: false };
    try {
      var mods = await new Promise(function (res, rej) {
        sap.ui.require(['sap/ui/core/mvc/XMLView', 'sap/ui/model/json/JSONModel'],
          function () { res(arguments); }, rej);
      });
      var XMLView = mods[0], JSONModel = mods[1];

      var startBinding = scenario === 'C'
        ? "{ path: 'START', formatter: 'Formatter.DateCreateObject' }"
        : "{START}";
      var endBinding = scenario === 'C'
        ? "{ path: 'END', formatter: 'Formatter.DateCreateObject' }"
        : "{END}";
      var xml =
        '<mvc:View xmlns:mvc="sap.ui.core.mvc" xmlns="sap.m" xmlns:unified="sap.ui.unified" xmlns:core="sap.ui.core"' +
        (scenario === 'C' ? ' core:require="{Formatter: \\'z2ui5/model/formatter\\'}"' : '') + '>' +
        '<PlanningCalendar rows="{/T_PEOPLE}">' +
        '<rows><PlanningCalendarRow title="{NAME}"' +
        ' appointments="{path: \\'T_APPOINTMENTS\\', templateShareable: true}">' +
        '<appointments><unified:CalendarAppointment' +
        ' startDate="' + startBinding.replace(/"/g, '&quot;') + '"' +
        ' endDate="' + endBinding.replace(/"/g, '&quot;') + '"' +
        ' title="{TITLE}"/></appointments>' +
        '</PlanningCalendarRow></rows></PlanningCalendar></mvc:View>';

      var mkDates = scenario === 'B';
      var data = { T_PEOPLE: [ { NAME: 'Anna', T_APPOINTMENTS: [ {
        START: mkDates ? new Date('2026-07-20T08:00:00') : '2026-07-20T08:00:00',
        END:   mkDates ? new Date('2026-07-20T09:00:00') : '2026-07-20T09:00:00',
        TITLE: 'Team meeting' } ] } ] };

      var view = await XMLView.create({ definition: xml });
      view.setModel(new JSONModel(data));
      view.placeAt('content');
      await new Promise(function (r) { setTimeout(r, 1200); });

      var pc = view.findAggregatedObjects(true, function (o) {
        return o.isA('sap.ui.unified.CalendarAppointment');
      })[0];
      if (pc) {
        var sd = pc.getStartDate();
        result.startDateType = sd instanceof Date ? 'Date(' + (isNaN(sd) ? 'Invalid' : sd.toISOString()) + ')' : typeof sd + '(' + sd + ')';
      }
      result.rendered = !!document.querySelector('.sapUiCalendarApp');
      view.destroy();
    } catch (e) {
      result.errors.push('THROW: ' + e.message);
    }
    result.errors = result.errors.concat(window.uiErrors.slice(from));
    return result;
  };
</script>
</head><body><div id="content"></div></body></html>`;

const server = http.createServer((req, res) => {
  const u = new URL(req.url, 'http://x');
  if (u.pathname === '/harness.html') { res.writeHead(200, { 'content-type': 'text/html' }); res.end(HARNESS); return; }
  if (u.pathname.startsWith('/resources/')) {
    const rel = u.pathname.slice('/resources/'.length);
    for (const root of LIB_ROOTS) {
      const full = path.join(root, rel);
      if (full.startsWith(root) && fs.existsSync(full) && fs.statSync(full).isFile()) {
        res.writeHead(200, { 'content-type': MIME[path.extname(full)] || 'application/octet-stream' });
        res.end(fs.readFileSync(full));
        return;
      }
    }
  }
  res.writeHead(404); res.end();
});
await new Promise((r) => server.listen(0, '127.0.0.1', r));
const base = `http://127.0.0.1:${server.address().port}`;

process.chdir(ROOT); // resolve playwright from ai-demokit's node_modules
const { chromium } = await import(path.join(ROOT, 'node_modules', 'playwright', 'index.mjs'));
const browser = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium' }).catch(() => chromium.launch());
const page = await browser.newPage();
await page.goto(`${base}/harness.html`);

for (const s of ['A', 'B', 'C']) {
  const r = await page.evaluate((sc) => window.probe(sc), s);
  console.log(`\n=== Scenario ${s} (${s === 'A' ? 'ISO string, plain binding' : s === 'B' ? 'Date object, plain binding' : 'ISO string + formatter'})`);
  console.log('  startDate on control:', r.startDateType);
  console.log('  appointment rendered:', r.rendered);
  console.log('  errors:', r.errors.length ? r.errors.slice(0, 3) : 'none');
}
await browser.close();
server.close();
