#!/usr/bin/env node
/*
 * sap.m.p13n panel probe (2026-08-08)
 *
 * The p13n family cannot be PORTED here - sap.m.p13n.Popup is @since 1.97 and
 * the panels @since 1.96/1.104, so every p13n sample is out of scope against
 * the 1.71 floor (api.md marks them all with a cross). But the controls ship
 * with OpenUI5, so their behaviour can still be MEASURED - and the curated
 * sample abap2UI5/samples 090 depends on three facts that were reasoned from
 * the sources rather than observed:
 *
 *   1. the panels take their items ONLY through setP13nData( ) - there is no
 *      bindable aggregation - which is why the sample needed hand-written
 *      custom JS (a z2ui5_cl_pop_js_loader popup) before
 *      CONTROL_METHODS.setP13nData existed
 *   2. Popup.open( ) works with NO argument in the default Dialog mode. The
 *      framework's control_by_id wire cannot pass a control instance, only
 *      strings, so a required source control would have blocked the sample
 *   3. the user's changes can be read back without custom JS, through the
 *      panel's own change event plus $event.oSource.getP13nData( )
 *
 * All three hold (see the run output). The probe also turned up a defect in
 * OpenUI5 itself: Popup.open( ) guards the missing source with
 * `if (!oSource && this.getMode() === "Popover") throw`, but P13nPopupMode
 * only offers `Dialog` and `ResponsivePopover` - "Popover" is not a value the
 * property can hold, so the guard is dead code. In ResponsivePopover mode the
 * call therefore does not raise the documented "Please provide a source
 * control!" but dies inside openBy(undefined) with "Cannot read properties of
 * undefined (reading 'getDomRef')". For abap2UI5 that is a real boundary: the
 * control_by_id wire carries strings, so a ResponsivePopover-mode p13n popup
 * cannot be opened from the backend at all - only the default Dialog mode can.
 *
 * Run:  node scripts/probes/p13n-panel-probe.mjs [--json]
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

function req(names) {
  return new Promise(function (res, rej) {
    sap.ui.require(names, function () { res(Array.prototype.slice.call(arguments)); }, rej);
  });
}
function attempt(fn) {
  try { return { ok: true, value: fn() }; }
  catch (e) { return { ok: false, error: e && e.message ? e.message : String(e) }; }
}

window.probe = async function () {
  await window.uiReady;
  var findings = [];
  var mods;
  try {
    mods = await req(['sap/m/p13n/Popup', 'sap/m/p13n/SelectionPanel',
      'sap/m/p13n/SortPanel', 'sap/m/p13n/GroupPanel', 'sap/m/library']);
  } catch (e) {
    return [{ key: 'require', verdict: 'ERROR', detail: String(e) }];
  }
  var Popup = mods[0], SelectionPanel = mods[1], SortPanel = mods[2],
      GroupPanel = mods[3], mLibrary = mods[4];

  // 1 - is there a bindable aggregation for the items, or only setP13nData?
  var meta = SelectionPanel.getMetadata();
  findings.push({
    key: 'no-bindable-items',
    question: 'do the panels expose an aggregation for their items (which a backend could bind) or only setP13nData()?',
    verdict: 'MEASURED',
    detail: {
      aggregations: Object.keys(meta.getAllAggregations()),
      properties: Object.keys(meta.getAllProperties()),
      hasSetP13nData: typeof SelectionPanel.prototype.setP13nData === 'function',
      hasGetP13nData: typeof SelectionPanel.prototype.getP13nData === 'function',
    },
  });

  // 2 - setP13nData / getP13nData round-trip with exactly the payload the
  //     CONTROL_METHODS "object" arg kind produces (JSON.parse of the wire)
  var wire = '[{"name":"key1","label":"City","visible":true},' +
             '{"name":"key2","label":"Country","visible":false}]';
  var panel = new SelectionPanel();
  var seeded = attempt(function () {
    panel.setP13nData(JSON.parse(wire));
    return panel.getP13nData();
  });
  findings.push({
    key: 'setP13nData-roundtrip',
    question: 'does setP13nData() accept the JSON-parsed wire payload, and does getP13nData() return it?',
    verdict: seeded.ok ? 'WORKS' : 'FAILS',
    detail: seeded.ok ? seeded.value : seeded.error,
  });

  // 3 - the same for the sort and group panels (different item shape)
  var sortPanel = new SortPanel();
  var sorted = attempt(function () {
    sortPanel.setP13nData(JSON.parse('[{"name":"key1","label":"City","sorted":true,"descending":true}]'));
    return sortPanel.getP13nData();
  });
  findings.push({
    key: 'setP13nData-sortpanel',
    question: 'same for SortPanel, whose items carry sorted/descending',
    verdict: sorted.ok ? 'WORKS' : 'FAILS',
    detail: sorted.ok ? sorted.value : sorted.error,
  });

  var groupPanel = new GroupPanel();
  var grouped = attempt(function () {
    groupPanel.setP13nData(JSON.parse('[{"name":"key1","label":"City","grouped":true}]'));
    return groupPanel.getP13nData();
  });
  findings.push({
    key: 'setP13nData-grouppanel',
    question: 'same for GroupPanel, whose items carry grouped',
    verdict: grouped.ok ? 'WORKS' : 'FAILS',
    detail: grouped.ok ? grouped.value : grouped.error,
  });

  // 4 - the change event: is it declared, and does oSource.getP13nData()
  //     report the current state from inside the handler? That is the whole
  //     read-back path (the event arg $event.oSource.getP13nData()).
  var readBack = null;
  var changePanel = new SelectionPanel();
  changePanel.setP13nData(JSON.parse(wire));
  changePanel.attachChange(function (oEvent) {
    readBack = attempt(function () { return oEvent.getSource().getP13nData(); });
  });
  var fired = attempt(function () { changePanel.fireChange({ reason: 'Add' }); return true; });
  findings.push({
    key: 'change-readback',
    question: 'is "change" a declared event, and does $event.oSource.getP13nData() work from the handler?',
    verdict: fired.ok && readBack && readBack.ok ? 'WORKS' : 'FAILS',
    detail: {
      eventDeclared: Boolean(SelectionPanel.getMetadata().getEvent('change')),
      fired: fired.ok ? true : fired.error,
      readBack: readBack ? (readBack.ok ? readBack.value : readBack.error) : null,
      serializable: readBack && readBack.ok
        ? attempt(function () { return JSON.stringify(readBack.value).length; })
        : null,
    },
  });

  // 5 - Popup.open() with NO argument, default mode. The framework's
  //     control_by_id wire carries strings only, so a required source control
  //     would have blocked the whole sample.
  var popup = new Popup({ title: 'Settings' });
  popup.addPanel(panel);
  var openNoArg = attempt(function () { popup.open(); return true; });
  findings.push({
    key: 'open-without-source',
    question: 'does Popup.open() work with no argument in the default mode?',
    verdict: openNoArg.ok ? 'WORKS' : 'FAILS',
    detail: { mode: popup.getMode(), result: openNoArg.ok ? 'opened' : openNoArg.error },
  });
  attempt(function () { popup.close(); return true; });

  // 6 - the other mode. The docs say a source control is required there, and
  //     open() carries a guard for it - but the guard tests for the string
  //     "Popover" while the enum only offers Dialog and ResponsivePopover, so
  //     it can never match. Measured with the REAL enum value.
  var built = attempt(function () {
    var p = new Popup({ title: 'Settings', mode: mLibrary.P13nPopupMode.ResponsivePopover });
    p.addPanel(new SelectionPanel());
    return p;
  });
  var popover = built.ok ? built.value : null;
  var openPopover = built.ok
    ? attempt(function () { popover.open(); return true; })
    : { ok: false, error: 'could not build the Popover-mode popup: ' + built.error };
  findings.push({
    key: 'open-popover-mode',
    question: 'and in ResponsivePopover mode, where the docs say a source control is required?',
    verdict: openPopover.ok ? 'WORKS' : 'THROWS (expected)',
    detail: {
      // record the EFFECTIVE mode: if the enum value did not resolve, the
      // property silently keeps its Dialog default and the outcome below
      // would say nothing about Popover mode at all
      enumValues: mLibrary && mLibrary.P13nPopupMode
        ? Object.keys(mLibrary.P13nPopupMode).join('|') : 'ENUM MISSING',
      effectiveMode: popover ? popover.getMode() : 'not built',
      result: openPopover.ok ? 'opened without a source' : openPopover.error,
    },
  });

  [panel, sortPanel, groupPanel, changePanel, popup, popover].filter(Boolean).forEach(function (c) {
    attempt(function () { c.destroy(); return true; });
  });
  return findings;
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
const page = await browser.newPage();
await page.goto(`http://127.0.0.1:${server.address().port}/harness.html`);
const findings = await page.evaluate(() => window.probe());
await browser.close();
server.close();

if (process.argv.includes('--json')) {
  console.log(JSON.stringify(findings, null, 1));
} else {
  console.log(`sap.m.p13n panel probe - real OpenUI5, ${findings.length} questions\n`);
  for (const f of findings) {
    console.log(`${String(f.verdict).padEnd(18)} ${f.key}`);
    console.log(`                   ${f.question || ''}`);
    console.log(`                   ${JSON.stringify(f.detail)}`);
    console.log('');
  }
}
