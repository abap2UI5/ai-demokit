CLASS z2ui5_cl_api_app_526 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_526 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_api_xml.
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
    view = z2ui5_cl_api_xml=>factory( ).

    
    CLEAR temp1.
    INSERT `$event.oSource.sId` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `$event.oSource.sId` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `$event.oSource.sId` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `$event.oSource.sId` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `$event.oSource.sId` INTO TABLE temp5.
    
    CLEAR temp6.
    INSERT `$event.oSource.sId` INTO TABLE temp6.
    
    CLEAR temp7.
    INSERT `$event.oSource.sId` INTO TABLE temp7.
    
    CLEAR temp8.
    INSERT `$event.oSource.sId` INTO TABLE temp8.
    
    CLEAR temp9.
    INSERT `$event.oSource.sId` INTO TABLE temp9.
    
    CLEAR temp10.
    INSERT `$event.oSource.sId` INTO TABLE temp10.
    
    CLEAR temp11.
    INSERT `$event.oSource.sId` INTO TABLE temp11.
    
    CLEAR temp12.
    INSERT `$event.oSource.sId` INTO TABLE temp12.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `height`     v = `100%`

        )->open( `Page`
            )->a( n = `title` v = `Page`
            )->a( n = `class` v = `sapUiContentPadding`

            )->open( `customHeader`
                )->open( `Toolbar`
                    )->leaf( `Button`
                        )->a( n = `type`  v = `Back`
                        )->a( n = `press` v = client->_event( val = `PRESS` t_arg = temp1 )
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Title`
                        )->a( n = `text`  v = `Title`
                        )->a( n = `level` v = `H2`
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Button`
                        )->a( n = `icon`          v = `sap-icon://edit`
                        )->a( n = `type`          v = `Transparent`
                        )->a( n = `press`         v = client->_event( val = `PRESS` t_arg = temp2 )
                        )->a( n = `ariaLabelledBy` v = `editButtonLabel`

                )->shut(
            )->shut(

            )->open( `subHeader`
                )->open( `Toolbar`
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Button`
                        )->a( n = `text`  v = `Default`
                        )->a( n = `press` v = client->_event( val = `PRESS` t_arg = temp3 )
                    )->leaf( `Button`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `text`  v = `Reject`
                        )->a( n = `press` v = client->_event( val = `PRESS` t_arg = temp4 )
                    )->leaf( `Button`
                        )->a( n = `icon`           v = `sap-icon://action`
                        )->a( n = `type`           v = `Transparent`
                        )->a( n = `press`          v = client->_event( val = `PRESS` t_arg = temp5 )
                        )->a( n = `ariaLabelledBy` v = `actionButtonLabel`
                    )->leaf( `ToolbarSpacer`

                )->shut(
            )->shut(

            )->open( `content`
                )->open( `HBox`
                    )->open( `Button`
                        )->a( n = `text`           v = `Default`
                        )->a( n = `press`          v = client->_event( val = `PRESS` t_arg = temp6 )
                        )->a( n = `ariaDescribedBy` v = `defaultButtonDescription genericButtonDescription`

                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `type`            v = `Accept`
                        )->a( n = `text`            v = `Accept`
                        )->a( n = `press`           v = client->_event( val = `PRESS` t_arg = temp7 )
                        )->a( n = `ariaDescribedBy` v = `acceptButtonDescription genericButtonDescription`

                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `type`            v = `Reject`
                        )->a( n = `text`            v = `Reject`
                        )->a( n = `press`           v = client->_event( val = `PRESS` t_arg = temp8 )
                        )->a( n = `ariaDescribedBy` v = `rejectButtonDescription genericButtonDescription`

                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `text`            v = `Coming Soon`
                        )->a( n = `press`           v = client->_event( val = `PRESS` t_arg = temp9 )
                        )->a( n = `ariaDescribedBy` v = `comingSoonButtonDescription genericButtonDescription`
                        )->a( n = `enabled`         v = `false`

                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->shut(
                    )->shut(
                )->shut(

                " Collection of labels (some invisible) providing ARIA descriptions for the buttons
                )->leaf( `Label`
                    )->a( n = `id`   v = `genericButtonDescription`
                    )->a( n = `text` v = `Note: The buttons in this sample display MessageToast when pressed.`
                )->leaf( n = `InvisibleText` ns = `core`
                    )->a( n = `id`   v = `defaultButtonDescription`
                    )->a( n = `text` v = `Description of default button goes here.`
                )->leaf( n = `InvisibleText` ns = `core`
                    )->a( n = `id`   v = `acceptButtonDescription`
                    )->a( n = `text` v = `Description of accept button goes here.`
                )->leaf( n = `InvisibleText` ns = `core`
                    )->a( n = `id`   v = `rejectButtonDescription`
                    )->a( n = `text` v = `Description of reject button goes here.`
                )->leaf( n = `InvisibleText` ns = `core`
                    )->a( n = `id`   v = `comingSoonButtonDescription`
                    )->a( n = `text` v = `This feature is not active just now.`
                )->leaf( n = `InvisibleText` ns = `core`
                    )->a( n = `id`   v = `editButtonLabel`
                    )->a( n = `text` v = `Edit Button Label`
                )->leaf( n = `InvisibleText` ns = `core`
                    )->a( n = `id`   v = `actionButtonLabel`
                    )->a( n = `text` v = `Action Button Label`

            )->shut(

            )->open( `footer`
                )->open( `Toolbar`
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Button`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `text`  v = `Emphasized`
                        )->a( n = `press` v = client->_event( val = `PRESS` t_arg = temp10 )
                    )->leaf( `Button`
                        )->a( n = `text`  v = `Default`
                        )->a( n = `press` v = client->_event( val = `PRESS` t_arg = temp11 )
                    )->leaf( `Button`
                        )->a( n = `icon`  v = `sap-icon://action`
                        )->a( n = `type`  v = `Transparent`
                        )->a( n = `press` v = client->_event( val = `PRESS` t_arg = temp12 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `PRESS`.
        " like the original: evt.getSource().getId() + " Pressed" -
        " the client-side control id arrives as event arg $event.oSource.sId
        client->message_toast_display( |{ client->get_event_arg( ) } Pressed| ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
