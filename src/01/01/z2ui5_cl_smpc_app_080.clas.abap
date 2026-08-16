" @keywords togglebutton toggle button sap.m bars pressed states bar title hbox flexitemdata
CLASS z2ui5_cl_smpc_app_080 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_080 IMPLEMENTATION.

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
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `Page`
            )->a( n = `title` v = `Page`
            )->a( n = `class` v = `sapUiContentPadding`

            )->ele( `customHeader`
                )->ele( `Bar`
                    )->ele( `contentMiddle`
                        )->tag( `Title`
                            )->a( n = `level` v = `H2`
                            )->a( n = `text`  v = `Title`

                    )->end(
                    )->ele( `contentRight`
                        )->tag( `ToggleButton`
                            )->a( n = `icon`  v = `sap-icon://edit`
                            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                            t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} {1?Pressed:Unpressed}` ) ( `$event.oSource.sId` ) ( `$event.oSource.getPressed()` ) ) )

                    )->end(
                )->end(
            )->end(

            )->ele( `subHeader`
                )->ele( `Bar`
                    )->ele( `contentLeft`
                        )->tag( `ToggleButton`
                            )->a( n = `text`    v = `Pressed`
                            )->a( n = `enabled` v = `true`
                            )->a( n = `pressed` v = `true`
                            )->a( n = `press`   v = client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} {1?Pressed:Unpressed}` ) ( `$event.oSource.sId` ) ( `$event.oSource.getPressed()` ) ) )
                        )->tag( `ToggleButton`
                            )->a( n = `text`    v = `Pressed & Disabled`
                            )->a( n = `enabled` v = `false`
                            )->a( n = `pressed` v = `true`
                            )->a( n = `press`   v = client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} {1?Pressed:Unpressed}` ) ( `$event.oSource.sId` ) ( `$event.oSource.getPressed()` ) ) )

                    )->end(
                    )->ele( `contentRight`
                        )->tag( `ToggleButton`
                            )->a( n = `icon`  v = `sap-icon://action`
                            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                            t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} {1?Pressed:Unpressed}` ) ( `$event.oSource.sId` ) ( `$event.oSource.getPressed()` ) ) )
                        )->tag( `ToggleButton`
                            )->a( n = `icon`    v = `sap-icon://home`
                            )->a( n = `enabled` v = `false`
                            )->a( n = `press`   v = client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} {1?Pressed:Unpressed}` ) ( `$event.oSource.sId` ) ( `$event.oSource.getPressed()` ) ) )

                    )->end(
                )->end(
            )->end(

            )->ele( `HBox`
                )->ele( `ToggleButton`
                    )->a( n = `text`    v = `Disabled`
                    )->a( n = `enabled` v = `false`
                    )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} {1?Pressed:Unpressed}` ) ( `$event.oSource.sId` ) ( `$event.oSource.getPressed()` ) ) )
                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(
                )->end(
                )->ele( `ToggleButton`
                    )->a( n = `text`    v = `Pressed`
                    )->a( n = `enabled` v = `true`
                    )->a( n = `pressed` v = `true`
                    )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} {1?Pressed:Unpressed}` ) ( `$event.oSource.sId` ) ( `$event.oSource.getPressed()` ) ) )
                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(
                )->end(
                )->ele( `ToggleButton`
                    )->a( n = `icon`    v = `sap-icon://action`
                    )->a( n = `enabled` v = `true`
                    )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} {1?Pressed:Unpressed}` ) ( `$event.oSource.sId` ) ( `$event.oSource.getPressed()` ) ) )
                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(
                )->end(
            )->end(

            )->ele( `footer`
                )->ele( `Bar`
                    )->ele( `contentRight`
                        )->tag( `ToggleButton`
                            )->a( n = `text`    v = `Pressed & Disabled`
                            )->a( n = `enabled` v = `false`
                            )->a( n = `pressed` v = `true`
                            )->a( n = `press`   v = client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} {1?Pressed:Unpressed}` ) ( `$event.oSource.sId` ) ( `$event.oSource.getPressed()` ) ) )
                        )->tag( `ToggleButton`
                            )->a( n = `icon`  v = `sap-icon://action`
                            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                            t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} {1?Pressed:Unpressed}` ) ( `$event.oSource.sId` ) ( `$event.oSource.getPressed()` ) ) )

                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
