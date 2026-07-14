#!/usr/bin/env node
/*
 * Generates the in-system overview app src/z2ui5_cl_api_app_overview.clas.*
 * — an abap2UI5 app that lists every ported sample app grouped by UI5 control
 * (demo kit entity) and starts it in the system (nav_app_call), mirroring the
 * layout of api.md. Depends only on src/ (no OpenUI5 checkout needed).
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

// collect ported apps: control (entity), library, sample name, class
const apps = [];
for (const f of walk(SRC)) {
  if (!f.endsWith('.clas.abap')) continue;
  const cls = path.basename(f, '.clas.abap');
  const m = fs.readFileSync(f, 'utf8')
    .match(/Rebuild of the UI5 demo kit sample:\s*\S*?entity\/([^/\s]+)\/sample\/(\S+)/);
  if (!m) continue;
  const entity = m[1];
  const id = m[2];
  const i = id.indexOf('.sample.');
  if (i === -1) continue;
  apps.push({ control: entity, lib: id.slice(0, i), name: id.slice(i + '.sample.'.length), app: cls });
}
// group by control, then by name (case-insensitive)
apps.sort((a, b) =>
  a.control.toLowerCase().localeCompare(b.control.toLowerCase()) ||
  a.name.toLowerCase().localeCompare(b.name.toLowerCase()));

// aligned VALUE #( ) rows
const w = (k) => Math.max(...apps.map((a) => a[k].length));
const wc = w('control'), wl = w('lib'), wn = w('name'), wa = w('app');
const rows = apps.map((a) =>
  `      ( control = \`${a.control}\`${' '.repeat(wc - a.control.length)}` +
  ` lib = \`${a.lib}\`${' '.repeat(wl - a.lib.length)}` +
  ` name = \`${a.name}\`${' '.repeat(wn - a.name.length)}` +
  ` app = \`${a.app}\`${' '.repeat(wa - a.app.length)} )`);

const abap = `"! Generated overview app - lists every abap2UI5 api sample app grouped by UI5
"! control and starts it in the system. Do not edit by hand - regenerate with
"! scripts/generate-overview.mjs
CLASS ${CLASS} DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_app,
        control TYPE string,
        lib     TYPE string,
        name    TYPE string,
        app     TYPE string,
      END OF ty_s_app.
    TYPES ty_t_app TYPE STANDARD TABLE OF ty_s_app WITH DEFAULT KEY.

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

    DATA(t_catalog) = get_catalog( ).

    " base url to launch an app in a new browser tab
    DATA(start) = |{ client->get( )-s_config-origin }{ client->get( )-s_config-pathname }?app_start=|.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = \`abap2UI5 - api\`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(prev_control) = \`\`.
    LOOP AT t_catalog INTO DATA(app).

      IF app-control <> prev_control.

        page->title(
            text  = app-control
            level = \`H3\`
            class = \`sapUiSmallMarginTop\` ).
        prev_control = app-control.

      ENDIF.

      DATA(url) = |https://sapui5.hana.ondemand.com/sdk/#/entity/{ app-control }/sample/{ app-lib }.sample.{ app-name }|.
      page->hbox( alignitems = \`Center\`
                  class      = \`sapUiTinyMarginBegin\`
          )->link(
              text  = app-name
              press = client->_event_client( val   = client->cs_event-open_new_tab
                                             t_arg = VALUE #( ( |{ start }{ to_upper( app-app ) }| ) ) )
          )->link(
              text   = \`demo kit\`
              href   = url
              target = \`_blank\`
              class  = \`sapUiSmallMarginBegin\` ).

    ENDLOOP.

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
