#!/usr/bin/env node
/*
 * abap2UI5 MCP server — the generate -> deploy -> run -> LOOK loop for AI
 * coding agents, without an SAP system.
 *
 * Speaks MCP over stdio. Register it in any MCP client, e.g. Claude Code:
 *
 *   claude mcp add abap2ui5 -- node mcp/server.mjs
 *
 * Tools (each wraps infrastructure this repo already trusts in CI):
 *   capabilities      what abap2UI5 can express (CAPABILITIES.md, live-parsed)
 *   generation_rules  the porting/building rulebook (generation-prompt.txt)
 *   scope_of          in/out-of-scope verdict for a UI5 control (scope-of.mjs)
 *   deploy_app        write an app class into src/zz_dev/ (+ optional lint)
 *   build_backend     transpile framework + apps to the Node backend (e2e-build)
 *   run_app           boot the app headless, return page errors + a SCREENSHOT
 *   backend           start/stop/status of the express backend
 *
 * The intended agent loop: capabilities -> deploy_app -> build_backend ->
 * run_app -> read the errors, LOOK at the screenshot -> edit -> repeat.
 */
import path from 'path';
import fs from 'fs';
import { spawn } from 'child_process';
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { CallToolRequestSchema, ListToolsRequestSchema } from '@modelcontextprotocol/sdk/types.js';
import { searchCapabilities, capabilitySummary, REPO_ROOT } from './lib/capabilities.mjs';
import {
  deployApp,
  removeApp,
  listDevApps,
  lintApp,
  buildBackend,
  backendBuilt,
  backendStatus,
  startBackend,
  stopBackend,
  runApp,
} from './lib/runtime.mjs';

const TOOLS = [
  {
    name: 'capabilities',
    description:
      'Query what abap2UI5 can express, from the verified capability map (CAPABILITIES.md — every entry ' +
      'names a proving port). Call this BEFORE deciding a UI5 feature cannot be built. ' +
      'Without arguments returns a summary; with `query` returns matching entries ' +
      '(status: direct | workaround | needs-live-test | not-expressible).',
    inputSchema: {
      type: 'object',
      properties: {
        query: { type: 'string', description: 'keywords matched against feature/how/evidence, e.g. "tree binding" or "dialog"' },
        status: {
          type: 'string',
          enum: ['direct', 'workaround', 'needs-live-test', 'not-expressible'],
          description: 'optional filter on the capability status',
        },
      },
    },
  },
  {
    name: 'generation_rules',
    description:
      'The canonical rulebook for writing an abap2UI5 app with the generic view builder ' +
      '(dispatcher skeleton, view/attribute idioms, binding and event rules). Read it once before ' +
      'generating ABAP.',
    inputSchema: { type: 'object', properties: {} },
  },
  {
    name: 'scope_of',
    description:
      'Authoritative in/out-of-scope verdict for UI5 control entities (exists since UI5 <= 1.71, not ' +
      'deprecated), read from the OpenUI5 source JSDoc. Needs an OpenUI5 checkout (OPENUI5_SRC or ' +
      '../fork-openui5).',
    inputSchema: {
      type: 'object',
      properties: {
        entities: {
          type: 'array',
          items: { type: 'string' },
          description: 'control entities, e.g. ["sap.m.Wizard", "sap.f.SidePanel"]',
        },
      },
      required: ['entities'],
    },
  },
  {
    name: 'deploy_app',
    description:
      'Deploy an abap2UI5 app: writes <class_name>.clas.abap (+ abapGit sidecar) into the gitignored ' +
      'dev sandbox src/zz_dev/ and lints it with the repo abaplint config. The class must implement ' +
      'z2ui5_if_app. After deploying, run build_backend once (rebuilds the transpiled Node backend), ' +
      'then run_app to see it. Set lint:false to skip the lint (faster, not recommended).',
    inputSchema: {
      type: 'object',
      properties: {
        class_name: { type: 'string', description: 'lowercase class name matching ^z2ui5_cl_..., <= 30 chars, e.g. z2ui5_cl_my_app' },
        abap_source: { type: 'string', description: 'full ABAP source of the class (CLASS ... DEFINITION + IMPLEMENTATION)' },
        description: { type: 'string', description: 'short class description (abapGit DESCRIPT)' },
        lint: { type: 'boolean', description: 'run abaplint after writing (default true)' },
      },
      required: ['class_name', 'abap_source'],
    },
  },
  {
    name: 'build_backend',
    description:
      'Rebuild the transpiled Node backend so run_app picks up deployed/edited ABAP. mode auto (default) is ' +
      'incremental when a prior full build exists: only src/zz_dev/ is re-copied and re-transpiled (~1-2 min). ' +
      'mode full runs the complete e2e-build (downport + transpile, tens of minutes) — needed once initially, or ' +
      'when framework/port sources changed, or when the incremental transpile rejects a construct (then simplify ' +
      'the ABAP or go full). Stops a running backend first.',
    inputSchema: {
      type: 'object',
      properties: {
        mode: { type: 'string', enum: ['auto', 'incremental', 'full'], description: 'default auto' },
      },
    },
  },
  {
    name: 'run_app',
    description:
      'Boot an app class headless in Chromium against the local backend (?app_start=<class>) and LOOK at it: ' +
      'returns booted/ok, real page errors + failed backend calls (benign UI5 noise filtered), and a full-page ' +
      'screenshot as an image. The visual verification step of the loop — also works for the 276 existing ports ' +
      'and z2ui5_cl_ai_app_overview.',
    inputSchema: {
      type: 'object',
      properties: {
        class_name: { type: 'string', description: 'the app class to start, e.g. z2ui5_cl_my_app or z2ui5_cl_ai_app_005' },
        timeout_ms: { type: 'number', description: 'boot timeout in ms (default 60000)' },
      },
      required: ['class_name'],
    },
  },
  {
    name: 'backend',
    description: 'Manage the local express backend serving the transpiled apps: status | start | stop | restart. ' +
      'run_app starts it automatically; use this for diagnostics or to free the port.',
    inputSchema: {
      type: 'object',
      properties: {
        action: { type: 'string', enum: ['status', 'start', 'stop', 'restart'], description: 'default: status' },
      },
    },
  },
  {
    name: 'remove_app',
    description: 'Remove a previously deployed dev app from src/zz_dev/ (takes effect in the served backend after the next build_backend). Without class_name lists the deployed dev apps.',
    inputSchema: {
      type: 'object',
      properties: {
        class_name: { type: 'string', description: 'the dev app class to remove; omit to list deployed dev apps' },
      },
    },
  },
];

function text(s) {
  return { content: [{ type: 'text', text: typeof s === 'string' ? s : JSON.stringify(s, null, 2) }] };
}

function toolError(message) {
  return { content: [{ type: 'text', text: message }], isError: true };
}

async function runScopeOf(entities) {
  return new Promise((resolve) => {
    const child = spawn('node', [path.join(REPO_ROOT, 'scripts', 'scope-of.mjs'), ...entities], { cwd: REPO_ROOT });
    let out = '';
    child.stdout.on('data', (d) => (out += d));
    child.stderr.on('data', (d) => (out += d));
    child.on('close', (code) => resolve({ code, out: out.trim() }));
  });
}

async function handle(name, args = {}) {
  switch (name) {
    case 'capabilities': {
      if (!args.query && !args.status) {
        const s = capabilitySummary();
        return text({
          summary: s,
          hint: 'pass `query` (keywords) and/or `status` to get the matching entries; statuses: direct, workaround, needs-live-test, not-expressible',
        });
      }
      const hits = searchCapabilities({ query: args.query, status: args.status });
      return text({ matches: hits.length, entries: hits });
    }
    case 'generation_rules': {
      const p = path.join(REPO_ROOT, 'scripts', 'generation-prompt.txt');
      const rules = fs.readFileSync(p, 'utf8');
      return text(
        rules +
          '\n\n---\nMore depth: AGENTS.md (conventions, gates), CAPABILITIES.md via the capabilities tool, ' +
          'and https://abap2ui5.github.io/docs/advanced/agent.html for apps built on z2ui5_cl_xml_view.',
      );
    }
    case 'scope_of': {
      const entities = args.entities || [];
      if (!entities.length) return toolError('pass at least one entity, e.g. ["sap.m.Wizard"]');
      const { code, out } = await runScopeOf(entities);
      return text(`${out}\n\n(exit ${code}: 0 = all in scope, 1 = at least one out of scope or unresolved)`);
    }
    case 'deploy_app': {
      const res = deployApp({
        className: args.class_name,
        source: args.abap_source,
        description: args.description,
      });
      const reply = { deployed: res.class, file: path.relative(REPO_ROOT, res.abapPath) };
      if (args.lint !== false) {
        reply.lint = await lintApp(res.class);
        if (!reply.lint.ok) {
          reply.hint = 'fix the lint findings and deploy again; build_backend is only worth running on a clean lint';
        }
      }
      if (!reply.lint || reply.lint.ok) {
        reply.next = 'run build_backend once, then run_app to see the app';
      }
      return text(reply);
    }
    case 'build_backend': {
      await stopBackend();
      const res = await buildBackend({ mode: args.mode || 'auto' });
      if (!res.ok) return toolError(`build failed (exit ${res.code}, mode ${res.mode || args.mode}):\n${res.tail}`);
      return text({ built: true, mode: res.mode, next: 'run_app { class_name } to boot and screenshot the app', tail: res.tail.split('\n').slice(-5).join('\n') });
    }
    case 'run_app': {
      const res = await runApp({ className: args.class_name, timeoutMs: args.timeout_ms || 60000 });
      const report = {
        class: res.class,
        booted: res.booted,
        ok: res.ok,
        errors: res.errors,
        screenshot: path.relative(REPO_ROOT, res.screenshotPath),
      };
      const content = [{ type: 'text', text: JSON.stringify(report, null, 2) }];
      if (res.base64) content.push({ type: 'image', data: res.base64, mimeType: 'image/png' });
      return { content, isError: !res.booted };
    }
    case 'backend': {
      const action = args.action || 'status';
      if (action === 'start') return text(await startBackend());
      if (action === 'stop') return text(await stopBackend());
      if (action === 'restart') {
        await stopBackend();
        return text(await startBackend());
      }
      return text(backendStatus());
    }
    case 'remove_app': {
      if (!args.class_name) return text({ devApps: listDevApps() });
      const removed = removeApp(args.class_name);
      return text({ removed, note: removed ? 'run build_backend to update the served backend' : 'no such dev app' });
    }
    default:
      return toolError(`unknown tool: ${name}`);
  }
}

const server = new Server(
  { name: 'abap2ui5', version: '1.0.0' },
  { capabilities: { tools: {} } },
);

server.setRequestHandler(ListToolsRequestSchema, async () => ({ tools: TOOLS }));
server.setRequestHandler(CallToolRequestSchema, async (req) => {
  try {
    return await handle(req.params.name, req.params.arguments || {});
  } catch (e) {
    return toolError(String((e && e.message) || e));
  }
});

process.on('SIGINT', async () => {
  await stopBackend().catch(() => {});
  process.exit(0);
});
process.on('SIGTERM', async () => {
  await stopBackend().catch(() => {});
  process.exit(0);
});

const transport = new StdioServerTransport();
await server.connect(transport);
console.error(`abap2ui5 MCP server ready (repo: ${REPO_ROOT}, backend built: ${backendBuilt()})`);
