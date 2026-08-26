" @keywords tree sap.m treejsonlazyloading standardtreeitem
" @summary Shows how lazy loading with a JSON model can be done using the toggleOpenState event.
CLASS z2ui5_cl_smpc_app_496 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_node_level6,
        text  TYPE string,
        dummy TYPE abap_bool,
      END OF ty_s_node_level6,
      BEGIN OF ty_s_node_level5,
        text  TYPE string,
        dummy TYPE abap_bool,
        nodes TYPE STANDARD TABLE OF ty_s_node_level6 WITH EMPTY KEY,
      END OF ty_s_node_level5,
      BEGIN OF ty_s_node_level4,
        text  TYPE string,
        dummy TYPE abap_bool,
        nodes TYPE STANDARD TABLE OF ty_s_node_level5 WITH EMPTY KEY,
      END OF ty_s_node_level4,
      BEGIN OF ty_s_node_level3,
        text  TYPE string,
        dummy TYPE abap_bool,
        nodes TYPE STANDARD TABLE OF ty_s_node_level4 WITH EMPTY KEY,
      END OF ty_s_node_level3,
      BEGIN OF ty_s_node_level2,
        text  TYPE string,
        dummy TYPE abap_bool,
        nodes TYPE STANDARD TABLE OF ty_s_node_level3 WITH EMPTY KEY,
      END OF ty_s_node_level2,
      BEGIN OF ty_s_node_level1,
        text  TYPE string,
        dummy TYPE abap_bool,
        nodes TYPE STANDARD TABLE OF ty_s_node_level2 WITH EMPTY KEY,
      END OF ty_s_node_level1.

    DATA t_nodes TYPE STANDARD TABLE OF ty_s_node_level1 WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_496 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `Tree`
            )->a( n = `id`                 v = `Tree`
            " items path '/' - bind the root table; the nested `nodes` drive the depth
            )->a( n = `items`              v = client->_bind( t_nodes )
            )->a( n = `busyIndicatorDelay` v = `0`
            " onToggleOpenState toasts the three event parameters and loads the level
            " below when the expanded node still holds the dummy child - the same three
            " values travel to the backend, which appends the nodes
            )->a( n = `toggleOpenState`    v = client->_event( val   = `TOGGLE`
                                                               t_arg = VALUE #( ( `${$parameters>/itemIndex}` )
                                                                                ( `${$parameters>/itemContext}.getPath()` )
                                                                                ( `${$parameters>/expanded}` ) ) )

            )->tag( `StandardTreeItem`
                )->a( n = `title` v = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    DATA indices  TYPE STANDARD TABLE OF i WITH EMPTY KEY.
    DATA segments TYPE string_table.
    DATA node1    TYPE REF TO ty_s_node_level1.
    DATA node2    TYPE REF TO ty_s_node_level2.
    DATA node3    TYPE REF TO ty_s_node_level3.
    DATA node4    TYPE REF TO ty_s_node_level4.
    DATA node5    TYPE REF TO ty_s_node_level5.

    IF client->get_event( ) = `TOGGLE`.

      DATA(item_index) = client->get_event_arg( ).
      DATA(item_path)  = client->get_event_arg( 2 ).
      DATA(expanded)   = CONV abap_bool( client->get_event_arg( 3 ) ).

      client->message_toast_display(
          text     = |Item index: { item_index }| &&
                     |\nItem context (path): { item_path }| &&
                     |\nExpanded: { COND string( WHEN expanded = abap_true THEN `true` ELSE `false` ) }|
          duration = `5000` ).

      IF expanded = abap_false.
        RETURN.
      ENDIF.

      " abap2UI5 sends /T_NODES/1/NODES/0 - NOT the original sample's /1/nodes/0:
      " the root is the bound attribute's name and the model is serialized
      " upper-cased, so matching a literal `nodes` never fires. Keep the numeric
      " segments and ignore the named ones, the way app 546's index_of does.
      SPLIT item_path AT `/` INTO TABLE segments.
      LOOP AT segments INTO DATA(segment).
        IF segment IS NOT INITIAL AND segment CO `0123456789`.
          APPEND CONV i( segment ) + 1 TO indices.
        ENDIF.
      ENDLOOP.

      " loadData replaces the dummy child of the expanded node with the next two
      " nodes; the level decides their name and whether they stay expandable
      DATA(level)   = lines( indices ) - 1.
      DATA(suffix)  = repeat( val = `-1` occ = level + 2 ).
      DATA(suffix2) = repeat( val = `-2` occ = level + 2 ).
      DATA(is_last) = xsdbool( level >= 5 ).

      CASE lines( indices ).

        WHEN 1.
          node1 = REF #( t_nodes[ indices[ 1 ] ] OPTIONAL ).
          IF node1 IS INITIAL.
            RETURN.
          ENDIF.
          node1->nodes = VALUE #(
              ( text = |Node{ suffix }| )
              ( text  = |Node{ suffix2 }|
                nodes = VALUE #( ( text  = COND #( WHEN is_last = abap_true THEN `Last node` ELSE `` )
                                   dummy = xsdbool( is_last = abap_false ) ) ) ) ).

        WHEN 2.
          node2 = REF #( t_nodes[ indices[ 1 ] ]-nodes[ indices[ 2 ] ] OPTIONAL ).
          IF node2 IS INITIAL.
            RETURN.
          ENDIF.
          node2->nodes = VALUE #(
              ( text = |Node{ suffix }| )
              ( text  = |Node{ suffix2 }|
                nodes = VALUE #( ( text  = COND #( WHEN is_last = abap_true THEN `Last node` ELSE `` )
                                   dummy = xsdbool( is_last = abap_false ) ) ) ) ).

        WHEN 3.
          node3 = REF #( t_nodes[ indices[ 1 ] ]-nodes[ indices[ 2 ] ]-nodes[ indices[ 3 ] ] OPTIONAL ).
          IF node3 IS INITIAL.
            RETURN.
          ENDIF.
          node3->nodes = VALUE #(
              ( text = |Node{ suffix }| )
              ( text  = |Node{ suffix2 }|
                nodes = VALUE #( ( text  = COND #( WHEN is_last = abap_true THEN `Last node` ELSE `` )
                                   dummy = xsdbool( is_last = abap_false ) ) ) ) ).

        WHEN 4.
          node4 = REF #( t_nodes[ indices[ 1 ] ]-nodes[ indices[ 2 ] ]-nodes[ indices[ 3 ] ]-nodes[ indices[ 4 ] ] OPTIONAL ).
          IF node4 IS INITIAL.
            RETURN.
          ENDIF.
          node4->nodes = VALUE #(
              ( text = |Node{ suffix }| )
              ( text  = |Node{ suffix2 }|
                nodes = VALUE #( ( text  = COND #( WHEN is_last = abap_true THEN `Last node` ELSE `` )
                                   dummy = xsdbool( is_last = abap_false ) ) ) ) ).

        WHEN 5.
          node5 = REF #( t_nodes[ indices[ 1 ] ]-nodes[ indices[ 2 ] ]-nodes[ indices[ 3 ] ]-nodes[ indices[ 4 ] ]-nodes[ indices[ 5 ] ] OPTIONAL ).
          IF node5 IS INITIAL.
            RETURN.
          ENDIF.
          node5->nodes = VALUE #(
              ( text = |Node{ suffix }| )
              ( text = |Node{ suffix2 }| ) ).

        WHEN OTHERS.
          RETURN.
      ENDCASE.

    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " loadData( ) seeds the two root nodes; every deeper level is fetched when its
    " parent is expanded
    t_nodes = VALUE #(
        ( text = `Node-1` )
        ( text  = `Node-2`
          nodes = VALUE #( ( text = `` dummy = abap_true ) ) ) ).

  ENDMETHOD.

ENDCLASS.
