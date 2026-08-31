# pr/open-abap-xml-escaping — `CALL TRANSFORMATION id` must escape XML character data

**Status: open upstream** — filed against
[open-abap/open-abap-core](https://github.com/open-abap/open-abap-core), not
abap2UI5. Worked around in this repo by a build-time patch
(`web/ci/patch_open_abap_xml.mjs`), applied by both transpiled builds — the
GitHub Pages demo (`web/`) and the Node e2e backend (`scripts/e2e-build.mjs`).
Delete this folder once the fix is upstream and the patch can go.

## Motivation

On the in-browser demo
(<https://abap2ui5.github.io/samples-controls/?app_start=z2ui5_cl_ai_app_overview>)
every backend round-trip of the overview app died with

```
Network error: ASSERTION_FAILED
```

— reported by a user 2026-07-31 for the row buttons that open the links and
the generation-notes popover (the app's only two `client->_event( )` wires;
everything else in the overview is frontend-only). The same failure was
recorded on the Node e2e backend on 2026-07-27 and written off as an
"open-abap runtime limit" (STATUS-history: *"the overview cannot do a second
roundtrip … reloading its own draft dies in the transpiled `cl_ixml` parse"*).
It is not a limit — it is a serializer bug, and it hits **every** app whose
model data contains a `<`.

## Current behavior

`KERNEL_CALL_TRANSFORMATION`'s `LCL_DATA_TO_XML->RUN`
([`src/kernel/call_transformation/kernel_call_transformation.clas.locals_imp.abap`](https://github.com/open-abap/open-abap-core/blob/main/src/kernel/call_transformation/kernel_call_transformation.clas.locals_imp.abap))
builds the result XML by string concatenation and writes element values **raw**:

```abap
      WHEN cl_abap_typedescr=>kind_elem.
        ...
          rv_xml = rv_xml &&
            |<{ iv_name }>| &&
            <ref> &&              " <-- not escaped
            |</{ iv_name }>|.
```

abap2UI5 persists its app state with exactly that statement
(`z2ui5_cl_a2ui5_context=>xml_stringify` → `CALL TRANSFORMATION id … RESULT XML`,
stored by `Z2UI5_CL_CORE_APP=>DB_SAVE`). The overview app's `NOTES` column
carries deviation texts such as `… menuPosition (1.56) … are <= 1.71`, so the
draft ends up containing

```xml
<NOTES>POST-1.71: … are <= 1.71. // IMPROVISED: …</NOTES>
```

On the next request `DB_LOAD` parses that string back with the transpiled
`CL_IXML`. Its parser
([`src/ixml/cl_ixml.clas.locals_imp.abap`](https://github.com/open-abap/open-abap-core/blob/main/src/ixml/cl_ixml.clas.locals_imp.abap),
`LCL_PARSER->IF_IXML_PARSER~PARSE`) sees the stray `<` as the start of a tag,
its tag regex does not match at offset 0 and it dies in

```abap
        FIND REGEX lc_regex_tag IN lv_xml RESULTS ls_match.
        ASSERT ls_match-offset = 0.
```

An `ASSERT` is not catchable in the JS runtime, so the `TRY … CATCH cx_root`
around the draft load cannot absorb it: the whole round-trip 500s and the
frontend renders the generic `Network error: ASSERTION_FAILED`. On a real ABAP
server asXML escapes the value and the identical app works — which is why this
only ever showed in the transpiled builds.

Second, smaller defect on the read side: `LCL_ESCAPE=>UNESCAPE_VALUE` replaces
`&amp;` **first**, so a value that literally contains `&lt;` comes back as `<`.

## Proposed change

1. Escape `&`, `<` and `>` in element character data on write
   (`LCL_DATA_TO_XML->RUN`, `kind_elem` branch).
2. Unescape `&amp;` **last** in `LCL_ESCAPE=>UNESCAPE_VALUE`.

The exact patch this repo applies (transpiler-friendly ABAP, escaping only
values that carry one of the three characters, so every other value serializes
byte-identically to today) is in
[`web/ci/patch_open_abap_xml.mjs`](../../web/ci/patch_open_abap_xml.mjs).

## Example

```abap
DATA lv_xml TYPE string.
DATA(ls_data) = VALUE ty_s( text = `a <= b` ).

CALL TRANSFORMATION id SOURCE data = ls_data RESULT XML lv_xml.
" today:  <TEXT>a <= b</TEXT>       -> CL_IXML parse: ASSERTION_FAILED
" wanted: <TEXT>a &lt;= b</TEXT>    -> parses back to `a <= b`

CALL TRANSFORMATION id SOURCE XML lv_xml RESULT data = ls_data.
```

A regression test belongs next to the existing round-trip tests in
`kernel_call_transformation.clas.testclasses.abap`.
