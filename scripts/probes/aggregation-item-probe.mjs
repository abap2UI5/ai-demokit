#!/usr/bin/env node
/*
 * aggregation-item probe (STATUS.md open findings, PROBE family
 * `template-clone-id`, 2026-08-06)
 *
 * abap2UI5 addresses a control by ID: every CONTROL_BY_ID method, SET_FOCUS,
 * SCROLL_INTO_VIEW and the domRef/controlId argument kinds take one. A control
 * the backend WROTE has an id, because the backend wrote it - but a control
 * CLONED from an aggregation template does not: UI5 mints its id from the
 * template id, the parent and the index.
 *
 * App 012 (`sap.m.sample.ComparisonPattern`) is the port that needs one. Its
 * `_updateCarouselsActivePage` re-syncs the two Carousels with
 *
 *     carousel.setActivePage(carousel.getPages()[this._iFirstItem])
 *
 * i.e. BY INDEX into the aggregation - and `Carousel.setActivePage` accepts
 * only a page id or a control (`sap/m/Carousel.js`), so the port dropped it.
 * Its sidecar names the missing piece: "an index-based page-resolution
 * mechanism, a new framework idea if more samples turn out to need it".
 *
 * Before designing that, two things have to be measured rather than assumed:
 *
 *   1. Is a template clone's id really unusable from the backend? The claim is
 *      that it is nondeterministic. If it is STABLE and derivable, no framework
 *      change is needed - the backend could just compute it.
 *   2. Does the obvious resolution work at all - getAggregation(name)[index]
 *      giving the control that setActivePage then accepts?
 *
 * Run:  node scripts/probes/aggregation-item-probe.mjs [--json]
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
  data-sap-ui-libs="sap.m,sap.ui.core" data-sap-ui-compatVersion="edge"
  data-sap-ui-preload=""></script>
<script>
window.uiReady = new Promise(function (resolve) {
  function boot() { sap.ui.getCore ? sap.ui.getCore().attachInit(resolve) : resolve(); }
  if (window.sap && sap.ui) boot(); else window.addEventListener('load', boot);
});

// A Carousel whose pages come from a TEMPLATE bound to a model, exactly the
// shape app 012 has. The view is created the way the framework creates it, so
// the ids carry a view prefix like they do in the app.
window.probe = async function () {
  await window.uiReady;
  var out = {};
  var mods = await new Promise(function (res, rej) {
    sap.ui.require(['sap/ui/core/mvc/XMLView', 'sap/ui/model/json/JSONModel'],
      function () { res(arguments); }, rej);
  });
  var XMLView = mods[0], JSONModel = mods[1];
  var xml = '<mvc:View xmlns="sap.m" xmlns:mvc="sap.ui.core.mvc">'
    + '<Carousel id="car" pages="{/items}"><Text id="tpl" text="{name}"/></Carousel>'
    + '</mvc:View>';
  var view = await XMLView.create({ definition: xml, id: 'v1' });
  var model = new JSONModel({ items: [{ name: 'a' }, { name: 'b' }, { name: 'c' }] });
  view.setModel(model);
  view.placeAt('content');
  await new Promise(function (r) { setTimeout(r, 300); });

  var car = view.byId('car');

  // 1. what do the clone ids look like, and is the TEMPLATE id (the only id
  //    the backend knows, because it wrote it) among them?
  out.templateId = view.byId('tpl') ? view.byId('tpl').getId() : null;
  out.cloneIdsBefore = car.getPages().map(function (p) { return p.getId(); });

  // 2. are they STABLE across a model update? (the backend's only chance to
  //    compute one)
  model.setData({ items: [{ name: 'a2' }, { name: 'b2' }, { name: 'c2' }] });
  await new Promise(function (r) { setTimeout(r, 200); });
  out.cloneIdsAfterRefresh = car.getPages().map(function (p) { return p.getId(); });

  // 3. and across a REORDER, which is what extended change detection reuses
  //    clones for
  model.setData({ items: [{ name: 'c2' }, { name: 'a2' }, { name: 'b2' }] });
  await new Promise(function (r) { setTimeout(r, 200); });
  out.cloneIdsAfterReorder = car.getPages().map(function (p) { return p.getId(); });
  out.textsAfterReorder = car.getPages().map(function (p) { return p.getText(); });

  // 4. does the obvious resolution work - getAggregation(name)[index] handed
  //    to setActivePage?
  try {
    var target = car.getAggregation('pages')[2];
    car.setActivePage(target);
    out.setActivePageById = car.getActivePage();
    out.resolvedIsPage3 = target.getId() === car.getPages()[2].getId();
  } catch (e) { out.setActivePageError = String(e && e.message || e); }

  // 5. and does a plain INDEX work, in case the API already accepts one?
  try {
    car.setActivePage(0);
    out.setActivePageByIndex = car.getActivePage();
  } catch (e) { out.setActivePageByIndexError = String(e && e.message || e); }

  view.destroy();
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
await page.goto(`http://127.0.0.1:${server.address().port}/harness.html`);
const out = await page.evaluate(() => window.probe());
await browser.close();
server.close();

if (process.argv.includes('--json')) {
  console.log(JSON.stringify(out, null, 1));
} else {
  const same = (a, b) => JSON.stringify(a) === JSON.stringify(b);
  console.log('aggregation-item probe — real OpenUI5, a Carousel with template-bound pages\n');
  console.log(`template id (the one the backend wrote)  ${out.templateId}`);
  console.log(`clone ids                                ${JSON.stringify(out.cloneIdsBefore)}`);
  console.log(`  after a model refresh                  ${same(out.cloneIdsBefore, out.cloneIdsAfterRefresh) ? 'UNCHANGED' : JSON.stringify(out.cloneIdsAfterRefresh)}`);
  console.log(`  after a reorder                        ${same(out.cloneIdsBefore, out.cloneIdsAfterReorder) ? 'UNCHANGED' : JSON.stringify(out.cloneIdsAfterReorder)}`);
  console.log(`  texts after that reorder               ${JSON.stringify(out.textsAfterReorder)}`);
  console.log('');
  console.log(`getAggregation('pages')[2] -> setActivePage   ${out.setActivePageById ?? out.setActivePageError}`);
  console.log(`  resolved control IS page 3                  ${out.resolvedIsPage3}`);
  console.log(`setActivePage(0) — a plain index             ${out.setActivePageByIndex ?? out.setActivePageByIndexError}`);
  console.log('');
  const derivable = out.cloneIdsBefore?.every((id) => out.templateId && id.includes(out.templateId.split('--').pop()));
  console.log(`VERDICT: clone ids ${same(out.cloneIdsBefore, out.cloneIdsAfterReorder) ? 'ARE stable' : 'are NOT stable'} across a reorder; `
    + `they ${derivable ? 'DO' : 'do NOT'} contain the template id.`);
}
