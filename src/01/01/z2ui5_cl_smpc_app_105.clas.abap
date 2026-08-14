CLASS z2ui5_cl_smpc_app_105 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_105 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`         v = `100%`
        )->a( n = `xmlns:core`     v = `sap.ui.core`
        )->a( n = `xmlns:mvc`      v = `sap.ui.core.mvc`
        )->a( n = `xmlns`          v = `sap.m`
        )->a( n = `xmlns:semantic` v = `sap.m.semantic`
        )->a( n = `xmlns:ui`       v = `sap.ca.ui`
        )->a( n = `displayBlock`   v = `true`

        )->ele( n = `FullscreenPage` ns = `semantic`
            )->a( n = `title`          v = `FullScreen Page Title`
            )->a( n = `showNavButton`  v = `true`
            )->a( n = `navButtonPress` v = client->_event( `NAV` )

            )->ele( n = `addAction` ns = `semantic`
                )->tag( n = `AddAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `AddAction` ) ) )

            )->end(
            )->ele( n = `editAction` ns = `semantic`
                )->tag( n = `EditAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `EditAction` ) ) )

            )->end(
            )->ele( n = `deleteAction` ns = `semantic`
                )->tag( n = `DeleteAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `DeleteAction` ) ) )

            )->end(
            )->ele( n = `flagAction` ns = `semantic`
                )->tag( n = `FlagAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `FlagAction` ) ) )

            )->end(
            )->ele( n = `favoriteAction` ns = `semantic`
                )->tag( n = `FavoriteAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `FavoriteAction` ) ) )

            )->end(
            )->ele( n = `sendEmailAction` ns = `semantic`
                )->tag( n = `SendEmailAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `SendEmailAction` ) ) )

            )->end(
            )->ele( n = `sendMessageAction` ns = `semantic`
                )->tag( n = `SendMessageAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `SendMessageAction` ) ) )

            )->end(
            )->ele( n = `discussInJamAction` ns = `semantic`
                )->tag( n = `DiscussInJamAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `DiscussInJamAction` ) ) )

            )->end(
            )->ele( n = `shareInJamAction` ns = `semantic`
                )->tag( n = `ShareInJamAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `ShareInJamAction` ) ) )

            )->end(
            )->ele( n = `printAction` ns = `semantic`
                )->tag( n = `PrintAction` ns = `semantic`
                    )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `PrintAction` ) ) )

            )->end(
            )->ele( n = `messagesIndicator` ns = `semantic`
                )->tag( n = `MessagesIndicator` ns = `semantic`
                    )->a( n = `press` v = client->_event( `MESSAGES` )

            )->end(
            )->ele( n = `customFooterContent` ns = `semantic`
                )->tag( `Button`
                    )->a( n = `text`  v = `CustomFooterBtn`
                    )->a( n = `press` v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                )->tag( `OverflowToolbarButton`
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
