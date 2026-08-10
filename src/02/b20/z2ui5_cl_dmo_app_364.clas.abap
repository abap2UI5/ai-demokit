CLASS z2ui5_cl_dmo_app_364 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the mock service's Nodes are a FLAT list carrying HierarchyLevel /
    " NodeID / ParentNodeID / DrillState, which only an OData tree binding can
    " assemble into a tree. abap2UI5 serves one JSON model, so the same nodes
    " are modelled NESTED here (one children table per level) and bound with
    " arrayNames - the JSON tree binding the framework does support. Every
    " node keeps all four of its own fields, so the four columns are unchanged
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


CLASS z2ui5_cl_dmo_app_364 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " the tree comes from the model's own nesting instead of the OData tree
    " annotations (hierarchyLevelFor / hierarchyNodeFor / hierarchyParentNodeFor
    " / hierarchyDrillStateFor), which have no counterpart without an OData
    " model - the rendered tree is the same one.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.ui.table`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `TreeTable`
            )->a( n = `id`                     v = `treeTable`
            )->a( n = `selectionMode`          v = `Single`
            )->a( n = `enableColumnReordering` v = `false`
            )->a( n = `rows`                   v = |\{ path: '{ client->_bind( val = t_nodes path = abap_true ) }', parameters: \{ arrayNames: ['CHILDREN'] \} \}|

            )->open( `columns`
                )->open( `Column`
                    )->leaf( n = `Label` ns = `m`
                        )->a( n = `text` v = `Description`

                    )->open( `template`
                        )->leaf( n = `Text` ns = `m`
                            )->a( n = `text`     v = `{DESCRIPTION}`
                            )->a( n = `wrapping` v = `false`

                    )->shut(
                )->shut(
                )->open( `Column`
                    )->leaf( n = `Label` ns = `m`
                        )->a( n = `text` v = `HierarchyLevel`

                    )->open( `template`
                        )->leaf( n = `Text` ns = `m`
                            )->a( n = `text`     v = `{HIERARCHYLEVEL}`
                            )->a( n = `wrapping` v = `false`

                    )->shut(
                )->shut(
                )->open( `Column`
                    )->leaf( n = `Label` ns = `m`
                        )->a( n = `text` v = `NodeID`

                    )->open( `template`
                        )->leaf( n = `Text` ns = `m`
                            )->a( n = `text`     v = `{NODEID}`
                            )->a( n = `wrapping` v = `false`

                    )->shut(
                )->shut(
                )->open( `Column`
                    )->leaf( n = `Label` ns = `m`
                        )->a( n = `text` v = `ParentNodeID`

                    )->open( `template`
                        )->leaf( n = `Text` ns = `m`
                            )->a( n = `text`     v = `{PARENTNODEID}`
                            )->a( n = `wrapping` v = `false`

                    )->shut(
                )->shut(
            )->shut( ).

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
