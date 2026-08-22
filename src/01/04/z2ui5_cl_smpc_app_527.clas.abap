" @keywords gridcontainer grid container sap.f gridcontainerdraganddropfromlist scrollcontainer togglebutton hbox list standardlistitem
" @summary This sample represents how items from a control which is not GridContainer can be dragged and dropped over a GridContainer.
CLASS z2ui5_cl_smpc_app_527 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_item,
             title   TYPE string,
             rows    TYPE i,
             columns TYPE i,
           END OF ty_s_item.
    TYPES ty_t_item TYPE STANDARD TABLE OF ty_s_item WITH EMPTY KEY.

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
                                                                              t_arg = VALUE #(
                                                                                ( `${$parameters>/draggedControl/oParent}.getId()` )
                                                                                ( `${$parameters>/draggedControl/oParent}.indexOfItem(${$parameters>/draggedControl})` )
                                                                                ( `${$parameters>/droppedControl} ? ${$parameters>/droppedControl/oParent}.getId() : ''` )
                                                                                ( `${$parameters>/droppedControl} ? ${$parameters>/droppedControl/oParent}.indexOfItem(${$parameters>/droppedControl}) : -1` )
                                                                                ( `${$parameters>/dropPosition}` ) ) )

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
                                                                              t_arg = VALUE #(
                                                                                ( `${$parameters>/draggedControl/oParent}.getId()` )
                                                                                ( `${$parameters>/draggedControl/oParent}.indexOfItem(${$parameters>/draggedControl})` )
                                                                                ( `${$parameters>/droppedControl} ? ${$parameters>/droppedControl/oParent}.getId() : ''` )
                                                                                ( `${$parameters>/droppedControl} ? ${$parameters>/droppedControl/oParent}.indexOfItem(${$parameters>/droppedControl}) : -1` )
                                                                                ( `${$parameters>/dropPosition}` ) ) )

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

    IF client->get_event( ) = `DROP`.

      DATA(drag_container) = client->get_event_arg( ).
      DATA(drag_index)     = CONV i( client->get_event_arg( 2 ) ).
      DATA(drop_container) = client->get_event_arg( 3 ).
      DATA(drop_index)     = CONV i( client->get_event_arg( 4 ) ).
      DATA(drop_position)  = client->get_event_arg( 5 ).

      DATA(from_list) = xsdbool( drag_container CS `list1` ).
      DATA(to_list)   = xsdbool( drop_container CS `list1` ).

      " onDrop: take the row out of the SOURCE model, correct the target index
      " the same two ways the original does, then splice it into the TARGET model
      DATA(source) = COND ty_t_item( WHEN from_list = abap_true THEN t_list ELSE t_grid ).
      IF drag_index >= 0 AND drag_index < lines( source ).

        DATA(item) = source[ drag_index + 1 ].
        DELETE source INDEX drag_index + 1.

        IF from_list = abap_true.
          t_list = source.
        ELSE.
          t_grid = source.
        ENDIF.

        DATA(target) = COND ty_t_item( WHEN to_list = abap_true THEN t_list ELSE t_grid ).

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
    t_list = VALUE #(
      ( title = `Open SAP Homepage 2x2`          rows = 2 columns = 2 )
      ( title = `Your personal information 3x3`  rows = 3 columns = 3 )
      ( title = `Appointments management 2x4`    rows = 2 columns = 4 ) ).

    t_grid = VALUE #(
      ( title = `Sales Fulfillment Application Title 4x2` rows = 4 columns = 2 )
      ( title = `Manage Activity Master Data Type 2x3`    rows = 2 columns = 3 )
      ( title = `Success Map 2x2`                         rows = 2 columns = 2 ) ).

  ENDMETHOD.

ENDCLASS.
