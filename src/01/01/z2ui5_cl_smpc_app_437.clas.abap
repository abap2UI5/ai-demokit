" @keywords tree sap.m treeselection overflowtoolbar title toolbarspacer select standardtreeitem
" @summary This example shows different selection modes of Tree.
CLASS z2ui5_cl_smpc_app_437 DEFINITION PUBLIC.

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
        nodes TYPE STANDARD TABLE OF ty_s_node_level5 WITH EMPTY KEY,
      END OF ty_s_node_level4,
      BEGIN OF ty_s_node_level3,
        text  TYPE string,
        ref   TYPE string,
        nodes TYPE STANDARD TABLE OF ty_s_node_level4 WITH EMPTY KEY,
      END OF ty_s_node_level3,
      BEGIN OF ty_s_node_level2,
        text  TYPE string,
        ref   TYPE string,
        nodes TYPE STANDARD TABLE OF ty_s_node_level3 WITH EMPTY KEY,
      END OF ty_s_node_level2,
      BEGIN OF ty_s_node_level1,
        text  TYPE string,
        ref   TYPE string,
        nodes TYPE STANDARD TABLE OF ty_s_node_level2 WITH EMPTY KEY,
      END OF ty_s_node_level1.
    DATA t_nodes TYPE STANDARD TABLE OF ty_s_node_level1 WITH EMPTY KEY.
    DATA mode TYPE string VALUE `MultiSelect`.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_437 IMPLEMENTATION.

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

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `Tree`
            )->a( n = `id`                     v = `Tree`
            " items path '/' - bind the root table; the nested `nodes` drive the depth
            )->a( n = `items`                  v = client->_bind( t_nodes )
            " handleSelectChange calls tree.setMode( selectedItem.getKey( ) ) - the
            " Select and the Tree share one two-way bound field instead (change dropped)
            )->a( n = `mode`                   v = client->_bind( mode )
            )->a( n = `includeItemInSelection` v = `true`

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`

                    )->ele( `content`
                        )->tag( `Title`
                            )->a( n = `text`  v = `Nodes`
                            )->a( n = `level` v = `H2`
                        )->tag( `ToolbarSpacer`
                        )->ele( `Select`
                            )->a( n = `selectedKey` v = client->_bind( mode )

                            )->ele( `items`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `key`  v = `None`
                                    )->a( n = `text` v = `No Selection`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `key`  v = `SingleSelect`
                                    )->a( n = `text` v = `Single Selection`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `key`  v = `SingleSelectLeft`
                                    )->a( n = `text` v = `Single Selection Left`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `key`  v = `SingleSelectMaster`
                                    )->a( n = `text` v = `Single Selection (Master)`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `key`  v = `MultiSelect`
                                    )->a( n = `text` v = `Multi Selection`

                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(

            )->tag( `StandardTreeItem`
                )->a( n = `title` v = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    t_nodes = VALUE #(
        ( text  = `Node1`
          ref   = `sap-icon://attachment-audio`
          nodes = VALUE #(
              ( text  = `Node1-1`
                ref   = `sap-icon://attachment-e-pub`
                nodes = VALUE #(
                    ( text = `Node1-1-1`
                      ref  = `sap-icon://attachment-html` )
                    ( text  = `Node1-1-2`
                      ref   = `sap-icon://attachment-photo`
                      nodes = VALUE #(
                          ( text  = `Node1-1-2-1`
                            ref   = `sap-icon://attachment-text-file`
                            nodes = VALUE #(
                                ( text = `Node1-1-2-1-1`
                                  ref  = `sap-icon://attachment-video` )
                                ( text = `Node1-1-2-1-2`
                                  ref  = `sap-icon://attachment-zip-file` )
                                ( text = `Node1-1-2-1-3`
                                  ref  = `sap-icon://course-program` ) ) ) ) ) ) )
              ( text = `Node1-2`
                ref  = `sap-icon://create` ) ) )
        ( text = `Node2`
          ref  = `sap-icon://customer-financial-fact-sheet` ) ).
  ENDMETHOD.

ENDCLASS.
