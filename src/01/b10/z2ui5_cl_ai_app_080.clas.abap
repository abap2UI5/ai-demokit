CLASS z2ui5_cl_ai_app_080 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_080 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).


    view->open( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( `Page`
            )->a( n = `title` v = `Page`
            )->a( n = `class` v = `sapUiContentPadding`

            )->open( `customHeader`
                )->open( `Bar`
                    )->open( `contentMiddle`
                        )->leaf( `Title`
                            )->a( n = `level` v = `H2`
                            )->a( n = `text`  v = `Title`

                    )->shut(
                    )->open( `contentRight`
                        )->leaf( `ToggleButton`
                            )->a( n = `icon`  v = `sap-icon://edit`
                            )->a( n = `press` v = client->_event( val = `PRESS` t_arg = VALUE #( ( `${$source>/pressed}` ) ) )

                    )->shut(
                )->shut(
            )->shut(

            )->open( `subHeader`
                )->open( `Bar`
                    )->open( `contentLeft`
                        )->leaf( `ToggleButton`
                            )->a( n = `text`    v = `Pressed`
                            )->a( n = `enabled` v = `true`
                            )->a( n = `pressed` v = `true`
                            )->a( n = `press`   v = client->_event( val = `PRESS` t_arg = VALUE #( ( `${$source>/pressed}` ) ) )
                        )->leaf( `ToggleButton`
                            )->a( n = `text`    v = `Pressed & Disabled`
                            )->a( n = `enabled` v = `false`
                            )->a( n = `pressed` v = `true`
                            )->a( n = `press`   v = client->_event( val = `PRESS` t_arg = VALUE #( ( `${$source>/pressed}` ) ) )

                    )->shut(
                    )->open( `contentRight`
                        )->leaf( `ToggleButton`
                            )->a( n = `icon`  v = `sap-icon://action`
                            )->a( n = `press` v = client->_event( val = `PRESS` t_arg = VALUE #( ( `${$source>/pressed}` ) ) )
                        )->leaf( `ToggleButton`
                            )->a( n = `icon`    v = `sap-icon://home`
                            )->a( n = `enabled` v = `false`
                            )->a( n = `press`   v = client->_event( val = `PRESS` t_arg = VALUE #( ( `${$source>/pressed}` ) ) )

                    )->shut(
                )->shut(
            )->shut(

            )->open( `HBox`
                )->open( `ToggleButton`
                    )->a( n = `text`    v = `Disabled`
                    )->a( n = `enabled` v = `false`
                    )->a( n = `press`   v = client->_event( val = `PRESS` t_arg = VALUE #( ( `${$source>/pressed}` ) ) )
                    )->open( `layoutData`
                        )->leaf( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->shut(
                )->shut(
                )->open( `ToggleButton`
                    )->a( n = `text`    v = `Pressed`
                    )->a( n = `enabled` v = `true`
                    )->a( n = `pressed` v = `true`
                    )->a( n = `press`   v = client->_event( val = `PRESS` t_arg = VALUE #( ( `${$source>/pressed}` ) ) )
                    )->open( `layoutData`
                        )->leaf( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->shut(
                )->shut(
                )->open( `ToggleButton`
                    )->a( n = `icon`    v = `sap-icon://action`
                    )->a( n = `enabled` v = `true`
                    )->a( n = `press`   v = client->_event( val = `PRESS` t_arg = VALUE #( ( `${$source>/pressed}` ) ) )
                    )->open( `layoutData`
                        )->leaf( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `footer`
                )->open( `Bar`
                    )->open( `contentRight`
                        )->leaf( `ToggleButton`
                            )->a( n = `text`    v = `Pressed & Disabled`
                            )->a( n = `enabled` v = `false`
                            )->a( n = `pressed` v = `true`
                            )->a( n = `press`   v = client->_event( val = `PRESS` t_arg = VALUE #( ( `${$source>/pressed}` ) ) )
                        )->leaf( `ToggleButton`
                            )->a( n = `icon`  v = `sap-icon://action`
                            )->a( n = `press` v = client->_event( val = `PRESS` t_arg = VALUE #( ( `${$source>/pressed}` ) ) )

                    )->shut(
                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `PRESS`.
        " the original toasts the button id + Pressed/Unpressed; the pressed state arrives via $source>/pressed
        IF client->get_event_arg( ) = `true`.
          client->message_toast_display( `Pressed` ).
        ELSE.
          client->message_toast_display( `Unpressed` ).
        ENDIF.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
