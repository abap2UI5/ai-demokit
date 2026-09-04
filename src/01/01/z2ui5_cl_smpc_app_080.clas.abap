" @keywords togglebutton toggle button sap.m bars pressed states bar title hbox flexitemdata
" @summary Toggle Buttons can be toggled between pressed and normal state.
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
    view = z2ui5_cl_ui5_view_builder=>factory( ).


    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `{0} {1?Pressed:Unpressed}` INTO TABLE temp1.
    INSERT `$event.oSource.sId` INTO TABLE temp1.
    INSERT `$event.oSource.getPressed()` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `{0} {1?Pressed:Unpressed}` INTO TABLE temp2.
    INSERT `$event.oSource.sId` INTO TABLE temp2.
    INSERT `$event.oSource.getPressed()` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `{0} {1?Pressed:Unpressed}` INTO TABLE temp3.
    INSERT `$event.oSource.sId` INTO TABLE temp3.
    INSERT `$event.oSource.getPressed()` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `MESSAGE_TOAST` INTO TABLE temp4.
    INSERT `show` INTO TABLE temp4.
    INSERT `{0} {1?Pressed:Unpressed}` INTO TABLE temp4.
    INSERT `$event.oSource.sId` INTO TABLE temp4.
    INSERT `$event.oSource.getPressed()` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `MESSAGE_TOAST` INTO TABLE temp5.
    INSERT `show` INTO TABLE temp5.
    INSERT `{0} {1?Pressed:Unpressed}` INTO TABLE temp5.
    INSERT `$event.oSource.sId` INTO TABLE temp5.
    INSERT `$event.oSource.getPressed()` INTO TABLE temp5.
    
    CLEAR temp6.
    INSERT `MESSAGE_TOAST` INTO TABLE temp6.
    INSERT `show` INTO TABLE temp6.
    INSERT `{0} {1?Pressed:Unpressed}` INTO TABLE temp6.
    INSERT `$event.oSource.sId` INTO TABLE temp6.
    INSERT `$event.oSource.getPressed()` INTO TABLE temp6.
    
    CLEAR temp7.
    INSERT `MESSAGE_TOAST` INTO TABLE temp7.
    INSERT `show` INTO TABLE temp7.
    INSERT `{0} {1?Pressed:Unpressed}` INTO TABLE temp7.
    INSERT `$event.oSource.sId` INTO TABLE temp7.
    INSERT `$event.oSource.getPressed()` INTO TABLE temp7.
    
    CLEAR temp8.
    INSERT `MESSAGE_TOAST` INTO TABLE temp8.
    INSERT `show` INTO TABLE temp8.
    INSERT `{0} {1?Pressed:Unpressed}` INTO TABLE temp8.
    INSERT `$event.oSource.sId` INTO TABLE temp8.
    INSERT `$event.oSource.getPressed()` INTO TABLE temp8.
    
    CLEAR temp9.
    INSERT `MESSAGE_TOAST` INTO TABLE temp9.
    INSERT `show` INTO TABLE temp9.
    INSERT `{0} {1?Pressed:Unpressed}` INTO TABLE temp9.
    INSERT `$event.oSource.sId` INTO TABLE temp9.
    INSERT `$event.oSource.getPressed()` INTO TABLE temp9.
    
    CLEAR temp10.
    INSERT `MESSAGE_TOAST` INTO TABLE temp10.
    INSERT `show` INTO TABLE temp10.
    INSERT `{0} {1?Pressed:Unpressed}` INTO TABLE temp10.
    INSERT `$event.oSource.sId` INTO TABLE temp10.
    INSERT `$event.oSource.getPressed()` INTO TABLE temp10.
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
                                                                            t_arg = temp1 )

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
                                                                              t_arg = temp2 )
                        )->tag( `ToggleButton`
                            )->a( n = `text`    v = `Pressed & Disabled`
                            )->a( n = `enabled` v = `false`
                            )->a( n = `pressed` v = `true`
                            )->a( n = `press`   v = client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = temp3 )

                    )->end(
                    )->ele( `contentRight`
                        )->tag( `ToggleButton`
                            )->a( n = `icon`  v = `sap-icon://action`
                            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                            t_arg = temp4 )
                        )->tag( `ToggleButton`
                            )->a( n = `icon`    v = `sap-icon://home`
                            )->a( n = `enabled` v = `false`
                            )->a( n = `press`   v = client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = temp5 )

                    )->end(
                )->end(
            )->end(

            )->ele( `HBox`
                )->ele( `ToggleButton`
                    )->a( n = `text`    v = `Disabled`
                    )->a( n = `enabled` v = `false`
                    )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp6 )
                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(
                )->end(
                )->ele( `ToggleButton`
                    )->a( n = `text`    v = `Pressed`
                    )->a( n = `enabled` v = `true`
                    )->a( n = `pressed` v = `true`
                    )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp7 )
                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(
                )->end(
                )->ele( `ToggleButton`
                    )->a( n = `icon`    v = `sap-icon://action`
                    )->a( n = `enabled` v = `true`
                    )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp8 )
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
                                                                              t_arg = temp9 )
                        )->tag( `ToggleButton`
                            )->a( n = `icon`  v = `sap-icon://action`
                            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                            t_arg = temp10 )

                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
