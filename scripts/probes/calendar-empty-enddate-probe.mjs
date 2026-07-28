// Empirical probe for the app-220 finding: a bound DateRange whose row carries
// an EMPTY end field. Formatter.DateCreateObject('') is new Date('') = Invalid
// Date, DateRange.endDate accepts it (type "object"), and sap.ui.unified's
// Month._checkDateEnabled then runs CalendarDate.fromLocalJSDate on every
// truthy endDate — which throws on an Invalid Date. The original sample simply
// omits `end` for its single-day range (undefined is falsy).
//
// Three scenarios against the real OpenUI5 runtime (headless Chromium):
//   A: endDate="{path:'END', formatter:'Formatter.DateCreateObject'}" (the port
//      before the fix) — expected to crash on the empty row
//   B: the same binding with the empty row REMOVED — control case, must render
//   C: endDate="{= ${END} ? Formatter.DateCreateObject(${END}) : null }" (the
//      fix) — the empty row must yield endDate null and the calendar must render
//
// The calendar is rendered on the month that carries the disabled dates, so
// MonthRenderer really walks _checkDateEnabled over them.
import fs from 'node:fs';
import http from 'node:http';
import path from 'node:path';

const ROOT = new URL('../..', import.meta.url).pathname;
const LIB_ROOTS = ['sap.ui.core', 'sap.m', 'sap.ui.layout', 'sap.ui.unified', 'themelib_sap_horizon']
  .map((p) => path.join(ROOT, 'node_modules', '@openui5', p, 'src'))
  .filter((p) => fs.existsSync(p));

const MIME = { '.js': 'text/javascript', '.css': 'text/css', '.json': 'application/json',
  '.xml': 'application/xml', '.properties': 'text/plain', '.html': 'text/html' };

const HARNESS = `<!DOCTYPE html>
<html><head><meta charset="utf-8"><title>calendar-empty-enddate-probe</title>
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
      // the framework's curated formatter, mirrored exactly (abap2UI5
      // app/webapp/model/formatter.js): new Date(s), no empty-string guard
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
    var result = { scenario: scenario, errors: [], endDates: [], rendered: false, days: 0 };
    try {
      var mods = await new Promise(function (res, rej) {
        sap.ui.require(['sap/ui/core/mvc/XMLView', 'sap/ui/model/json/JSONModel'],
          function () { res(arguments); }, rej);
      });
      var XMLView = mods[0], JSONModel = mods[1];

      var endBinding = scenario === 'C'
        ? "{= \${END} ? Formatter.DateCreateObject(\${END}) : null }"
        : "{ path: 'END', formatter: 'Formatter.DateCreateObject' }";

      var xml =
        '<mvc:View xmlns:mvc="sap.ui.core.mvc" xmlns="sap.m" xmlns:u="sap.ui.unified"' +
        ' xmlns:core="sap.ui.core" core:require="{Formatter: \\'z2ui5/model/formatter\\'}">' +
        '<u:Calendar id="calendar"' +
        ' minDate="{ path: \\'/MIN_DATE\\', formatter: \\'Formatter.DateCreateObject\\' }"' +
        ' maxDate="{ path: \\'/MAX_DATE\\', formatter: \\'Formatter.DateCreateObject\\' }"' +
        ' disabledDates="{/T_DISABLED}">' +
        '<u:disabledDates><u:DateRange' +
        ' startDate="{ path: \\'START\\', formatter: \\'Formatter.DateCreateObject\\' }"' +
        ' endDate="' + endBinding.replace(/"/g, '&quot;') + '"/></u:disabledDates>' +
        '</u:Calendar></mvc:View>';

      // app 220's own model values; scenario B drops the row with the empty end
      var rows = [
        { START: '2016-01-04', END: '2016-01-10' },
        { START: '2016-01-15', END: '' },
      ];
      if (scenario === 'B') rows = rows.slice(0, 1);

      var view = await XMLView.create({ definition: xml });
      view.setModel(new JSONModel({
        MIN_DATE: '2000-01-01', MAX_DATE: '2050-12-31', T_DISABLED: rows,
      }));
      view.placeAt('content');

      // navigate to the month that actually carries the disabled dates, so the
      // renderer walks _checkDateEnabled over them
      var cal = view.findAggregatedObjects(true, function (o) {
        return o.isA('sap.ui.unified.Calendar');
      })[0];
      if (cal) { cal.focusDate(new Date(2016, 0, 15)); }
      await new Promise(function (r) { setTimeout(r, 1500); });

      view.findAggregatedObjects(true, function (o) {
        return o.isA('sap.ui.unified.DateRange');
      }).forEach(function (r) {
        var d = r.getEndDate();
        result.endDates.push(d === null ? 'null'
          : d === undefined ? 'undefined'
          : d instanceof Date ? 'Date(' + (isNaN(d) ? 'INVALID' : d.toISOString().slice(0, 10)) + ')'
          : typeof d + '(' + d + ')');
      });
      result.days = document.querySelectorAll('.sapUiCalItem').length;
      result.rendered = result.days > 0;
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

const LABEL = {
  A: 'formatter binding, empty end row present (the port before the fix)',
  B: 'formatter binding, empty end row removed (control)',
  C: 'expression binding with a falsy guard (the fix)',
};
for (const s of ['A', 'B', 'C']) {
  const r = await page.evaluate((sc) => window.probe(sc), s);
  console.log(`\n=== Scenario ${s} — ${LABEL[s]}`);
  console.log('  endDate per DateRange:', r.endDates.length ? r.endDates.join(', ') : '(none)');
  console.log('  calendar days rendered:', r.days);
  console.log('  errors:', r.errors.length ? r.errors.slice(0, 3) : 'none');
}
await browser.close();
server.close();
