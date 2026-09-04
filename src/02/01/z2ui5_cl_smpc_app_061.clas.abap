" @keywords menubutton menu button sap.m buttons regular split mode overflowtoolbar toolbarspacer label menuitem
" @summary This control is used to open a menu in both desktop and mobile.
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
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    DATA temp5 TYPE string_table.
    DATA temp6 TYPE string_table.
    DATA temp7 TYPE string_table.
    DATA temp8 TYPE string_table.
    DATA temp9 TYPE string_table.
    DATA temp10 TYPE string_table.
    DATA temp11 TYPE string_table.
    DATA temp12 TYPE string_table.
    DATA temp13 TYPE string_table.
    DATA temp14 TYPE string_table.
    DATA temp15 TYPE string_table.
    DATA temp16 TYPE string_table.
    DATA temp17 TYPE string_table.
    DATA temp18 TYPE string_table.
    DATA temp19 TYPE string_table.
    DATA temp20 TYPE string_table.
    DATA temp21 TYPE string_table.
    DATA temp22 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `{0} Pressed` INTO TABLE temp1.
    INSERT `$event.oSource.sId` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `{0} Pressed` INTO TABLE temp2.
    INSERT `$event.oSource.sId` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `{0} Pressed` INTO TABLE temp3.
    INSERT `$event.oSource.sId` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `MESSAGE_TOAST` INTO TABLE temp4.
    INSERT `show` INTO TABLE temp4.
    INSERT `Action triggered on item: {0}` INTO TABLE temp4.
    INSERT `${$parameters>/item}.getText()` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `MESSAGE_TOAST` INTO TABLE temp5.
    INSERT `show` INTO TABLE temp5.
    INSERT `Action triggered on item: {0}` INTO TABLE temp5.
    INSERT `${$parameters>/item}.getText()` INTO TABLE temp5.
    
    CLEAR temp6.
    INSERT `MESSAGE_TOAST` INTO TABLE temp6.
    INSERT `show` INTO TABLE temp6.
    INSERT `Action triggered on item: {0}` INTO TABLE temp6.
    INSERT `${$parameters>/item}.getText()` INTO TABLE temp6.
    
    CLEAR temp7.
    INSERT `MESSAGE_TOAST` INTO TABLE temp7.
    INSERT `show` INTO TABLE temp7.
    INSERT `Default action triggered` INTO TABLE temp7.
    
    CLEAR temp8.
    INSERT `MESSAGE_TOAST` INTO TABLE temp8.
    INSERT `show` INTO TABLE temp8.
    INSERT `beforeMenuOpen is fired` INTO TABLE temp8.
    
    CLEAR temp9.
    INSERT `MESSAGE_TOAST` INTO TABLE temp9.
    INSERT `show` INTO TABLE temp9.
    INSERT `Action triggered on item: {0}` INTO TABLE temp9.
    INSERT `${$parameters>/item}.getText()` INTO TABLE temp9.
    
    CLEAR temp10.
    INSERT `MESSAGE_TOAST` INTO TABLE temp10.
    INSERT `show` INTO TABLE temp10.
    INSERT `Default action triggered` INTO TABLE temp10.
    
    CLEAR temp11.
    INSERT `MESSAGE_TOAST` INTO TABLE temp11.
    INSERT `show` INTO TABLE temp11.
    INSERT `beforeMenuOpen is fired` INTO TABLE temp11.
    
    CLEAR temp12.
    INSERT `MESSAGE_TOAST` INTO TABLE temp12.
    INSERT `show` INTO TABLE temp12.
    INSERT `Action triggered on item: {0}` INTO TABLE temp12.
    INSERT `${$parameters>/item}.getText()` INTO TABLE temp12.
    
    CLEAR temp13.
    INSERT `MESSAGE_TOAST` INTO TABLE temp13.
    INSERT `show` INTO TABLE temp13.
    INSERT `Default action triggered` INTO TABLE temp13.
    
    CLEAR temp14.
    INSERT `MESSAGE_TOAST` INTO TABLE temp14.
    INSERT `show` INTO TABLE temp14.
    INSERT `beforeMenuOpen is fired` INTO TABLE temp14.
    
    CLEAR temp15.
    INSERT `MESSAGE_TOAST` INTO TABLE temp15.
    INSERT `show` INTO TABLE temp15.
    INSERT `Action triggered on item: {0}` INTO TABLE temp15.
    INSERT `${$parameters>/item}.getText()` INTO TABLE temp15.
    
    CLEAR temp16.
    INSERT `MESSAGE_TOAST` INTO TABLE temp16.
    INSERT `show` INTO TABLE temp16.
    INSERT `Accepted` INTO TABLE temp16.
    
    CLEAR temp17.
    INSERT `MESSAGE_TOAST` INTO TABLE temp17.
    INSERT `show` INTO TABLE temp17.
    INSERT `beforeMenuOpen is fired` INTO TABLE temp17.
    
    CLEAR temp18.
    INSERT `MESSAGE_TOAST` INTO TABLE temp18.
    INSERT `show` INTO TABLE temp18.
    INSERT `Action triggered on item: {0}` INTO TABLE temp18.
    INSERT `${$parameters>/item}.getText()` INTO TABLE temp18.
    
    CLEAR temp19.
    INSERT `MESSAGE_TOAST` INTO TABLE temp19.
    INSERT `show` INTO TABLE temp19.
    INSERT `Default action triggered` INTO TABLE temp19.
    
    CLEAR temp20.
    INSERT `MESSAGE_TOAST` INTO TABLE temp20.
    INSERT `show` INTO TABLE temp20.
    INSERT `beforeMenuOpen is fired` INTO TABLE temp20.
    
    CLEAR temp21.
    INSERT `MESSAGE_TOAST` INTO TABLE temp21.
    INSERT `show` INTO TABLE temp21.
    INSERT `Action triggered on item: {0}` INTO TABLE temp21.
    INSERT `${$parameters>/item}.getText()` INTO TABLE temp21.
    
    CLEAR temp22.
    INSERT `MESSAGE_TOAST` INTO TABLE temp22.
    INSERT `show` INTO TABLE temp22.
    INSERT `Action triggered on item: {0}` INTO TABLE temp22.
    INSERT `${$parameters>/item}.getText()` INTO TABLE temp22.
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
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp1 )
                            )->ele( `customData`
                                )->tag( n = `CustomData` ns = `core`
                                    )->a( n = `key`   v = `target`
                                    )->a( n = `value` v = `p1`

                            )->end(
                        )->end(
                        )->tag( `MenuItem`
                            )->a( n = `text`  v = `Save`
                            )->a( n = `icon`  v = `sap-icon://save`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp2 )
                        )->tag( `MenuItem`
                            )->a( n = `text`  v = `Open`
                            )->a( n = `icon`  v = `sap-icon://open-folder`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp3 )

                    )->end(
                )->end(
            )->end(

            )->ele( `MenuButton`
                )->a( n = `text`                v = `Calculator`
                )->a( n = `buttonMode`          v = `Split`
                )->a( n = `useDefaultActionOnly` v = `true`
                )->ele( `menu`
                    )->ele( `Menu`
                        )->a( n = `itemSelected` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp4 )
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
                        )->a( n = `itemSelected` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp5 )
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
                        )->a( n = `itemSelected` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp6 )
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
                )->a( n = `defaultAction`  v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp7 )
                )->a( n = `beforeMenuOpen` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp8 )
                )->ele( `menu`
                    )->ele( `Menu`
                        )->a( n = `itemSelected` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp9 )
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
                )->a( n = `defaultAction`  v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp10 )
                )->a( n = `beforeMenuOpen` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp11 )
                )->ele( `menu`
                    )->ele( `Menu`
                        )->a( n = `itemSelected` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp12 )
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
                )->a( n = `defaultAction`       v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp13 )
                )->a( n = `beforeMenuOpen`      v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp14 )
                )->a( n = `useDefaultActionOnly` v = `true`
                )->ele( `menu`
                    )->ele( `Menu`
                        )->a( n = `itemSelected` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp15 )
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
                )->a( n = `defaultAction`       v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp16 )
                )->a( n = `beforeMenuOpen`      v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp17 )
                )->a( n = `useDefaultActionOnly` v = `true`
                )->ele( `menu`
                    )->ele( `Menu`
                        )->a( n = `itemSelected` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp18 )
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
                )->a( n = `defaultAction`       v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp19 )
                )->a( n = `beforeMenuOpen`      v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp20 )
                )->a( n = `useDefaultActionOnly` v = `true`
                )->a( n = `menuPosition`        v = `RightBottom`
                )->ele( `menu`
                    )->ele( `Menu`
                        )->a( n = `itemSelected` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp21 )
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
                        )->a( n = `itemSelected` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp22 )
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
