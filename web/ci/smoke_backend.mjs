/*
 * smoke_backend — ask the built site to answer a request before it ships.
 *
 * WHY: nothing between `npm run build` and the Pages deploy ever did. The
 * transpiler does not fail on an unresolved type or a wrong runtime guard, it
 * emits code that THROWS, so the build stays green and the bundle is dead.
 * Two such bundles reached the published demo:
 *
 *   - srv/zcl_sicf.clas.abap named z2ui5_cl_http_handler, which moved to
 *     src/99 and is deleted by `npm run assemble`. Every request answered
 *     "Void type: Z2UI5_CL_HTTP_HANDLER".
 *   - ci/patch_diss_oref.mjs guarded Z2UI5_CL_UI5_*, which after the core
 *     rename also covers the SHIPPED APPS. Guarding an app stops its own
 *     attributes from being dissolved, so the first POST answered 500
 *     "BINDING_ERROR - No class attribute for binding found".
 *
 * Both are one request away from being obvious, and neither needs a browser:
 * they are backend failures. So this is a plain HTTP probe of the transpiled
 * backend, seconds rather than a Chromium download, and it fails the build.
 *
 * What it asserts, in the order a user meets it:
 *   1. GET  /  answers 200 with the bootstrap HTML the backend writes
 *   2. POST /  starts an app and returns its S_FRONT (the first roundtrip)
 *   3. POST /  with an event restores the draft and returns a new ID
 *      (the draft save/load cycle the dissolve guard exists to protect)
 *
 * and fails on the framework's own error markers anywhere in a response.
 *
 * Run: node ci/smoke_backend.mjs   (needs `npm run build` output/ in place)
 */
import { spawn } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const WEB_ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const PORT = Number(process.env.SMOKE_PORT || 3000);
const BASE = `http://localhost:${PORT}/`;
const BOOT_TIMEOUT_MS = 120_000;
const REQ_TIMEOUT_MS = 180_000;

/* The markers the transpiled runtime uses when it fails. A response carrying
 * one is a failure even when the status is 200 - the framework renders its
 * error page with a 200 in some paths. */
const FATAL = [
  'Void type:',
  'BINDING_ERROR',
  'LOOP at undefined',
  'is not a function',
  'Cannot read properties of undefined',
];

const fail = (msg) => { console.error(`smoke_backend: FAIL - ${msg}`); process.exitCode = 1; };

function post(body, contextId) {
  const headers = { 'Content-Type': 'application/json', 'sap-contextid-accept': 'header' };
  if (contextId) headers['sap-contextid'] = contextId;
  return fetch(BASE, {
    method: 'POST',
    headers,
    body: JSON.stringify({ value: body }),
    signal: AbortSignal.timeout(REQ_TIMEOUT_MS),
  });
}

const front = () => ({ CONFIG: {}, ORIGIN: `http://localhost:${PORT}`, PATHNAME: '/', SEARCH: '', HASH: '' });

const server = spawn(process.execPath, ['srv/express.mjs'], {
  cwd: WEB_ROOT,
  stdio: ['ignore', 'pipe', 'pipe'],
  env: { ...process.env, PORT: String(PORT) },
});
let serverLog = '';
server.stdout.on('data', (d) => { serverLog += d; });
server.stderr.on('data', (d) => { serverLog += d; });

const stop = () => { try { server.kill('SIGKILL'); } catch { /* already gone */ } };
process.on('exit', stop);

try {
  // wait for the port rather than for a log line - the shim owns the message
  const deadline = Date.now() + BOOT_TIMEOUT_MS;
  let up = false;
  while (Date.now() < deadline && !up) {
    if (server.exitCode !== null) throw new Error(`server exited with ${server.exitCode}:\n${serverLog.slice(-2000)}`);
    try {
      await fetch(BASE, { signal: AbortSignal.timeout(5000) });
      up = true;
    } catch {
      await new Promise((r) => setTimeout(r, 500));
    }
  }
  if (!up) throw new Error(`server did not come up within ${BOOT_TIMEOUT_MS / 1000}s:\n${serverLog.slice(-2000)}`);

  // --- 1. the bootstrap HTML ------------------------------------------------
  const getRes = await fetch(BASE, { signal: AbortSignal.timeout(REQ_TIMEOUT_MS) });
  const html = await getRes.text();
  if (!getRes.ok) fail(`GET / answered ${getRes.status}`);
  const marker = FATAL.find((m) => html.includes(m));
  if (marker) fail(`GET / carries "${marker}"`);
  else if (!/sap-ui-bootstrap|<script/i.test(html)) fail('GET / returned no bootstrap HTML');
  else console.log(`smoke_backend: GET / ok (${html.length} bytes)`);

  // --- 2. the first roundtrip ----------------------------------------------
  const firstRes = await post({ S_FRONT: front() });
  const firstText = await firstRes.text();
  const firstMarker = FATAL.find((m) => firstText.includes(m));
  if (!firstRes.ok) fail(`first POST answered ${firstRes.status}: ${firstText.slice(0, 400)}`);
  else if (firstMarker) fail(`first POST carries "${firstMarker}": ${firstText.slice(0, 400)}`);
  else {
    let first;
    try { first = JSON.parse(firstText); } catch { fail(`first POST is not JSON: ${firstText.slice(0, 200)}`); }
    const app = first?.S_FRONT?.APP;
    const id = first?.S_FRONT?.ID;
    if (!app || !id) fail(`first POST returned no app/id: ${firstText.slice(0, 300)}`);
    else {
      console.log(`smoke_backend: first roundtrip ok (app ${app})`);

      // --- 3. the draft save/load cycle ------------------------------------
      const f2 = { ...front(), ID: id, EVENT: 'BUTTON_CHECK', VIEW: 'MAIN' };
      const secondRes = await post({ S_FRONT: f2 }, firstRes.headers.get('sap-contextid'));
      const secondText = await secondRes.text();
      const secondMarker = FATAL.find((m) => secondText.includes(m));
      if (!secondRes.ok) fail(`event POST answered ${secondRes.status}: ${secondText.slice(0, 400)}`);
      else if (secondMarker) fail(`event POST carries "${secondMarker}": ${secondText.slice(0, 400)}`);
      else {
        let second;
        try { second = JSON.parse(secondText); } catch { fail('event POST is not JSON'); }
        if (!second?.S_FRONT?.ID) fail(`event POST restored no draft: ${secondText.slice(0, 300)}`);
        else console.log('smoke_backend: draft save/load roundtrip ok');
      }
    }
  }
} catch (e) {
  fail(e.message);
} finally {
  stop();
}

if (!process.exitCode) console.log('smoke_backend: ok - the built backend answers');
