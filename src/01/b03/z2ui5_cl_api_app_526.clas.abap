"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.Button - Button
"! https://sdk.openui5.org/entity/sap.m.Button/sample/sap.m.sample.Button
"! API USAGE AUDIT: (a) frontend_action (_event_client): NO | (b) event t_arg: YES
"! CHECKED (2026-07-15): manually verified in a running system - each press
"! toasts the pressed button's client-side control id, read via the event arg
"! $event.oSource.sId, exactly like the original.
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
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

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
                        )->a( n = `press` v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Title`
                        )->a( n = `text`  v = `Title`
                        )->a( n = `level` v = `H2`
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Button`
                        )->a( n = `icon`          v = `sap-icon://edit`
                        )->a( n = `type`          v = `Transparent`
                        )->a( n = `press`         v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                        )->a( n = `ariaLabelledBy` v = `editButtonLabel`

                )->shut(
            )->shut(

            )->open( `subHeader`
                )->open( `Toolbar`
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Button`
                        )->a( n = `text`  v = `Default`
                        )->a( n = `press` v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                    )->leaf( `Button`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `text`  v = `Reject`
                        )->a( n = `press` v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                    )->leaf( `Button`
                        )->a( n = `icon`           v = `sap-icon://action`
                        )->a( n = `type`           v = `Transparent`
                        )->a( n = `press`          v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                        )->a( n = `ariaLabelledBy` v = `actionButtonLabel`
                    )->leaf( `ToolbarSpacer`

                )->shut(
            )->shut(

            )->open( `content`
                )->open( `HBox`
                    )->open( `Button`
                        )->a( n = `text`           v = `Default`
                        )->a( n = `press`          v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                        )->a( n = `ariaDescribedBy` v = `defaultButtonDescription genericButtonDescription`

                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `type`            v = `Accept`
                        )->a( n = `text`            v = `Accept`
                        )->a( n = `press`           v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                        )->a( n = `ariaDescribedBy` v = `acceptButtonDescription genericButtonDescription`

                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `type`            v = `Reject`
                        )->a( n = `text`            v = `Reject`
                        )->a( n = `press`           v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                        )->a( n = `ariaDescribedBy` v = `rejectButtonDescription genericButtonDescription`

                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `text`            v = `Coming Soon`
                        )->a( n = `press`           v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
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
                        )->a( n = `press` v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                    )->leaf( `Button`
                        )->a( n = `text`  v = `Default`
                        )->a( n = `press` v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                    )->leaf( `Button`
                        )->a( n = `icon`  v = `sap-icon://action`
                        )->a( n = `type`  v = `Transparent`
                        )->a( n = `press` v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) ) ).

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
