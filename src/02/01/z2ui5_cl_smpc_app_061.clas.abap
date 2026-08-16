CLASS z2ui5_cl_smpc_app_061 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_061 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `OverflowToolbar`
            )->tag( `ToolbarSpacer`
            )->tag( `Label`
                )->a( n = `text` v = `In a toolbar`

            )->ele( `MenuButton`
                )->a( n = `text` v = `File`
                )->ele( `menu`
                    )->ele( `Menu`
                        )->ele( `MenuItem`
                            )->a( n = `text`  v = `Edit`
                            )->a( n = `icon`  v = `sap-icon://edit`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} Pressed` ) ( `$event.oSource.sId` ) ) )
                            )->ele( `customData`
                                )->tag( n = `CustomData` ns = `core`
                                    )->a( n = `key`   v = `target`
                                    )->a( n = `value` v = `p1`

                            )->end(
                        )->end(
                        )->tag( `MenuItem`
                            )->a( n = `text`  v = `Save`
                            )->a( n = `icon`  v = `sap-icon://save`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} Pressed` ) ( `$event.oSource.sId` ) ) )
                        )->tag( `MenuItem`
                            )->a( n = `text`  v = `Open`
                            )->a( n = `icon`  v = `sap-icon://open-folder`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} Pressed` ) ( `$event.oSource.sId` ) ) )

                    )->end(
                )->end(
            )->end(

            )->ele( `MenuButton`
                )->a( n = `text`                v = `Calculator`
                )->a( n = `buttonMode`          v = `Split`
                )->a( n = `useDefaultActionOnly` v = `true`
                )->ele( `menu`
                    )->ele( `Menu`
                        )->a( n = `itemSelected` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Action triggered on item: {0}` ) ( `${$parameters>/item}.getText()` ) ) )
                        )->ele( `MenuItem`
                            )->a( n = `text` v = `basic`
                            )->a( n = `icon` v = `sap-icon://chalkboard`
                            )->ele( `items`
                                )->tag( `MenuItem`
                                    )->a( n = `text` v = `add`
                                    )->a( n = `icon` v = `sap-icon://add`
                                )->tag( `MenuItem`
                                    )->a( n = `text` v = `subtract`
                                    )->a( n = `icon` v = `sap-icon://less`
                                )->tag( `MenuItem`
                                    )->a( n = `text` v = `multiply`
                                    )->a( n = `icon` v = `sap-icon://decline`

                            )->end(
                        )->end(
                        )->ele( `MenuItem`
                            )->a( n = `text` v = `complex`
                            )->a( n = `icon` v = `sap-icon://display`
                            )->ele( `items`
                                )->tag( `MenuItem`
                                    )->a( n = `text` v = `square`
                                    )->a( n = `icon` v = `sap-icon://status-completed`

                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(

            )->tag( `ToolbarSpacer`

        )->end(

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->tag( `Label`
                )->a( n = `text` v = `With a complex menu`
            )->ele( `MenuButton`
                )->a( n = `text`                v = `Calculator`
                )->a( n = `buttonMode`          v = `Split`
                )->a( n = `useDefaultActionOnly` v = `true`
                )->ele( `menu`
                    )->ele( `Menu`
                        )->a( n = `itemSelected` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Action triggered on item: {0}` ) ( `${$parameters>/item}.getText()` ) ) )
                        )->ele( `MenuItem`
                            )->a( n = `text` v = `basic`
                            )->a( n = `icon` v = `sap-icon://chalkboard`
                            )->ele( `items`
                                )->tag( `MenuItem`
                                    )->a( n = `text` v = `add`
                                    )->a( n = `icon` v = `sap-icon://add`
                                )->tag( `MenuItem`
                                    )->a( n = `text` v = `subtract`
                                    )->a( n = `icon` v = `sap-icon://less`
                                )->tag( `MenuItem`
                                    )->a( n = `text` v = `multiply`
                                    )->a( n = `icon` v = `sap-icon://decline`

                            )->end(
                        )->end(
                        )->ele( `MenuItem`
                            )->a( n = `text` v = `complex`
                            )->a( n = `icon` v = `sap-icon://display`
                            )->ele( `items`
                                )->tag( `MenuItem`
                                    )->a( n = `text` v = `square`
                                    )->a( n = `icon` v = `sap-icon://status-completed`

                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(

            )->tag( `Label`
                )->a( n = `text` v = `Regular mode button`
            )->ele( `MenuButton`
                )->a( n = `text` v = `File`
                )->ele( `menu`
                    )->ele( `Menu`
                        )->a( n = `itemSelected` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Action triggered on item: {0}` ) ( `${$parameters>/item}.getText()` ) ) )
                        )->tag( `MenuItem`
                            )->a( n = `text` v = `Edit`
                            )->a( n = `icon` v = `sap-icon://edit`
                        )->tag( `MenuItem`
                            )->a( n = `text` v = `Save`
                            )->a( n = `icon` v = `sap-icon://save`
                        )->tag( `MenuItem`
                            )->a( n = `text` v = `Open`
                            )->a( n = `icon` v = `sap-icon://open-folder`

                    )->end(
                )->end(
            )->end(

            )->tag( `Label`
                )->a( n = `text` v = `Split mode button with associated last action`
            )->ele( `MenuButton`
                )->a( n = `text`           v = `File Menu`
                )->a( n = `buttonMode`     v = `Split`
                )->a( n = `defaultAction`  v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Default action triggered` ) ) )
                )->a( n = `beforeMenuOpen` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `beforeMenuOpen is fired` ) ) )
                )->ele( `menu`
                    )->ele( `Menu`
                        )->a( n = `itemSelected` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Action triggered on item: {0}` ) ( `${$parameters>/item}.getText()` ) ) )
                        )->tag( `MenuItem`
                            )->a( n = `text` v = `Edit`
                            )->a( n = `icon` v = `sap-icon://edit`
                        )->tag( `MenuItem`
                            )->a( n = `text` v = `Save`
                            )->a( n = `icon` v = `sap-icon://save`
                        )->tag( `MenuItem`
                            )->a( n = `text` v = `Open`
                            )->a( n = `icon` v = `sap-icon://open-folder`

                    )->end(
                )->end(
            )->end(

            )->tag( `Label`
                )->a( n = `text` v = `Split mode button with associated last action with initial icon`
            )->ele( `MenuButton`
                )->a( n = `text`           v = `File Menu`
                )->a( n = `buttonMode`     v = `Split`
                )->a( n = `defaultAction`  v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Default action triggered` ) ) )
                )->a( n = `beforeMenuOpen` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `beforeMenuOpen is fired` ) ) )
                )->ele( `menu`
                    )->ele( `Menu`
                        )->a( n = `itemSelected` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Action triggered on item: {0}` ) ( `${$parameters>/item}.getText()` ) ) )
                        )->tag( `MenuItem`
                            )->a( n = `text` v = `Edit`
                            )->a( n = `icon` v = `sap-icon://edit`
                        )->tag( `MenuItem`
                            )->a( n = `text` v = `Save`
                            )->a( n = `icon` v = `sap-icon://save`
                        )->tag( `MenuItem`
                            )->a( n = `text` v = `Open`
                            )->a( n = `icon` v = `sap-icon://open-folder`

                    )->end(
                )->end(
            )->end(

            )->tag( `Label`
                )->a( n = `text` v = `Split mode button with default action only`
            )->ele( `MenuButton`
                )->a( n = `text`                v = `File Menu`
                )->a( n = `buttonMode`          v = `Split`
                )->a( n = `defaultAction`       v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Default action triggered` ) ) )
                )->a( n = `beforeMenuOpen`      v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `beforeMenuOpen is fired` ) ) )
                )->a( n = `useDefaultActionOnly` v = `true`
                )->ele( `menu`
                    )->ele( `Menu`
                        )->a( n = `itemSelected` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Action triggered on item: {0}` ) ( `${$parameters>/item}.getText()` ) ) )
                        )->tag( `MenuItem`
                            )->a( n = `text` v = `Edit`
                            )->a( n = `icon` v = `sap-icon://edit`
                        )->tag( `MenuItem`
                            )->a( n = `text` v = `Save`
                            )->a( n = `icon` v = `sap-icon://save`
                        )->tag( `MenuItem`
                            )->a( n = `text` v = `Open`
                            )->a( n = `icon` v = `sap-icon://open-folder`

                    )->end(
                )->end(
            )->end(

            )->tag( `Label`
                )->a( n = `text` v = `Split mode with type Accept and constant default action`
            )->ele( `MenuButton`
                )->a( n = `text`                v = `Accept`
                )->a( n = `buttonMode`          v = `Split`
                )->a( n = `type`                v = `Accept`
                )->a( n = `defaultAction`       v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Accepted` ) ) )
                )->a( n = `beforeMenuOpen`      v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `beforeMenuOpen is fired` ) ) )
                )->a( n = `useDefaultActionOnly` v = `true`
                )->ele( `menu`
                    )->ele( `Menu`
                        )->a( n = `itemSelected` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Action triggered on item: {0}` ) ( `${$parameters>/item}.getText()` ) ) )
                        )->tag( `MenuItem`
                            )->a( n = `text` v = `Send the response now`
                            )->a( n = `icon` v = `sap-icon://response`
                        )->tag( `MenuItem`
                            )->a( n = `text` v = `Edit the response before sending`
                            )->a( n = `icon` v = `sap-icon://edit-outside`
                        )->tag( `MenuItem`
                            )->a( n = `text` v = `Do not send a response`
                            )->a( n = `icon` v = `sap-icon://action`

                    )->end(
                )->end(
            )->end(

            )->tag( `Label`
                )->a( n = `text` v = `Menu button with menuPosition set to Right Bottom which in RTL will stay on the Right`
            )->ele( `MenuButton`
                )->a( n = `text`                v = `File Menu`
                )->a( n = `defaultAction`       v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Default action triggered` ) ) )
                )->a( n = `beforeMenuOpen`      v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `beforeMenuOpen is fired` ) ) )
                )->a( n = `useDefaultActionOnly` v = `true`
                )->a( n = `menuPosition`        v = `RightBottom`
                )->ele( `menu`
                    )->ele( `Menu`
                        )->a( n = `itemSelected` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Action triggered on item: {0}` ) ( `${$parameters>/item}.getText()` ) ) )
                        )->tag( `MenuItem`
                            )->a( n = `text` v = `Edit`
                            )->a( n = `icon` v = `sap-icon://edit`
                        )->tag( `MenuItem`
                            )->a( n = `text` v = `Save`
                            )->a( n = `icon` v = `sap-icon://save`
                        )->tag( `MenuItem`
                            )->a( n = `text` v = `Open`
                            )->a( n = `icon` v = `sap-icon://open-folder`

                    )->end(
                )->end(
            )->end(

            )->tag( `Label`
                )->a( n = `text` v = `Menu button with menuPosition set to Begin Bottom. This way the menu in LTR will be positioned on the left and in RTL on the Right.`
            )->ele( `MenuButton`
                )->a( n = `text`                v = `Calculator`
                )->a( n = `useDefaultActionOnly` v = `true`
                )->a( n = `menuPosition`        v = `BeginBottom`
                )->ele( `menu`
                    )->ele( `Menu`
                        )->a( n = `itemSelected` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Action triggered on item: {0}` ) ( `${$parameters>/item}.getText()` ) ) )
                        )->ele( `MenuItem`
                            )->a( n = `text` v = `basic`
                            )->a( n = `icon` v = `sap-icon://chalkboard`
                            )->ele( `items`
                                )->tag( `MenuItem`
                                    )->a( n = `text` v = `add`
                                    )->a( n = `icon` v = `sap-icon://add`
                                )->tag( `MenuItem`
                                    )->a( n = `text` v = `subtract`
                                    )->a( n = `icon` v = `sap-icon://less`
                                )->tag( `MenuItem`
                                    )->a( n = `text` v = `multiply`
                                    )->a( n = `icon` v = `sap-icon://decline`

                            )->end(
                        )->end(
                        )->ele( `MenuItem`
                            )->a( n = `text` v = `complex`
                            )->a( n = `icon` v = `sap-icon://display`
                            )->ele( `items`
                                )->tag( `MenuItem`
                                    )->a( n = `text` v = `square`
                                    )->a( n = `icon` v = `sap-icon://status-completed`

                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
