"! <p class="shorttext">sap.suite.ui.commons - ProcessFlow</p>
"!
"! SAPUI5-only control: it ships with SAPUI5, not with OpenUI5, so there is no
"! demo kit original in this repo's sample universe and no 1:1 port (AGENTS §3).
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
    TYPES ty_t_nodes2 TYPE STANDARD TABLE OF ty_s_nodes2 WITH EMPTY KEY.
    TYPES ty_t_lanes5 TYPE STANDARD TABLE OF ty_s_lanes5 WITH EMPTY KEY.

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

    IF client->check_on_init( ).

      set_data( ).

      view_display( ).
      RETURN.
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `NODE_PRESS`.
        " the wire carries no argument, so the press is all this knows. To act
        " on the node itself, add a t_arg to the _event( ) call in view_display
        " and read it back with client->get_event_arg( ).
        client->message_toast_display( `nodePress - a process flow node was clicked` ).

    ENDCASE.

  ENDMETHOD.

  METHOD set_data.

    mt_nodes = VALUE #( ( id = `1` lane = `0` title = `Sales Order 1` titleabbreviation = `SO 1` children = VALUE #( ( 10 ) ( 11 ) ( 12 ) ) state = `Positive` statetext = `OK status` focused = abap_true
                          highlighted = abap_false texts = VALUE #( ( `Sales Order Document Overdue long text for the wrap up all the aspects` ) ( `Not cleared` ) ) )
                        ( id = `10` lane = `1` title = `Outbound Delivery 40` titleabbreviation = `OD 40` state = `Positive` statetext = `OK status` focused = abap_true highlighted = abap_false
                        texts = VALUE #( ( `Sales Order Document Overdue long text for the wrap up all the aspects` ) ( `Not cleared` ) ) )
                        ( id = `11` lane = `1` title = `Outbound Delivery 43` titleabbreviation = `OD 43` children = VALUE #( ( 21 ) ) state = `Neutral` statetext = `OK status` focused = abap_true highlighted = abap_false
                        texts = VALUE #( ( `Sales Order Document Overdue long text for the wrap up all the aspects` ) ( `Not cleared` ) ) )
                        ( id = `12` lane = `1` title = `Outbound Delivery 45` titleabbreviation = `OD 45` children = VALUE #( ( 20 ) ) state = `Neutral` focused = abap_false highlighted = abap_false
                         texts = VALUE #( ( `Sales Order Document Overdue long text for the wrap up all the aspects` ) ( `Not cleared` ) ) )
                        ( id = `20` lane = `2` title = `Invoice 9` titleabbreviation = `I 9` state = `Positive` statetext = `OK status` focused = abap_false highlighted = abap_false
                        texts = VALUE #( ( `Sales Order Document Overdue long text for the wrap up all the aspects` ) ( `Not cleared` ) ) )
                        ( id = `21` lane = `2` title = `Invoice Planned` titleabbreviation = `IP` state = `PlannedNegative` focused = abap_false highlighted = abap_false
                        texts = VALUE #( ( `Sales Order Document Overdue long text for the wrap up all the aspects` ) ( `Not cleared` ) ) ) ).

    mt_lanes = VALUE #( ( id = `0` icon = `sap-icon://order-status` label = `Order Processing` position = 0 )
                        ( id = `1` icon = `sap-icon://monitor-payments` label = `Delivery Processing` position = 1 )
                        ( id = `2` icon = `sap-icon://payment-approval` label = `Invoicing` position = 2 ) ).

  ENDMETHOD.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell( )->page(
        title          = `abap2UI5 - Process Flow`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( )
        class          = `sapUiContentPadding` ).

    page->process_flow(
        id            = `processflow1`
        scrollable    = abap_true
        wheelzoomable = abap_false
        foldedcorners = abap_true
        nodepress     = client->_event( val = `NODE_PRESS` )
        nodes         = client->_bind( mt_nodes )
        lanes         = client->_bind( mt_lanes )
      )->nodes( `commons`
        )->process_flow_node(
          laneid            = `{LANE}`
          nodeid            = `{ID}`
          title             = `{TITLE}`
          titleabbreviation = `{TITLEABBREVIATION}`
          children          = `{CHILDREN}`
          state             = `{STATE}`
          statetext         = `{STATETEXT}`
          highlighted       = `{HIGHLIGHTED}`
          focused           = `{FOCUSED}`
        )->get_parent( )->get_parent(
      )->lanes(
        )->process_flow_lane_header(
          laneid   = `{ID}`
          iconsrc  = `{ICON}`
          text     = `{LABEL}`
          position = `{POSITION}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
