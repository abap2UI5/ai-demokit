#!/usr/bin/env node
/*
 * Generates the in-system overview app src/z2ui5_cl_api_app_overview.clas.*
 * — an abap2UI5 app that lists every ported sample as one row of a table with
 * columns: Module, Control (-> OpenUI5 API), Sample (name -> OpenUI5 repo
 * source, ↗ -> live OpenUI5 fullscreen sample) and abap2UI5 (class name ->
 * generated class on GitHub, ↗ -> starts the app). Every link opens in a NEW
 * browser tab (target="_blank"; the ↗ start link uses the ?app_start= URL).
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
const CLASS = 'z2ui5_cl_api_app_overview';
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

// collect ported apps: control (entity), module (library), sample name, class,
// and the repo-relative path of the generated class (for the ABAP GitHub link)
const apps = [];
const DEV_LABEL = { IMPROVISED: 'IMPROVISED', LIVE_TEST: 'LIVE-TEST', DROPPED_171: '1.71', SUBSET_DATA: 'SUBSET', NOTE: 'NOTE' };
for (const mf of fs.readdirSync(META)) {
  if (!mf.endsWith('.json')) continue;
  const m = JSON.parse(fs.readFileSync(path.join(META, mf), 'utf8'));
  const i = m.sample.indexOf('.sample.');
  if (i === -1) continue;
  apps.push({
    module: m.sample.slice(0, i),
    control: m.entity,
    name: m.sample.slice(i + '.sample.'.length),
    cls: m.class,
    file: m.file,
    checked: m.checked ? `CHECKED (${m.checked.date}): ${m.checked.note}` : '',
    notes: (m.deviations || []).map((d) => `${DEV_LABEL[d.type] ?? d.type}: ${d.what}`).join(' // '),
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
  if (a.checked) extras.push(`checked = ${abapStr(a.checked)}`);
  if (a.notes) extras.push(`notes = ${abapStr(a.notes)}`);
  return extras.length ? `${base}\n        ${extras.join('\n        ')} )` : `${base} )`;
});

const abap = `"! Generated overview app - lists every abap2UI5 api sample app in a table.
"! In the Sample column the name links the OpenUI5 source and the ↗ starts the
"! live OpenUI5 sample; in the abap2UI5 column the class name links the generated
"! ABAP class and the ↗ starts the app; Control links the OpenUI5 API - all
"! opening in a new browser tab. The Note column shows a green check when the
"! port was manually verified in a running system, and a hint button that opens
"! a popup with the port's generation caveats when present. Do not edit by hand -
"! regenerate with scripts/generate-overview.mjs
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
      END OF ty_s_app.
    TYPES ty_t_app TYPE STANDARD TABLE OF ty_s_app WITH EMPTY KEY.

    DATA t_app TYPE ty_t_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS get_catalog
      RETURNING
        VALUE(result) TYPE ty_t_app.

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

      WHEN \`SHOW_NOTES\`.
        " one Text per bullet of the clicked row's generation notes
        SPLIT client->get_event_arg( ) AT \` // \` INTO TABLE DATA(lt_line).

        DATA(popup) = z2ui5_cl_api_xml=>factory( ).
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

    ENDLOOP.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = \`View\` ns = \`mvc\`
        )->a( n = \`xmlns\`      v = \`sap.m\`
        )->a( n = \`xmlns:mvc\`  v = \`sap.ui.core.mvc\`
        )->a( n = \`xmlns:core\` v = \`sap.ui.core\`

        )->open( \`Shell\`
            )->open( \`Page\`
                )->a( n = \`title\`          v = \`abap2UI5 - api\`
                )->a( n = \`navButtonPress\` v = client->_event_nav_app_leave( )
                )->a( n = \`showNavButton\`  v = z2ui5_cl_api_xml=>as_bool( client->check_app_prev_stack( ) )

                )->open( \`Table\`
                    )->a( n = \`sticky\` v = \`ColumnHeaders\`
                    )->a( n = \`items\`  v = client->_bind_edit( t_app )

                    )->open( \`columns\`
                        )->open( \`Column\`
                            )->leaf( \`Text\`
                                )->a( n = \`text\` v = \`Module\`

                        )->shut(
                        )->open( \`Column\`
                            )->leaf( \`Text\`
                                )->a( n = \`text\` v = \`Control\`

                        )->shut(
                        )->open( \`Column\`
                            )->leaf( \`Text\`
                                )->a( n = \`text\` v = \`Sample\`

                        )->shut(
                        )->open( \`Column\`
                            )->leaf( \`Text\`
                                )->a( n = \`text\` v = \`abap2UI5\`

                        )->shut(
                        )->open( \`Column\`
                            )->leaf( \`Text\`
                                )->a( n = \`text\` v = \`Note\`

                        )->shut(
                    )->shut(

                    )->open( \`items\`
                        )->open( \`ColumnListItem\`
                            )->open( \`cells\`
                                )->leaf( \`Text\`
                                    )->a( n = \`text\` v = \`{MODULE}\`
                                )->leaf( \`Link\`
                                    )->a( n = \`text\`   v = \`{CTRL_NAME}\`
                                    )->a( n = \`href\`   v = \`{API_URL}\`
                                    )->a( n = \`target\` v = \`_blank\`

                                )->open( \`HBox\`
                                    )->leaf( \`Link\`
                                        )->a( n = \`text\`   v = \`{NAME}\`
                                        )->a( n = \`href\`   v = \`{JS_URL}\`
                                        )->a( n = \`target\` v = \`_blank\`
                                    )->leaf( \`Text\`
                                        )->a( n = \`text\` v = \` \`
                                    )->leaf( \`Link\`
                                        )->a( n = \`text\`   v = \`↗\`
                                        )->a( n = \`href\`   v = \`{UI5_URL}\`
                                        )->a( n = \`target\` v = \`_blank\`

                                )->shut(
                                )->open( \`HBox\`
                                    )->leaf( \`Link\`
                                        )->a( n = \`text\`   v = \`{CLASS}\`
                                        )->a( n = \`href\`   v = \`{ABAP_URL}\`
                                        )->a( n = \`target\` v = \`_blank\`
                                    )->leaf( \`Text\`
                                        )->a( n = \`text\` v = \` \`
                                    )->leaf( \`Link\`
                                        )->a( n = \`text\`   v = \`↗\`
                                        )->a( n = \`href\`   v = \`{START_URL}\`
                                        )->a( n = \`target\` v = \`_blank\`

                                )->shut(
                                )->open( \`HBox\`
                                    )->a( n = \`alignItems\` v = \`Center\`

                                    )->leaf( \`core:Icon\`
                                        )->a( n = \`src\`     v = \`sap-icon://accept\`
                                        )->a( n = \`color\`   v = \`#107e3e\`
                                        )->a( n = \`tooltip\` v = \`{CHECKED}\`
                                        )->a( n = \`visible\` v = \`{HAS_CHECK}\`
                                    )->leaf( \`Button\`
                                        )->a( n = \`icon\`    v = \`sap-icon://hint\`
                                        )->a( n = \`type\`    v = \`Transparent\`
                                        )->a( n = \`tooltip\` v = \`{NOTES}\`
                                        )->a( n = \`visible\` v = \`{HAS_NOTES}\`
                                        )->a( n = \`press\`   v = client->_event( val = \`SHOW_NOTES\` t_arg = VALUE #( ( \`\${NOTES}\` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD get_catalog.

    result = VALUE #(
${rows.join('\n')} ).

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
