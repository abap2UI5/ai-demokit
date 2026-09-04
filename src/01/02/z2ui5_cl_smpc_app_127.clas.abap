" @keywords invisibletext invisible text sap.ui.core aria descriptions toolbar button toolbarspacer title hbox flexitemdata
" @summary Many controls provide the associations ariaLabelledBy and ariaDescribedBy for accessibility purposes. The InvisibleText control can be used by application to provide hidden texts on the UI which can be referenced via these associations.
CLASS z2ui5_cl_smpc_app_127 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_127 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " original onPress: MessageToast.show( source.getId() + ' Pressed' )
    
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
    INSERT `{0} Pressed` INTO TABLE temp4.
    INSERT `$event.oSource.sId` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `MESSAGE_TOAST` INTO TABLE temp5.
    INSERT `show` INTO TABLE temp5.
    INSERT `{0} Pressed` INTO TABLE temp5.
    INSERT `$event.oSource.sId` INTO TABLE temp5.
    
    CLEAR temp6.
    INSERT `MESSAGE_TOAST` INTO TABLE temp6.
    INSERT `show` INTO TABLE temp6.
    INSERT `{0} Pressed` INTO TABLE temp6.
    INSERT `$event.oSource.sId` INTO TABLE temp6.
    
    CLEAR temp7.
    INSERT `MESSAGE_TOAST` INTO TABLE temp7.
    INSERT `show` INTO TABLE temp7.
    INSERT `{0} Pressed` INTO TABLE temp7.
    INSERT `$event.oSource.sId` INTO TABLE temp7.
    
    CLEAR temp8.
    INSERT `MESSAGE_TOAST` INTO TABLE temp8.
    INSERT `show` INTO TABLE temp8.
    INSERT `{0} Pressed` INTO TABLE temp8.
    INSERT `$event.oSource.sId` INTO TABLE temp8.
    
    CLEAR temp9.
    INSERT `MESSAGE_TOAST` INTO TABLE temp9.
    INSERT `show` INTO TABLE temp9.
    INSERT `{0} Pressed` INTO TABLE temp9.
    INSERT `$event.oSource.sId` INTO TABLE temp9.
    
    CLEAR temp10.
    INSERT `MESSAGE_TOAST` INTO TABLE temp10.
    INSERT `show` INTO TABLE temp10.
    INSERT `{0} Pressed` INTO TABLE temp10.
    INSERT `$event.oSource.sId` INTO TABLE temp10.
    
    CLEAR temp11.
    INSERT `MESSAGE_TOAST` INTO TABLE temp11.
    INSERT `show` INTO TABLE temp11.
    INSERT `{0} Pressed` INTO TABLE temp11.
    INSERT `$event.oSource.sId` INTO TABLE temp11.
    
    CLEAR temp12.
    INSERT `MESSAGE_TOAST` INTO TABLE temp12.
    INSERT `show` INTO TABLE temp12.
    INSERT `{0} Pressed` INTO TABLE temp12.
    INSERT `$event.oSource.sId` INTO TABLE temp12.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `height`     v = `100%`

        )->ele( `Page`
            )->a( n = `title` v = `Page`
            )->a( n = `class` v = `sapUiContentPadding`

            )->ele( `customHeader`
                )->ele( `Toolbar`
                    )->tag( `Button`
                        )->a( n = `type`  v = `Back`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp1 )
                    )->tag( `ToolbarSpacer`
                    )->tag( `Title`
                        )->a( n = `text` v = `Title`
                    )->tag( `ToolbarSpacer`
                    )->tag( `Button`
                        )->a( n = `icon`          v = `sap-icon://edit`
                        )->a( n = `press`         v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp2 )
                        )->a( n = `ariaLabelledBy` v = `editButtonLabel`

                )->end(
            )->end(

            )->ele( `subHeader`
                )->ele( `Toolbar`
                    )->tag( `ToolbarSpacer`
                    )->tag( `Button`
                        )->a( n = `text`  v = `Default`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp3 )
                    )->tag( `Button`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `text`  v = `Reject`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp4 )
                    )->tag( `Button`
                        )->a( n = `icon`           v = `sap-icon://action`
                        )->a( n = `press`          v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp5 )
                        )->a( n = `ariaLabelledBy` v = `actionButtonLabel`
                    )->tag( `ToolbarSpacer`

                )->end(
            )->end(

            )->ele( `content`
                )->ele( `HBox`
                    )->ele( `Button`
                        )->a( n = `text`           v = `Default`
                        )->a( n = `press`          v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp6 )
                        )->a( n = `ariaDescribedBy` v = `defaultButtonDescription genericButtonDescription`
                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `type`           v = `Accept`
                        )->a( n = `text`           v = `Accept`
                        )->a( n = `press`          v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp7 )
                        )->a( n = `ariaDescribedBy` v = `acceptButtonDescription genericButtonDescription`
                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `type`           v = `Reject`
                        )->a( n = `text`           v = `Reject`
                        )->a( n = `press`          v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp8 )
                        )->a( n = `ariaDescribedBy` v = `rejectButtonDescription genericButtonDescription`
                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `text`           v = `Coming Soon`
                        )->a( n = `press`          v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp9 )
                        )->a( n = `ariaDescribedBy` v = `comingSoonButtonDescription genericButtonDescription`
                        )->a( n = `enabled`        v = `false`
                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(
                )->end(

                )->tag( `Label`
                    )->a( n = `id`   v = `genericButtonDescription`
                    )->a( n = `text` v = `Note: The buttons in this sample display MessageToast when pressed.`

                )->tag( n = `InvisibleText` ns = `core`
                    )->a( n = `id`   v = `defaultButtonDescription`
                    )->a( n = `text` v = `Description of default button goes here.`
                )->tag( n = `InvisibleText` ns = `core`
                    )->a( n = `id`   v = `acceptButtonDescription`
                    )->a( n = `text` v = `Description of accept button goes here.`
                )->tag( n = `InvisibleText` ns = `core`
                    )->a( n = `id`   v = `rejectButtonDescription`
                    )->a( n = `text` v = `Description of reject button goes here.`
                )->tag( n = `InvisibleText` ns = `core`
                    )->a( n = `id`   v = `comingSoonButtonDescription`
                    )->a( n = `text` v = `This feature is not active just now.`
                )->tag( n = `InvisibleText` ns = `core`
                    )->a( n = `id`   v = `editButtonLabel`
                    )->a( n = `text` v = `Edit Button Label`
                )->tag( n = `InvisibleText` ns = `core`
                    )->a( n = `id`   v = `actionButtonLabel`
                    )->a( n = `text` v = `Action Button Label`

            )->end(

            )->ele( `footer`
                )->ele( `Toolbar`
                    )->tag( `ToolbarSpacer`
                    )->tag( `Button`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `text`  v = `Emphasized`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp10 )
                    )->tag( `Button`
                        )->a( n = `text`  v = `Default`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp11 )
                    )->tag( `Button`
                        )->a( n = `icon`  v = `sap-icon://action`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp12 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
