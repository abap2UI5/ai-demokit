/*
 * lib-smoke — the boot-noise contract of the e2e smoke gate, importable.
 *
 * Page-error (real JS exception) messages that are environment noise, not
 * port defects. Resource 404/500s are handled separately by response URL (a
 * localhost:3000 backend asset failing is real; an unbundled-UI5 resource we
 * didn't serve is benign) — the console "Failed to load resource" line
 * carries no URL, so it is ignored in favour of response tracking.
 *
 * This is the single source of the list: e2e-smoke.mjs consumes it here, and
 * the ai-mcp server imports this file from its resolved ai-demokit checkout
 * so its run_app tool judges boots by the same rules as the nightly gate.
 */
export const BENIGN = [
  /library-preload/i, /messagebundle/i, /i18n/i, /themes?\/|library(\.css|-parameters)/i,
  /theming\.Parameters|\.properties/i, /failed to load (javascript )?resource/i,
  /Core\.applyTheme|sap\.ui\.getCore/i, /favicon/i, /deprecat/i, /sap-ui-cachebuster/i,
  /ERR_TUNNEL_CONNECTION_FAILED/i,
];

export const benign = (s) => BENIGN.some((re) => re.test(s));
