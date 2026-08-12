/**
 * The src/ package scheme — shared by scaffold.mjs (where a new port is filed)
 * and validate-meta.mjs (the gate that keeps it true).
 *
 * A port's path is src/<category>/<library>/<class>.clas.abap:
 *
 *   category — UI5 flavour x release, derived from the port's own meta sidecar
 *              (AGENTS §3): the flavour from the libraries the port touches,
 *              the release from whether it keeps a post-1.71 member (a POST_171
 *              deviation). Both facts live in the sidecar, so the category is a
 *              pure function of it — no OpenUI5 checkout needed.
 *   library  — the second-level namespace of the SAMPLE (`sap.m.sample.X` ->
 *              sap.m), the same key generate-overview/-coverage group by. It is
 *              not always the entity's library: `sap.m.sample.ContainerNoPadding`
 *              documents a sap.ui.core entity and still belongs to sap.m.
 *              Numbered once and globally — a library keeps its number in every
 *              category folder.
 */

// second-level namespace -> library package number. One registry for all four
// category folders, so sap.m is `01` under src/01 and under src/02 alike.
const LIB_FOLDER = [
  [/^sap\.m(\.|$)/, '01'],
  [/^sap\.ui(\.|$)/, '02'], // sap.ui.core, .layout, .unified, .table, .integration, .codeeditor, .model.type, and SAPUI5's .comp / .vbm
  [/^sap\.uxap(\.|$)/, '03'],
  [/^sap\.f(\.|$)/, '04'],
  [/^sap\.tnt(\.|$)/, '05'],
  [/^sap\.suite(\.|$)/, '06'],
  [/^sap\.viz(\.|$)/, '07'],
  [/^sap\.gantt(\.|$)/, '08'],
  [/^sap\.ndc(\.|$)/, '09'],
];

const LIB_CTEXT = {
  '01': 'sap.m',
  '02': 'sap.ui',
  '03': 'sap.uxap',
  '04': 'sap.f',
  '05': 'sap.tnt',
  '06': 'sap.suite',
  '07': 'sap.viz',
  '08': 'sap.gantt',
  '09': 'sap.ndc',
};

// libraries that ship with SAPUI5 only — a port using one of them is outside
// the OpenUI5 checkout the property gate and the render smoke are built on.
const SAPUI5_ONLY =
  /^(sap\.suite(\.|$)|sap\.viz(\.|$)|sap\.gantt(\.|$)|sap\.ndc(\.|$)|sap\.ushell(\.|$)|sap\.collaboration(\.|$)|sap\.me(\.|$)|sap\.ui\.comp(\.|$)|sap\.ui\.vbm(\.|$)|sap\.ui\.generic(\.|$))/;

const CAT_CTEXT = {
  '01': 'OpenUI5 <= 1.71',
  '02': 'OpenUI5 > 1.71',
  '03': 'SAPUI5 <= 1.71',
  '04': 'SAPUI5 > 1.71',
};

/** the sample's own library — "sap.m.sample.CheckBoxTriState" -> "sap.m" */
export function sampleLib(sample) {
  const s = String(sample || '');
  const i = s.indexOf('.sample.');
  return i === -1 ? s : s.slice(0, i);
}

/** library package number for a namespace ("sap.m" / "sap.m.CheckBox" -> "01"), or null */
export function libFolder(ns) {
  for (const [re, nr] of LIB_FOLDER) if (re.test(String(ns || ''))) return nr;
  return null;
}

export function isSapui5Only(ns) {
  return SAPUI5_ONLY.test(String(ns || ''));
}

/** a port keeps a member newer than 1.71 — every one of them is a POST_171 deviation */
export function isPost171(meta) {
  return (meta.deviations || []).some((d) => d.type === 'POST_171');
}

/** category package number for a meta sidecar ("01".."04") */
export function catFolder(meta) {
  const sapui5 = isSapui5Only(sampleLib(meta.sample)) || isSapui5Only(meta.entity);
  return String((sapui5 ? 2 : 0) + (isPost171(meta) ? 1 : 0) + 1).padStart(2, '0');
}

/** the repo-relative path a port must live at, or null when the library is unknown */
export function portPath(meta) {
  const lib = libFolder(sampleLib(meta.sample));
  return lib ? `src/${catFolder(meta)}/${lib}/${meta.class}.clas.abap` : null;
}

export { LIB_CTEXT, CAT_CTEXT, LIB_FOLDER, SAPUI5_ONLY };
