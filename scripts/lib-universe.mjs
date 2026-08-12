/*
 * lib-universe — the shared loaders for the committed UI5 scope/metadata
 * snapshots under ui5/, plus the scope helpers built on them. One source for
 * what used to be duplicated across generate-coverage.mjs,
 * generate-overview.mjs, scope-of.mjs and generate-status.mjs — the verdicts
 * (scope, since-fallback, non-app families) must stay identical everywhere,
 * and a copy per script is how they drift.
 *
 * Pure loaders: same fallbacks as the originals (a missing optional file is
 * an empty collection, never an error); the universe SNAPSHOT is required by
 * its callers and stays their decision (generate-coverage can also REBUILD it
 * from an OpenUI5 checkout — that path stays there).
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

export const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const UI5 = path.join(ROOT, 'ui5');

const readJson = (file, fallback) => {
  if (!fs.existsSync(file)) return fallback;
  try { return JSON.parse(fs.readFileSync(file, 'utf8')); } catch { return fallback; }
};

/** ui5/universe.json parsed, or null when the snapshot is absent. */
export function loadUniverseSnapshot() {
  const p = path.join(UI5, 'universe.json');
  return fs.existsSync(p) ? JSON.parse(fs.readFileSync(p, 'utf8')) : null;
}
export const UNIVERSE_SNAPSHOT_PATH = path.join(UI5, 'universe.json');

/** ui5/properties.json -> the control catalog ({} when absent/unreadable). */
export function loadPropertiesControls() {
  return readJson(path.join(UI5, 'properties.json'), {}).controls || {};
}

/** ui5/entity-overrides.json -> sample id -> owning entity ({} when absent). */
export function loadEntityOverrides() {
  return readJson(path.join(UI5, 'entity-overrides.json'), {}).overrides || {};
}

/** ui5/scope-nonapp.json -> the non-app sample families ([] when absent). */
export function loadNonAppFamilies() {
  return readJson(path.join(UI5, 'scope-nonapp.json'), {}).families || [];
}

/** ui5/universe-excludes.json -> Set("<lib>\t<name>") ([] when absent). */
export function loadUniverseExcludes() {
  return new Set(
    (readJson(path.join(UI5, 'universe-excludes.json'), {}).excludes || [])
      .map((e) => `${e.lib}\t${e.name}`));
}

/** The matching non-app family (with its reason) or null — the ONE matcher
 *  behind both generate-coverage's scopeOf and scope-of.mjs's verdict. */
export function nonAppFamilyFor(families, { lib, name, entity }) {
  return families.find((f) =>
    (!f.lib || f.lib === lib)
    && (!f.entityPrefix || (entity || '').startsWith(f.entityPrefix))
    && (!f.namePrefix || (name || '').startsWith(f.namePrefix))
    && (f.entityPrefix || f.namePrefix)) || null;
}

/** The porting scope line (AGENTS.md §1): a control is old enough when it
 *  existed by UI5 1.71 (empty since = older than tracking). */
export const sinceLeq171 = (since) => {
  if (!since) return true;
  const m = String(since).match(/^(\d+)\.(\d+)/);
  return m ? (+m[1] < 1 || (+m[1] === 1 && +m[2] <= 71)) : false;
};

/** Fill a universe sample's null since/deprecated from the control-level
 *  source scan (ui5/properties.json) — returns an enriched copy. */
export function enrichFromProperties(controls, s) {
  const c = s.entity && controls[s.entity];
  if (!c) return s;
  return {
    ...s,
    since: s.since || c.since || null,
    deprecated: s.deprecated || c.deprecated || null,
  };
}
