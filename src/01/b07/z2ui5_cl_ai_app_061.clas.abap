CLASS z2ui5_cl_ai_app_061 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_061 IMPLEMENTATION.

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
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `OverflowToolbar`
            )->leaf( `ToolbarSpacer`
            )->leaf( `Label`
                )->a( n = `text` v = `In a toolbar`

            )->open( `MenuButton`
                )->a( n = `text` v = `File`
                )->open( `menu`
                    )->open( `Menu`
                        )->open( `MenuItem`
                            )->a( n = `text`  v = `Edit`
                            )->a( n = `icon`  v = `sap-icon://edit`
                            )->a( n = `press` v = client->_event( val   = `PRESS`
                                                                  t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                            )->open( `customData`
                                )->leaf( n = `CustomData` ns = `core`
                                    )->a( n = `key`   v = `target`
                                    )->a( n = `value` v = `p1`

                            )->shut(
                        )->shut(
                        )->leaf( `MenuItem`
                            )->a( n = `text`  v = `Save`
                            )->a( n = `icon`  v = `sap-icon://save`
                            )->a( n = `press` v = client->_event( val   = `PRESS`
                                                                  t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                        )->leaf( `MenuItem`
                            )->a( n = `text`  v = `Open`
                            )->a( n = `icon`  v = `sap-icon://open-folder`
                            )->a( n = `press` v = client->_event( val   = `PRESS`
                                                                  t_arg = VALUE #( ( `$event.oSource.sId` ) ) )

                    )->shut(
                )->shut(
            )->shut(

            )->open( `MenuButton`
                )->a( n = `text`                v = `Calculator`
                )->a( n = `buttonMode`          v = `Split`
                )->a( n = `useDefaultActionOnly` v = `true`
                )->open( `menu`
                    )->open( `Menu`
                        )->a( n = `itemSelected` v = client->_event( val   = `MENU_ACTION`
                                                                     t_arg = VALUE #( ( `${$parameters>/item}.getText()` ) ) )
                        )->open( `MenuItem`
                            )->a( n = `text` v = `basic`
                            )->a( n = `icon` v = `sap-icon://chalkboard`
                            )->open( `items`
                                )->leaf( `MenuItem`
                                    )->a( n = `text` v = `add`
                                    )->a( n = `icon` v = `sap-icon://add`
                                )->leaf( `MenuItem`
                                    )->a( n = `text` v = `subtract`
                                    )->a( n = `icon` v = `sap-icon://less`
                                )->leaf( `MenuItem`
                                    )->a( n = `text` v = `multiply`
                                    )->a( n = `icon` v = `sap-icon://decline`

                            )->shut(
                        )->shut(
                        )->open( `MenuItem`
                            )->a( n = `text` v = `complex`
                            )->a( n = `icon` v = `sap-icon://display`
                            )->open( `items`
                                )->leaf( `MenuItem`
                                    )->a( n = `text` v = `square`
                                    )->a( n = `icon` v = `sap-icon://status-completed`

                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->leaf( `ToolbarSpacer`

        )->shut(

        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->leaf( `Label`
                )->a( n = `text` v = `With a complex menu`
            )->open( `MenuButton`
                )->a( n = `text`                v = `Calculator`
                )->a( n = `buttonMode`          v = `Split`
                )->a( n = `useDefaultActionOnly` v = `true`
                )->open( `menu`
                    )->open( `Menu`
                        )->a( n = `itemSelected` v = client->_event( val   = `MENU_ACTION`
                                                                     t_arg = VALUE #( ( `${$parameters>/item}.getText()` ) ) )
                        )->open( `MenuItem`
                            )->a( n = `text` v = `basic`
                            )->a( n = `icon` v = `sap-icon://chalkboard`
                            )->open( `items`
                                )->leaf( `MenuItem`
                                    )->a( n = `text` v = `add`
                                    )->a( n = `icon` v = `sap-icon://add`
                                )->leaf( `MenuItem`
                                    )->a( n = `text` v = `subtract`
                                    )->a( n = `icon` v = `sap-icon://less`
                                )->leaf( `MenuItem`
                                    )->a( n = `text` v = `multiply`
                                    )->a( n = `icon` v = `sap-icon://decline`

                            )->shut(
                        )->shut(
                        )->open( `MenuItem`
                            )->a( n = `text` v = `complex`
                            )->a( n = `icon` v = `sap-icon://display`
                            )->open( `items`
                                )->leaf( `MenuItem`
                                    )->a( n = `text` v = `square`
                                    )->a( n = `icon` v = `sap-icon://status-completed`

                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->leaf( `Label`
                )->a( n = `text` v = `Regular mode button`
            )->open( `MenuButton`
                )->a( n = `text` v = `File`
                )->open( `menu`
                    )->open( `Menu`
                        )->a( n = `itemSelected` v = client->_event( val   = `MENU_ACTION`
                                                                     t_arg = VALUE #( ( `${$parameters>/item}.getText()` ) ) )
                        )->leaf( `MenuItem`
                            )->a( n = `text` v = `Edit`
                            )->a( n = `icon` v = `sap-icon://edit`
                        )->leaf( `MenuItem`
                            )->a( n = `text` v = `Save`
                            )->a( n = `icon` v = `sap-icon://save`
                        )->leaf( `MenuItem`
                            )->a( n = `text` v = `Open`
                            )->a( n = `icon` v = `sap-icon://open-folder`

                    )->shut(
                )->shut(
            )->shut(

            )->leaf( `Label`
                )->a( n = `text` v = `Split mode button with associated last action`
            )->open( `MenuButton`
                )->a( n = `text`           v = `File Menu`
                )->a( n = `buttonMode`     v = `Split`
                )->a( n = `defaultAction`  v = client->_event( `DEFAULT_ACTION` )
                )->a( n = `beforeMenuOpen` v = client->_event( `BEFORE_MENU_OPEN` )
                )->open( `menu`
                    )->open( `Menu`
                        )->a( n = `itemSelected` v = client->_event( val   = `MENU_ACTION`
                                                                     t_arg = VALUE #( ( `${$parameters>/item}.getText()` ) ) )
                        )->leaf( `MenuItem`
                            )->a( n = `text` v = `Edit`
                            )->a( n = `icon` v = `sap-icon://edit`
                        )->leaf( `MenuItem`
                            )->a( n = `text` v = `Save`
                            )->a( n = `icon` v = `sap-icon://save`
                        )->leaf( `MenuItem`
                            )->a( n = `text` v = `Open`
                            )->a( n = `icon` v = `sap-icon://open-folder`

                    )->shut(
                )->shut(
            )->shut(

            )->leaf( `Label`
                )->a( n = `text` v = `Split mode button with associated last action with initial icon`
            )->open( `MenuButton`
                )->a( n = `text`           v = `File Menu`
                )->a( n = `buttonMode`     v = `Split`
                )->a( n = `defaultAction`  v = client->_event( `DEFAULT_ACTION` )
                )->a( n = `beforeMenuOpen` v = client->_event( `BEFORE_MENU_OPEN` )
                )->open( `menu`
                    )->open( `Menu`
                        )->a( n = `itemSelected` v = client->_event( val   = `MENU_ACTION`
                                                                     t_arg = VALUE #( ( `${$parameters>/item}.getText()` ) ) )
                        )->leaf( `MenuItem`
                            )->a( n = `text` v = `Edit`
                            )->a( n = `icon` v = `sap-icon://edit`
                        )->leaf( `MenuItem`
                            )->a( n = `text` v = `Save`
                            )->a( n = `icon` v = `sap-icon://save`
                        )->leaf( `MenuItem`
                            )->a( n = `text` v = `Open`
                            )->a( n = `icon` v = `sap-icon://open-folder`

                    )->shut(
                )->shut(
            )->shut(

            )->leaf( `Label`
                )->a( n = `text` v = `Split mode button with default action only`
            )->open( `MenuButton`
                )->a( n = `text`                v = `File Menu`
                )->a( n = `buttonMode`          v = `Split`
                )->a( n = `defaultAction`       v = client->_event( `DEFAULT_ACTION` )
                )->a( n = `beforeMenuOpen`      v = client->_event( `BEFORE_MENU_OPEN` )
                )->a( n = `useDefaultActionOnly` v = `true`
                )->open( `menu`
                    )->open( `Menu`
                        )->a( n = `itemSelected` v = client->_event( val   = `MENU_ACTION`
                                                                     t_arg = VALUE #( ( `${$parameters>/item}.getText()` ) ) )
                        )->leaf( `MenuItem`
                            )->a( n = `text` v = `Edit`
                            )->a( n = `icon` v = `sap-icon://edit`
                        )->leaf( `MenuItem`
                            )->a( n = `text` v = `Save`
                            )->a( n = `icon` v = `sap-icon://save`
                        )->leaf( `MenuItem`
                            )->a( n = `text` v = `Open`
                            )->a( n = `icon` v = `sap-icon://open-folder`

                    )->shut(
                )->shut(
            )->shut(

            )->leaf( `Label`
                )->a( n = `text` v = `Split mode with type Accept and constant default action`
            )->open( `MenuButton`
                )->a( n = `text`                v = `Accept`
                )->a( n = `buttonMode`          v = `Split`
                )->a( n = `type`                v = `Accept`
                )->a( n = `defaultAction`       v = client->_event( `DEFAULT_ACTION_ACCEPT` )
                )->a( n = `beforeMenuOpen`      v = client->_event( `BEFORE_MENU_OPEN` )
                )->a( n = `useDefaultActionOnly` v = `true`
                )->open( `menu`
                    )->open( `Menu`
                        )->a( n = `itemSelected` v = client->_event( val   = `MENU_ACTION`
                                                                     t_arg = VALUE #( ( `${$parameters>/item}.getText()` ) ) )
                        )->leaf( `MenuItem`
                            )->a( n = `text` v = `Send the response now`
                            )->a( n = `icon` v = `sap-icon://response`
                        )->leaf( `MenuItem`
                            )->a( n = `text` v = `Edit the response before sending`
                            )->a( n = `icon` v = `sap-icon://edit-outside`
                        )->leaf( `MenuItem`
                            )->a( n = `text` v = `Do not send a response`
                            )->a( n = `icon` v = `sap-icon://action`

                    )->shut(
                )->shut(
            )->shut(

            )->leaf( `Label`
                )->a( n = `text` v = `Menu button with menuPosition set to Right Bottom which in RTL will stay on the Right`
            )->open( `MenuButton`
                )->a( n = `text`                v = `File Menu`
                )->a( n = `defaultAction`       v = client->_event( `DEFAULT_ACTION` )
                )->a( n = `beforeMenuOpen`      v = client->_event( `BEFORE_MENU_OPEN` )
                )->a( n = `useDefaultActionOnly` v = `true`
                )->a( n = `menuPosition`        v = `RightBottom`
                )->open( `menu`
                    )->open( `Menu`
                        )->a( n = `itemSelected` v = client->_event( val   = `MENU_ACTION`
                                                                     t_arg = VALUE #( ( `${$parameters>/item}.getText()` ) ) )
                        )->leaf( `MenuItem`
                            )->a( n = `text` v = `Edit`
                            )->a( n = `icon` v = `sap-icon://edit`
                        )->leaf( `MenuItem`
                            )->a( n = `text` v = `Save`
                            )->a( n = `icon` v = `sap-icon://save`
                        )->leaf( `MenuItem`
                            )->a( n = `text` v = `Open`
                            )->a( n = `icon` v = `sap-icon://open-folder`

                    )->shut(
                )->shut(
            )->shut(

            )->leaf( `Label`
                )->a( n = `text` v = `Menu button with menuPosition set to Begin Bottom. This way the menu in LTR will be positioned on the left and in RTL on the Right.`
            )->open( `MenuButton`
                )->a( n = `text`                v = `Calculator`
                )->a( n = `useDefaultActionOnly` v = `true`
                )->a( n = `menuPosition`        v = `BeginBottom`
                )->open( `menu`
                    )->open( `Menu`
                        )->a( n = `itemSelected` v = client->_event( val   = `MENU_ACTION`
                                                                     t_arg = VALUE #( ( `${$parameters>/item}.getText()` ) ) )
                        )->open( `MenuItem`
                            )->a( n = `text` v = `basic`
                            )->a( n = `icon` v = `sap-icon://chalkboard`
                            )->open( `items`
                                )->leaf( `MenuItem`
                                    )->a( n = `text` v = `add`
                                    )->a( n = `icon` v = `sap-icon://add`
                                )->leaf( `MenuItem`
                                    )->a( n = `text` v = `subtract`
                                    )->a( n = `icon` v = `sap-icon://less`
                                )->leaf( `MenuItem`
                                    )->a( n = `text` v = `multiply`
                                    )->a( n = `icon` v = `sap-icon://decline`

                            )->shut(
                        )->shut(
                        )->open( `MenuItem`
                            )->a( n = `text` v = `complex`
                            )->a( n = `icon` v = `sap-icon://display`
                            )->open( `items`
                                )->leaf( `MenuItem`
                                    )->a( n = `text` v = `square`
                                    )->a( n = `icon` v = `sap-icon://status-completed`

                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `PRESS`.
        client->message_toast_display( |{ client->get_event_arg( ) } Pressed| ).

      WHEN `MENU_ACTION`.
        client->message_toast_display( |Action triggered on item: { client->get_event_arg( ) }| ).

      WHEN `DEFAULT_ACTION`.
        client->message_toast_display( `Default action triggered` ).

      WHEN `DEFAULT_ACTION_ACCEPT`.
        client->message_toast_display( `Accepted` ).

      WHEN `BEFORE_MENU_OPEN`.
        client->message_toast_display( `beforeMenuOpen is fired` ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
