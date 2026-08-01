// scratch probe (not committed): boot one port, run PROBE_ACT, dump selectors
import path from 'path';
import { spawn } from 'child_process';
import { chromium } from 'playwright';
import fs from 'fs';

const A2 = '/home/user/ai-demokit/.abap2UI5';
const ROOT = '/home/user/ai-demokit';
const cls = process.argv[2];
const sels = process.argv.slice(3);

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

const srv = spawn('node', [path.join(A2, 'node/srv/express.mjs')], { env: { ...process.env, PORT: '3000' } });
await new Promise((res) => { const on = (d) => { if (/Listening on/.test(String(d))) { srv.stdout.off('data', on); res(); } }; srv.stdout.on('data', on); });

const browser = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium' });
const page = await browser.newPage();
page.on('pageerror', (e) => console.log('PAGEERROR', String(e.message).slice(0, 200)));
await page.route('**://sdk.openui5.org/**', (route) => {
  const hit = resolveLocal(new URL(route.request().url()).pathname);
  return hit ? route.fulfill({ status: 200, contentType: hit.type, body: hit.body }) : route.fulfill({ status: 404, body: '' });
});
await page.goto(`http://localhost:3000/?app_start=${cls}`, { waitUntil: 'domcontentloaded' });
await page.waitForFunction(() => window.sap && document.querySelectorAll('[data-sap-ui]').length > 3, { timeout: 60000 });
await page.waitForTimeout(1500);
if (process.env.PROBE_ACT) { await eval('(async () => {' + process.env.PROBE_ACT + '})()'); }
for (const s of sels) {
  const n = await page.locator(s).count();
  const txt = n ? (await page.locator(s).first().innerText().catch(() => '')) : '';
  console.log(s, 'count=', n, 'text=', JSON.stringify(txt.slice(0, 300)));
}
await browser.close();
srv.kill();
process.exit(0);
