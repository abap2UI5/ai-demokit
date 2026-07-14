"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.GridList/sample/sap.f.sample.GridListBasic
CLASS z2ui5_cl_api_app_416 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_item,
        title    TYPE string,
        subtitle TYPE string,
      END OF ty_s_item.
    DATA t_items      TYPE STANDARD TABLE OF ty_s_item WITH EMPTY KEY.
    DATA slider_value TYPE string.
    DATA panel_width  TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS data_init.
    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_416 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      data_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `SLIDER_MOVED` ).

      panel_width = |{ slider_value }%|.
      client->view_model_update( ).

    ENDIF.

  ENDMETHOD.


  METHOD data_init.

    slider_value = `100`.
    panel_width  = `100%`.
    t_items = VALUE #(
      ( title = `Grid item title 1` subtitle = `Subtitle 1` )
      ( title = `Grid item title 2` subtitle = `Subtitle 2` )
      ( title = `Grid item title 3` subtitle = `Subtitle 3` )
      ( title = `Grid item title 4` subtitle = `Subtitle 4` )
      ( title = `Grid item title 5` subtitle = `Subtitle 5` )
      ( title = `Very long Grid item title that should wrap 6` subtitle = `Subtitle 6` )
      ( title = `Very long Grid item title that should wrap 7` subtitle = `This is a long subtitle 7` )
      ( title = `Grid item title B 8` subtitle = `Subtitle 8` )
      ( title = `Grid item title B 9` subtitle = `Subtitle 9` )
      ( title = `Grid item title B 10` subtitle = `Subtitle 10` )
      ( title = `Grid item title B 11` subtitle = `Subtitle 11` )
      ( title = `Grid item title B 12` subtitle = `Subtitle 12` )
      ( title = `Grid item title 13` subtitle = `Subtitle 13` )
      ( title = `Grid item title 14` subtitle = `Subtitle 14` )
      ( title = `Grid item title 15` subtitle = `Subtitle 15` ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
                a = VALUE #( ( n = `xmlns`     v = `sap.m` )
                             ( n = `xmlns:mvc` v = `sap.ui.core.mvc` )
                             ( n = `xmlns:f`   v = `sap.f` ) )

        )->leaf( n = `Slider`
                 a = VALUE #( ( n = `value`      v = client->_bind_edit( slider_value ) )
                              ( n = `liveChange` v = client->_event( `SLIDER_MOVED` ) ) )

        )->open( n = `Panel`
                 a = VALUE #( ( n = `id`               v = `panelForGridList` )
                              ( n = `backgroundDesign` v = `Transparent` )
                              ( n = `width`            v = client->_bind( panel_width ) ) )
            )->open( `headerToolbar`
                )->open( n = `Toolbar`
                         a = VALUE #( ( n = `height` v = `3rem` ) )

                    )->leaf( n = `Title`
                             a = VALUE #( ( n = `text` v = `GridList with default grid layout` ) )

                )->shut(
            )->shut(
            )->open( n = `GridList` ns = `f`
                     a = VALUE #( ( n = `id`         v = `gridList` )
                                  ( n = `headerText` v = `GridList header` )
                                  ( n = `items`      v = client->_bind( t_items ) ) )
                )->open( n = `GridListItem` ns = `f`
                    )->open( n = `VBox`
                             a = VALUE #( ( n = `class` v = `sapUiSmallMargin` ) )
                        )->open( `layoutData`

                            )->leaf( n = `FlexItemData`
                                     a = VALUE #( ( n = `growFactor`   v = `1` )
                                                  ( n = `shrinkFactor` v = `0` ) )

                        )->shut(
                        )->leaf( n = `Title`
                                 a = VALUE #( ( n = `text`     v = `{TITLE}` )
                                              ( n = `wrapping` v = `true` ) )
                        )->leaf( n = `Label`
                                 a = VALUE #( ( n = `text`     v = `{SUBTITLE}` )
                                              ( n = `wrapping` v = `true` ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
