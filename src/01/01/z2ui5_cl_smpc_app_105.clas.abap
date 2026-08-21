" @keywords semanticpage semantic sap.m.semantic actions messagepopover messageitem button overflowtoolbarbutton
" @summary Semantic Page Full Screen
CLASS z2ui5_cl_smpc_app_105 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_message,
             message     TYPE string,
             description TYPE string,
             type        TYPE string,
           END OF ty_s_message.
    DATA t_messages TYPE STANDARD TABLE OF ty_s_message WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_105 IMPLEMENTATION.

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
        )->a( n = `height`         v = `100%`
        )->a( n = `xmlns:core`     v = `sap.ui.core`
        )->a( n = `xmlns:mvc`      v = `sap.ui.core.mvc`
        )->a( n = `xmlns`          v = `sap.m`
        )->a( n = `xmlns:semantic` v = `sap.m.semantic`
        )->a( n = `xmlns:z2ui5`    v = `z2ui5.cc`
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
                )->ele( n = `MessagesIndicator` ns = `semantic`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                    t_arg = VALUE #( ( `semMessagePopover` ) ( `toggleBy` ) ( `$event.oSource.sId` ) ) )

                    " the original's controller-built MessagePopover over the
                    " message model, declared as a dependent of its anchor
                    )->ele( n = `dependents` ns = `semantic`
                        )->ele( `MessagePopover`
                            )->a( n = `id`    v = `semMessagePopover`
                            )->a( n = `items` v = `{message>/}`

                            )->tag( `MessageItem`
                                )->a( n = `description` v = `{message>description}`
                                )->a( n = `type`        v = `{message>type}`
                                )->a( n = `title`       v = `{message>message}`

                        )->end(
                    )->end(
                )->end(
            )->end(
            )->ele( n = `content` ns = `semantic`
                " added container (declared): the z2ui5.cc.MessageManager bridge
                " reproducing onInit's MessageManager.addMessages seed
                )->tag( n = `MessageManager` ns = `z2ui5`
                    )->a( n = `items` v = client->_bind( t_messages )

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

    CASE client->get_event( ).

      WHEN `SEM`.
        client->message_toast_display( |Pressed: { client->get_event_arg( ) }| ).

      WHEN `NAV`.
        client->message_toast_display( `Pressed navigation button` ).

      WHEN `PRESS`.
        client->message_toast_display( |Pressed custom button { client->get_event_arg( ) }| ).

    ENDCASE.

  ENDMETHOD.

  METHOD model_init.

    " onInit: MessageManager.addMessages( new Message( { message: 'Something
    " wrong happened', type: Error } ) ) - reconciled by the
    " z2ui5.cc.MessageManager bridge control in the view
    t_messages = VALUE #( ( message = `Something wrong happened` type = `Error` ) ).

  ENDMETHOD.

ENDCLASS.
