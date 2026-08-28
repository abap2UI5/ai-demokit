/*
 * overview-openui5 — the OpenUI5 membership oracle behind the overview app's
 * `ui5_only` flag, plus the staleness check on the snapshot it reads.
 *
 * Split out of generate-overview.mjs on 2026-08-28. That file had grown to
 * 1477 lines mixing the src walk, this probe, version comparison, column-width
 * maths, ABAP statement-size budgeting, text hoisting and the whole emitted
 * class — and AGENTS.md answered by telling agents to "grep it, never read it
 * whole", which is a workaround for a structural problem rather than a
 * property of the file. The three seams were already there; this is the first,
 * and the code inside it is unchanged.
 *
 * The oracle is the one part of the overview that MUST NOT depend on the
 * environment — see the comment below for the incident that made it a
 * committed snapshot.
 */
import fs from 'fs';
import path from 'path';
import { loadPropertiesControls } from '../lib-universe.mjs';

/**
 * @param {object}  o
 * @param {string}  o.ROOT    repository root
 * @param {string}  o.META    the meta/ directory
 * @param {boolean} o.update  rebuild ui5/openui5-entities.json from the
 *                            installed @openui5 sources instead of checking it
 * @returns {{ controls: object, inOpenUI5: (entity: string) => boolean }}
 */
export function openui5Membership({ ROOT, META, update = false }) {
// OpenUI5 membership oracle — DETERMINISTIC, reads only committed data: a
// control/entity is in OpenUI5 if it is a known control (ui5/properties.json,
// the offline control catalog) OR listed in ui5/openui5-entities.json (the
// committed snapshot of OpenUI5 entities that have no properties.json entry:
// statics/helpers like MessageBox/MessageToast/URLHelper, the sap.ui.model
// types, CSS-class doc entities). Entities in neither are "not in OpenUI5"
// (demo-kit-only patterns). The snapshot exists so the ui5_only flags come out
// identical with and without node_modules — the previous filesystem probe of
// node_modules/@openui5 made the generated class differ between environments
// (6 vs 25 flags), so the meta_valid drift gate and the pre-commit hook
// disagreed depending on whether npm ci had run. When the @openui5 packages
// ARE installed, the snapshot is cross-checked against their sources and a
// stale snapshot fails the run; rebuild it with --update-entities.
const OPENUI5_CONTROLS = loadPropertiesControls();
const ENTITIES_FILE = path.join(ROOT, 'ui5', 'openui5-entities.json');
const EXTRA_ENTITIES = new Set((() => {
  try { return JSON.parse(fs.readFileSync(ENTITIES_FILE, 'utf8')).entities || []; }
  catch { return []; }
})());
const OPENUI5_PKG = path.join(ROOT, 'node_modules', '@openui5');
const OPENUI5_LIBS = fs.existsSync(OPENUI5_PKG) ? fs.readdirSync(OPENUI5_PKG) : [];

// per-library text (library.js + .library manifest) - catches OpenUI5 entities
// that have no own module: statics/helpers (sap.m.URLHelper, in library.js) and
// CSS-class doc entities (sap.ui.core.StandardMargins/ContainerPadding, in .library)
const libTextCache = {};
function libText(lib) {
  if (libTextCache[lib] !== undefined) return libTextCache[lib];
  const base = path.join(OPENUI5_PKG, lib, 'src', lib.replace(/\./g, '/'));
  let t = '';
  for (const f of ['library.js', '.library']) {
    try { t += fs.readFileSync(path.join(base, f), 'utf8'); } catch { /* absent */ }
  }
  return (libTextCache[lib] = t);
}
function inOpenUI5(entity) {
  return !!OPENUI5_CONTROLS[entity] || EXTRA_ENTITIES.has(entity);
}
// source probe — used ONLY to build/verify ui5/openui5-entities.json, never to
// decide a flag directly (that would reintroduce the environment dependence)
function probeOpenUI5(entity) {
  const rel = entity.replace(/\./g, '/') + '.js';
  const wordRe = new RegExp('\\b' + entity.split('.').pop() + '\\b');
  return OPENUI5_LIBS.some((lib) =>
    fs.existsSync(path.join(OPENUI5_PKG, lib, 'src', rel)) || wordRe.test(libText(lib)));
}

// The list holds only entities that ui5/properties.json does NOT carry, so an
// entry can also fall out because the property snapshot grew to cover it -
// "no longer needed here" does not mean OpenUI5 dropped the control.
// --update-entities rebuilds the snapshot from the installed @openui5 sources;
// a plain run with node_modules present cross-checks the snapshot instead and
// fails when it is stale, so the committed verdicts can never silently drift
// from the sources they were derived from.
{
  const metaEntities = new Set();
  for (const mf of fs.readdirSync(META)) {
    if (!mf.endsWith('.json')) continue;
    const e = JSON.parse(fs.readFileSync(path.join(META, mf), 'utf8')).entity;
    if (e) metaEntities.add(e);
  }
  const UPDATE_ENTITIES = update;
  if (UPDATE_ENTITIES && !OPENUI5_LIBS.length) {
    console.error('--update-entities needs the installed @openui5 packages (run npm ci first).');
    process.exit(1);
  }
  if (OPENUI5_LIBS.length) {
    const probed = [...metaEntities]
      .filter((e) => !OPENUI5_CONTROLS[e] && probeOpenUI5(e))
      .sort();
    if (UPDATE_ENTITIES) {
      const note =
        'OpenUI5 entities with no ui5/properties.json entry (statics/helpers, sap.ui.model ' +
        'types, CSS-class doc entities). Read by generate-overview.mjs so the ui5_only flag ' +
        'is deterministic without node_modules. Never hand-edit - rebuild with: ' +
        'node scripts/generate-overview.mjs --update-entities';
      fs.writeFileSync(ENTITIES_FILE, JSON.stringify({ note, entities: probed }, null, 2) + '\n');
      EXTRA_ENTITIES.clear();
      for (const e of probed) EXTRA_ENTITIES.add(e);
      console.log(`openui5-entities.json: ${probed.length} entities`);
    } else {
      const missing = probed.filter((e) => !EXTRA_ENTITIES.has(e));
      const gone = [...EXTRA_ENTITIES].filter((e) => metaEntities.has(e) && !probed.includes(e));
      if (missing.length || gone.length) {
        console.error(
          `ui5/openui5-entities.json is stale (missing: ${missing.join(', ') || '-'}; ` +
            `no longer needed here: ${gone.join(', ') || '-'}) - ` +
            'rebuild with: node scripts/generate-overview.mjs --update-entities'
        );
        process.exit(1);
      }
    }
  }
}

return { controls: OPENUI5_CONTROLS, inOpenUI5 };
}
