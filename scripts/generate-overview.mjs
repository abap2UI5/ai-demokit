#!/usr/bin/env node
/*
 * Generates the in-system overview app src/z2ui5_cl_smpc_app_000.clas.*
 * — an abap2UI5 app that lists every ported sample as one row of a table with
 * columns: Module, Control (-> OpenUI5 API), Sample (name -> OpenUI5 repo
 * source, ↗ -> live OpenUI5 fullscreen sample), abap2UI5 (class name ->
 * generated class on GitHub, ↗ -> starts the app) and Note (green check when
 * live-verified; orange 1.71+ badge when the port keeps members newer than
 * UI5 1.71; hint button opens the deviations popup). Every link opens in
 * a NEW browser tab (target="_blank"; the ↗ start link uses ?app_start=).
 * Reads everything from the meta/ sidecars (the source of truth for sample,
 * entity, checked and deviations - the port classes carry no header).
 *
 * Run:  node scripts/generate-overview.mjs
 *       node scripts/generate-overview.mjs --update-entities
 *         (rebuilds ui5/openui5-entities.json from the installed @openui5
 *          sources - needs node_modules; see the oracle comment below)
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { loadUniverseSnapshot, enrichFromProperties } from './lib-universe.mjs';
import { openui5Membership } from './lib/overview-openui5.mjs';
import { buildApps } from './lib/overview-model.mjs';
import { emitOverview } from './lib/overview-emit.mjs';
import { formatSource } from './lib/format-chain.mjs';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const SRC = path.join(ROOT, 'src');
const META = path.join(ROOT, 'meta');
const CLASS = 'z2ui5_cl_smpc_app_000';
const OUT_ABAP = path.join(SRC, `${CLASS}.clas.abap`);
const OUT_XML = path.join(SRC, `${CLASS}.clas.xml`);

// control availability from the sample-universe snapshot (same source as the
// coverage docs): the release a control appeared in + whether it is deprecated
const uni = loadUniverseSnapshot();
if (!uni) { console.error('ui5/universe.json missing — the overview needs the sample-universe snapshot.'); process.exit(1); }
const uniMap = new Map();
for (const lib of uni.libs) for (const s of lib.samples) uniMap.set(`${lib.lib}|${s.name}`, s);

/* The three seams this file was split along on 2026-08-28. It had grown to
 * 1477 lines mixing the src walk, an OpenUI5 entity probe, version
 * comparison, column-width maths, ABAP statement-size budgeting, text
 * hoisting and the whole emitted class — and AGENTS.md's answer was to tell
 * agents to grep it and never read it whole, which is a workaround for a
 * structural problem rather than a property of the file. What is left here
 * is the pipeline: read the snapshot, ask the oracle, build the model, emit
 * it, format it, write it. Every module carries the code unchanged, so the
 * generated class is byte-identical across the split — which is what the
 * meta_valid diff gate proves on every run. */
const { controls: OPENUI5_CONTROLS, inOpenUI5 } = openui5Membership({
  ROOT,
  META,
  update: process.argv.includes('--update-entities'),
});

// scope fallback (the same lib-universe enrichment generate-coverage uses):
// the universe snapshot carries since:null for most controls, so fill the
// nulls from the control-level @since/@deprecated that the linter's generate-metadata.mjs
// parses out of the OpenUI5 sources — the overview's Since column and the
// deprecation strikethrough then match the authoritative scope verdict.
for (const [k, s] of uniMap) uniMap.set(k, enrichFromProperties(OPENUI5_CONTROLS, s));

const apps = buildApps({ ROOT, META, uniMap, inOpenUI5 });

const { abap, xml } = emitOverview({ apps, CLASS });

/* The view chains above are emitted from template strings at a fixed indent,
 * which cannot know the base column of the statement they land in. Run the
 * result through the same formatter the corpus is checked with, so generated
 * code carries the layout rule instead of quietly reintroducing the drift. */
fs.writeFileSync(OUT_ABAP, formatSource(abap));
fs.writeFileSync(OUT_XML, xml);
console.log(`${CLASS}: ${apps.length} apps across ${new Set(apps.map((a) => a.control)).size} controls`);
