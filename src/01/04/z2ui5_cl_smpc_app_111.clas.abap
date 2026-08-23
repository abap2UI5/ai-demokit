" @keywords gridlist grid list sap.f layout slider panel toolbar title gridlistitem vbox flexitemdata
" @summary A GridList with the default grid layout, resized live with a slider to show how the grid reflows.
CLASS z2ui5_cl_smpc_app_111 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_item,
             title    TYPE string,
             subtitle TYPE string,
           END OF ty_s_item.
    DATA t_items TYPE STANDARD TABLE OF ty_s_item WITH EMPTY KEY.
    DATA slider_value TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_111 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`   v = `sap.f`

        )->tag( `Slider`
            )->a( n = `value` v = client->_bind( slider_value )

        )->ele( `Panel`
            )->a( n = `id`               v = `panelForGridList`
            )->a( n = `backgroundDesign` v = `Transparent`
            " original onSliderMoved sets the panel width imperatively; here it is a roundtrip-free expression binding over the slider value
            )->a( n = `width`            v = |\{= ${ client->_bind( slider_value ) } + '%' \}|

            )->ele( `headerToolbar`
                )->ele( `Toolbar`
                    )->a( n = `height` v = `3rem`
                    )->tag( `Title`
                        )->a( n = `text` v = `GridList with default grid layout`

                )->end(
            )->end(
            )->ele( n = `GridList` ns = `f`
                )->a( n = `id`         v = `gridList`
                )->a( n = `headerText` v = `GridList header`
                )->a( n = `items`      v = client->_bind( t_items )

                )->ele( n = `GridListItem` ns = `f`
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


  METHOD model_init.

    slider_value = 100.
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
      ( title = `Grid item title B 23` subtitle = `Subtitle 23` ) ).

  ENDMETHOD.

ENDCLASS.
