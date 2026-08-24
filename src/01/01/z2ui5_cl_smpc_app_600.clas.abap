" @keywords tree sap.m treednd dragdropinfo standardtreeitem
" @summary This example shows drag-and-drop capability.
CLASS z2ui5_cl_smpc_app_600 DEFINITION PUBLIC.

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

    " what the view binds - rebuilt from the flat table after every drop
    DATA t_nodes TYPE STANDARD TABLE OF ty_s_node_level1 WITH EMPTY KEY.

    " the hierarchy the drop rewrites: one row per node, parent by text
    TYPES: BEGIN OF ty_s_flat,
             text   TYPE string,
             ref    TYPE string,
             parent TYPE string,
           END OF ty_s_flat.
    DATA t_flat TYPE STANDARD TABLE OF ty_s_flat WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS node_drop.
    METHODS model_init.
    METHODS nodes_rebuild.
    METHODS is_descendant IMPORTING node          TYPE string
                                    ancestor      TYPE string
                          RETURNING VALUE(result) TYPE abap_bool.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_600 IMPLEMENTATION.

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
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:dnd` v = `sap.ui.core.dnd`

        )->ele( `Tree`
            )->a( n = `id`    v = `Tree`
            " items path '/' - bind the root table; the nested `nodes` drive the depth
            )->a( n = `items` v = client->_bind( t_nodes )
            " onInit does tree.setMode( 'MultiSelect' ); a bindable property beats
            " a frontend action, so the port writes it in the view
            )->a( n = `mode`  v = `MultiSelect`

            )->ele( `dragDropConfig`
                )->tag( n = `DragDropInfo` ns = `dnd`
                    )->a( n = `sourceAggregation` v = `items`
                    )->a( n = `targetAggregation` v = `items`
                    " onDragStart vetoes a drag that starts on a row OUTSIDE the
                    " current selection. The condition is known only at the moment
                    " of the drag, so the per-WIRE check_prevent_default flag cannot
                    " express it - prevent_default_expr can: a client expression
                    " evaluated on each firing. The dragged item's parent IS the
                    " Tree, so the selection is reachable inline
                    )->a( n = `dragStart`         v = client->_event(
                        val    = `DRAG_START`
                        s_ctrl = VALUE #( prevent_default_expr =
                            `${$parameters>/target}.getParent().getSelectedItems().length > 0 && ` &&
                            `${$parameters>/target}.getParent().getSelectedItems().indexOf(${$parameters>/target}) === -1` ) )
                    " onDrop moves the dragged node under the dropped one; the two
                    " node texts are what travels (app 569 idiom)
                    )->a( n = `drop`              v = client->_event( val   = `DROP_NODE`
                                                                      t_arg = VALUE #( ( `${$parameters>/draggedControl}.getTitle()` )
                                                                                       ( `${$parameters>/droppedControl}.getTitle()` ) ) )
            )->end(

            )->tag( `StandardTreeItem`
                )->a( n = `title` v = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    " DRAG_START arrives too and is deliberately unhandled: its wire exists
    " only to carry prevent_default_expr, and the veto has already been
    " decided on the client by the time the event gets here
    IF client->get_event( ) = `DROP_NODE`.
      node_drop( ).
    ENDIF.

  ENDMETHOD.


  METHOD node_drop.

    DATA(dragged_text) = client->get_event_arg( ).
    DATA(dropped_text) = client->get_event_arg( 2 ).

    IF dragged_text IS INITIAL OR dropped_text IS INITIAL OR dragged_text = dropped_text.
      RETURN.
    ENDIF.

    " onDrop's own guard: never move a node into one of its own children
    IF is_descendant( node     = dropped_text
                      ancestor = dragged_text ) = abap_true.
      RETURN.
    ENDIF.

    " "Copy the data to the new parent" plus "remove the data" - one reparenting
    LOOP AT t_flat ASSIGNING FIELD-SYMBOL(<flat>) WHERE text = dragged_text.
      <flat>-parent = dropped_text.
    ENDLOOP.

    nodes_rebuild( ).

  ENDMETHOD.


  METHOD is_descendant.

    DATA(walker) = node.
    WHILE walker IS NOT INITIAL.
      IF walker = ancestor.
        result = abap_true.
        RETURN.
      ENDIF.
      DATA(current) = walker.
      CLEAR walker.
      LOOP AT t_flat INTO DATA(row) WHERE text = current.
        walker = row-parent.
      ENDLOOP.
    ENDWHILE.

  ENDMETHOD.


  METHOD nodes_rebuild.

    CLEAR t_nodes.

    LOOP AT t_flat INTO DATA(row1) WHERE parent IS INITIAL.
      DATA(node1) = VALUE ty_s_node_level1( text = row1-text
                                            ref  = row1-ref ).
      DATA(parent1) = row1-text.

      LOOP AT t_flat INTO DATA(row2) WHERE parent = parent1.
        DATA(node2) = VALUE ty_s_node_level2( text = row2-text
                                              ref  = row2-ref ).
        DATA(parent2) = row2-text.

        LOOP AT t_flat INTO DATA(row3) WHERE parent = parent2.
          DATA(node3) = VALUE ty_s_node_level3( text = row3-text
                                                ref  = row3-ref ).
          DATA(parent3) = row3-text.

          LOOP AT t_flat INTO DATA(row4) WHERE parent = parent3.
            DATA(node4) = VALUE ty_s_node_level4( text = row4-text
                                                  ref  = row4-ref ).
            DATA(parent4) = row4-text.

            LOOP AT t_flat INTO DATA(row5) WHERE parent = parent4.
              INSERT VALUE #( text = row5-text
                              ref  = row5-ref ) INTO TABLE node4-nodes.
            ENDLOOP.

            INSERT node4 INTO TABLE node3-nodes.
          ENDLOOP.

          INSERT node3 INTO TABLE node2-nodes.
        ENDLOOP.

        INSERT node2 INTO TABLE node1-nodes.
      ENDLOOP.

      INSERT node1 INTO TABLE t_nodes.
    ENDLOOP.

  ENDMETHOD.


  METHOD model_init.

    " Tree.json, flattened: text, icon and the parent each node hangs under
    t_flat = VALUE #(
      ( text = `Node1`         ref = `sap-icon://attachment-audio`              parent = `` )
      ( text = `Node1-1`       ref = `sap-icon://attachment-e-pub`              parent = `Node1` )
      ( text = `Node1-1-1`     ref = `sap-icon://attachment-html`               parent = `Node1-1` )
      ( text = `Node1-1-2`     ref = `sap-icon://attachment-photo`              parent = `Node1-1` )
      ( text = `Node1-1-2-1`   ref = `sap-icon://attachment-text-file`          parent = `Node1-1-2` )
      ( text = `Node1-1-2-1-1` ref = `sap-icon://attachment-video`              parent = `Node1-1-2-1` )
      ( text = `Node1-1-2-1-2` ref = `sap-icon://attachment-zip-file`           parent = `Node1-1-2-1` )
      ( text = `Node1-1-2-1-3` ref = `sap-icon://course-program`                parent = `Node1-1-2-1` )
      ( text = `Node1-2`       ref = `sap-icon://create`                        parent = `Node1` )
      ( text = `Node2`         ref = `sap-icon://customer-financial-fact-sheet` parent = `` )
    ).

    nodes_rebuild( ).

  ENDMETHOD.

ENDCLASS.
