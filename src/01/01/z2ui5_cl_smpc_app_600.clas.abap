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

    " what the view binds - rebuilt from the flat table after every drop
    DATA t_nodes TYPE STANDARD TABLE OF ty_s_node_level1 WITH DEFAULT KEY.

    " the hierarchy the drop rewrites: one row per node, parent by text
    TYPES: BEGIN OF ty_s_flat,
             text   TYPE string,
             ref    TYPE string,
             parent TYPE string,
           END OF ty_s_flat.
    DATA t_flat TYPE STANDARD TABLE OF ty_s_flat WITH DEFAULT KEY.

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
    DATA temp1 TYPE z2ui5_if_client=>ty_s_event_control.
    DATA temp2 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    temp1-prevent_default_expr = `${$parameters>/target}.getParent().getSelectedItems().length > 0 && ` && `${$parameters>/target}.getParent().getSelectedItems().indexOf(${$parameters>/target}) === -1`.
    
    CLEAR temp2.
    INSERT `${$parameters>/draggedControl}.getTitle()` INTO TABLE temp2.
    INSERT `${$parameters>/droppedControl}.getTitle()` INTO TABLE temp2.
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
                        s_ctrl = temp1 )
                    " onDrop moves the dragged node under the dropped one; the two
                    " node texts are what travels (app 569 idiom)
                    )->a( n = `drop`              v = client->_event( val   = `DROP_NODE`
                                                                      t_arg = temp2 )
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

    DATA dragged_text TYPE string.
    DATA dropped_text TYPE string.
    FIELD-SYMBOLS <flat> LIKE LINE OF t_flat.
    dragged_text = client->get_event_arg( ).
    
    dropped_text = client->get_event_arg( 2 ).

    IF dragged_text IS INITIAL OR dropped_text IS INITIAL OR dragged_text = dropped_text.
      RETURN.
    ENDIF.

    " onDrop's own guard: never move a node into one of its own children
    IF is_descendant( node = dropped_text ancestor = dragged_text ) = abap_true.
      RETURN.
    ENDIF.

    " "Copy the data to the new parent" plus "remove the data" - one reparenting
    
    LOOP AT t_flat ASSIGNING <flat> WHERE text = dragged_text.
      <flat>-parent = dropped_text.
    ENDLOOP.

    nodes_rebuild( ).

  ENDMETHOD.


  METHOD is_descendant.

    DATA walker LIKE node.
      DATA current LIKE walker.
      DATA row LIKE LINE OF t_flat.
    walker = node.
    WHILE walker IS NOT INITIAL.
      IF walker = ancestor.
        result = abap_true.
        RETURN.
      ENDIF.
      
      current = walker.
      CLEAR walker.
      
      LOOP AT t_flat INTO row WHERE text = current.
        walker = row-parent.
      ENDLOOP.
    ENDWHILE.

  ENDMETHOD.


  METHOD nodes_rebuild.
    DATA row1 LIKE LINE OF t_flat.
      DATA temp2 TYPE ty_s_node_level1.
      DATA node1 LIKE temp2.
      DATA parent1 LIKE row1-text.
      DATA row2 LIKE LINE OF t_flat.
        DATA temp3 TYPE ty_s_node_level2.
        DATA node2 LIKE temp3.
        DATA parent2 LIKE row2-text.
        DATA row3 LIKE LINE OF t_flat.
          DATA temp4 TYPE ty_s_node_level3.
          DATA node3 LIKE temp4.
          DATA parent3 LIKE row3-text.
          DATA row4 LIKE LINE OF t_flat.
            DATA temp5 TYPE ty_s_node_level4.
            DATA node4 LIKE temp5.
            DATA parent4 LIKE row4-text.
            DATA row5 LIKE LINE OF t_flat.
              DATA temp6 TYPE z2ui5_cl_smpc_app_600=>ty_s_node_level5.

    CLEAR t_nodes.

    
    LOOP AT t_flat INTO row1 WHERE parent IS INITIAL.
      
      CLEAR temp2.
      temp2-text = row1-text.
      temp2-ref = row1-ref.
      
      node1 = temp2.
      
      parent1 = row1-text.

      
      LOOP AT t_flat INTO row2 WHERE parent = parent1.
        
        CLEAR temp3.
        temp3-text = row2-text.
        temp3-ref = row2-ref.
        
        node2 = temp3.
        
        parent2 = row2-text.

        
        LOOP AT t_flat INTO row3 WHERE parent = parent2.
          
          CLEAR temp4.
          temp4-text = row3-text.
          temp4-ref = row3-ref.
          
          node3 = temp4.
          
          parent3 = row3-text.

          
          LOOP AT t_flat INTO row4 WHERE parent = parent3.
            
            CLEAR temp5.
            temp5-text = row4-text.
            temp5-ref = row4-ref.
            
            node4 = temp5.
            
            parent4 = row4-text.

            
            LOOP AT t_flat INTO row5 WHERE parent = parent4.
              
              CLEAR temp6.
              temp6-text = row5-text.
              temp6-ref = row5-ref.
              INSERT temp6 INTO TABLE node4-nodes.
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
    DATA temp7 LIKE t_flat.
    DATA temp8 LIKE LINE OF temp7.
    CLEAR temp7.
    
    temp8-text = `Node1`.
    temp8-ref = `sap-icon://attachment-audio`.
    temp8-parent = ``.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Node1-1`.
    temp8-ref = `sap-icon://attachment-e-pub`.
    temp8-parent = `Node1`.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Node1-1-1`.
    temp8-ref = `sap-icon://attachment-html`.
    temp8-parent = `Node1-1`.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Node1-1-2`.
    temp8-ref = `sap-icon://attachment-photo`.
    temp8-parent = `Node1-1`.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Node1-1-2-1`.
    temp8-ref = `sap-icon://attachment-text-file`.
    temp8-parent = `Node1-1-2`.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Node1-1-2-1-1`.
    temp8-ref = `sap-icon://attachment-video`.
    temp8-parent = `Node1-1-2-1`.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Node1-1-2-1-2`.
    temp8-ref = `sap-icon://attachment-zip-file`.
    temp8-parent = `Node1-1-2-1`.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Node1-1-2-1-3`.
    temp8-ref = `sap-icon://course-program`.
    temp8-parent = `Node1-1-2-1`.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Node1-2`.
    temp8-ref = `sap-icon://create`.
    temp8-parent = `Node1`.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Node2`.
    temp8-ref = `sap-icon://customer-financial-fact-sheet`.
    temp8-parent = ``.
    INSERT temp8 INTO TABLE temp7.
    t_flat = temp7.

    nodes_rebuild( ).

  ENDMETHOD.

ENDCLASS.
