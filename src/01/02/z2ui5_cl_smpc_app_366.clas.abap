" @keywords treetable tree table sap.ui.table treetable.odataannotationstreebinding column label text
" @summary Illustrates how to bind to data from an OData model using $metadata annotations.
CLASS z2ui5_cl_smpc_app_366 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the mock service's Nodes are a FLAT list carrying HierarchyLevel /
    " NodeID / ParentNodeID / DrillState, which only an OData tree binding can
    " assemble into a tree. abap2UI5 serves one JSON model, so the same nodes
    " are modelled NESTED here (one children table per level) and bound with
    " arrayNames - the JSON tree binding the framework does support. Every
    " node keeps all FIVE of its own fields (NodeID, HierarchyLevel, Description,
    " ParentNodeID, DrillState); four of them are rendered as columns, and the
    " fifth - ParentNodeID - is what the nesting replaces, carried but not shown
    TYPES:
      BEGIN OF ty_s_node3,
        nodeid         TYPE i,
        hierarchylevel TYPE i,
        description    TYPE string,
        parentnodeid   TYPE string,
        drillstate     TYPE string,
      END OF ty_s_node3,
      ty_t_node3 TYPE STANDARD TABLE OF ty_s_node3 WITH DEFAULT KEY,
      BEGIN OF ty_s_node2,
        nodeid         TYPE i,
        hierarchylevel TYPE i,
        description    TYPE string,
        parentnodeid   TYPE string,
        drillstate     TYPE string,
        children       TYPE ty_t_node3,
      END OF ty_s_node2,
      ty_t_node2 TYPE STANDARD TABLE OF ty_s_node2 WITH DEFAULT KEY,
      BEGIN OF ty_s_node1,
        nodeid         TYPE i,
        hierarchylevel TYPE i,
        description    TYPE string,
        parentnodeid   TYPE string,
        drillstate     TYPE string,
        children       TYPE ty_t_node2,
      END OF ty_s_node1,
      ty_t_node1 TYPE STANDARD TABLE OF ty_s_node1 WITH DEFAULT KEY,
      BEGIN OF ty_s_node0,
        nodeid         TYPE i,
        hierarchylevel TYPE i,
        description    TYPE string,
        parentnodeid   TYPE string,
        drillstate     TYPE string,
        children       TYPE ty_t_node1,
      END OF ty_s_node0.
    DATA t_nodes TYPE STANDARD TABLE OF ty_s_node0 WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_366 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " the tree comes from the model's own nesting instead of the OData tree
    " ANNOTATIONS the service metadata carries; numberOfExpandedLevels is kept
    " as a binding parameter, so the first level opens like in the original.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.ui.table`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( `TreeTable`
            )->a( n = `id`                     v = `treeTable`
            )->a( n = `selectionMode`          v = `Single`
            )->a( n = `enableColumnReordering` v = `false`
            )->a( n = `rows`                   v = |\{ path: '{ client->_bind_path( t_nodes ) }', parameters: \{ arrayNames: ['CHILDREN'], numberOfExpandedLevels: 1 \} \}|

            )->ele( `columns`
                )->ele( `Column`
                    )->tag( n = `Label` ns = `m`
                        )->a( n = `text` v = `Description`

                    )->ele( `template`
                        )->tag( n = `Text` ns = `m`
                            )->a( n = `text`     v = `{DESCRIPTION}`
                            )->a( n = `wrapping` v = `false`

                    )->end(
                )->end(
                )->ele( `Column`
                    )->tag( n = `Label` ns = `m`
                        )->a( n = `text` v = `HierarchyLevel`

                    )->ele( `template`
                        )->tag( n = `Text` ns = `m`
                            )->a( n = `text`     v = `{HIERARCHYLEVEL}`
                            )->a( n = `wrapping` v = `false`

                    )->end(
                )->end(
                )->ele( `Column`
                    )->tag( n = `Label` ns = `m`
                        )->a( n = `text` v = `NodeID`

                    )->ele( `template`
                        )->tag( n = `Text` ns = `m`
                            )->a( n = `text`     v = `{NODEID}`
                            )->a( n = `wrapping` v = `false`

                    )->end(
                )->end(
                )->ele( `Column`
                    )->tag( n = `Label` ns = `m`
                        )->a( n = `text` v = `ParentNodeID`

                    )->ele( `template`
                        )->tag( n = `Text` ns = `m`
                            )->a( n = `text`     v = `{PARENTNODEID}`
                            )->a( n = `wrapping` v = `false`

                    )->end(
                )->end(
            )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " localService/mockdata/Nodes.json - the sixteen nodes of the mock service,
    " re-shaped from the flat parent/child list into the nesting the JSON tree
    " binding needs. Node ids, levels, descriptions, parent ids and drill states
    " are the mock's own values
    DATA temp1 LIKE t_nodes.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE z2ui5_cl_smpc_app_366=>ty_t_node1.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp9 TYPE z2ui5_cl_smpc_app_366=>ty_t_node2.
    DATA temp10 LIKE LINE OF temp9.
    DATA temp5 TYPE z2ui5_cl_smpc_app_366=>ty_t_node1.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp7 TYPE z2ui5_cl_smpc_app_366=>ty_t_node1.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp11 TYPE z2ui5_cl_smpc_app_366=>ty_t_node2.
    DATA temp12 LIKE LINE OF temp11.
    DATA temp13 TYPE z2ui5_cl_smpc_app_366=>ty_t_node3.
    DATA temp14 LIKE LINE OF temp13.
    CLEAR temp1.
    
    temp2-nodeid = 1.
    temp2-hierarchylevel = 0.
    temp2-description = `1`.
    temp2-parentnodeid = ``.
    temp2-drillstate = `expanded`.
    
    CLEAR temp3.
    
    temp4-nodeid = 4.
    temp4-hierarchylevel = 1.
    temp4-description = `1.1`.
    temp4-parentnodeid = `1`.
    temp4-drillstate = `leaf`.
    INSERT temp4 INTO TABLE temp3.
    temp4-nodeid = 5.
    temp4-hierarchylevel = 1.
    temp4-description = `1.2`.
    temp4-parentnodeid = `1`.
    temp4-drillstate = `expanded`.
    
    CLEAR temp9.
    
    temp10-nodeid = 6.
    temp10-hierarchylevel = 2.
    temp10-description = `1.2.1`.
    temp10-parentnodeid = `5`.
    temp10-drillstate = `leaf`.
    INSERT temp10 INTO TABLE temp9.
    temp10-nodeid = 7.
    temp10-hierarchylevel = 2.
    temp10-description = `1.2.2`.
    temp10-parentnodeid = `5`.
    temp10-drillstate = `leaf`.
    INSERT temp10 INTO TABLE temp9.
    temp4-children = temp9.
    INSERT temp4 INTO TABLE temp3.
    temp2-children = temp3.
    INSERT temp2 INTO TABLE temp1.
    temp2-nodeid = 2.
    temp2-hierarchylevel = 0.
    temp2-description = `2`.
    temp2-parentnodeid = ``.
    temp2-drillstate = `expanded`.
    
    CLEAR temp5.
    
    temp6-nodeid = 8.
    temp6-hierarchylevel = 1.
    temp6-description = `2.1`.
    temp6-parentnodeid = `2`.
    temp6-drillstate = `leaf`.
    INSERT temp6 INTO TABLE temp5.
    temp6-nodeid = 9.
    temp6-hierarchylevel = 1.
    temp6-description = `2.2`.
    temp6-parentnodeid = `2`.
    temp6-drillstate = `leaf`.
    INSERT temp6 INTO TABLE temp5.
    temp6-nodeid = 10.
    temp6-hierarchylevel = 1.
    temp6-description = `2.3`.
    temp6-parentnodeid = `2`.
    temp6-drillstate = `leaf`.
    INSERT temp6 INTO TABLE temp5.
    temp2-children = temp5.
    INSERT temp2 INTO TABLE temp1.
    temp2-nodeid = 3.
    temp2-hierarchylevel = 0.
    temp2-description = `3`.
    temp2-parentnodeid = ``.
    temp2-drillstate = `expanded`.
    
    CLEAR temp7.
    
    temp8-nodeid = 11.
    temp8-hierarchylevel = 1.
    temp8-description = `3.1`.
    temp8-parentnodeid = `3`.
    temp8-drillstate = `expanded`.
    
    CLEAR temp11.
    
    temp12-nodeid = 12.
    temp12-hierarchylevel = 2.
    temp12-description = `3.1.1`.
    temp12-parentnodeid = `11`.
    temp12-drillstate = `expanded`.
    
    CLEAR temp13.
    
    temp14-nodeid = 13.
    temp14-hierarchylevel = 3.
    temp14-description = `3.1.1.1`.
    temp14-parentnodeid = `12`.
    temp14-drillstate = `leaf`.
    INSERT temp14 INTO TABLE temp13.
    temp14-nodeid = 14.
    temp14-hierarchylevel = 3.
    temp14-description = `3.1.1.2`.
    temp14-parentnodeid = `12`.
    temp14-drillstate = `leaf`.
    INSERT temp14 INTO TABLE temp13.
    temp14-nodeid = 15.
    temp14-hierarchylevel = 3.
    temp14-description = `3.1.1.3`.
    temp14-parentnodeid = `12`.
    temp14-drillstate = `leaf`.
    INSERT temp14 INTO TABLE temp13.
    temp14-nodeid = 16.
    temp14-hierarchylevel = 3.
    temp14-description = `3.1.1.4`.
    temp14-parentnodeid = `12`.
    temp14-drillstate = `leaf`.
    INSERT temp14 INTO TABLE temp13.
    temp12-children = temp13.
    INSERT temp12 INTO TABLE temp11.
    temp8-children = temp11.
    INSERT temp8 INTO TABLE temp7.
    temp2-children = temp7.
    INSERT temp2 INTO TABLE temp1.
    t_nodes = temp1.

  ENDMETHOD.

ENDCLASS.
