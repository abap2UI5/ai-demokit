CLASS z2ui5_cl_api_app_487 DEFINITION PUBLIC.

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

    METHODS model_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_487 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    DATA temp1 LIKE t_nodes.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE z2ui5_cl_api_app_487=>ty_s_node_level1-nodes.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 TYPE z2ui5_cl_api_app_487=>ty_s_node_level2-nodes.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp7 TYPE z2ui5_cl_api_app_487=>ty_s_node_level3-nodes.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp9 TYPE z2ui5_cl_api_app_487=>ty_s_node_level4-nodes.
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


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_api_xml.
    view = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `Tree`
            )->a( n = `id`    v = `Tree`
            " '{path: '/'}' -> bind the root table; the nested `nodes` drive the depth
            )->a( n = `items` v = client->_bind_edit( t_nodes )

            )->leaf( `StandardTreeItem`
                )->a( n = `title` v = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
