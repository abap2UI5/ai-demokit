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
        nodes TYPE STANDARD TABLE OF ty_s_node_level6 WITH DEFAULT KEY,
      END OF ty_s_node_level5,
      BEGIN OF ty_s_node_level4,
        text  TYPE string,
        dummy TYPE abap_bool,
        nodes TYPE STANDARD TABLE OF ty_s_node_level5 WITH DEFAULT KEY,
      END OF ty_s_node_level4,
      BEGIN OF ty_s_node_level3,
        text  TYPE string,
        dummy TYPE abap_bool,
        nodes TYPE STANDARD TABLE OF ty_s_node_level4 WITH DEFAULT KEY,
      END OF ty_s_node_level3,
      BEGIN OF ty_s_node_level2,
        text  TYPE string,
        dummy TYPE abap_bool,
        nodes TYPE STANDARD TABLE OF ty_s_node_level3 WITH DEFAULT KEY,
      END OF ty_s_node_level2,
      BEGIN OF ty_s_node_level1,
        text  TYPE string,
        dummy TYPE abap_bool,
        nodes TYPE STANDARD TABLE OF ty_s_node_level2 WITH DEFAULT KEY,
      END OF ty_s_node_level1.

    TYPES temp1_537bfb1c6c TYPE STANDARD TABLE OF ty_s_node_level1 WITH DEFAULT KEY.
DATA t_nodes TYPE temp1_537bfb1c6c.

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
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `${$parameters>/itemIndex}` INTO TABLE temp1.
    INSERT `${$parameters>/itemContext}.getPath()` INTO TABLE temp1.
    INSERT `${$parameters>/expanded}` INTO TABLE temp1.
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
                                                               t_arg = temp1 )

            )->tag( `StandardTreeItem`
                )->a( n = `title` v = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    TYPES temp77 TYPE STANDARD TABLE OF i WITH DEFAULT KEY.
DATA indices  TYPE temp77.
    DATA segments TYPE string_table.
    DATA node1    TYPE REF TO ty_s_node_level1.
    DATA node2    TYPE REF TO ty_s_node_level2.
    DATA node3    TYPE REF TO ty_s_node_level3.
    DATA node4    TYPE REF TO ty_s_node_level4.
    DATA node5    TYPE REF TO ty_s_node_level5.
      DATA item_index TYPE string.
      DATA item_path TYPE string.
      DATA temp3 TYPE abap_bool.
      DATA expanded LIKE temp3.
      DATA temp4 TYPE string.
      DATA segment LIKE LINE OF segments.
          DATA temp5 TYPE i.
          DATA temp1 LIKE LINE OF indices.
      DATA level TYPE i.
      DATA suffix TYPE string.
      DATA suffix2 TYPE string.
      DATA is_last TYPE abap_bool.
      DATA temp78 TYPE xsdboolean.
          FIELD-SYMBOLS <temp6> TYPE z2ui5_cl_smpc_app_496=>ty_s_node_level1.
          DATA temp27 LIKE LINE OF indices.
          DATA temp28 LIKE sy-tabix.
          DATA temp7 TYPE z2ui5_cl_smpc_app_496=>ty_s_node_level1-nodes.
          DATA temp8 LIKE LINE OF temp7.
          DATA temp2 TYPE z2ui5_cl_smpc_app_496=>ty_s_node_level2-nodes.
          DATA temp6 LIKE LINE OF temp2.
          DATA temp23 TYPE z2ui5_cl_smpc_app_496=>ty_s_node_level3-text.
          DATA temp79 TYPE xsdboolean.
          FIELD-SYMBOLS <temp9> TYPE z2ui5_cl_smpc_app_496=>ty_s_node_level2.
          DATA temp29 LIKE LINE OF t_nodes.
          DATA temp30 LIKE sy-tabix.
          DATA temp37 LIKE LINE OF indices.
          DATA temp38 LIKE sy-tabix.
          DATA temp39 LIKE LINE OF indices.
          DATA temp40 LIKE sy-tabix.
          DATA temp10 TYPE z2ui5_cl_smpc_app_496=>ty_s_node_level2-nodes.
          DATA temp11 LIKE LINE OF temp10.
          DATA temp9 TYPE z2ui5_cl_smpc_app_496=>ty_s_node_level3-nodes.
          DATA temp12 LIKE LINE OF temp9.
          DATA temp24 TYPE z2ui5_cl_smpc_app_496=>ty_s_node_level4-text.
          DATA temp80 TYPE xsdboolean.
          FIELD-SYMBOLS <temp12> TYPE z2ui5_cl_smpc_app_496=>ty_s_node_level3.
          DATA temp31 LIKE LINE OF t_nodes.
          DATA temp32 LIKE sy-tabix.
          DATA temp41 LIKE LINE OF indices.
          DATA temp42 LIKE sy-tabix.
          DATA temp43 LIKE LINE OF temp31-nodes.
          DATA temp44 LIKE sy-tabix.
          DATA temp53 LIKE LINE OF indices.
          DATA temp54 LIKE sy-tabix.
          DATA temp55 LIKE LINE OF indices.
          DATA temp56 LIKE sy-tabix.
          DATA temp13 TYPE z2ui5_cl_smpc_app_496=>ty_s_node_level3-nodes.
          DATA temp14 LIKE LINE OF temp13.
          DATA temp15 TYPE z2ui5_cl_smpc_app_496=>ty_s_node_level4-nodes.
          DATA temp18 LIKE LINE OF temp15.
          DATA temp25 TYPE z2ui5_cl_smpc_app_496=>ty_s_node_level5-text.
          DATA temp81 TYPE xsdboolean.
          FIELD-SYMBOLS <temp15> TYPE z2ui5_cl_smpc_app_496=>ty_s_node_level4.
          DATA temp33 LIKE LINE OF t_nodes.
          DATA temp34 LIKE sy-tabix.
          DATA temp45 LIKE LINE OF indices.
          DATA temp46 LIKE sy-tabix.
          DATA temp47 LIKE LINE OF temp33-nodes.
          DATA temp48 LIKE sy-tabix.
          DATA temp57 LIKE LINE OF indices.
          DATA temp58 LIKE sy-tabix.
          DATA temp59 LIKE LINE OF temp47-nodes.
          DATA temp60 LIKE sy-tabix.
          DATA temp65 LIKE LINE OF indices.
          DATA temp66 LIKE sy-tabix.
          DATA temp67 LIKE LINE OF indices.
          DATA temp68 LIKE sy-tabix.
          DATA temp16 TYPE z2ui5_cl_smpc_app_496=>ty_s_node_level4-nodes.
          DATA temp17 LIKE LINE OF temp16.
          DATA temp21 TYPE z2ui5_cl_smpc_app_496=>ty_s_node_level5-nodes.
          DATA temp22 LIKE LINE OF temp21.
          DATA temp26 TYPE z2ui5_cl_smpc_app_496=>ty_s_node_level6-text.
          DATA temp82 TYPE xsdboolean.
          FIELD-SYMBOLS <temp18> TYPE z2ui5_cl_smpc_app_496=>ty_s_node_level5.
          DATA temp35 LIKE LINE OF t_nodes.
          DATA temp36 LIKE sy-tabix.
          DATA temp49 LIKE LINE OF indices.
          DATA temp50 LIKE sy-tabix.
          DATA temp51 LIKE LINE OF temp35-nodes.
          DATA temp52 LIKE sy-tabix.
          DATA temp61 LIKE LINE OF indices.
          DATA temp62 LIKE sy-tabix.
          DATA temp63 LIKE LINE OF temp51-nodes.
          DATA temp64 LIKE sy-tabix.
          DATA temp69 LIKE LINE OF indices.
          DATA temp70 LIKE sy-tabix.
          DATA temp71 LIKE LINE OF temp63-nodes.
          DATA temp72 LIKE sy-tabix.
          DATA temp73 LIKE LINE OF indices.
          DATA temp74 LIKE sy-tabix.
          DATA temp75 LIKE LINE OF indices.
          DATA temp76 LIKE sy-tabix.
          DATA temp19 TYPE z2ui5_cl_smpc_app_496=>ty_s_node_level5-nodes.
          DATA temp20 LIKE LINE OF temp19.

    IF client->get_event( ) = `TOGGLE`.

      
      item_index = client->get_event_arg( ).
      
      item_path  = client->get_event_arg( 2 ).
      
      temp3 = client->get_event_arg( 3 ).
      
      expanded = temp3.

      
      IF expanded = abap_true.
        temp4 = `true`.
      ELSE.
        temp4 = `false`.
      ENDIF.
      client->message_toast_display(
          text     = |Item index: { item_index }| &&
                     |\nItem context (path): { item_path }| &&
                     |\nExpanded: { temp4 }|
          duration = `5000` ).

      IF expanded = abap_false.
        RETURN.
      ENDIF.

      " abap2UI5 sends /T_NODES/1/NODES/0 - NOT the original sample's /1/nodes/0:
      " the root is the bound attribute's name and the model is serialized
      " upper-cased, so matching a literal `nodes` never fires. Keep the numeric
      " segments and ignore the named ones, the way app 546's index_of does.
      SPLIT item_path AT `/` INTO TABLE segments.
      
      LOOP AT segments INTO segment.
        IF segment IS NOT INITIAL AND segment CO `0123456789`.
          
          temp5 = segment.
          
          temp1 = temp5 + 1.
          APPEND temp1 TO indices.
        ENDIF.
      ENDLOOP.

      " loadData replaces the dummy child of the expanded node with the next two
      " nodes; the level decides their name and whether they stay expandable
      
      level   = lines( indices ) - 1.
      
      suffix  = repeat( val = `-1` occ = level + 2 ).
      
      suffix2 = repeat( val = `-2` occ = level + 2 ).
      
      
      temp78 = boolc( level >= 5 ).
      is_last = temp78.

      CASE lines( indices ).

        WHEN 1.
          
          
          
          temp28 = sy-tabix.
          READ TABLE indices INDEX 1 INTO temp27.
          sy-tabix = temp28.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          READ TABLE t_nodes INDEX temp27 ASSIGNING <temp6>.
IF sy-subrc <> 0.
  ASSERT 1 = 0.
ENDIF.
GET REFERENCE OF <temp6> INTO node1.
          IF node1 IS INITIAL.
            RETURN.
          ENDIF.
          
          CLEAR temp7.
          
          temp8-text = |Node{ suffix }|.
          INSERT temp8 INTO TABLE temp7.
          temp8-text = |Node{ suffix2 }|.
          
          CLEAR temp2.
          
          
          IF is_last = abap_true.
            temp23 = `Last node`.
          ELSE.
            temp23 = ``.
          ENDIF.
          temp6-text = temp23.
          
          temp79 = boolc( is_last = abap_false ).
          temp6-dummy = temp79.
          INSERT temp6 INTO TABLE temp2.
          temp8-nodes = temp2.
          INSERT temp8 INTO TABLE temp7.
          node1->nodes = temp7.

        WHEN 2.
          
          
          
          temp30 = sy-tabix.
          
          
          temp38 = sy-tabix.
          READ TABLE indices INDEX 1 INTO temp37.
          sy-tabix = temp38.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          READ TABLE t_nodes INDEX temp37 INTO temp29.
          sy-tabix = temp30.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          
          
          temp40 = sy-tabix.
          READ TABLE indices INDEX 2 INTO temp39.
          sy-tabix = temp40.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          READ TABLE temp29-nodes INDEX temp39 ASSIGNING <temp9>.
IF sy-subrc <> 0.
  ASSERT 1 = 0.
ENDIF.
GET REFERENCE OF <temp9> INTO node2.
          IF node2 IS INITIAL.
            RETURN.
          ENDIF.
          
          CLEAR temp10.
          
          temp11-text = |Node{ suffix }|.
          INSERT temp11 INTO TABLE temp10.
          temp11-text = |Node{ suffix2 }|.
          
          CLEAR temp9.
          
          
          IF is_last = abap_true.
            temp24 = `Last node`.
          ELSE.
            temp24 = ``.
          ENDIF.
          temp12-text = temp24.
          
          temp80 = boolc( is_last = abap_false ).
          temp12-dummy = temp80.
          INSERT temp12 INTO TABLE temp9.
          temp11-nodes = temp9.
          INSERT temp11 INTO TABLE temp10.
          node2->nodes = temp10.

        WHEN 3.
          
          
          
          temp32 = sy-tabix.
          
          
          temp42 = sy-tabix.
          READ TABLE indices INDEX 1 INTO temp41.
          sy-tabix = temp42.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          READ TABLE t_nodes INDEX temp41 INTO temp31.
          sy-tabix = temp32.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          
          
          temp44 = sy-tabix.
          
          
          temp54 = sy-tabix.
          READ TABLE indices INDEX 2 INTO temp53.
          sy-tabix = temp54.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          READ TABLE temp31-nodes INDEX temp53 INTO temp43.
          sy-tabix = temp44.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          
          
          temp56 = sy-tabix.
          READ TABLE indices INDEX 3 INTO temp55.
          sy-tabix = temp56.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          READ TABLE temp43-nodes INDEX temp55 ASSIGNING <temp12>.
IF sy-subrc <> 0.
  ASSERT 1 = 0.
ENDIF.
GET REFERENCE OF <temp12> INTO node3.
          IF node3 IS INITIAL.
            RETURN.
          ENDIF.
          
          CLEAR temp13.
          
          temp14-text = |Node{ suffix }|.
          INSERT temp14 INTO TABLE temp13.
          temp14-text = |Node{ suffix2 }|.
          
          CLEAR temp15.
          
          
          IF is_last = abap_true.
            temp25 = `Last node`.
          ELSE.
            temp25 = ``.
          ENDIF.
          temp18-text = temp25.
          
          temp81 = boolc( is_last = abap_false ).
          temp18-dummy = temp81.
          INSERT temp18 INTO TABLE temp15.
          temp14-nodes = temp15.
          INSERT temp14 INTO TABLE temp13.
          node3->nodes = temp13.

        WHEN 4.
          
          
          
          temp34 = sy-tabix.
          
          
          temp46 = sy-tabix.
          READ TABLE indices INDEX 1 INTO temp45.
          sy-tabix = temp46.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          READ TABLE t_nodes INDEX temp45 INTO temp33.
          sy-tabix = temp34.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          
          
          temp48 = sy-tabix.
          
          
          temp58 = sy-tabix.
          READ TABLE indices INDEX 2 INTO temp57.
          sy-tabix = temp58.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          READ TABLE temp33-nodes INDEX temp57 INTO temp47.
          sy-tabix = temp48.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          
          
          temp60 = sy-tabix.
          
          
          temp66 = sy-tabix.
          READ TABLE indices INDEX 3 INTO temp65.
          sy-tabix = temp66.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          READ TABLE temp47-nodes INDEX temp65 INTO temp59.
          sy-tabix = temp60.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          
          
          temp68 = sy-tabix.
          READ TABLE indices INDEX 4 INTO temp67.
          sy-tabix = temp68.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          READ TABLE temp59-nodes INDEX temp67 ASSIGNING <temp15>.
IF sy-subrc <> 0.
  ASSERT 1 = 0.
ENDIF.
GET REFERENCE OF <temp15> INTO node4.
          IF node4 IS INITIAL.
            RETURN.
          ENDIF.
          
          CLEAR temp16.
          
          temp17-text = |Node{ suffix }|.
          INSERT temp17 INTO TABLE temp16.
          temp17-text = |Node{ suffix2 }|.
          
          CLEAR temp21.
          
          
          IF is_last = abap_true.
            temp26 = `Last node`.
          ELSE.
            temp26 = ``.
          ENDIF.
          temp22-text = temp26.
          
          temp82 = boolc( is_last = abap_false ).
          temp22-dummy = temp82.
          INSERT temp22 INTO TABLE temp21.
          temp17-nodes = temp21.
          INSERT temp17 INTO TABLE temp16.
          node4->nodes = temp16.

        WHEN 5.
          
          
          
          temp36 = sy-tabix.
          
          
          temp50 = sy-tabix.
          READ TABLE indices INDEX 1 INTO temp49.
          sy-tabix = temp50.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          READ TABLE t_nodes INDEX temp49 INTO temp35.
          sy-tabix = temp36.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          
          
          temp52 = sy-tabix.
          
          
          temp62 = sy-tabix.
          READ TABLE indices INDEX 2 INTO temp61.
          sy-tabix = temp62.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          READ TABLE temp35-nodes INDEX temp61 INTO temp51.
          sy-tabix = temp52.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          
          
          temp64 = sy-tabix.
          
          
          temp70 = sy-tabix.
          READ TABLE indices INDEX 3 INTO temp69.
          sy-tabix = temp70.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          READ TABLE temp51-nodes INDEX temp69 INTO temp63.
          sy-tabix = temp64.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          
          
          temp72 = sy-tabix.
          
          
          temp74 = sy-tabix.
          READ TABLE indices INDEX 4 INTO temp73.
          sy-tabix = temp74.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          READ TABLE temp63-nodes INDEX temp73 INTO temp71.
          sy-tabix = temp72.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          
          
          temp76 = sy-tabix.
          READ TABLE indices INDEX 5 INTO temp75.
          sy-tabix = temp76.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          READ TABLE temp71-nodes INDEX temp75 ASSIGNING <temp18>.
IF sy-subrc <> 0.
  ASSERT 1 = 0.
ENDIF.
GET REFERENCE OF <temp18> INTO node5.
          IF node5 IS INITIAL.
            RETURN.
          ENDIF.
          
          CLEAR temp19.
          
          temp20-text = |Node{ suffix }|.
          INSERT temp20 INTO TABLE temp19.
          temp20-text = |Node{ suffix2 }|.
          INSERT temp20 INTO TABLE temp19.
          node5->nodes = temp19.

        WHEN OTHERS.
          RETURN.
      ENDCASE.

    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " loadData( ) seeds the two root nodes; every deeper level is fetched when its
    " parent is expanded
    DATA temp21 LIKE t_nodes.
    DATA temp22 LIKE LINE OF temp21.
    DATA temp23 TYPE z2ui5_cl_smpc_app_496=>ty_s_node_level1-nodes.
    DATA temp24 LIKE LINE OF temp23.
    CLEAR temp21.
    
    temp22-text = `Node-1`.
    INSERT temp22 INTO TABLE temp21.
    temp22-text = `Node-2`.
    
    CLEAR temp23.
    
    temp24-text = ``.
    temp24-dummy = abap_true.
    INSERT temp24 INTO TABLE temp23.
    temp22-nodes = temp23.
    INSERT temp22 INTO TABLE temp21.
    t_nodes = temp21.

  ENDMETHOD.

ENDCLASS.
