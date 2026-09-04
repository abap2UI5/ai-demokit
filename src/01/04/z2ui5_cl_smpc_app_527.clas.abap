" @keywords gridcontainer grid container sap.f gridcontainerdraganddropfromlist scrollcontainer togglebutton hbox list draginfo dropinfo standardlistitem
" @summary This sample represents how items from a control which is not GridContainer can be dragged and dropped over a GridContainer.
CLASS z2ui5_cl_smpc_app_527 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_item,
             title   TYPE string,
             rows    TYPE i,
             columns TYPE i,
           END OF ty_s_item.
    TYPES ty_t_item TYPE STANDARD TABLE OF ty_s_item WITH DEFAULT KEY.

    DATA t_list TYPE ty_t_item.
    DATA t_grid TYPE ty_t_item.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_527 IMPLEMENTATION.

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
    DATA temp2 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `${$parameters>/draggedControl/oParent}.getId()` INTO TABLE temp1.
    INSERT `${$parameters>/draggedControl/oParent}.indexOfItem(${$parameters>/draggedControl})` INTO TABLE temp1.
    INSERT `${$parameters>/droppedControl} ? ${$parameters>/droppedControl/oParent}.getId() : ''` INTO TABLE temp1.
    INSERT `${$parameters>/droppedControl} ? ${$parameters>/droppedControl/oParent}.indexOfItem(${$parameters>/droppedControl}) : -1` INTO TABLE temp1.
    INSERT `${$parameters>/dropPosition}` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `${$parameters>/draggedControl/oParent}.getId()` INTO TABLE temp2.
    INSERT `${$parameters>/draggedControl/oParent}.indexOfItem(${$parameters>/draggedControl})` INTO TABLE temp2.
    INSERT `${$parameters>/droppedControl} ? ${$parameters>/droppedControl/oParent}.getId() : ''` INTO TABLE temp2.
    INSERT `${$parameters>/droppedControl} ? ${$parameters>/droppedControl/oParent}.indexOfItem(${$parameters>/droppedControl}) : -1` INTO TABLE temp2.
    INSERT `${$parameters>/dropPosition}` INTO TABLE temp2.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`       v = `sap.f`
        )->a( n = `xmlns:card`    v = `sap.f.cards`
        )->a( n = `xmlns:dnd`     v = `sap.ui.core.dnd`
        )->a( n = `xmlns:dndgrid` v = `sap.f.dnd`
        )->a( n = `displayBlock`  v = `true`
        )->a( n = `height`        v = `100%`

        )->ele( `ScrollContainer`
            )->a( n = `height`   v = `100%`
            )->a( n = `width`    v = `100%`
            )->a( n = `vertical` v = `true`

            " press wire dropped (declared): RevealGrid is a sample-local JS
            " helper module (grid outline overlay) with no declarative equivalent
            )->tag( `ToggleButton`
                )->a( n = `id`    v = `revealGrid`
                )->a( n = `text`  v = `Reveal Grid`
                )->a( n = `class` v = `sapUiSmallMarginBegin sapUiSmallMarginTop sapUiTinyMarginBottom`

            )->ele( `HBox`
                )->a( n = `renderType` v = `Bare`

                )->ele( `List`
                    )->a( n = `id`    v = `list1`
                    )->a( n = `class` v = `sapUiSmallMargin`
                    )->a( n = `width` v = `400px`
                    )->a( n = `items` v = client->_bind( t_list )

                    )->ele( `dragDropConfig`
                        )->tag( n = `DragInfo` ns = `dnd`
                            )->a( n = `sourceAggregation` v = `items`
                        )->tag( n = `DropInfo` ns = `dnd`
                            )->a( n = `targetAggregation` v = `items`
                            )->a( n = `dropPosition`      v = `Between`
                            )->a( n = `dropLayout`        v = `Vertical`
                            " both containers raise the SAME drop event; the argument list names the
                            " source container, the source index, the target container, the target
                            " index and the drop position, which is everything onDrop reads
                            )->a( n = `drop`              v = client->_event( val   = `DROP`
                                                                              t_arg = temp1 )

                    )->end(

                    )->tag( `StandardListItem`
                        )->a( n = `title` v = `{TITLE}`

                )->end(

                )->ele( n = `GridContainer` ns = `f`
                    )->a( n = `id`         v = `grid1`
                    )->a( n = `class`      v = `sapUiSmallMargin`
                    )->a( n = `width`      v = `100%`
                    )->a( n = `snapToRow`  v = `true`
                    )->a( n = `items`      v = client->_bind( t_grid )

                    )->ele( n = `dragDropConfig` ns = `f`
                        )->tag( n = `DragInfo` ns = `dnd`
                            )->a( n = `sourceAggregation` v = `items`
                        )->tag( n = `GridDropInfo` ns = `dndgrid`
                            )->a( n = `targetAggregation` v = `items`
                            )->a( n = `dropPosition`      v = `Between`
                            )->a( n = `dropLayout`        v = `Horizontal`
                            " both containers raise the SAME drop event; the argument list names the
                            " source container, the source index, the target container, the target
                            " index and the drop position, which is everything onDrop reads
                            )->a( n = `drop`              v = client->_event( val   = `DROP`
                                                                              t_arg = temp2 )

                    )->end(

                    )->ele( n = `layout` ns = `f`
                        )->tag( n = `GridContainerSettings` ns = `f`
                            )->a( n = `rowSize`    v = `84px`
                            )->a( n = `columnSize` v = `84px`
                            )->a( n = `gap`        v = `8px`

                    )->end(
                    )->ele( n = `layoutXS` ns = `f`
                        )->tag( n = `GridContainerSettings` ns = `f`
                            )->a( n = `rowSize`    v = `70px`
                            )->a( n = `columnSize` v = `70px`
                            )->a( n = `gap`        v = `8px`

                    )->end(

                    )->ele( n = `items` ns = `f`
                        )->ele( n = `Card` ns = `f`

                            )->ele( n = `layoutData` ns = `f`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `minRows` v = `{ROWS}`
                                    )->a( n = `columns` v = `{COLUMNS}`

                            )->end(
                            )->ele( n = `header` ns = `f`
                                )->tag( n = `Header` ns = `card`
                                    )->a( n = `title` v = `{TITLE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
      DATA drag_container TYPE string.
      DATA temp3 TYPE i.
      DATA drag_index LIKE temp3.
      DATA drop_container TYPE string.
      DATA temp4 TYPE i.
      DATA drop_index LIKE temp4.
      DATA drop_position TYPE string.
      DATA from_list TYPE abap_bool.
      DATA temp1 TYPE xsdboolean.
      DATA to_list TYPE abap_bool.
      DATA temp2 TYPE xsdboolean.
      DATA temp5 TYPE ty_t_item.
      DATA source LIKE temp5.
        DATA item LIKE LINE OF source.
        DATA temp7 LIKE LINE OF source.
        DATA temp8 LIKE sy-tabix.
        DATA temp6 TYPE ty_t_item.
        DATA target LIKE temp6.

    IF client->get_event( ) = `DROP`.

      
      drag_container = client->get_event_arg( ).
      
      temp3 = client->get_event_arg( 2 ).
      
      drag_index = temp3.
      
      drop_container = client->get_event_arg( 3 ).
      
      temp4 = client->get_event_arg( 4 ).
      
      drop_index = temp4.
      
      drop_position  = client->get_event_arg( 5 ).

      
      
      temp1 = boolc( drag_container CS `list1` ).
      from_list = temp1.
      
      
      temp2 = boolc( drop_container CS `list1` ).
      to_list   = temp2.

      " onDrop: take the row out of the SOURCE model, correct the target index
      " the same two ways the original does, then splice it into the TARGET model
      
      IF from_list = abap_true.
        temp5 = t_list.
      ELSE.
        temp5 = t_grid.
      ENDIF.
      
      source = temp5.
      IF drag_index >= 0 AND drag_index < lines( source ).

        
        
        
        temp8 = sy-tabix.
        READ TABLE source INDEX drag_index + 1 INTO temp7.
        sy-tabix = temp8.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        item = temp7.
        DELETE source INDEX drag_index + 1.

        IF from_list = abap_true.
          t_list = source.
        ELSE.
          t_grid = source.
        ENDIF.

        
        IF to_list = abap_true.
          temp6 = t_list.
        ELSE.
          temp6 = t_grid.
        ENDIF.
        
        target = temp6.

        IF from_list = to_list AND drag_index < drop_index.
          drop_index = drop_index - 1.
        ENDIF.
        IF drop_position = `After`.
          drop_index = drop_index + 1.
        ENDIF.
        IF drop_index < 0 OR drop_index > lines( target ).
          drop_index = lines( target ).
        ENDIF.

        INSERT item INTO target INDEX drop_index + 1.

        IF to_list = abap_true.
          t_list = target.
        ELSE.
          t_grid = target.
        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " initData: the List's three rows and the GridContainer's three rows
    DATA temp7 TYPE z2ui5_cl_smpc_app_527=>ty_t_item.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp9 TYPE z2ui5_cl_smpc_app_527=>ty_t_item.
    DATA temp10 LIKE LINE OF temp9.
    CLEAR temp7.
    
    temp8-title = `Open SAP Homepage 2x2`.
    temp8-rows = 2.
    temp8-columns = 2.
    INSERT temp8 INTO TABLE temp7.
    temp8-title = `Your personal information 3x3`.
    temp8-rows = 3.
    temp8-columns = 3.
    INSERT temp8 INTO TABLE temp7.
    temp8-title = `Appointments management 2x4`.
    temp8-rows = 2.
    temp8-columns = 4.
    INSERT temp8 INTO TABLE temp7.
    t_list = temp7.

    
    CLEAR temp9.
    
    temp10-title = `Sales Fulfillment Application Title 4x2`.
    temp10-rows = 4.
    temp10-columns = 2.
    INSERT temp10 INTO TABLE temp9.
    temp10-title = `Manage Activity Master Data Type 2x3`.
    temp10-rows = 2.
    temp10-columns = 3.
    INSERT temp10 INTO TABLE temp9.
    temp10-title = `Success Map 2x2`.
    temp10-rows = 2.
    temp10-columns = 2.
    INSERT temp10 INTO TABLE temp9.
    t_grid = temp9.

  ENDMETHOD.

ENDCLASS.
