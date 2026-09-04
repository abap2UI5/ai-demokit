" @keywords gridlist grid list sap.f drag drop panel toolbar title draginfo griddropinfo gridboxlayout
" @summary This sample represents GridList with enabled Drag and Drop functionality.
CLASS z2ui5_cl_smpc_app_148 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_item,
        title     TYPE string,
        subtitle  TYPE string,
        counter   TYPE i,
        highlight TYPE string,
        type      TYPE string,
        unread    TYPE abap_bool,
        busy      TYPE abap_bool,
      END OF ty_item.
    DATA t_items TYPE STANDARD TABLE OF ty_item WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_148 IMPLEMENTATION.

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

    " the drop carries the two row indices and the insert position as client-side
    " resolved $-args (CAPABILITIES "Drag & drop reorder"); on_event reorders the
    " ABAP table with exactly the original controller's splice arithmetic
    
    CLEAR temp1.
    INSERT `${$parameters>/draggedControl/oParent}.indexOfItem(${$parameters>/draggedControl})` INTO TABLE temp1.
    INSERT `${$parameters>/droppedControl/oParent}.indexOfItem(${$parameters>/droppedControl})` INTO TABLE temp1.
    INSERT `${$parameters>/dropPosition}` INTO TABLE temp1.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:grid`    v = `sap.ui.layout.cssgrid`
        )->a( n = `xmlns:f`       v = `sap.f`
        )->a( n = `xmlns:dnd`     v = `sap.ui.core.dnd`
        )->a( n = `xmlns:dndgrid` v = `sap.f.dnd`

        )->ele( `Panel`
            )->a( n = `id`               v = `panelForGridList`
            )->a( n = `backgroundDesign` v = `Transparent`

            )->ele( `headerToolbar`
                )->ele( `Toolbar`
                    )->a( n = `height` v = `3rem`
                    )->tag( `Title`
                        )->a( n = `text` v = `Grid List with Drag and Drop`

                )->end(
            )->end(

            )->ele( n = `GridList` ns = `f`
                )->a( n = `id`         v = `gridList`
                )->a( n = `headerText` v = `GridList header`
                )->a( n = `items`      v = client->_bind( t_items )

                )->ele( n = `dragDropConfig` ns = `f`
                    )->tag( n = `DragInfo` ns = `dnd`
                        )->a( n = `sourceAggregation` v = `items`
                    )->tag( n = `GridDropInfo` ns = `dndgrid`
                        )->a( n = `targetAggregation` v = `items`
                        )->a( n = `dropPosition`      v = `Between`
                        )->a( n = `dropLayout`        v = `Horizontal`
                        )->a( n = `drop`              v = client->_event( val   = `DROP`
                                                                          t_arg = temp1 )

                )->end(

                )->ele( n = `customLayout` ns = `f`
                    )->tag( n = `GridBoxLayout` ns = `grid`
                        )->a( n = `boxMinWidth` v = `17rem`

                )->end(

                )->ele( n = `GridListItem` ns = `f`
                    )->a( n = `counter`   v = `{COUNTER}`
                    )->a( n = `highlight` v = `{HIGHLIGHT}`
                    )->a( n = `type`      v = `{TYPE}`
                    )->a( n = `unread`    v = `{UNREAD}`
                    )->ele( `VBox`
                        )->a( n = `height` v = `100%`
                        )->ele( `VBox`
                            )->a( n = `class` v = `sapUiSmallMargin`
                            )->ele( `layoutData`
                                )->tag( `FlexItemData`
                                    )->a( n = `growFactor`   v = `1`
                                    )->a( n = `shrinkFactor` v = `0`

                            )->end(
                            )->tag( `Title`
                                )->a( n = `text`     v = `{TITLE}`
                                )->a( n = `wrapping` v = `true`
                            )->tag( `Label`
                                )->a( n = `text`     v = `{SUBTITLE}`
                                )->a( n = `wrapping` v = `true` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
      DATA temp3 TYPE i.
      DATA drag_pos LIKE temp3.
      DATA temp4 TYPE i.
      DATA drop_pos LIKE temp4.
      DATA position TYPE string.
      DATA item LIKE LINE OF t_items.
      DATA temp1 LIKE LINE OF t_items.
      DATA temp2 LIKE sy-tabix.
      DATA temp5 TYPE i.
      DATA insert_at LIKE temp5.

    IF client->get_event( ) = `DROP`.
      " onDrop 1:1 - the client indices are 0-based, ABAP rows 1-based. Both
      " arrive from the frontend, so they are range-checked before they are
      " used as a table index: JS would splice a nonsense index harmlessly,
      " ABAP would dump on the read
      
      temp3 = client->get_event_arg( ).
      
      drag_pos = temp3.
      
      temp4 = client->get_event_arg( 2 ).
      
      drop_pos = temp4.
      
      position = client->get_event_arg( 3 ).

      IF drag_pos < 0 OR drag_pos >= lines( t_items ) OR drop_pos < 0 OR drop_pos >= lines( t_items ).
        RETURN.
      ENDIF.

      
      
      
      temp2 = sy-tabix.
      READ TABLE t_items INDEX drag_pos + 1 INTO temp1.
      sy-tabix = temp2.
      IF sy-subrc <> 0.
        ASSERT 1 = 0.
      ENDIF.
      item = temp1.
      DELETE t_items INDEX drag_pos + 1.

      IF drag_pos < drop_pos.
        drop_pos = drop_pos - 1.
      ENDIF.

      " the original is two Array.splice calls, and splice CLAMPS a start index
      " past the end - it appends. ABAP does not: INSERT ... INDEX beyond
      " lines + 1 sets sy-subrc = 4 and inserts nothing, so the row deleted a
      " moment ago would be gone. Reachable: GridDragOver falls back to the LAST
      " item with "After" when the pointer is over no item at all, which can be
      " the dragged one, giving drag_pos = drop_pos = lines - 1
      
      IF position = `Before`.
        temp5 = drop_pos + 1.
      ELSE.
        temp5 = drop_pos + 2.
      ENDIF.
      
      insert_at = temp5.
      IF insert_at > lines( t_items ) + 1.
        insert_at = lines( t_items ) + 1.
      ENDIF.
      INSERT item INTO t_items INDEX insert_at.
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " 27 items inlined from model/data.json; absent enum fields defaulted to
    " their UI5 values (highlight None, type Inactive) so the bound properties
    " stay valid, matching the original's undefined-renders-as-default.
    DATA temp6 LIKE t_items.
    DATA temp7 LIKE LINE OF temp6.
    CLEAR temp6.
    
    temp7-title = `Box title 1`.
    temp7-subtitle = `Subtitle 1`.
    temp7-counter = 5.
    temp7-highlight = `Error`.
    temp7-type = `Active`.
    temp7-unread = abap_true.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title 2`.
    temp7-subtitle = `Subtitle 2`.
    temp7-counter = 15.
    temp7-highlight = `Warning`.
    temp7-type = `Active`.
    temp7-unread = abap_false.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title 3`.
    temp7-subtitle = `Subtitle 3`.
    temp7-counter = 15734.
    temp7-highlight = `None`.
    temp7-type = `Inactive`.
    temp7-unread = abap_false.
    temp7-busy = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title 4`.
    temp7-subtitle = `Subtitle 4`.
    temp7-counter = 2.
    temp7-highlight = `None`.
    temp7-type = `Inactive`.
    temp7-unread = abap_false.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title 5`.
    temp7-subtitle = `Subtitle 5`.
    temp7-counter = 1.
    temp7-highlight = `Warning`.
    temp7-type = `Inactive`.
    temp7-unread = abap_false.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title 6 Box title Box title Box title Box title Box title`.
    temp7-subtitle = `Subtitle 6`.
    temp7-counter = 5.
    temp7-highlight = `None`.
    temp7-type = `Active`.
    temp7-unread = abap_false.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Very long Box title that should wrap 7`.
    temp7-subtitle = `This is a long subtitle 7`.
    temp7-counter = 5.
    temp7-highlight = `Error`.
    temp7-type = `DetailAndActive`.
    temp7-unread = abap_false.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title B 8`.
    temp7-subtitle = `Subtitle 8`.
    temp7-counter = 0.
    temp7-highlight = `None`.
    temp7-type = `Navigation`.
    temp7-unread = abap_false.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title B 9 Box title B  Box title B 9 Box title B 9Box title B 9title B 9 Box title B 9Box title B`.
    temp7-subtitle = `Subtitle 9`.
    temp7-counter = 0.
    temp7-highlight = `Success`.
    temp7-type = `Inactive`.
    temp7-unread = abap_false.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title B 10`.
    temp7-subtitle = `Subtitle 10`.
    temp7-counter = 0.
    temp7-highlight = `None`.
    temp7-type = `Active`.
    temp7-unread = abap_false.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title B 11`.
    temp7-subtitle = `Subtitle 11`.
    temp7-counter = 0.
    temp7-highlight = `None`.
    temp7-type = `Active`.
    temp7-unread = abap_false.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title B 12`.
    temp7-subtitle = `Subtitle 12`.
    temp7-counter = 0.
    temp7-highlight = `Information`.
    temp7-type = `Inactive`.
    temp7-unread = abap_false.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title 13`.
    temp7-subtitle = `Subtitle 13`.
    temp7-counter = 5.
    temp7-highlight = `None`.
    temp7-type = `Navigation`.
    temp7-unread = abap_false.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title 14`.
    temp7-subtitle = `Subtitle 14`.
    temp7-counter = 0.
    temp7-highlight = `Success`.
    temp7-type = `DetailAndActive`.
    temp7-unread = abap_false.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title 15`.
    temp7-subtitle = `Subtitle 15`.
    temp7-counter = 0.
    temp7-highlight = `None`.
    temp7-type = `Inactive`.
    temp7-unread = abap_false.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title 16`.
    temp7-subtitle = `Subtitle 16`.
    temp7-counter = 37412578.
    temp7-highlight = `None`.
    temp7-type = `Navigation`.
    temp7-unread = abap_false.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title 17`.
    temp7-subtitle = `Subtitle 17`.
    temp7-counter = 0.
    temp7-highlight = `Information`.
    temp7-type = `Inactive`.
    temp7-unread = abap_false.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title 18`.
    temp7-subtitle = `Subtitle 18`.
    temp7-counter = 0.
    temp7-highlight = `None`.
    temp7-type = `Inactive`.
    temp7-unread = abap_false.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Very long Box title that should wrap 19`.
    temp7-subtitle = `This is a long subtitle 19`.
    temp7-counter = 0.
    temp7-highlight = `None`.
    temp7-type = `Inactive`.
    temp7-unread = abap_false.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title B 20`.
    temp7-subtitle = `Subtitle 20`.
    temp7-counter = 1.
    temp7-highlight = `Success`.
    temp7-type = `Inactive`.
    temp7-unread = abap_false.
    temp7-busy = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title B 21`.
    temp7-subtitle = `Subtitle 21`.
    temp7-counter = 0.
    temp7-highlight = `None`.
    temp7-type = `Navigation`.
    temp7-unread = abap_false.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title B 22`.
    temp7-subtitle = `Subtitle 22`.
    temp7-counter = 5.
    temp7-highlight = `None`.
    temp7-type = `Inactive`.
    temp7-unread = abap_true.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title B 23`.
    temp7-subtitle = `Subtitle 23`.
    temp7-counter = 3.
    temp7-highlight = `None`.
    temp7-type = `Inactive`.
    temp7-unread = abap_true.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title B 24`.
    temp7-subtitle = `Subtitle 24`.
    temp7-counter = 5.
    temp7-highlight = `Error`.
    temp7-type = `Inactive`.
    temp7-unread = abap_false.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title B 21`.
    temp7-subtitle = `Subtitle 21`.
    temp7-counter = 0.
    temp7-highlight = `None`.
    temp7-type = `Inactive`.
    temp7-unread = abap_false.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title B 22`.
    temp7-subtitle = `Subtitle 22`.
    temp7-counter = 0.
    temp7-highlight = `None`.
    temp7-type = `Navigation`.
    temp7-unread = abap_true.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Box title B 23`.
    temp7-subtitle = `Subtitle 23`.
    temp7-counter = 0.
    temp7-highlight = `None`.
    temp7-type = `Navigation`.
    temp7-unread = abap_false.
    temp7-busy = abap_false.
    INSERT temp7 INTO TABLE temp6.
    t_items = temp6.

  ENDMETHOD.

ENDCLASS.
