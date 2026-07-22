CLASS z2ui5_cl_ai_app_105 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_105 IMPLEMENTATION.

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
        )->a( n = `height`         v = `100%`
        )->a( n = `xmlns:core`     v = `sap.ui.core`
        )->a( n = `xmlns:mvc`      v = `sap.ui.core.mvc`
        )->a( n = `xmlns`          v = `sap.m`
        )->a( n = `xmlns:semantic` v = `sap.m.semantic`
        )->a( n = `xmlns:ui`       v = `sap.ca.ui`
        )->a( n = `displayBlock`   v = `true`

        )->open( n = `FullscreenPage` ns = `semantic`
            )->a( n = `title`          v = `FullScreen Page Title`
            )->a( n = `showNavButton`  v = `true`
            )->a( n = `navButtonPress` v = client->_event( `NAV` )

            )->open( n = `addAction` ns = `semantic`
                )->leaf( n = `AddAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `AddAction` ) ) )

            )->shut(
            )->open( n = `editAction` ns = `semantic`
                )->leaf( n = `EditAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `EditAction` ) ) )

            )->shut(
            )->open( n = `deleteAction` ns = `semantic`
                )->leaf( n = `DeleteAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `DeleteAction` ) ) )

            )->shut(
            )->open( n = `flagAction` ns = `semantic`
                )->leaf( n = `FlagAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `FlagAction` ) ) )

            )->shut(
            )->open( n = `favoriteAction` ns = `semantic`
                )->leaf( n = `FavoriteAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `FavoriteAction` ) ) )

            )->shut(
            )->open( n = `sendEmailAction` ns = `semantic`
                )->leaf( n = `SendEmailAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `SendEmailAction` ) ) )

            )->shut(
            )->open( n = `sendMessageAction` ns = `semantic`
                )->leaf( n = `SendMessageAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `SendMessageAction` ) ) )

            )->shut(
            )->open( n = `discussInJamAction` ns = `semantic`
                )->leaf( n = `DiscussInJamAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `DiscussInJamAction` ) ) )

            )->shut(
            )->open( n = `shareInJamAction` ns = `semantic`
                )->leaf( n = `ShareInJamAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `ShareInJamAction` ) ) )

            )->shut(
            )->open( n = `printAction` ns = `semantic`
                )->leaf( n = `PrintAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `PrintAction` ) ) )

            )->shut(
            )->open( n = `messagesIndicator` ns = `semantic`
                )->leaf( n = `MessagesIndicator` ns = `semantic`
                    )->a( n = `press` v = client->_event( `MESSAGES` )

            )->shut(
            )->open( n = `customFooterContent` ns = `semantic`
                )->leaf( `Button`
                    )->a( n = `text`  v = `CustomFooterBtn`
                    )->a( n = `press` v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                )->leaf( `OverflowToolbarButton`
                    )->a( n = `icon`  v = `sap-icon://settings`
                    )->a( n = `text`  v = `Settings`
                    )->a( n = `press` v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `SEM`.
        client->message_toast_display( |Pressed: { client->get_event_arg( ) }| ).

      WHEN `NAV`.
        client->message_toast_display( `Pressed navigation button` ).

      WHEN `MESSAGES`.
        client->message_toast_display( `Messages` ).

      WHEN `PRESS`.
        client->message_toast_display( |Pressed custom button { client->get_event_arg( ) }| ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
