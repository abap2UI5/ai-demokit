// Pre-transpile patch: make the open-abap `CALL TRANSFORMATION id` writer
// XML-escape character data.
//
// Runs against a checkout of https://github.com/open-abap/open-abap-core
// (the transpiler lib the browser build and the Node e2e backend both stand
// on), before `abap_transpile` reads it — the config points at the patched
// folder instead of cloning the lib itself.
//
// Why: KERNEL_CALL_TRANSFORMATION's LCL_DATA_TO_XML builds the result XML by
// plain string concatenation and writes every element value RAW:
//
//     rv_xml = rv_xml && |<{ iv_name }>| && <ref> && |</{ iv_name }>|.
//
// So an app data field holding a `<` (the overview app's generation notes:
// "... are <= 1.71", "<strong>", the deprecated-control `<del>` markup) lands
// unescaped in the draft XML that Z2UI5_CL_CORE_APP=>DB_SAVE persists. On the
// next request DB_LOAD parses that XML back with the transpiled CL_IXML, whose
// parser sees the stray `<` as the start of a tag, fails its tag regex and
// dies in `ASSERT ls_match-offset = 0` — an ASSERT is not catchable in the JS
// runtime, so the whole roundtrip 500s and the frontend shows
// "Network error: ASSERTION_FAILED". On a real ABAP server asXML escapes the
// value and the same app works, which is why this only ever bit the
// transpiled builds (GitHub Pages demo + `npm run e2e`).
//
// Two edits, both written in the same transpiler-friendly ABAP subset the lib
// itself uses:
//   1. escape `&`, `<`, `>` in element character data on write (only when the
//      value carries one of them, so every other value serializes byte-identical
//      to before);
//   2. unescape `&amp;` LAST on read (CL_IXML replaced it first, so a value
//      that literally contains `&lt;` came back as `<`).
import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const WRITE_FILE = "src/kernel/call_transformation/kernel_call_transformation.clas.locals_imp.abap";
const READ_FILE = "src/ixml/cl_ixml.clas.locals_imp.abap";

// --- 1. escape on write (LCL_DATA_TO_XML->RUN, kind_elem branch) -------------
const WRITE_ANCHOR = `        IF lo_type->type_kind = cl_abap_typedescr=>typekind_string AND <ref> IS INITIAL.
          rv_xml = rv_xml && |<{ iv_name }/>|.
        ELSE.
          rv_xml = rv_xml &&
            |<{ iv_name }>| &&
            <ref> &&
            |</{ iv_name }>|.
        ENDIF.`;

const WRITE_PATCH = `        IF lo_type->type_kind = cl_abap_typedescr=>typekind_string AND <ref> IS INITIAL.
          rv_xml = rv_xml && |<{ iv_name }/>|.
        ELSE.
* Patch for the transpiled abap2UI5 builds (web/ci/patch_open_abap_xml.mjs):
* XML-escape character data. Without it a data value containing "<" (or "&")
* produces XML that CL_IXML cannot parse back - the draft roundtrip then dies
* in an uncatchable ASSERT ("Network error: ASSERTION_FAILED").
          lv_escaped = <ref>.
          IF lv_escaped CA '&<>'.
            REPLACE ALL OCCURRENCES OF '&' IN lv_escaped WITH '&amp;'.
            REPLACE ALL OCCURRENCES OF '<' IN lv_escaped WITH '&lt;'.
            REPLACE ALL OCCURRENCES OF '>' IN lv_escaped WITH '&gt;'.
            rv_xml = rv_xml &&
              |<{ iv_name }>| &&
              lv_escaped &&
              |</{ iv_name }>|.
          ELSE.
            rv_xml = rv_xml &&
              |<{ iv_name }>| &&
              <ref> &&
              |</{ iv_name }>|.
          ENDIF.
        ENDIF.`;

// the local variable the patch above needs, declared with RUN's other DATA
const DATA_ANCHOR = `    DATA lv_ref   TYPE REF TO data.

    FIELD-SYMBOLS <any>   TYPE any.`;
const DATA_PATCH = `    DATA lv_ref   TYPE REF TO data.
    DATA lv_escaped TYPE string.

    FIELD-SYMBOLS <any>   TYPE any.`;

// --- 2. unescape "&amp;" last on read (LCL_ESCAPE=>UNESCAPE_VALUE) ----------
const READ_ANCHOR = `    REPLACE ALL OCCURRENCES OF '&amp;' IN rv_value WITH '&'.
    REPLACE ALL OCCURRENCES OF '&lt;' IN rv_value WITH '<'.
    REPLACE ALL OCCURRENCES OF '&gt;' IN rv_value WITH '>'.
    REPLACE ALL OCCURRENCES OF '&quot;' IN rv_value WITH '"'.
    REPLACE ALL OCCURRENCES OF '&apos;' IN rv_value WITH |'|.`;

const READ_PATCH = `    REPLACE ALL OCCURRENCES OF '&lt;' IN rv_value WITH '<'.
    REPLACE ALL OCCURRENCES OF '&gt;' IN rv_value WITH '>'.
    REPLACE ALL OCCURRENCES OF '&quot;' IN rv_value WITH '"'.
    REPLACE ALL OCCURRENCES OF '&apos;' IN rv_value WITH |'|.
* Patched (web/ci/patch_open_abap_xml.mjs): "&amp;" must be unescaped LAST,
* otherwise a value that literally contains "&lt;" comes back as "<".
    REPLACE ALL OCCURRENCES OF '&amp;' IN rv_value WITH '&'.`;

function patch(file, edits) {
  if (!existsSync(file)) {
    throw new Error(`patch_open_abap_xml: ${file} not found - is the open-abap-core clone complete?`);
  }
  let src = readFileSync(file, "utf8");
  for (const [anchor, replacement, note] of edits) {
    if (src.includes(replacement)) continue; // already patched (re-runnable)
    if (!src.includes(anchor)) {
      throw new Error(`patch_open_abap_xml: anchor not found in ${file} (${note}) - open-abap-core changed?`);
    }
    src = src.replace(anchor, replacement);
  }
  writeFileSync(file, src);
}

export function patchOpenAbapXml(root) {
  patch(join(root, WRITE_FILE), [
    [DATA_ANCHOR, DATA_PATCH, "LCL_DATA_TO_XML->RUN declarations"],
    [WRITE_ANCHOR, WRITE_PATCH, "LCL_DATA_TO_XML->RUN kind_elem branch"],
  ]);
  patch(join(root, READ_FILE), [
    [READ_ANCHOR, READ_PATCH, "LCL_ESCAPE=>UNESCAPE_VALUE"],
  ]);
  console.log(`patch_open_abap_xml: XML escaping patched in ${root}`);
}

// CLI: node patch_open_abap_xml.mjs [path-to-open-abap-core]
if (process.argv[1] && fileURLToPath(import.meta.url) === resolve(process.argv[1])) {
  patchOpenAbapXml(process.argv[2] || fileURLToPath(new URL("../open-abap-core", import.meta.url)));
}
