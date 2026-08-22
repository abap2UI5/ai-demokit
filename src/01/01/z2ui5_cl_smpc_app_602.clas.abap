" @keywords tree sap.m treeexpandto text toolbarspacer select button standardtreeitem
" @summary This example shows the initial expand state and how to collapse all nodes.
CLASS z2ui5_cl_smpc_app_602 DEFINITION PUBLIC.

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

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_602 IMPLEMENTATION.

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
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc` ).

    root->ele( `OverflowToolbar`
        )->ele( `content`
            )->tag( `Text`
                )->a( n = `text` v = `Initially expand to Level1`
            )->tag( `ToolbarSpacer`
            )->tag( `Text`
                )->a( n = `text` v = `Expand to level `

            " handleSelectChange does tree.expandToLevel( selectedItem.getKey( ) );
            " expandToLevel is whitelisted, so the change is a roundtrip-free
            " frontend action carrying the picked key (app 248/365 idiom)
            )->ele( `Select`
                )->a( n = `selectedKey` v = `1`
                )->a( n = `change`      v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                      t_arg = VALUE #( ( `Tree` )
                                                                                       ( `expandToLevel` )
                                                                                       ( `${$parameters>/selectedItem}.getKey()` ) ) )
                )->ele( `items`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `0`
                        )->a( n = `text` v = `0`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `1`
                        )->a( n = `text` v = `1`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `2`
                        )->a( n = `text` v = `2`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `3`
                        )->a( n = `text` v = `3`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `4`
                        )->a( n = `text` v = `4`
                )->end(
            )->end(

            )->tag( `Button`
                )->a( n = `id`    v = `collapseAll`
                )->a( n = `text`  v = `collapse all nodes`
                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                t_arg = VALUE #( ( `Tree` ) ( `collapseAll` ) ) )
        )->end(
    )->end( ).

    root->ele( `Tree`
        )->a( n = `id`    v = `Tree`
        " items path '/' - bind the root table; the nested `nodes` drive the depth
        )->a( n = `items` v = client->_bind( t_nodes )

        )->tag( `StandardTreeItem`
            )->a( n = `title` v = `{TEXT}`
    )->end( ).

    " onInit does tree.expandToLevel( 1 ), which is what the Select's own
    " selectedKey='1' announces
    client->follow_up_action( val   = client->cs_event-control_by_id
                              t_arg = VALUE #( ( `Tree` ) ( `expandToLevel` ) ( `1` ) ) ).

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
              ( text  = `Node1-2`
                ref   = `sap-icon://create`
                nodes = VALUE #(
                    ( text = `Node1-2-1`
                      ref  = `sap-icon://attachment-html` )
                    ( text  = `Node1-2-2`
                      ref   = `sap-icon://attachment-photo`
                      nodes = VALUE #(
                          ( text  = `Node1-2-2-1`
                            ref   = `sap-icon://attachment-text-file`
                            nodes = VALUE #(
                                ( text = `Node1-2-2-1-1`
                                  ref  = `sap-icon://attachment-video` )
                                ( text = `Node1-2-2-1-2`
                                  ref  = `sap-icon://attachment-zip-file` )
                                ( text = `Node1-2-2-1-3`
                                  ref  = `sap-icon://course-program` ) ) ) ) ) ) )
              ( text  = `Node1-3`
                ref   = `sap-icon://create`
                nodes = VALUE #(
                    ( text = `Node1-3-1`
                      ref  = `sap-icon://attachment-html` )
                    ( text  = `Node1-3-2`
                      ref   = `sap-icon://attachment-photo`
                      nodes = VALUE #(
                          ( text  = `Node1-3-2-1`
                            ref   = `sap-icon://attachment-text-file`
                            nodes = VALUE #(
                                ( text = `Node1-3-2-1-1`
                                  ref  = `sap-icon://attachment-video` )
                                ( text = `Node1-3-2-1-2`
                                  ref  = `sap-icon://attachment-zip-file` )
                                ( text = `Node1-3-2-1-3`
                                  ref  = `sap-icon://course-program` ) ) ) ) ) ) )
              ( text  = `Node1-4`
                ref   = `sap-icon://attachment-e-pub`
                nodes = VALUE #(
                    ( text = `Node1-4-1`
                      ref  = `sap-icon://attachment-html` )
                    ( text  = `Node1-4-2`
                      ref   = `sap-icon://attachment-photo`
                      nodes = VALUE #(
                          ( text  = `Node1-4-2-1`
                            ref   = `sap-icon://attachment-text-file`
                            nodes = VALUE #(
                                ( text = `Node1-4-2-1-1`
                                  ref  = `sap-icon://attachment-video` )
                                ( text = `Node1-4-2-1-2`
                                  ref  = `sap-icon://attachment-zip-file` )
                                ( text = `Node1-4-2-1-3`
                                  ref  = `sap-icon://course-program` ) ) ) ) ) ) )
              ( text  = `Node1-5`
                ref   = `sap-icon://attachment-e-pub`
                nodes = VALUE #(
                    ( text = `Node1-5-1`
                      ref  = `sap-icon://attachment-html` )
                    ( text  = `Node1-5-2`
                      ref   = `sap-icon://attachment-photo`
                      nodes = VALUE #(
                          ( text  = `Node1-5-2-1`
                            ref   = `sap-icon://attachment-text-file`
                            nodes = VALUE #(
                                ( text = `Node1-5-2-1-1`
                                  ref  = `sap-icon://attachment-video` )
                                ( text = `Node1-5-2-1-2`
                                  ref  = `sap-icon://attachment-zip-file` )
                                ( text = `Node1-5-2-1-3`
                                  ref  = `sap-icon://course-program` ) ) ) ) ) ) )
              ( text  = `Node1-6`
                ref   = `sap-icon://attachment-e-pub`
                nodes = VALUE #(
                    ( text = `Node1-6-1`
                      ref  = `sap-icon://attachment-html` )
                    ( text  = `Node1-6-2`
                      ref   = `sap-icon://attachment-photo`
                      nodes = VALUE #(
                          ( text  = `Node1-6-2-1`
                            ref   = `sap-icon://attachment-text-file`
                            nodes = VALUE #(
                                ( text = `Node1-6-2-1-1`
                                  ref  = `sap-icon://attachment-video` )
                                ( text = `Node1-6-2-1-2`
                                  ref  = `sap-icon://attachment-zip-file` )
                                ( text = `Node1-6-2-1-3`
                                  ref  = `sap-icon://course-program` ) ) ) ) ) ) ) ) )
        ( text = `Node2`
          ref  = `sap-icon://customer-financial-fact-sheet` ) ).

  ENDMETHOD.

ENDCLASS.
