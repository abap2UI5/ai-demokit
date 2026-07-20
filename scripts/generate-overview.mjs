#!/usr/bin/env node
/*
 * Generates the in-system overview app src/z2ui5_cl_ai_app_overview.clas.*
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
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const SRC = path.join(ROOT, 'src');
const META = path.join(ROOT, 'meta');
const CLASS = 'z2ui5_cl_ai_app_overview';
const OUT_ABAP = path.join(SRC, `${CLASS}.clas.abap`);
const OUT_XML = path.join(SRC, `${CLASS}.clas.xml`);

function walk(dir, out = []) {
  for (const name of fs.readdirSync(dir)) {
    const full = path.join(dir, name);
    if (fs.statSync(full).isDirectory()) walk(full, out);
    else out.push(full);
  }
  return out;
}

// control availability from the sample-universe snapshot (same source as the
// coverage docs): the release a control appeared in + whether it is deprecated
const uni = JSON.parse(fs.readFileSync(path.join(ROOT, 'ui5', 'universe.json'), 'utf8'));
const uniMap = new Map();
for (const lib of uni.libs) for (const s of lib.samples) uniMap.set(`${lib.lib}|${s.name}`, s);

// collect ported apps: control (entity), module (library), sample name, class,
// and the repo-relative path of the generated class (for the ABAP GitHub link)
const apps = [];
const DEV_LABEL = { IMPROVISED: 'IMPROVISED', POST_171: 'POST-1.71', LIVE_TEST: 'LIVE-TEST', DROPPED_171: '1.71', SUBSET_DATA: 'SUBSET', NOTE: 'NOTE' };
for (const mf of fs.readdirSync(META)) {
  if (!mf.endsWith('.json')) continue;
  const m = JSON.parse(fs.readFileSync(path.join(META, mf), 'utf8'));
  const i = m.sample.indexOf('.sample.');
  if (i === -1) continue;
  const module = m.sample.slice(0, i);
  const name = m.sample.slice(i + '.sample.'.length);
  const u = uniMap.get(`${module}|${name}`) || {};
  const dep = u.deprecated || null;
  apps.push({
    module,
    control: m.entity,
    name,
    cls: m.class,
    file: m.file,
    checked: m.checked ? `CHECKED (${m.checked.date}): ${m.checked.note}` : '',
    notes: (m.deviations || []).map((d) => `${DEV_LABEL[d.type] ?? d.type}: ${d.what}`).join(' // '),
    post171: (m.deviations || []).filter((d) => d.type === 'POST_171').map((d) => d.what).join(' // '),
    golden: m.status === 'golden',
    since: u.since || '',
    dep_text: dep ? `Deprecated since ${dep.since}: ${dep.text}` : '',
  });
}
// order by module, then control, then sample name (case-insensitive)
apps.sort((a, b) =>
  a.module.toLowerCase().localeCompare(b.module.toLowerCase()) ||
  a.control.toLowerCase().localeCompare(b.control.toLowerCase()) ||
  a.name.toLowerCase().localeCompare(b.name.toLowerCase()));

// aligned VALUE #( ) rows — only the generation-time facts; the URLs are built
// at runtime in view_display (the abap2UI5 start URL needs the system origin)
const w = (k) => Math.max(...apps.map((a) => a[k].length));
const wm = w('module'), wc = w('control'), wn = w('name'), wl = w('cls'), wf = w('file');
// render a string as an ABAP backtick literal, splitting long text with && to stay < 255 cols
const abapStr = (s) => {
  const q = (x) => '`' + x + '`';
  const esc = s.replace(/`/g, '``');
  if (esc.length <= 200) return q(esc);
  const parts = [];
  let rest = esc;
  while (rest.length > 200) {
    let cut = rest.lastIndexOf(' ', 200);
    if (cut < 100) cut = 200;
    // never split a doubled backtick escape across two literals: if an odd
    // number of consecutive backticks ends at the cut, shift the cut past the pair
    let bt = 0;
    while (bt < cut && rest[cut - 1 - bt] === '`') bt++;
    if (bt % 2 === 1) cut++;
    parts.push(rest.slice(0, cut));
    rest = rest.slice(cut);
  }
  if (rest) parts.push(rest);
  return parts.map(q).join(' &&\n                 ');
};
const rows = apps.map((a) => {
  const base =
    `      ( module = \`${a.module}\`${' '.repeat(wm - a.module.length)}` +
    ` control = \`${a.control}\`${' '.repeat(wc - a.control.length)}` +
    ` name = \`${a.name}\`${' '.repeat(wn - a.name.length)}` +
    ` class = \`${a.cls}\`${' '.repeat(wl - a.cls.length)}` +
    ` path = \`${a.file}\`${' '.repeat(wf - a.file.length)}`;
  const extras = [];
  if (a.golden) extras.push('golden = abap_true');
  if (a.since) extras.push(`since = \`${a.since}\``);
  if (a.dep_text) extras.push(`dep_text = ${abapStr(a.dep_text)}`);
  if (a.checked) extras.push(`checked = ${abapStr(a.checked)}`);
  if (a.notes) extras.push(`notes = ${abapStr(a.notes)}`);
  if (a.post171) extras.push(`post171 = ${abapStr(a.post171)}`);
  return extras.length ? `${base}\n        ${extras.join('\n        ')} )` : `${base} )`;
});

// the Tree view's nested model is built in ABAP (build_tree) from the filtered
// app list, so the search filters the tree as well as the table.

// --- client-side (roundtrip-free) filter & sort, both via cs_event-binding_call
// wired through _event_client (see abap2UI5 z2ui5_if_client / FrontendAction.js):
// the value/direction is resolved on the frontend, the model stays untouched. ---
const ID_TABLE = 'idOverviewTable';
// a Contains filter on the FILTER blob column; valExpr is a client-resolved
// $-expression (the search field's newValue/query). Empty value clears it.
const filterCall = (valExpr) =>
  'client->_event_client( val = client->cs_event-binding_call' +
  ` t_arg = VALUE #( ( \`${ID_TABLE}\` ) ( \`items\` ) ( \`filter\` ) ( \`FILTER\` ) ( \`Contains\` ) ( \`${valExpr}\` ) ) )`;
// a Sorter on one column path; descending passes the abap_bool `X`, ascending omits it
const sortCall = (path, desc) =>
  'client->_event_client( val = client->cs_event-binding_call' +
  ` t_arg = VALUE #( ( \`${ID_TABLE}\` ) ( \`items\` ) ( \`sort\` ) ( \`${path}\` )${desc ? ' ( `X` )' : ''} ) )`;

// a sortable column: header label + ascending/descending sort icons (client-side)
const sortableColumn = (label, path) => `                        )->open( \`Column\`
                            )->open( \`HBox\`
                                )->a( n = \`alignItems\` v = \`Center\`

                                )->leaf( \`Text\`
                                    )->a( n = \`text\` v = \`${label}\`
                                )->leaf( \`core:Icon\`
                                    )->a( n = \`src\`     v = \`sap-icon://sort-ascending\`
                                    )->a( n = \`tooltip\` v = \`Sort by ${label} ascending\`
                                    )->a( n = \`class\`   v = \`sapUiTinyMarginBegin\`
                                    )->a( n = \`press\`   v = ${sortCall(path, false)}
                                )->leaf( \`core:Icon\`
                                    )->a( n = \`src\`     v = \`sap-icon://sort-descending\`
                                    )->a( n = \`tooltip\` v = \`Sort by ${label} descending\`
                                    )->a( n = \`press\`   v = ${sortCall(path, true)}

                            )->shut(
                        )->shut(`;
// a plain (non-sortable) column: header label only, plus optional Column attrs
const plainColumn = (label, attrs = []) => {
  const attrLines = attrs.map(([n, v]) => `                            )->a( n = \`${n}\` v = \`${v}\``).join('\n');
  const head = attrs.length
    ? `                        )->open( \`Column\`\n${attrLines}\n\n                            )->leaf( \`Text\``
    : `                        )->open( \`Column\`\n                            )->leaf( \`Text\``;
  return `${head}\n                                )->a( n = \`text\` v = \`${label}\`\n\n                        )->shut(`;
};
// column order (mirrored 1:1 by the cells below): Since sits after Control,
// Note + Open are the trailing non-sortable columns
const columnsBlock = [
  sortableColumn('Module', 'MODULE'),
  sortableColumn('Control', 'CTRL_NAME'),
  plainColumn('Since', [['width', '6rem']]),
  sortableColumn('Sample', 'NAME'),
  sortableColumn('abap2UI5', 'CLASS'),
  plainColumn('Note'),
  plainColumn('Open', [['width', '5rem'], ['hAlign', 'Center']]),
].join('\n');

const abap = `"! Generated overview app - lists every abap2UI5 api sample app in a table.
"! A Switch in the header toggles between the table and a module -> control ->
"! sample tree (sap.m.Tree, expanded by default) showing the same samples - both
"! views are bound and their visibility is an expression binding over the two-way
"! show_tree flag, so the toggle runs entirely on the client (no round-trip). The
"! search field filters the table on the client (binding_call Contains, no
"! round-trip); the tree is not filtered. Each tree leaf has the same jump
"! popover as the table's Open column.
"! The Since column shows the UI5 release the control appeared in (from
"! ui5/universe.json; blank when older than tracking). Text is never coloured;
"! a deprecated control's name is struck through (FormattedText htmlText, so the
"! strikethrough can vary per row).
"! The Module / Control / Sample / abap2UI5 columns are plain text; every link
"! (OpenUI5 API, OpenUI5 source, live fullscreen sample, the generated ABAP
"! class on GitHub, and starting the app) lives in the trailing Open column: its
"! button opens an anchored popover of all those links, each opening in a new
"! browser tab. The Note column shows a gold star for golden ports (live-checked
"! and exemplary), a green check when the port was manually verified in a
"! running system, and a hint icon that opens a popup with the port's generation
"! caveats when present. The search field above the table filters all rows by a
"! substring over every column, and each column header carries ascending/
"! descending sort icons - both run entirely on the frontend
"! (cs_event-binding_call via _event_client, no server round-trip). Do not edit
"! by hand - regenerate with scripts/generate-overview.mjs
CLASS ${CLASS} DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_app,
        module    TYPE string,
        control   TYPE string,
        ctrl_name TYPE string,
        name      TYPE string,
        class     TYPE string,
        path      TYPE string,
        api_url   TYPE string,
        js_url    TYPE string,
        ui5_url   TYPE string,
        abap_url  TYPE string,
        start_url TYPE string,
        checked   TYPE string,
        has_check TYPE abap_bool,
        notes     TYPE string,
        has_notes TYPE abap_bool,
        post171   TYPE string,
        has_p171  TYPE abap_bool,
        golden    TYPE abap_bool,
        since     TYPE string,
        dep_text  TYPE string,
        ctrl_html TYPE string,
        filter    TYPE string,
      END OF ty_s_app.
    TYPES ty_t_app TYPE STANDARD TABLE OF ty_s_app WITH EMPTY KEY.

    " nested tree model (module -> control -> sample); sap.m.Tree recurses on the
    " nodes tables. The sample leaves carry the same links as the table's Open column
    TYPES:
      BEGIN OF ty_s_sample,
        text      TYPE string,
        api_url   TYPE string,
        js_url    TYPE string,
        ui5_url   TYPE string,
        abap_url  TYPE string,
        start_url TYPE string,
        has_link  TYPE abap_bool,
      END OF ty_s_sample,
      BEGIN OF ty_s_control,
        text  TYPE string,
        nodes TYPE STANDARD TABLE OF ty_s_sample WITH EMPTY KEY,
      END OF ty_s_control,
      BEGIN OF ty_s_module,
        text  TYPE string,
        nodes TYPE STANDARD TABLE OF ty_s_control WITH EMPTY KEY,
      END OF ty_s_module.
    TYPES ty_t_tree TYPE STANDARD TABLE OF ty_s_module WITH EMPTY KEY.

    DATA t_app TYPE ty_t_app.
    DATA t_tree TYPE ty_t_tree.
    " table/tree toggle (drives the visible expression bindings)
    DATA show_tree TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS get_catalog
      RETURNING
        VALUE(result) TYPE ty_t_app.
    METHODS build_tree
      IMPORTING
        it_app        TYPE ty_t_app
      RETURNING
        VALUE(result) TYPE ty_t_tree.

  PRIVATE SECTION.
ENDCLASS.


CLASS ${CLASS} IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN \`LINKS\`.
        " every navigation link for the pressed row, resolved client-side and
        " passed in via t_arg; open them in an anchored popover (by the button id)
        DATA(lv_api)   = client->get_event_arg( ).
        DATA(lv_js)    = client->get_event_arg( 2 ).
        DATA(lv_ui5)   = client->get_event_arg( 3 ).
        DATA(lv_abap)  = client->get_event_arg( 4 ).
        DATA(lv_start) = client->get_event_arg( 5 ).

        DATA(links) = z2ui5_cl_ai_xml=>factory( ).
        links->open( n = \`FragmentDefinition\` ns = \`core\`
            )->a( n = \`xmlns\`      v = \`sap.m\`
            )->a( n = \`xmlns:core\` v = \`sap.ui.core\`

            )->open( \`Popover\`
                )->a( n = \`title\`       v = \`Open in a new tab\`
                )->a( n = \`placement\`   v = \`Auto\`
                )->a( n = \`contentWidth\` v = \`22rem\`

                )->open( \`VBox\`
                    )->a( n = \`class\` v = \`sapUiContentPadding\`

                    )->leaf( \`Link\`
                        )->a( n = \`text\`   v = \`Control - OpenUI5 API reference\`
                        )->a( n = \`href\`   v = lv_api
                        )->a( n = \`target\` v = \`_blank\`
                        )->a( n = \`class\`  v = \`sapUiTinyMarginBottom\`
                    )->leaf( \`Link\`
                        )->a( n = \`text\`   v = \`Sample - OpenUI5 source\`
                        )->a( n = \`href\`   v = lv_js
                        )->a( n = \`target\` v = \`_blank\`
                        )->a( n = \`class\`  v = \`sapUiTinyMarginBottom\`
                    )->leaf( \`Link\`
                        )->a( n = \`text\`   v = \`Sample - live fullscreen runner\`
                        )->a( n = \`href\`   v = lv_ui5
                        )->a( n = \`target\` v = \`_blank\`
                        )->a( n = \`class\`  v = \`sapUiTinyMarginBottom\`
                    )->leaf( \`Link\`
                        )->a( n = \`text\`   v = \`abap2UI5 - class on GitHub\`
                        )->a( n = \`href\`   v = lv_abap
                        )->a( n = \`target\` v = \`_blank\`
                        )->a( n = \`class\`  v = \`sapUiTinyMarginBottom\`
                    )->leaf( \`Link\`
                        )->a( n = \`text\`   v = \`abap2UI5 - start this app\`
                        )->a( n = \`href\`   v = lv_start
                        )->a( n = \`target\` v = \`_blank\` ).

        client->popover_display( xml   = links->stringify( )
                                 by_id = client->get_event_arg( 6 ) ).

      WHEN \`SHOW_NOTES\`.
        " one Text per bullet of the clicked row's generation notes
        SPLIT client->get_event_arg( ) AT \` // \` INTO TABLE DATA(lt_line).

        DATA(popup) = z2ui5_cl_ai_xml=>factory( ).
        DATA(box) = popup->open( n = \`FragmentDefinition\` ns = \`core\`
            )->a( n = \`xmlns\`      v = \`sap.m\`
            )->a( n = \`xmlns:core\` v = \`sap.ui.core\`

            )->open( \`Dialog\`
                )->a( n = \`title\`        v = \`Generation notes\`
                )->a( n = \`contentWidth\` v = \`34rem\`

                )->open( \`VBox\`
                    )->a( n = \`class\` v = \`sapUiContentPadding\` ).

        LOOP AT lt_line INTO DATA(lv_line).
          box->leaf( \`Text\`
              )->a( n = \`text\` v = lv_line ).
        ENDLOOP.

        box->shut( )->open( \`endButton\`
            )->leaf( \`Button\`
                )->a( n = \`text\`  v = \`Close\`
                )->a( n = \`press\` v = client->_event_client( client->cs_event-popup_close ) ).

        client->popup_display( popup->stringify( ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    " base url to launch an abap2UI5 app in a new browser tab
    DATA(start) = |{ client->get( )-s_config-origin }{ client->get( )-s_config-pathname }?app_start=|.

    t_app = get_catalog( ).
    LOOP AT t_app ASSIGNING FIELD-SYMBOL(<app>).

      DATA(libpath) = replace( val = <app>-module
                               sub = \`.\`
                               with = \`/\`
                               occ = 0 ).

      " display only the bare control, without its namespace (sap.f.GridList -> GridList)
      DATA(dot) = find( val = <app>-control sub = \`.\` occ = -1 ).
      <app>-ctrl_name = COND #( WHEN dot >= 0 THEN substring( val = <app>-control off = dot + 1 ) ELSE <app>-control ).

      <app>-api_url   = |https://sdk.openui5.org/api/{ <app>-control }|.
      <app>-js_url    = |https://github.com/SAP/openui5/tree/master/src/{ <app>-module }| &&
                        |/test/{ libpath }/demokit/sample/{ <app>-name }|.
      <app>-ui5_url   = |https://sdk.openui5.org/resources/sap/ui/documentation/sdk/index.html| &&
                        |?sap-ui-xx-sample-id={ <app>-module }.sample.{ <app>-name }| &&
                        |&sap-ui-xx-sample-lib={ <app>-module }|.
      <app>-abap_url  = |https://github.com/abap2UI5/api/blob/main/{ <app>-path }|.
      <app>-start_url = |{ start }{ to_upper( <app>-class ) }|.
      <app>-has_check = xsdbool( <app>-checked IS NOT INITIAL ).
      <app>-has_notes = xsdbool( <app>-notes IS NOT INITIAL ).
      <app>-has_p171  = xsdbool( <app>-post171 IS NOT INITIAL ).

      " control name: struck through when the control is deprecated, otherwise
      " plain - never coloured (carried as FormattedText htmlText so the
      " strikethrough can vary per row); a plain control is rendered as-is
      <app>-ctrl_html = COND string(
          WHEN <app>-dep_text IS NOT INITIAL
          THEN |<span style="text-decoration:line-through">{ <app>-ctrl_name }</span>|
          ELSE <app>-ctrl_name ).

      " one blob per row, bound as the FILTER column that the table search's
      " client-side Contains filter (binding_call) matches against
      <app>-filter = <app>-module   && \` \` && <app>-control && \` \` && <app>-ctrl_name && \` \` &&
                     <app>-name     && \` \` && <app>-class   && \` \` && <app>-since     && \` \` &&
                     <app>-notes    && \` \` && <app>-checked && \` \` && <app>-post171.

    ENDLOOP.

    " the tree lists the full, unfiltered catalog (search filters only the table)
    t_tree = build_tree( t_app ).

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = \`View\` ns = \`mvc\`
        )->a( n = \`xmlns\`      v = \`sap.m\`
        )->a( n = \`xmlns:mvc\`  v = \`sap.ui.core.mvc\`
        )->a( n = \`xmlns:core\` v = \`sap.ui.core\`

        )->open( \`Shell\`
            )->open( \`Page\`
                )->a( n = \`title\`          v = \`abap2UI5 - Demokit\`
                )->a( n = \`navButtonPress\` v = client->_event_nav_app_leave( )
                )->a( n = \`showNavButton\`  v = z2ui5_cl_ai_xml=>as_bool( client->check_app_prev_stack( ) )

                )->open( \`subHeader\`
                    )->open( \`Toolbar\`
                        " client-side filter over the table only: liveChange/search run
                        " a binding_call Contains filter via _event_client (no round-trip);
                        " the tree is intentionally left unfiltered
                        )->leaf( \`SearchField\`
                            )->a( n = \`placeholder\` v = \`Search the table - module, control, sample, class, notes...\`
                            )->a( n = \`width\`       v = \`24rem\`
                            " disabled while the tree is shown (search filters only the table)
                            )->a( n = \`enabled\`     v = |\\{= !\${ client->_bind( show_tree ) } \\}|
                            )->a( n = \`liveChange\`  v = ${filterCall('${$parameters>/newValue}')}
                            )->a( n = \`search\`      v = ${filterCall('${$parameters>/query}')}
                        )->leaf( \`ToolbarSpacer\`
                        )->leaf( \`Label\`
                            )->a( n = \`text\` v = \`Tree view\`
                        " Switch toggles table vs tree entirely on the client (two-way
                        " bound show_tree drives both views' visible expression bindings)
                        )->leaf( \`Switch\`
                            )->a( n = \`state\`   v = client->_bind( show_tree )
                            )->a( n = \`tooltip\` v = \`Switch between the table and a module -> control -> sample tree\`

                    )->shut(
                )->shut(

                )->open( \`Table\`
                    )->a( n = \`id\`      v = \`${ID_TABLE}\`
                    )->a( n = \`sticky\`  v = \`ColumnHeaders\`
                    )->a( n = \`visible\` v = |\\{= !\${ client->_bind( show_tree ) } \\}|
                    )->a( n = \`items\`   v = client->_bind( t_app )

                    )->open( \`columns\`
${columnsBlock}
                    )->shut(

                    )->open( \`items\`
                        )->open( \`ColumnListItem\`
                            )->open( \`cells\`
                                )->leaf( \`Text\`
                                    )->a( n = \`text\` v = \`{MODULE}\`
                                " control name, struck through when deprecated (never
                                " coloured); FormattedText so the strikethrough can vary per row
                                )->leaf( \`FormattedText\`
                                    )->a( n = \`htmlText\` v = \`{CTRL_HTML}\`
                                    )->a( n = \`tooltip\`  v = \`{DEP_TEXT}\`
                                " release the control appeared in (plain number)
                                )->leaf( \`Text\`
                                    )->a( n = \`text\`    v = \`{SINCE}\`
                                    )->a( n = \`tooltip\` v = \`{DEP_TEXT}\`
                                )->leaf( \`Text\`
                                    )->a( n = \`text\` v = \`{NAME}\`
                                )->leaf( \`Text\`
                                    )->a( n = \`text\` v = \`{CLASS}\`

                                )->open( \`HBox\`
                                    )->a( n = \`alignItems\` v = \`Center\`
                                    )->a( n = \`class\`      v = \`sapUiTinyMarginBegin\`

                                    " gold star - golden port (live-checked and exemplary)
                                    )->leaf( \`core:Icon\`
                                        )->a( n = \`src\`     v = \`sap-icon://favorite\`
                                        )->a( n = \`size\`    v = \`1rem\`
                                        )->a( n = \`color\`   v = \`#e9730c\`
                                        )->a( n = \`tooltip\` v = \`Golden sample - live-checked and exemplary\`
                                        )->a( n = \`visible\` v = \`{GOLDEN}\`
                                        )->a( n = \`class\`   v = \`sapUiTinyMarginEnd\`
                                    " green check - verified live in a running system
                                    )->leaf( \`core:Icon\`
                                        )->a( n = \`src\`     v = \`sap-icon://accept\`
                                        )->a( n = \`size\`    v = \`1rem\`
                                        )->a( n = \`color\`   v = \`#107e3e\`
                                        )->a( n = \`tooltip\` v = \`{CHECKED}\`
                                        )->a( n = \`visible\` v = \`{HAS_CHECK}\`
                                        )->a( n = \`class\`   v = \`sapUiTinyMarginEnd\`
                                    " orange badge - keeps members newer than UI5 1.71 (POST_171)
                                    )->leaf( \`ObjectStatus\`
                                        )->a( n = \`text\`    v = \`1.71+\`
                                        )->a( n = \`state\`   v = \`Warning\`
                                        )->a( n = \`tooltip\` v = \`{POST171}\`
                                        )->a( n = \`visible\` v = \`{HAS_P171}\`
                                        )->a( n = \`class\`   v = \`sapUiTinyMarginEnd\`
                                    " info hint - opens a popup with the port's generation caveats
                                    )->leaf( \`core:Icon\`
                                        )->a( n = \`src\`     v = \`sap-icon://hint\`
                                        )->a( n = \`size\`    v = \`1rem\`
                                        )->a( n = \`color\`   v = \`#0a6ed1\`
                                        )->a( n = \`tooltip\` v = \`{NOTES}\`
                                        )->a( n = \`visible\` v = \`{HAS_NOTES}\`
                                        )->a( n = \`press\`   v = client->_event( val = \`SHOW_NOTES\` t_arg = VALUE #( ( \`\${NOTES}\` ) ) )

                                )->shut(
                                " opens an anchored popover with every link for this row (all navigation
                                " lives here now that the table cells are plain text) - the pressed
                                " button's runtime id (\$event.oSource.sId) anchors the popover
                                )->leaf( \`Button\`
                                    )->a( n = \`icon\`    v = \`sap-icon://action\`
                                    )->a( n = \`type\`    v = \`Transparent\`
                                    )->a( n = \`tooltip\` v = \`Open links for this sample\`
                                    )->a( n = \`press\`   v = client->_event( val = \`LINKS\` t_arg = VALUE #( ( \`\${API_URL}\` ) ( \`\${JS_URL}\` ) ( \`\${UI5_URL}\` ) ( \`\${ABAP_URL}\` ) ( \`\${START_URL}\` ) ( \`\$event.oSource.sId\` ) ) )

                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(

                    " tree view (module -> control -> sample) - shown instead of the
                    " table when the header Switch is on (client-side visible binding);
                    " numberOfExpandedLevels expands every level by default
                    )->open( \`Tree\`
                        )->a( n = \`id\`      v = \`idOverviewTree\`
                        )->a( n = \`visible\` v = |\\{= \${ client->_bind( show_tree ) } \\}|
                        )->a( n = \`items\`   v = |\\{ path: '{ client->_bind( val = t_tree path = abap_true ) }', parameters: \\{ numberOfExpandedLevels: 10 \\} \\}|

                        )->open( \`CustomTreeItem\`
                            )->open( \`HBox\`
                                )->a( n = \`alignItems\` v = \`Center\`

                                )->leaf( \`Text\`
                                    )->a( n = \`text\` v = \`{TEXT}\`
                                " same jump popover as the table's Open column - only on sample leaves
                                )->leaf( \`Button\`
                                    )->a( n = \`icon\`    v = \`sap-icon://action\`
                                    )->a( n = \`type\`    v = \`Transparent\`
                                    )->a( n = \`tooltip\` v = \`Open links for this sample\`
                                    )->a( n = \`class\`   v = \`sapUiTinyMarginBegin\`
                                    )->a( n = \`visible\` v = \`{HAS_LINK}\`
                                    )->a( n = \`press\`   v = client->_event( val = \`LINKS\` t_arg = VALUE #( ( \`\${API_URL}\` ) ( \`\${JS_URL}\` ) ( \`\${UI5_URL}\` ) ( \`\${ABAP_URL}\` ) ( \`\${START_URL}\` ) ( \`\$event.oSource.sId\` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD get_catalog.

    result = VALUE #(
${rows.join('\n')} ).

  ENDMETHOD.


  METHOD build_tree.

    " group the (already module/control/sample-sorted) apps into the nested tree;
    " each sample leaf keeps the links so its popover can jump the same places
    LOOP AT it_app INTO DATA(ls_app).

      IF result IS INITIAL OR result[ lines( result ) ]-text <> ls_app-module.
        APPEND VALUE #( text = ls_app-module ) TO result.
      ENDIF.
      ASSIGN result[ lines( result ) ] TO FIELD-SYMBOL(<module>).

      IF <module>-nodes IS INITIAL OR <module>-nodes[ lines( <module>-nodes ) ]-text <> ls_app-ctrl_name.
        APPEND VALUE #( text = ls_app-ctrl_name ) TO <module>-nodes.
      ENDIF.
      ASSIGN <module>-nodes[ lines( <module>-nodes ) ] TO FIELD-SYMBOL(<control>).

      APPEND VALUE #( text      = |{ ls_app-name } - { ls_app-class }|
                      api_url   = ls_app-api_url
                      js_url    = ls_app-js_url
                      ui5_url   = ls_app-ui5_url
                      abap_url  = ls_app-abap_url
                      start_url = ls_app-start_url
                      has_link  = abap_true ) TO <control>-nodes.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
`;

const xml = `﻿<?xml version="1.0" encoding="utf-8"?>
<abapGit version="v1.0.0" serializer="LCL_OBJECT_CLAS" serializer_version="v1.0.0">
 <asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
  <asx:values>
   <VSEOCLASS>
    <CLSNAME>${CLASS.toUpperCase()}</CLSNAME>
    <LANGU>E</LANGU>
    <DESCRIPT>abap2UI5 - api overview</DESCRIPT>
    <STATE>1</STATE>
    <CLSCCINCL>X</CLSCCINCL>
    <FIXPT>X</FIXPT>
    <UNICODE>X</UNICODE>
   </VSEOCLASS>
  </asx:values>
 </asx:abap>
</abapGit>
`;

fs.writeFileSync(OUT_ABAP, abap);
fs.writeFileSync(OUT_XML, xml);
console.log(`${CLASS}: ${apps.length} apps across ${new Set(apps.map((a) => a.control)).size} controls`);
