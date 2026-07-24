CLASS z2ui5_cl_ai_app_148 DEFINITION PUBLIC.

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
    DATA t_items TYPE STANDARD TABLE OF ty_item WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_148 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:grid`    v = `sap.ui.layout.cssgrid`
        )->a( n = `xmlns:f`       v = `sap.f`
        )->a( n = `xmlns:dnd`     v = `sap.ui.core.dnd`
        )->a( n = `xmlns:dndgrid` v = `sap.f.dnd`

        )->open( `Panel`
            )->a( n = `id`               v = `panelForGridList`
            )->a( n = `backgroundDesign` v = `Transparent`

            )->open( `headerToolbar`
                )->open( `Toolbar`
                    )->a( n = `height` v = `3rem`
                    )->leaf( `Title`
                        )->a( n = `text` v = `Grid List with Drag and Drop`

            )->shut(
            )->shut(

            )->open( n = `GridList` ns = `f`
                )->a( n = `id`         v = `gridList`
                )->a( n = `headerText` v = `GridList header`
                )->a( n = `items`      v = client->_bind( t_items )

                )->open( n = `dragDropConfig` ns = `f`
                    )->leaf( n = `DragInfo` ns = `dnd`
                        )->a( n = `sourceAggregation` v = `items`
                    )->leaf( n = `GridDropInfo` ns = `dndgrid`
                        )->a( n = `targetAggregation` v = `items`
                        )->a( n = `dropPosition`      v = `Between`
                        )->a( n = `dropLayout`        v = `Horizontal`
                        )->a( n = `drop`              v = client->_event( `DROP` )

                )->shut(

                )->open( n = `customLayout` ns = `f`
                    )->leaf( n = `GridBoxLayout` ns = `grid`
                        )->a( n = `boxMinWidth` v = `17rem`

                )->shut(

                )->open( n = `GridListItem` ns = `f`
                    )->a( n = `counter`   v = `{COUNTER}`
                    )->a( n = `highlight` v = `{HIGHLIGHT}`
                    )->a( n = `type`      v = `{TYPE}`
                    )->a( n = `unread`    v = `{UNREAD}`
                    )->open( `VBox`
                        )->a( n = `height` v = `100%`
                        )->open( `VBox`
                            )->a( n = `class` v = `sapUiSmallMargin`
                            )->open( `layoutData`
                                )->leaf( `FlexItemData`
                                    )->a( n = `growFactor`   v = `1`
                                    )->a( n = `shrinkFactor` v = `0`

                            )->shut(
                            )->leaf( `Title`
                                )->a( n = `text`     v = `{TITLE}`
                                )->a( n = `wrapping` v = `true`
                            )->leaf( `Label`
                                )->a( n = `text`     v = `{SUBTITLE}`
                                )->a( n = `wrapping` v = `true` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " 27 items inlined from model/data.json; absent enum fields defaulted to
    " their UI5 values (highlight None, type Inactive) so the bound properties
    " stay valid, matching the original's undefined-renders-as-default.
    t_items = VALUE #(
      ( title = `Box title 1` subtitle = `Subtitle 1` counter = 5 highlight = `Error` type = `Active` unread = abap_true busy = abap_false )
      ( title = `Box title 2` subtitle = `Subtitle 2` counter = 15 highlight = `Warning` type = `Active` unread = abap_false busy = abap_false )
      ( title = `Box title 3` subtitle = `Subtitle 3` counter = 15734 highlight = `None` type = `Inactive` unread = abap_false busy = abap_true )
      ( title = `Box title 4` subtitle = `Subtitle 4` counter = 2 highlight = `None` type = `Inactive` unread = abap_false busy = abap_false )
      ( title = `Box title 5` subtitle = `Subtitle 5` counter = 1 highlight = `Warning` type = `Inactive` unread = abap_false busy = abap_false )
      ( title = `Box title 6 Box title Box title Box title Box title Box title` subtitle = `Subtitle 6` counter = 5 highlight = `None` type = `Active` unread = abap_false busy = abap_false )
      ( title = `Very long Box title that should wrap 7` subtitle = `This is a long subtitle 7` counter = 5 highlight = `Error` type = `DetailAndActive` unread = abap_false busy = abap_false )
      ( title = `Box title B 8` subtitle = `Subtitle 8` counter = 0 highlight = `None` type = `Navigation` unread = abap_false busy = abap_false )
      ( title = `Box title B 9 Box title B  Box title B 9 Box title B 9Box title B 9title B 9 Box title B 9Box title B` subtitle = `Subtitle 9` counter = 0 highlight = `Success` type = `Inactive` unread = abap_false busy = abap_false )
      ( title = `Box title B 10` subtitle = `Subtitle 10` counter = 0 highlight = `None` type = `Active` unread = abap_false busy = abap_false )
      ( title = `Box title B 11` subtitle = `Subtitle 11` counter = 0 highlight = `None` type = `Active` unread = abap_false busy = abap_false )
      ( title = `Box title B 12` subtitle = `Subtitle 12` counter = 0 highlight = `Information` type = `Inactive` unread = abap_false busy = abap_false )
      ( title = `Box title 13` subtitle = `Subtitle 13` counter = 5 highlight = `None` type = `Navigation` unread = abap_false busy = abap_false )
      ( title = `Box title 14` subtitle = `Subtitle 14` counter = 0 highlight = `Success` type = `DetailAndActive` unread = abap_false busy = abap_false )
      ( title = `Box title 15` subtitle = `Subtitle 15` counter = 0 highlight = `None` type = `Inactive` unread = abap_false busy = abap_false )
      ( title = `Box title 16` subtitle = `Subtitle 16` counter = 37412578 highlight = `None` type = `Navigation` unread = abap_false busy = abap_false )
      ( title = `Box title 17` subtitle = `Subtitle 17` counter = 0 highlight = `Information` type = `Inactive` unread = abap_false busy = abap_false )
      ( title = `Box title 18` subtitle = `Subtitle 18` counter = 0 highlight = `None` type = `Inactive` unread = abap_false busy = abap_false )
      ( title = `Very long Box title that should wrap 19` subtitle = `This is a long subtitle 19` counter = 0 highlight = `None` type = `Inactive` unread = abap_false busy = abap_false )
      ( title = `Box title B 20` subtitle = `Subtitle 20` counter = 1 highlight = `Success` type = `Inactive` unread = abap_false busy = abap_true )
      ( title = `Box title B 21` subtitle = `Subtitle 21` counter = 0 highlight = `None` type = `Navigation` unread = abap_false busy = abap_false )
      ( title = `Box title B 22` subtitle = `Subtitle 22` counter = 5 highlight = `None` type = `Inactive` unread = abap_true busy = abap_false )
      ( title = `Box title B 23` subtitle = `Subtitle 23` counter = 3 highlight = `None` type = `Inactive` unread = abap_true busy = abap_false )
      ( title = `Box title B 24` subtitle = `Subtitle 24` counter = 5 highlight = `Error` type = `Inactive` unread = abap_false busy = abap_false )
      ( title = `Box title B 21` subtitle = `Subtitle 21` counter = 0 highlight = `None` type = `Inactive` unread = abap_false busy = abap_false )
      ( title = `Box title B 22` subtitle = `Subtitle 22` counter = 0 highlight = `None` type = `Navigation` unread = abap_true busy = abap_false )
      ( title = `Box title B 23` subtitle = `Subtitle 23` counter = 0 highlight = `None` type = `Navigation` unread = abap_false busy = abap_false )
    ).

  ENDMETHOD.

ENDCLASS.
