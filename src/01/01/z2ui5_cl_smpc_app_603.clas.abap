" @keywords tree sap.m treeodata odatatreebinding hierarchy messagestrip standardtreeitem
CLASS z2ui5_cl_smpc_app_603 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_node3,
        nodeid         TYPE i,
        hierarchylevel TYPE i,
        description    TYPE string,
        parentnodeid   TYPE string,
        drillstate     TYPE string,
      END OF ty_s_node3,
      ty_t_node3 TYPE STANDARD TABLE OF ty_s_node3 WITH EMPTY KEY,
      BEGIN OF ty_s_node2,
        nodeid         TYPE i,
        hierarchylevel TYPE i,
        description    TYPE string,
        parentnodeid   TYPE string,
        drillstate     TYPE string,
        children       TYPE ty_t_node3,
      END OF ty_s_node2,
      ty_t_node2 TYPE STANDARD TABLE OF ty_s_node2 WITH EMPTY KEY,
      BEGIN OF ty_s_node1,
        nodeid         TYPE i,
        hierarchylevel TYPE i,
        description    TYPE string,
        parentnodeid   TYPE string,
        drillstate     TYPE string,
        children       TYPE ty_t_node2,
      END OF ty_s_node1,
      ty_t_node1 TYPE STANDARD TABLE OF ty_s_node1 WITH EMPTY KEY,
      BEGIN OF ty_s_node0,
        nodeid         TYPE i,
        hierarchylevel TYPE i,
        description    TYPE string,
        parentnodeid   TYPE string,
        drillstate     TYPE string,
        children       TYPE ty_t_node1,
      END OF ty_s_node0.
    DATA t_nodes TYPE STANDARD TABLE OF ty_s_node0 WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_603 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    DATA(root) = view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc` ).

    root->tag( `MessageStrip`
        )->a( n = `text`            v = `Currently only a limited amount of data is supported for sap.m.Tree. Please consider to consume the same amount of data as in List based controls, or use sap.ui.table.TreeTable to display large amount of data.`
        )->a( n = `showIcon`        v = `true`
        )->a( n = `showCloseButton` v = `true`
        )->a( n = `class`           v = `sapUiMediumMarginBottom` ).

    root->ele( `Tree`
        )->a( n = `id`    v = `Tree`
        " items '/Nodes' with countMode Inline - an ODataTreeBinding over the
        " mock service; the port binds the same sixteen nodes as one nested table
        )->a( n = `items` v = client->_bind( t_nodes )

        )->tag( `StandardTreeItem`
            )->a( n = `title` v = `{DESCRIPTION}`
    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " localService/mockdata/Nodes.json - the sixteen nodes of the mock service,
    " re-shaped from the flat parent/child list into the nesting the JSON tree
    " binding needs. Node ids, levels, descriptions, parent ids and drill states
    " are the mock's own values
    t_nodes = VALUE #(
      ( nodeid = 1 hierarchylevel = 0 description = `1` parentnodeid = `` drillstate = `expanded`
        children = VALUE #(
          ( nodeid = 4 hierarchylevel = 1 description = `1.1` parentnodeid = `1` drillstate = `leaf` )
          ( nodeid = 5 hierarchylevel = 1 description = `1.2` parentnodeid = `1` drillstate = `expanded`
            children = VALUE #(
              ( nodeid = 6 hierarchylevel = 2 description = `1.2.1` parentnodeid = `5` drillstate = `leaf` )
              ( nodeid = 7 hierarchylevel = 2 description = `1.2.2` parentnodeid = `5` drillstate = `leaf` )
            ) )
        ) )
      ( nodeid = 2 hierarchylevel = 0 description = `2` parentnodeid = `` drillstate = `expanded`
        children = VALUE #(
          ( nodeid = 8 hierarchylevel = 1 description = `2.1` parentnodeid = `2` drillstate = `leaf` )
          ( nodeid = 9 hierarchylevel = 1 description = `2.2` parentnodeid = `2` drillstate = `leaf` )
          ( nodeid = 10 hierarchylevel = 1 description = `2.3` parentnodeid = `2` drillstate = `leaf` )
        ) )
      ( nodeid = 3 hierarchylevel = 0 description = `3` parentnodeid = `` drillstate = `expanded`
        children = VALUE #(
          ( nodeid = 11 hierarchylevel = 1 description = `3.1` parentnodeid = `3` drillstate = `expanded`
            children = VALUE #(
              ( nodeid = 12 hierarchylevel = 2 description = `3.1.1` parentnodeid = `11` drillstate = `expanded`
                children = VALUE #(
                  ( nodeid = 13 hierarchylevel = 3 description = `3.1.1.1` parentnodeid = `12` drillstate = `leaf` )
                  ( nodeid = 14 hierarchylevel = 3 description = `3.1.1.2` parentnodeid = `12` drillstate = `leaf` )
                  ( nodeid = 15 hierarchylevel = 3 description = `3.1.1.3` parentnodeid = `12` drillstate = `leaf` )
                  ( nodeid = 16 hierarchylevel = 3 description = `3.1.1.4` parentnodeid = `12` drillstate = `leaf` )
                ) )
            ) )
        ) )
      ).

  ENDMETHOD.

ENDCLASS.
