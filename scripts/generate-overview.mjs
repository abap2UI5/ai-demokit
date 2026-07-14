#!/usr/bin/env node
/*
 * Generates the in-system overview app src/z2ui5_cl_api_app_overview.clas.*
 * — an abap2UI5 app that lists every ported sample as one row of a table with
 * columns: Module, Control (-> OpenUI5 API), Sample (name -> OpenUI5 repo
 * source, ↗ -> live OpenUI5 fullscreen sample) and abap2UI5 (class name ->
 * generated class on GitHub, ↗ -> starts the app). Every link opens in a NEW
 * browser tab (target="_blank"; the ↗ start link uses the ?app_start= URL).
 * Depends only on src/ (no OpenUI5 checkout needed).
 *
 * Run:  node scripts/generate-overview.mjs
 */

import fs from 'fs';
import path from 'path';

const ROOT = path.join(path.dirname(new URL(import.meta.url).pathname), '..');
const SRC = path.join(ROOT, 'src');
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
for (const f of walk(SRC)) {
  if (!f.endsWith('.clas.abap')) continue;
  const cls = path.basename(f, '.clas.abap');
  const m = fs.readFileSync(f, 'utf8')
    .match(/entity\/([^/\s]+)\/sample\/(\S+)/);
  if (!m) continue;
  const entity = m[1];
  const id = m[2];
  const i = id.indexOf('.sample.');
  if (i === -1) continue;
  apps.push({
    module: id.slice(0, i),
    control: entity,
    name: id.slice(i + '.sample.'.length),
    cls,
    file: path.relative(ROOT, f).split(path.sep).join('/'),
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
const rows = apps.map((a) =>
  `      ( module = \`${a.module}\`${' '.repeat(wm - a.module.length)}` +
  ` control = \`${a.control}\`${' '.repeat(wc - a.control.length)}` +
  ` name = \`${a.name}\`${' '.repeat(wn - a.name.length)}` +
  ` class = \`${a.cls}\`${' '.repeat(wl - a.cls.length)}` +
  ` path = \`${a.file}\`${' '.repeat(wf - a.file.length)} )`);

const abap = `"! Generated overview app - lists every abap2UI5 api sample app in a table.
"! In the Sample column the name links the OpenUI5 source and the ↗ starts the
"! live OpenUI5 sample; in the abap2UI5 column the class name links the generated
"! ABAP class and the ↗ starts the app; Control links the OpenUI5 API - all
"! opening in a new browser tab. Do not edit by hand - regenerate with
"! scripts/generate-overview.mjs
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
      END OF ty_s_app.
    TYPES ty_t_app TYPE STANDARD TABLE OF ty_s_app WITH DEFAULT KEY.

    DATA t_app TYPE ty_t_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
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
    ENDIF.

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

    ENDLOOP.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(tab) = view->shell(
        )->page(
            title          = \`abap2UI5 - api\`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( )
        )->table(
            sticky = \`ColumnHeaders\`
            items  = client->_bind( t_app ) ).

    tab->columns(
        )->column( )->text( \`Module\` )->get_parent(
        )->column( )->text( \`Control\` )->get_parent(
        )->column( )->text( \`Sample\` )->get_parent(
        )->column( )->text( \`abap2UI5\` ).

    tab->items(
        )->column_list_item(
            )->cells(
                )->text( \`{MODULE}\`
                )->link( text   = \`{CTRL_NAME}\`
                         href   = \`{API_URL}\`
                         target = \`_blank\`
                )->hbox(
                    )->link( text   = \`{NAME}\`
                             href   = \`{JS_URL}\`
                             target = \`_blank\`
                    )->text( \` \`
                    )->link( text   = \`↗\`
                             href   = \`{UI5_URL}\`
                             target = \`_blank\`
                    )->get_parent(
                )->hbox(
                    )->link( text   = \`{CLASS}\`
                             href   = \`{ABAP_URL}\`
                             target = \`_blank\`
                    )->text( \` \`
                    )->link( text   = \`↗\`
                             href   = \`{START_URL}\`
                             target = \`_blank\` ).

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
