CLASS z2ui5_cl_ai_app_144 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_item,
        title    TYPE string,
        subtitle TYPE string,
      END OF ty_item.
    DATA t_items      TYPE STANDARD TABLE OF ty_item WITH EMPTY KEY.
    DATA slider_value TYPE i.
    DATA panel_width  TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_144 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:grid` v = `sap.ui.layout.cssgrid`
        )->a( n = `xmlns:f`    v = `sap.f`

        )->leaf( `Slider`
            )->a( n = `value`      v = client->_bind( slider_value )
            )->a( n = `liveChange` v = client->_event( `SLIDER` )

        )->open( `Panel`
            )->a( n = `id`               v = `panelForGridList`
            )->a( n = `backgroundDesign` v = `Transparent`
            )->a( n = `width`            v = client->_bind( panel_width )

            )->open( `headerToolbar`
                )->open( `Toolbar`
                    )->a( n = `height` v = `3rem`
                    )->leaf( `Title`
                        )->a( n = `text` v = `Grid List with GridBoxLayout and minWidth 17rem`

            )->shut(
            )->shut(

            )->open( n = `GridList` ns = `f`
                )->a( n = `id`         v = `gridList`
                )->a( n = `headerText` v = `GridList header`
                )->a( n = `items`      v = client->_bind( t_items )

                )->open( n = `customLayout` ns = `f`
                    )->leaf( n = `GridBoxLayout` ns = `grid`
                        )->a( n = `boxMinWidth` v = `17rem`

                )->shut(

                )->open( n = `GridListItem` ns = `f`
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


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `SLIDER`.
        " original onSliderMoved: byId('panelForGridList').setWidth(value + '%')
        panel_width = |{ slider_value }%|.
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    slider_value = 100.
    panel_width  = `100%`.
    t_items = VALUE #(
      ( title = `Grid item title 1` subtitle = `Subtitle 1` )
      ( title = `Grid item title 2` subtitle = `Subtitle 2` )
      ( title = `Grid item title 3` subtitle = `Subtitle 3` )
      ( title = `Grid item title 4` subtitle = `Subtitle 4` )
      ( title = `Grid item title 5` subtitle = `Subtitle 5` )
      ( title = `Grid item title 6 Grid item title Grid item title Grid item title Grid item title Grid item title` subtitle = `Subtitle 6` )
      ( title = `Very long Grid item title that should wrap 7` subtitle = `This is a long subtitle 7` )
      ( title = `Grid item title B 8` subtitle = `Subtitle 8` )
      ( title = `Grid item title B 9 Grid item title B  Grid item title B 9 Grid item title B 9Grid item title B 9title B 9 Grid item title B 9Grid item title B` subtitle = `Subtitle 9` )
      ( title = `Grid item title B 10` subtitle = `Subtitle 10` )
      ( title = `Grid item title B 11` subtitle = `Subtitle 11` )
      ( title = `Grid item title B 12` subtitle = `Subtitle 12` )
      ( title = `Grid item title 13` subtitle = `Subtitle 13` )
      ( title = `Grid item title 14` subtitle = `Subtitle 14` )
      ( title = `Grid item title 15` subtitle = `Subtitle 15` )
      ( title = `Grid item title 16` subtitle = `Subtitle 16` )
      ( title = `Grid item title 17` subtitle = `Subtitle 17` )
      ( title = `Grid item title 18` subtitle = `Subtitle 18` )
      ( title = `Very long Grid item title that should wrap 19` subtitle = `This is a long subtitle 19` )
      ( title = `Grid item title B 20` subtitle = `Subtitle 20` )
      ( title = `Grid item title B 21` subtitle = `Subtitle 21` )
      ( title = `Grid item title B 22` subtitle = `Subtitle 22` )
      ( title = `Grid item title B 23` subtitle = `Subtitle 23` )
      ( title = `Grid item title B 24` subtitle = `Subtitle 24` )
      ( title = `Grid item title B 21` subtitle = `Subtitle 21` )
      ( title = `Grid item title B 22` subtitle = `Subtitle 22` )
      ( title = `Grid item title B 23` subtitle = `Subtitle 23` )
    ).

  ENDMETHOD.

ENDCLASS.
