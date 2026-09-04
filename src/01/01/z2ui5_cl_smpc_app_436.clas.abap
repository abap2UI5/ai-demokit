" @keywords tree sap.m treeicon overflowtoolbar title toolbarspacer togglebutton menu menuitem
" @summary Tree item with icon. This example also shows the context menu for the items in the Tree control.
CLASS z2ui5_cl_smpc_app_436 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_node_level5,
        text TYPE string,
        ref  TYPE string,
      END OF ty_s_node_level5,
      BEGIN OF ty_s_node_level4,
        text  TYPE string,
        ref   TYPE string,
        nodes TYPE STANDARD TABLE OF ty_s_node_level5 WITH DEFAULT KEY,
      END OF ty_s_node_level4,
      BEGIN OF ty_s_node_level3,
        text  TYPE string,
        ref   TYPE string,
        nodes TYPE STANDARD TABLE OF ty_s_node_level4 WITH DEFAULT KEY,
      END OF ty_s_node_level3,
      BEGIN OF ty_s_node_level2,
        text  TYPE string,
        ref   TYPE string,
        nodes TYPE STANDARD TABLE OF ty_s_node_level3 WITH DEFAULT KEY,
      END OF ty_s_node_level2,
      BEGIN OF ty_s_node_level1,
        text  TYPE string,
        ref   TYPE string,
        nodes TYPE STANDARD TABLE OF ty_s_node_level2 WITH DEFAULT KEY,
      END OF ty_s_node_level1.
    DATA t_nodes TYPE STANDARD TABLE OF ty_s_node_level1 WITH DEFAULT KEY.
    DATA menu_on TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_436 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA tree TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    tree = view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `Tree`
            )->a( n = `id`    v = `Tree`
            " items path '/' - bind the root table; the nested `nodes` drive the depth
            )->a( n = `items` v = client->_bind( t_nodes ) ).

    tree->ele( `headerToolbar`
        )->ele( `OverflowToolbar`

            )->tag( `Title`
                )->a( n = `text` v = `Tree`
            )->tag( `ToolbarSpacer`
            " onToggleContextMenu builds a sap.m.Menu on press and destroys it again -
            " the pressed state travels to the backend, which emits the contextMenu
            " subtree below or leaves it out
            )->tag( `ToggleButton`
                )->a( n = `icon`    v = `sap-icon://menu`
                )->a( n = `tooltip` v = `Enable / Disable Custom Context Menu`
                " NOT `b = <field>`: that parameter writes the LITERAL 'true' or
                " 'false' into the attribute at render time (view_builder->a),
                " so a field the event handler changes never reaches the
                " control - none of these apps re-renders after an event
                " (e2e-caught on app 505, 2026-08-22)
                )->a( n = `pressed` v = client->_bind( menu_on )
                )->a( n = `press`   v = client->_event( val = `TOGGLE_CONTEXT_MENU` arg = `${$parameters>/pressed}` ) ).

    IF menu_on = abap_true.
      tree->ele( `contextMenu`
          )->ele( `Menu`
              )->tag( `MenuItem`
                  )->a( n = `text` v = `{TEXT}` ).
    ENDIF.

    tree->tag( `StandardTreeItem`
        )->a( n = `title` v = `{TEXT}`
        )->a( n = `icon`  v = `{REF}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `TOGGLE_CONTEXT_MENU`.
      menu_on = client->get_event_arg( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    DATA temp1 LIKE t_nodes.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE z2ui5_cl_smpc_app_436=>ty_s_node_level1-nodes.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 TYPE z2ui5_cl_smpc_app_436=>ty_s_node_level2-nodes.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp7 TYPE z2ui5_cl_smpc_app_436=>ty_s_node_level3-nodes.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp9 TYPE z2ui5_cl_smpc_app_436=>ty_s_node_level4-nodes.
    DATA temp10 LIKE LINE OF temp9.
    CLEAR temp1.
    
    temp2-text = `Node1`.
    temp2-ref = `sap-icon://attachment-audio`.
    
    CLEAR temp3.
    
    temp4-text = `Node1-1`.
    temp4-ref = `sap-icon://attachment-e-pub`.
    
    CLEAR temp5.
    
    temp6-text = `Node1-1-1`.
    temp6-ref = `sap-icon://attachment-html`.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Node1-1-2`.
    temp6-ref = `sap-icon://attachment-photo`.
    
    CLEAR temp7.
    
    temp8-text = `Node1-1-2-1`.
    temp8-ref = `sap-icon://attachment-text-file`.
    
    CLEAR temp9.
    
    temp10-text = `Node1-1-2-1-1`.
    temp10-ref = `sap-icon://attachment-video`.
    INSERT temp10 INTO TABLE temp9.
    temp10-text = `Node1-1-2-1-2`.
    temp10-ref = `sap-icon://attachment-zip-file`.
    INSERT temp10 INTO TABLE temp9.
    temp10-text = `Node1-1-2-1-3`.
    temp10-ref = `sap-icon://course-program`.
    INSERT temp10 INTO TABLE temp9.
    temp8-nodes = temp9.
    INSERT temp8 INTO TABLE temp7.
    temp6-nodes = temp7.
    INSERT temp6 INTO TABLE temp5.
    temp4-nodes = temp5.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Node1-2`.
    temp4-ref = `sap-icon://create`.
    INSERT temp4 INTO TABLE temp3.
    temp2-nodes = temp3.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `Node2`.
    temp2-ref = `sap-icon://customer-financial-fact-sheet`.
    INSERT temp2 INTO TABLE temp1.
    t_nodes = temp1.
  ENDMETHOD.

ENDCLASS.
