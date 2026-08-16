" @keywords ganttchartcontainer shell messagestrip scrollcontainer text label
"! <p class="shorttext">sap.gantt - GanttChartContainer</p>
"!
"! SAPUI5-only control: it ships with SAPUI5, not with OpenUI5, so there is no
"! demo kit original in this repo's sample universe and no 1:1 port (AGENTS section 3).
"! Collected here as orientation - how the control is expressed in abap2UI5.
"!
"! SAPUI5 demo kit: https://ui5.sap.com/#/entity/sap.gantt.GanttChartContainer
"!
"! DEPRECATED as of UI5 1.64 - kept as a record of the control, not as a
"! recommendation. Check the demo kit for its successor before using it.
"! Follow-up of https://github.com/abap2UI5/abap2UI5/issues/988#issuecomment-1978738754
CLASS z2ui5_cl_smpc_sapui5_014 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " The column's export configuration. Bound rather than written into the
    " attribute: UI5 reads a leading `{` as a BINDING, so a raw JSON literal in
    " an attribute never reaches the control at all.
    DATA mv_export_config TYPE string.

    TYPES:
      BEGIN OF ty_s_relation,
        relationid  TYPE string,
        type        TYPE string,
        predecessor TYPE string,
        successor   TYPE string,
      END OF ty_s_relation.
    TYPES ty_t_relation TYPE STANDARD TABLE OF ty_s_relation WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_task,
        objectid      TYPE string,
        objectname    TYPE string,
        starttime     TYPE string,
        endtime       TYPE string,
        relationships TYPE ty_t_relation,
      END OF ty_s_task.
    TYPES:
      BEGIN OF ty_s_phase,
        objectid      TYPE string,
        objectname    TYPE string,
        starttime     TYPE string,
        endtime       TYPE string,
        relationships TYPE ty_t_relation,
        children      TYPE STANDARD TABLE OF ty_s_task WITH EMPTY KEY,
      END OF ty_s_phase.
    TYPES:
      BEGIN OF ty_s_root,
        children TYPE STANDARD TABLE OF ty_s_phase WITH EMPTY KEY,
      END OF ty_s_root.
    DATA s_root TYPE ty_s_root.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS data_read.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_smpc_sapui5_014 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).

      mv_export_config = `{"columnKey": "OBJECTNAME", `      &&
                         `"leadingProperty": "OBJECTNAME", ` &&
                         `"dataType": "string", `            &&
                         `"wrap": true}`.
      data_read( ).
      view_display( ).

    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.

  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `displayBlock`   v = `true`
        )->a( n = `height`         v = `100%`
        )->a( n = `xmlns`          v = `sap.m`
        )->a( n = `xmlns:mvc`      v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`     v = `sap.ui.core`
        )->a( n = `xmlns:gantt`    v = `sap.gantt.simple`
        )->a( n = `xmlns:axistime` v = `sap.gantt.axistime`
        )->a( n = `xmlns:config`   v = `sap.gantt.config`
        )->a( n = `xmlns:table`    v = `sap.ui.table`
        )->a( n = `core:require`   v = `{Formatter:'z2ui5/model/formatter'}`

        )->ele( `Shell`
            )->ele( `Page`
                )->a( n = `id`             v = `page_main`
                )->a( n = `title`          v = `abap2UI5 - Gantt Chart with Relationships`
                )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
                )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                )->a( n = `class`          v = `sapUiContentPadding`

                )->tag( `MessageStrip`
                    )->a( n = `text`     v = `A sap.gantt chart whose shapes are connected by relationships: ` &&
                                             `every row carries a nested RELATIONSHIPS table, and each entry ` &&
                                             `draws a connector of its own type (FinishToStart, StartToStart, ...) ` &&
                                             `from a predecessor to a successor shape. Use the container toolbar ` &&
                                             `to zoom, search and switch the display type.`
                    )->a( n = `type`     v = `Information`
                    )->a( n = `class`    v = `sapUiSmallMargin`
                    )->a( n = `showIcon` b = abap_true

                )->ele( `ScrollContainer`
                    )->a( n = `horizontal` b = abap_true

                    )->ele( n = `GanttChartContainer` ns = `gantt`
                        )->ele( n = `toolbar` ns = `gantt`
                            )->tag( n = `ContainerToolbar` ns = `gantt`
                                )->a( n = `showSearchButton`      b = abap_true
                                )->a( n = `showDisplayTypeButton` b = abap_true
                                )->a( n = `showLegendButton`      b = abap_true
                                )->a( n = `showSettingButton`     b = abap_true
                                )->a( n = `showTimeZoomControl`   b = abap_true

                        )->end(

                        )->ele( n = `GanttChartWithTable` ns = `gantt`
                            )->a( n = `id`                        v = `gantt`
                            )->a( n = `shapeSelectionMode`        v = `Single`
                            )->a( n = `isConnectorDetailsVisible` b = abap_true

                            )->ele( n = `axisTimeStrategy` ns = `gantt`
                                )->ele( n = `ProportionZoomStrategy` ns = `axistime`
                                    )->ele( n = `totalHorizon` ns = `axistime`
                                        )->tag( n = `TimeHorizon` ns = `config`
                                            )->a( n = `startTime` v = `20181101000000`
                                            )->a( n = `endTime`   v = `20181130000000`

                                    )->end(

                                    )->ele( n = `visibleHorizon` ns = `axistime`
                                        )->tag( n = `TimeHorizon` ns = `config`
                                            )->a( n = `startTime` v = `20181101000000`
                                            )->a( n = `endTime`   v = `20181130000000`

                                    )->end(
                                )->end(
                            )->end(

                            )->ele( n = `table` ns = `gantt`
                                )->ele( n = `TreeTable` ns = `table`
                                    )->a( n = `rows` v = |\{ path: '{ client->_bind( val  = s_root
                                                                                    path = abap_true ) }', | &&
                                                          |parameters: \{ arrayNames: ['CHILDREN'], numberOfExpandedLevels: 2 \} \}|

                                    )->ele( n = `columns` ns = `table`
                                        )->ele( n = `Column` ns = `table`
                                            )->a( n = `id` v = `col_objectname`

                                            )->ele( n = `customData` ns = `table`
                                                )->tag( n = `CustomData` ns = `core`
                                                    )->a( n = `key`   v = `exportTableColumnConfig`
                                                    )->a( n = `value` v = client->_bind( mv_export_config )

                                            )->end(

                                            )->tag( `Text`
                                                )->a( n = `text` v = `Object Name`

                                            )->ele( n = `template` ns = `table`
                                                )->tag( `Label`
                                                    )->a( n = `text` v = `{OBJECTNAME}`

                                            )->end(
                                        )->end(
                                    )->end(

                                    )->ele( n = `rowSettingsTemplate` ns = `table`
                                        )->ele( n = `GanttRowSettings` ns = `gantt`
                                            )->a( n = `rowId`         v = `{OBJECTID}`
                                            )->a( n = `relationships` v = `{path: 'RELATIONSHIPS', templateShareable: false}`

                                            )->ele( n = `shapes1` ns = `gantt`
                                                )->tag( n = `BaseRectangle` ns = `gantt`
                                                    )->a( n = `shapeId`                 v = `{OBJECTID}`
                                                    )->a( n = `time`                    v = `{= Formatter.DateCreateObject(${STARTTIME}) }`
                                                    )->a( n = `endTime`                 v = `{= Formatter.DateCreateObject(${ENDTIME}) }`
                                                    )->a( n = `height`                  v = `19`
                                                    )->a( n = `title`                   v = `{OBJECTNAME}`
                                                    )->a( n = `horizontalTextAlignment` v = `Start`
                                                    )->a( n = `connectable`             b = abap_true

                                            )->end(

                                            )->ele( n = `relationships` ns = `gantt`
                                                )->tag( n = `Relationship` ns = `gantt`
                                                    )->a( n = `shapeId`     v = `{RELATIONID}`
                                                    )->a( n = `type`        v = `{TYPE}`
                                                    )->a( n = `predecessor` v = `{PREDECESSOR}`
                                                    )->a( n = `successor`   v = `{SUCCESSOR}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

  METHOD data_read.

    s_root = VALUE #(
        children = VALUE #(
            ( objectid      = `object-0-1`
              objectname    = `Phase 1 - Design`
              starttime     = `2018-11-01T09:00:00`
              endtime       = `2018-11-10T17:00:00`
              relationships = VALUE #( ( relationid  = `rls-4`
                                         type        = `StartToFinish`
                                         predecessor = `object-0-1`
                                         successor   = `object-0-2` ) )
              children      = VALUE #(
                  ( objectid      = `object-0-1-1`
                    objectname    = `Draft`
                    starttime     = `2018-11-01T09:00:00`
                    endtime       = `2018-11-05T17:00:00`
                    relationships = VALUE #( ( relationid  = `rls-0`
                                               type        = `StartToFinish`
                                               predecessor = `object-0-1-1`
                                               successor   = `object-0-1-2` ) ) )
                  ( objectid   = `object-0-1-2`
                    objectname = `Review`
                    starttime  = `2018-11-06T09:00:00`
                    endtime    = `2018-11-10T17:00:00` ) ) )

            ( objectid   = `object-0-2`
              objectname = `Phase 2 - Build`
              starttime  = `2018-11-11T09:00:00`
              endtime    = `2018-11-24T17:00:00`
              children   = VALUE #(
                  ( objectid      = `object-0-2-1`
                    objectname    = `Prepare`
                    starttime     = `2018-11-11T09:00:00`
                    endtime       = `2018-11-13T17:00:00`
                    relationships = VALUE #( ( relationid  = `rls-2`
                                               type        = `StartToStart`
                                               predecessor = `object-0-2-1`
                                               successor   = `object-0-2-4` )
                                             ( relationid  = `rls-3`
                                               type        = `FinishToFinish`
                                               predecessor = `object-0-2-1`
                                               successor   = `object-0-2-3` ) ) )
                  ( objectid      = `object-0-2-2`
                    objectname    = `Implement`
                    starttime     = `2018-11-14T09:00:00`
                    endtime       = `2018-11-17T17:00:00`
                    relationships = VALUE #( ( relationid  = `rls-1`
                                               type        = `FinishToFinish`
                                               predecessor = `object-0-2-2`
                                               successor   = `object-0-2-3` ) ) )
                  ( objectid   = `object-0-2-3`
                    objectname = `Test`
                    starttime  = `2018-11-18T09:00:00`
                    endtime    = `2018-11-20T17:00:00` )
                  ( objectid      = `object-0-2-4`
                    objectname    = `Ship`
                    starttime     = `2018-11-21T09:00:00`
                    endtime       = `2018-11-22T17:00:00`
                    relationships = VALUE #( ( relationid  = `rls-5`
                                               type        = `FinishToStart`
                                               predecessor = `object-0-2-4`
                                               successor   = `object-0-2-5` ) ) )
                  ( objectid   = `object-0-2-5`
                    objectname = `Handover`
                    starttime  = `2018-11-23T09:00:00`
                    endtime    = `2018-11-24T17:00:00` ) ) )

            ( objectid      = `object-0-3`
              objectname    = `Phase 3 - Close`
              starttime     = `2018-11-25T09:00:00`
              endtime       = `2018-11-29T17:00:00`
              relationships = VALUE #( ( relationid  = `rls-6`
                                         type        = `FinishToStart`
                                         predecessor = `object-0-3`
                                         successor   = `object-0-3-1` ) )
              children      = VALUE #(
                  ( objectid   = `object-0-3-1`
                    objectname = `Sign off`
                    starttime  = `2018-11-25T09:00:00`
                    endtime    = `2018-11-29T17:00:00` ) ) ) ) ).

  ENDMETHOD.
ENDCLASS.
