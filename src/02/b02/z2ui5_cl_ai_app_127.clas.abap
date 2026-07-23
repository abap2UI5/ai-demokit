CLASS z2ui5_cl_ai_app_127 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_127 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " original onPress: MessageToast.show( source.getId() + ' Pressed' )
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
                        )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Pressed` ) ) )
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Title`
                        )->a( n = `text` v = `Title`
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Button`
                        )->a( n = `icon`          v = `sap-icon://edit`
                        )->a( n = `press`         v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Pressed` ) ) )
                        )->a( n = `ariaLabelledBy` v = `editButtonLabel`

                )->shut(
            )->shut(

            )->open( `subHeader`
                )->open( `Toolbar`
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Button`
                        )->a( n = `text`  v = `Default`
                        )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Pressed` ) ) )
                    )->leaf( `Button`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `text`  v = `Reject`
                        )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Pressed` ) ) )
                    )->leaf( `Button`
                        )->a( n = `icon`           v = `sap-icon://action`
                        )->a( n = `press`          v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Pressed` ) ) )
                        )->a( n = `ariaLabelledBy` v = `actionButtonLabel`
                    )->leaf( `ToolbarSpacer`

                )->shut(
            )->shut(

            )->open( `content`
                )->open( `HBox`
                    )->open( `Button`
                        )->a( n = `text`           v = `Default`
                        )->a( n = `press`          v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Pressed` ) ) )
                        )->a( n = `ariaDescribedBy` v = `defaultButtonDescription genericButtonDescription`
                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                    )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `type`           v = `Accept`
                        )->a( n = `text`           v = `Accept`
                        )->a( n = `press`          v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Pressed` ) ) )
                        )->a( n = `ariaDescribedBy` v = `acceptButtonDescription genericButtonDescription`
                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                    )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `type`           v = `Reject`
                        )->a( n = `text`           v = `Reject`
                        )->a( n = `press`          v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Pressed` ) ) )
                        )->a( n = `ariaDescribedBy` v = `rejectButtonDescription genericButtonDescription`
                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                    )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `text`           v = `Coming Soon`
                        )->a( n = `press`          v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Pressed` ) ) )
                        )->a( n = `ariaDescribedBy` v = `comingSoonButtonDescription genericButtonDescription`
                        )->a( n = `enabled`        v = `false`
                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                    )->shut(
                )->shut(
            )->shut(

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
                        )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Pressed` ) ) )
                    )->leaf( `Button`
                        )->a( n = `text`  v = `Default`
                        )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Pressed` ) ) )
                    )->leaf( `Button`
                        )->a( n = `icon`  v = `sap-icon://action`
                        )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Pressed` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
