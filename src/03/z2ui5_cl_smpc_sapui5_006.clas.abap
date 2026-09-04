" @keywords processflow shell processflownode processflowlaneheader
" @summary sap.suite.ui.commons.ProcessFlow expressed in abap2UI5 - a SAPUI5-only control, so the demo kit original is outside OpenUI5 and this is orientation rather than a 1:1 port.
"! <p class="shorttext">sap.suite.ui.commons - ProcessFlow</p>
"!
"! SAPUI5-only control: it ships with SAPUI5, not with OpenUI5, so there is no
"! demo kit original in this repo's sample universe and no 1:1 port (AGENTS section 3).
"! Collected here as orientation - how the control is expressed in abap2UI5.
"!
"! SAPUI5 demo kit: https://ui5.sap.com/#/entity/sap.suite.ui.commons.ProcessFlow
CLASS z2ui5_cl_smpc_sapui5_006 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES ty_t_children TYPE STANDARD TABLE OF int4 WITH NON-UNIQUE KEY table_line.
    TYPES ty_t_texts TYPE STANDARD TABLE OF string WITH NON-UNIQUE KEY table_line.

    TYPES: BEGIN OF ty_s_nodes2,
             id                TYPE string,
             lane              TYPE string,
             title             TYPE string,
             titleabbreviation TYPE string,
             children          TYPE ty_t_children,
             state             TYPE string,
             statetext         TYPE string,
             focused           TYPE abap_bool,
             highlighted       TYPE abap_bool,
             texts             TYPE ty_t_texts,
           END OF ty_s_nodes2.
    TYPES: BEGIN OF ty_s_lanes5,
             id       TYPE string,
             icon     TYPE string,
             label    TYPE string,
             position TYPE i,
           END OF ty_s_lanes5.
    TYPES ty_t_nodes2 TYPE STANDARD TABLE OF ty_s_nodes2 WITH DEFAULT KEY.
    TYPES ty_t_lanes5 TYPE STANDARD TABLE OF ty_s_lanes5 WITH DEFAULT KEY.

    DATA mt_nodes TYPE ty_t_nodes2.
    DATA mt_lanes TYPE ty_t_lanes5.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS set_data.
    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_smpc_sapui5_006 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client     = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      set_data( ).

      view_display( ).
      RETURN.
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `NODE_PRESS`.
      " the wire carries no argument, so the press is all this knows. To act
      " on the node itself, add a t_arg to the _event( ) call in view_display
      " and read it back with client->get_event_arg( ).
      client->message_toast_display( `nodePress - a process flow node was clicked` ).
    ENDIF.

  ENDMETHOD.

  METHOD set_data.

    DATA temp1 TYPE z2ui5_cl_smpc_sapui5_006=>ty_t_nodes2.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp5 TYPE z2ui5_cl_smpc_sapui5_006=>ty_t_children.
    DATA temp7 TYPE z2ui5_cl_smpc_sapui5_006=>ty_t_texts.
    DATA temp9 TYPE z2ui5_cl_smpc_sapui5_006=>ty_t_texts.
    DATA temp11 TYPE z2ui5_cl_smpc_sapui5_006=>ty_t_children.
    DATA temp13 TYPE z2ui5_cl_smpc_sapui5_006=>ty_t_texts.
    DATA temp15 TYPE z2ui5_cl_smpc_sapui5_006=>ty_t_children.
    DATA temp17 TYPE z2ui5_cl_smpc_sapui5_006=>ty_t_texts.
    DATA temp19 TYPE z2ui5_cl_smpc_sapui5_006=>ty_t_texts.
    DATA temp21 TYPE z2ui5_cl_smpc_sapui5_006=>ty_t_texts.
    DATA temp3 TYPE z2ui5_cl_smpc_sapui5_006=>ty_t_lanes5.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp1.
    
    temp2-id = `1`.
    temp2-lane = `0`.
    temp2-title = `Sales Order 1`.
    temp2-titleabbreviation = `SO 1`.
    
    CLEAR temp5.
    INSERT 10 INTO TABLE temp5.
    INSERT 11 INTO TABLE temp5.
    INSERT 12 INTO TABLE temp5.
    temp2-children = temp5.
    temp2-state = `Positive`.
    temp2-statetext = `OK status`.
    temp2-focused = abap_true.
    temp2-highlighted = abap_false.
    
    CLEAR temp7.
    INSERT `Sales Order Document Overdue long text for the wrap up all the aspects` INTO TABLE temp7.
    INSERT `Not cleared` INTO TABLE temp7.
    temp2-texts = temp7.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `10`.
    temp2-lane = `1`.
    temp2-title = `Outbound Delivery 40`.
    temp2-titleabbreviation = `OD 40`.
    temp2-state = `Positive`.
    temp2-statetext = `OK status`.
    temp2-focused = abap_true.
    temp2-highlighted = abap_false.
    
    CLEAR temp9.
    INSERT `Sales Order Document Overdue long text for the wrap up all the aspects` INTO TABLE temp9.
    INSERT `Not cleared` INTO TABLE temp9.
    temp2-texts = temp9.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `11`.
    temp2-lane = `1`.
    temp2-title = `Outbound Delivery 43`.
    temp2-titleabbreviation = `OD 43`.
    
    CLEAR temp11.
    INSERT 21 INTO TABLE temp11.
    temp2-children = temp11.
    temp2-state = `Neutral`.
    temp2-statetext = `OK status`.
    temp2-focused = abap_true.
    temp2-highlighted = abap_false.
    
    CLEAR temp13.
    INSERT `Sales Order Document Overdue long text for the wrap up all the aspects` INTO TABLE temp13.
    INSERT `Not cleared` INTO TABLE temp13.
    temp2-texts = temp13.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `12`.
    temp2-lane = `1`.
    temp2-title = `Outbound Delivery 45`.
    temp2-titleabbreviation = `OD 45`.
    
    CLEAR temp15.
    INSERT 20 INTO TABLE temp15.
    temp2-children = temp15.
    temp2-state = `Neutral`.
    temp2-focused = abap_false.
    temp2-highlighted = abap_false.
    
    CLEAR temp17.
    INSERT `Sales Order Document Overdue long text for the wrap up all the aspects` INTO TABLE temp17.
    INSERT `Not cleared` INTO TABLE temp17.
    temp2-texts = temp17.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `20`.
    temp2-lane = `2`.
    temp2-title = `Invoice 9`.
    temp2-titleabbreviation = `I 9`.
    temp2-state = `Positive`.
    temp2-statetext = `OK status`.
    temp2-focused = abap_false.
    temp2-highlighted = abap_false.
    
    CLEAR temp19.
    INSERT `Sales Order Document Overdue long text for the wrap up all the aspects` INTO TABLE temp19.
    INSERT `Not cleared` INTO TABLE temp19.
    temp2-texts = temp19.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `21`.
    temp2-lane = `2`.
    temp2-title = `Invoice Planned`.
    temp2-titleabbreviation = `IP`.
    temp2-state = `PlannedNegative`.
    temp2-focused = abap_false.
    temp2-highlighted = abap_false.
    
    CLEAR temp21.
    INSERT `Sales Order Document Overdue long text for the wrap up all the aspects` INTO TABLE temp21.
    INSERT `Not cleared` INTO TABLE temp21.
    temp2-texts = temp21.
    INSERT temp2 INTO TABLE temp1.
    mt_nodes = temp1.

    
    CLEAR temp3.
    
    temp4-id = `0`.
    temp4-icon = `sap-icon://order-status`.
    temp4-label = `Order Processing`.
    temp4-position = 0.
    INSERT temp4 INTO TABLE temp3.
    temp4-id = `1`.
    temp4-icon = `sap-icon://monitor-payments`.
    temp4-label = `Delivery Processing`.
    temp4-position = 1.
    INSERT temp4 INTO TABLE temp3.
    temp4-id = `2`.
    temp4-icon = `sap-icon://payment-approval`.
    temp4-label = `Invoicing`.
    temp4-position = 2.
    INSERT temp4 INTO TABLE temp3.
    mt_lanes = temp3.

  ENDMETHOD.

  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `displayBlock`  v = `true`
        )->a( n = `height`        v = `100%`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:commons` v = `sap.suite.ui.commons`

        )->ele( `Shell`
            )->ele( `Page`
                )->a( n = `title`          v = `abap2UI5 - Process Flow`
                )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
                )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                )->a( n = `class`          v = `sapUiContentPadding`

                )->ele( n = `ProcessFlow` ns = `commons`
                    )->a( n = `id`            v = `processflow1`
                    )->a( n = `nodePress`     v = client->_event( val = `NODE_PRESS` )
                    )->a( n = `nodes`         v = client->_bind( mt_nodes )
                    )->a( n = `lanes`         v = client->_bind( mt_lanes )
                    )->a( n = `scrollable`    b = abap_true
                    )->a( n = `wheelZoomable` b = abap_false
                    )->a( n = `foldedCorners` b = abap_true

                    )->ele( n = `nodes` ns = `commons`
                        )->tag( n = `ProcessFlowNode` ns = `commons`
                            )->a( n = `laneId`            v = `{LANE}`
                            )->a( n = `nodeId`            v = `{ID}`
                            )->a( n = `title`             v = `{TITLE}`
                            )->a( n = `titleAbbreviation` v = `{TITLEABBREVIATION}`
                            )->a( n = `children`          v = `{CHILDREN}`
                            )->a( n = `state`             v = `{STATE}`
                            )->a( n = `stateText`         v = `{STATETEXT}`
                            )->a( n = `highlighted`       v = `{HIGHLIGHTED}`
                            )->a( n = `focused`           v = `{FOCUSED}`

                    )->end(

                    )->ele( n = `lanes` ns = `commons`
                        )->tag( n = `ProcessFlowLaneHeader` ns = `commons`
                            )->a( n = `laneId`   v = `{ID}`
                            )->a( n = `iconSrc`  v = `{ICON}`
                            )->a( n = `text`     v = `{LABEL}`
                            )->a( n = `position` v = `{POSITION}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
