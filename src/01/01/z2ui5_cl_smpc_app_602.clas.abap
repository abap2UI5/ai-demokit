" @keywords tree sap.m treeexpandto text toolbarspacer select item button standardtreeitem
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

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_602 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA root TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    root = view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc` ).

    
    CLEAR temp1.
    INSERT `Tree` INTO TABLE temp1.
    INSERT `expandToLevel` INTO TABLE temp1.
    INSERT `${$parameters>/selectedItem}.getKey()` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `Tree` INTO TABLE temp2.
    INSERT `collapseAll` INTO TABLE temp2.
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
                                                                      t_arg = temp1 )
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
                                                                t_arg = temp2 )
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
    
    CLEAR temp3.
    INSERT `Tree` INTO TABLE temp3.
    INSERT `expandToLevel` INTO TABLE temp3.
    INSERT `1` INTO TABLE temp3.
    client->follow_up_action( val   = client->cs_event-control_by_id
                              t_arg = temp3 ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    DATA temp5 LIKE t_nodes.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp7 TYPE z2ui5_cl_smpc_app_602=>ty_s_node_level1-nodes.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp1 TYPE z2ui5_cl_smpc_app_602=>ty_s_node_level2-nodes.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp17 TYPE z2ui5_cl_smpc_app_602=>ty_s_node_level3-nodes.
    DATA temp18 LIKE LINE OF temp17.
    DATA temp29 TYPE z2ui5_cl_smpc_app_602=>ty_s_node_level4-nodes.
    DATA temp30 LIKE LINE OF temp29.
    DATA temp3 TYPE z2ui5_cl_smpc_app_602=>ty_s_node_level2-nodes.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp19 TYPE z2ui5_cl_smpc_app_602=>ty_s_node_level3-nodes.
    DATA temp20 LIKE LINE OF temp19.
    DATA temp31 TYPE z2ui5_cl_smpc_app_602=>ty_s_node_level4-nodes.
    DATA temp32 LIKE LINE OF temp31.
    DATA temp9 TYPE z2ui5_cl_smpc_app_602=>ty_s_node_level2-nodes.
    DATA temp10 LIKE LINE OF temp9.
    DATA temp21 TYPE z2ui5_cl_smpc_app_602=>ty_s_node_level3-nodes.
    DATA temp22 LIKE LINE OF temp21.
    DATA temp33 TYPE z2ui5_cl_smpc_app_602=>ty_s_node_level4-nodes.
    DATA temp34 LIKE LINE OF temp33.
    DATA temp11 TYPE z2ui5_cl_smpc_app_602=>ty_s_node_level2-nodes.
    DATA temp12 LIKE LINE OF temp11.
    DATA temp23 TYPE z2ui5_cl_smpc_app_602=>ty_s_node_level3-nodes.
    DATA temp24 LIKE LINE OF temp23.
    DATA temp35 TYPE z2ui5_cl_smpc_app_602=>ty_s_node_level4-nodes.
    DATA temp36 LIKE LINE OF temp35.
    DATA temp13 TYPE z2ui5_cl_smpc_app_602=>ty_s_node_level2-nodes.
    DATA temp14 LIKE LINE OF temp13.
    DATA temp25 TYPE z2ui5_cl_smpc_app_602=>ty_s_node_level3-nodes.
    DATA temp26 LIKE LINE OF temp25.
    DATA temp37 TYPE z2ui5_cl_smpc_app_602=>ty_s_node_level4-nodes.
    DATA temp38 LIKE LINE OF temp37.
    DATA temp15 TYPE z2ui5_cl_smpc_app_602=>ty_s_node_level2-nodes.
    DATA temp16 LIKE LINE OF temp15.
    DATA temp27 TYPE z2ui5_cl_smpc_app_602=>ty_s_node_level3-nodes.
    DATA temp28 LIKE LINE OF temp27.
    DATA temp39 TYPE z2ui5_cl_smpc_app_602=>ty_s_node_level4-nodes.
    DATA temp40 LIKE LINE OF temp39.
    CLEAR temp5.
    
    temp6-text = `Node1`.
    temp6-ref = `sap-icon://attachment-audio`.
    
    CLEAR temp7.
    
    temp8-text = `Node1-1`.
    temp8-ref = `sap-icon://attachment-e-pub`.
    
    CLEAR temp1.
    
    temp2-text = `Node1-1-1`.
    temp2-ref = `sap-icon://attachment-html`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `Node1-1-2`.
    temp2-ref = `sap-icon://attachment-photo`.
    
    CLEAR temp17.
    
    temp18-text = `Node1-1-2-1`.
    temp18-ref = `sap-icon://attachment-text-file`.
    
    CLEAR temp29.
    
    temp30-text = `Node1-1-2-1-1`.
    temp30-ref = `sap-icon://attachment-video`.
    INSERT temp30 INTO TABLE temp29.
    temp30-text = `Node1-1-2-1-2`.
    temp30-ref = `sap-icon://attachment-zip-file`.
    INSERT temp30 INTO TABLE temp29.
    temp30-text = `Node1-1-2-1-3`.
    temp30-ref = `sap-icon://course-program`.
    INSERT temp30 INTO TABLE temp29.
    temp18-nodes = temp29.
    INSERT temp18 INTO TABLE temp17.
    temp2-nodes = temp17.
    INSERT temp2 INTO TABLE temp1.
    temp8-nodes = temp1.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Node1-2`.
    temp8-ref = `sap-icon://create`.
    
    CLEAR temp3.
    
    temp4-text = `Node1-2-1`.
    temp4-ref = `sap-icon://attachment-html`.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Node1-2-2`.
    temp4-ref = `sap-icon://attachment-photo`.
    
    CLEAR temp19.
    
    temp20-text = `Node1-2-2-1`.
    temp20-ref = `sap-icon://attachment-text-file`.
    
    CLEAR temp31.
    
    temp32-text = `Node1-2-2-1-1`.
    temp32-ref = `sap-icon://attachment-video`.
    INSERT temp32 INTO TABLE temp31.
    temp32-text = `Node1-2-2-1-2`.
    temp32-ref = `sap-icon://attachment-zip-file`.
    INSERT temp32 INTO TABLE temp31.
    temp32-text = `Node1-2-2-1-3`.
    temp32-ref = `sap-icon://course-program`.
    INSERT temp32 INTO TABLE temp31.
    temp20-nodes = temp31.
    INSERT temp20 INTO TABLE temp19.
    temp4-nodes = temp19.
    INSERT temp4 INTO TABLE temp3.
    temp8-nodes = temp3.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Node1-3`.
    temp8-ref = `sap-icon://create`.
    
    CLEAR temp9.
    
    temp10-text = `Node1-3-1`.
    temp10-ref = `sap-icon://attachment-html`.
    INSERT temp10 INTO TABLE temp9.
    temp10-text = `Node1-3-2`.
    temp10-ref = `sap-icon://attachment-photo`.
    
    CLEAR temp21.
    
    temp22-text = `Node1-3-2-1`.
    temp22-ref = `sap-icon://attachment-text-file`.
    
    CLEAR temp33.
    
    temp34-text = `Node1-3-2-1-1`.
    temp34-ref = `sap-icon://attachment-video`.
    INSERT temp34 INTO TABLE temp33.
    temp34-text = `Node1-3-2-1-2`.
    temp34-ref = `sap-icon://attachment-zip-file`.
    INSERT temp34 INTO TABLE temp33.
    temp34-text = `Node1-3-2-1-3`.
    temp34-ref = `sap-icon://course-program`.
    INSERT temp34 INTO TABLE temp33.
    temp22-nodes = temp33.
    INSERT temp22 INTO TABLE temp21.
    temp10-nodes = temp21.
    INSERT temp10 INTO TABLE temp9.
    temp8-nodes = temp9.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Node1-4`.
    temp8-ref = `sap-icon://attachment-e-pub`.
    
    CLEAR temp11.
    
    temp12-text = `Node1-4-1`.
    temp12-ref = `sap-icon://attachment-html`.
    INSERT temp12 INTO TABLE temp11.
    temp12-text = `Node1-4-2`.
    temp12-ref = `sap-icon://attachment-photo`.
    
    CLEAR temp23.
    
    temp24-text = `Node1-4-2-1`.
    temp24-ref = `sap-icon://attachment-text-file`.
    
    CLEAR temp35.
    
    temp36-text = `Node1-4-2-1-1`.
    temp36-ref = `sap-icon://attachment-video`.
    INSERT temp36 INTO TABLE temp35.
    temp36-text = `Node1-4-2-1-2`.
    temp36-ref = `sap-icon://attachment-zip-file`.
    INSERT temp36 INTO TABLE temp35.
    temp36-text = `Node1-4-2-1-3`.
    temp36-ref = `sap-icon://course-program`.
    INSERT temp36 INTO TABLE temp35.
    temp24-nodes = temp35.
    INSERT temp24 INTO TABLE temp23.
    temp12-nodes = temp23.
    INSERT temp12 INTO TABLE temp11.
    temp8-nodes = temp11.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Node1-5`.
    temp8-ref = `sap-icon://attachment-e-pub`.
    
    CLEAR temp13.
    
    temp14-text = `Node1-5-1`.
    temp14-ref = `sap-icon://attachment-html`.
    INSERT temp14 INTO TABLE temp13.
    temp14-text = `Node1-5-2`.
    temp14-ref = `sap-icon://attachment-photo`.
    
    CLEAR temp25.
    
    temp26-text = `Node1-5-2-1`.
    temp26-ref = `sap-icon://attachment-text-file`.
    
    CLEAR temp37.
    
    temp38-text = `Node1-5-2-1-1`.
    temp38-ref = `sap-icon://attachment-video`.
    INSERT temp38 INTO TABLE temp37.
    temp38-text = `Node1-5-2-1-2`.
    temp38-ref = `sap-icon://attachment-zip-file`.
    INSERT temp38 INTO TABLE temp37.
    temp38-text = `Node1-5-2-1-3`.
    temp38-ref = `sap-icon://course-program`.
    INSERT temp38 INTO TABLE temp37.
    temp26-nodes = temp37.
    INSERT temp26 INTO TABLE temp25.
    temp14-nodes = temp25.
    INSERT temp14 INTO TABLE temp13.
    temp8-nodes = temp13.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Node1-6`.
    temp8-ref = `sap-icon://attachment-e-pub`.
    
    CLEAR temp15.
    
    temp16-text = `Node1-6-1`.
    temp16-ref = `sap-icon://attachment-html`.
    INSERT temp16 INTO TABLE temp15.
    temp16-text = `Node1-6-2`.
    temp16-ref = `sap-icon://attachment-photo`.
    
    CLEAR temp27.
    
    temp28-text = `Node1-6-2-1`.
    temp28-ref = `sap-icon://attachment-text-file`.
    
    CLEAR temp39.
    
    temp40-text = `Node1-6-2-1-1`.
    temp40-ref = `sap-icon://attachment-video`.
    INSERT temp40 INTO TABLE temp39.
    temp40-text = `Node1-6-2-1-2`.
    temp40-ref = `sap-icon://attachment-zip-file`.
    INSERT temp40 INTO TABLE temp39.
    temp40-text = `Node1-6-2-1-3`.
    temp40-ref = `sap-icon://course-program`.
    INSERT temp40 INTO TABLE temp39.
    temp28-nodes = temp39.
    INSERT temp28 INTO TABLE temp27.
    temp16-nodes = temp27.
    INSERT temp16 INTO TABLE temp15.
    temp8-nodes = temp15.
    INSERT temp8 INTO TABLE temp7.
    temp6-nodes = temp7.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Node2`.
    temp6-ref = `sap-icon://customer-financial-fact-sheet`.
    INSERT temp6 INTO TABLE temp5.
    t_nodes = temp5.

  ENDMETHOD.

ENDCLASS.
