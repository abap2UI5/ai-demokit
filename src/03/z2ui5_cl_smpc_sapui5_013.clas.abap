" @keywords ganttchartwithtable messagestrip ganttchartcontainer proportionzoomstrategy timehorizon treetable column text ganttrowsettings task
" @summary sap.gantt.GanttChartWithTable expressed in abap2UI5 - a SAPUI5-only control, so the demo kit original is outside OpenUI5 and this is orientation rather than a 1:1 port.
"! <p class="shorttext">sap.gantt - GanttChartWithTable</p>
"!
"! SAPUI5-only control: it ships with SAPUI5, not with OpenUI5, so there is no
"! demo kit original in this repo's sample universe and no 1:1 port (AGENTS section 3).
"! Collected here as orientation - how the control is expressed in abap2UI5.
"!
"! SAPUI5 demo kit: https://ui5.sap.com/#/entity/sap.gantt.GanttChartWithTable
"!
"! DEPRECATED as of UI5 1.64 - kept as a record of the control, not as a
"! recommendation. Check the demo kit for its successor before using it.
CLASS z2ui5_cl_smpc_sapui5_013 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_shape,
        id        TYPE string,
        starttime TYPE string,
        endtime   TYPE string,
      END OF ty_s_shape.
    TYPES ty_t_shape TYPE STANDARD TABLE OF ty_s_shape WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_s_level2,
        id      TYPE string,
        text    TYPE string,
        subtask TYPE ty_t_shape,
      END OF ty_s_level2.
    TYPES:
      BEGIN OF ty_s_level1,
        id       TYPE string,
        text     TYPE string,
        task     TYPE ty_t_shape,
        children TYPE STANDARD TABLE OF ty_s_level2 WITH DEFAULT KEY,
      END OF ty_s_level1.
    TYPES:
      BEGIN OF ty_s_root,
        children TYPE STANDARD TABLE OF ty_s_level1 WITH DEFAULT KEY,
      END OF ty_s_root.
    DATA s_root TYPE ty_s_root.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS data_read.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_smpc_sapui5_013 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.

      data_read( ).
      view_display( ).

    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.

  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `displayBlock`    v = `true`
        )->a( n = `height`          v = `100%`
        )->a( n = `xmlns`           v = `sap.m`
        )->a( n = `xmlns:mvc`       v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`      v = `sap.ui.core`
        )->a( n = `xmlns:gantt`     v = `sap.gantt.simple`
        )->a( n = `xmlns:axistime`  v = `sap.gantt.axistime`
        )->a( n = `xmlns:config`    v = `sap.gantt.config`
        )->a( n = `xmlns:shapes`    v = `sap.gantt.simple.shapes`
        )->a( n = `xmlns:table`     v = `sap.ui.table`
        )->a( n = `core:require`    v = `{Formatter:'z2ui5/model/formatter'}`

        )->ele( `Page`
            )->a( n = `id`             v = `page_main`
            )->a( n = `title`          v = `abap2UI5 - Gantt Chart`
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `class`          v = `sapUiContentPadding`

            )->tag( `MessageStrip`
                )->a( n = `text`     v = `A sap.gantt chart fed from a plain ABAP structure: the TreeTable ` &&
                                         `builds the rows from the nested CHILDREN tables, every row draws its ` &&
                                         `own shapes from TASK (level 1) and SUBTASK (level 2). The ISO ` &&
                                         `timestamps are turned into JavaScript Date objects at the point of ` &&
                                         `use, because the shape time properties are object-typed.`
                )->a( n = `type`     v = `Information`
                )->a( n = `class`    v = `sapUiSmallMargin`
                )->a( n = `showIcon` b = abap_true

            )->ele( n = `GanttChartContainer` ns = `gantt`
                )->ele( n = `GanttChartWithTable` ns = `gantt`
                    )->a( n = `id`                 v = `gantt`
                    )->a( n = `shapeSelectionMode` v = `Single`

                    )->ele( n = `axisTimeStrategy` ns = `gantt`
                        )->ele( n = `ProportionZoomStrategy` ns = `axistime`
                            )->ele( n = `totalHorizon` ns = `axistime`
                                )->tag( n = `TimeHorizon` ns = `config`
                                    )->a( n = `startTime` v = `20181029000000`
                                    )->a( n = `endTime`   v = `20181129000000`

                            )->end(

                            )->ele( n = `visibleHorizon` ns = `axistime`
                                )->tag( n = `TimeHorizon` ns = `config`
                                    )->a( n = `startTime` v = `20181029000000`
                                    )->a( n = `endTime`   v = `20181129000000`

                            )->end(
                        )->end(
                    )->end(

                    )->ele( n = `table` ns = `gantt`
                        )->ele( n = `TreeTable` ns = `table`
                            )->a( n = `rows` v = |\{ path: '{ client->_bind_path( s_root ) }', | &&
                                                  |parameters: \{ arrayNames: ['CHILDREN'], numberOfExpandedLevels: 1 \} \}|

                            )->ele( n = `columns` ns = `table`
                                )->ele( n = `Column` ns = `table`
                                    )->a( n = `label` v = `Task`

                                    )->ele( n = `template` ns = `table`
                                        )->tag( `Text`
                                            )->a( n = `text` v = `{TEXT}`

                                    )->end(
                                )->end(
                            )->end(

                            )->ele( n = `rowSettingsTemplate` ns = `table`
                                )->ele( n = `GanttRowSettings` ns = `gantt`
                                    )->a( n = `rowId`   v = `{ID}`
                                    )->a( n = `shapes1` v = `{path: 'TASK', templateShareable: false}`
                                    )->a( n = `shapes2` v = `{path: 'SUBTASK', templateShareable: false}`

                                    )->ele( n = `shapes1` ns = `gantt`
                                        )->tag( n = `Task` ns = `shapes`
                                            )->a( n = `time`    v = `{= Formatter.DateCreateObject(${STARTTIME}) }`
                                            )->a( n = `endTime` v = `{= Formatter.DateCreateObject(${ENDTIME}) }`
                                            )->a( n = `type`    v = `SummaryExpanded`
                                            )->a( n = `color`   v = `sapUiAccent5`

                                    )->end(

                                    )->ele( n = `shapes2` ns = `gantt`
                                        )->tag( n = `Task` ns = `shapes`
                                            )->a( n = `time`    v = `{= Formatter.DateCreateObject(${STARTTIME}) }`
                                            )->a( n = `endTime` v = `{= Formatter.DateCreateObject(${ENDTIME}) }` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

  METHOD data_read.
    DATA temp1 TYPE z2ui5_cl_smpc_sapui5_013=>ty_s_root-children.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE z2ui5_cl_smpc_sapui5_013=>ty_t_shape.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 TYPE z2ui5_cl_smpc_sapui5_013=>ty_s_level1-children.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp7 TYPE z2ui5_cl_smpc_sapui5_013=>ty_t_shape.
    DATA temp8 LIKE LINE OF temp7.

    CLEAR s_root.
    
    CLEAR temp1.
    
    temp2-id = `line`.
    temp2-text = `Level 1`.
    
    CLEAR temp3.
    
    temp4-id = `rectangle1`.
    temp4-starttime = `2018-11-01T09:00:00`.
    temp4-endtime = `2018-11-27T09:00:00`.
    INSERT temp4 INTO TABLE temp3.
    temp2-task = temp3.
    
    CLEAR temp5.
    
    temp6-id = `line2`.
    temp6-text = `Level 2`.
    
    CLEAR temp7.
    
    temp8-id = `chevron1`.
    temp8-starttime = `2018-11-01T09:00:00`.
    temp8-endtime = `2018-11-13T09:00:00`.
    INSERT temp8 INTO TABLE temp7.
    temp8-id = `chevron2`.
    temp8-starttime = `2018-11-15T09:00:00`.
    temp8-endtime = `2018-11-27T09:00:00`.
    INSERT temp8 INTO TABLE temp7.
    temp6-subtask = temp7.
    INSERT temp6 INTO TABLE temp5.
    temp2-children = temp5.
    INSERT temp2 INTO TABLE temp1.
    s_root-children = temp1.

  ENDMETHOD.
ENDCLASS.
