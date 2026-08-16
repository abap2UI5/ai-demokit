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
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " original onPress: MessageToast.show( source.getId() + ' Pressed' )
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
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} Pressed` ) ( `$event.oSource.sId` ) ) )
                    )->tag( `ToolbarSpacer`
                    )->tag( `Title`
                        )->a( n = `text` v = `Title`
                    )->tag( `ToolbarSpacer`
                    )->tag( `Button`
                        )->a( n = `icon`          v = `sap-icon://edit`
                        )->a( n = `press`         v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} Pressed` ) ( `$event.oSource.sId` ) ) )
                        )->a( n = `ariaLabelledBy` v = `editButtonLabel`

                )->end(
            )->end(

            )->ele( `subHeader`
                )->ele( `Toolbar`
                    )->tag( `ToolbarSpacer`
                    )->tag( `Button`
                        )->a( n = `text`  v = `Default`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} Pressed` ) ( `$event.oSource.sId` ) ) )
                    )->tag( `Button`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `text`  v = `Reject`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} Pressed` ) ( `$event.oSource.sId` ) ) )
                    )->tag( `Button`
                        )->a( n = `icon`           v = `sap-icon://action`
                        )->a( n = `press`          v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} Pressed` ) ( `$event.oSource.sId` ) ) )
                        )->a( n = `ariaLabelledBy` v = `actionButtonLabel`
                    )->tag( `ToolbarSpacer`

                )->end(
            )->end(

            )->ele( `content`
                )->ele( `HBox`
                    )->ele( `Button`
                        )->a( n = `text`           v = `Default`
                        )->a( n = `press`          v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} Pressed` ) ( `$event.oSource.sId` ) ) )
                        )->a( n = `ariaDescribedBy` v = `defaultButtonDescription genericButtonDescription`
                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `type`           v = `Accept`
                        )->a( n = `text`           v = `Accept`
                        )->a( n = `press`          v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} Pressed` ) ( `$event.oSource.sId` ) ) )
                        )->a( n = `ariaDescribedBy` v = `acceptButtonDescription genericButtonDescription`
                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `type`           v = `Reject`
                        )->a( n = `text`           v = `Reject`
                        )->a( n = `press`          v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} Pressed` ) ( `$event.oSource.sId` ) ) )
                        )->a( n = `ariaDescribedBy` v = `rejectButtonDescription genericButtonDescription`
                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `text`           v = `Coming Soon`
                        )->a( n = `press`          v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} Pressed` ) ( `$event.oSource.sId` ) ) )
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
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} Pressed` ) ( `$event.oSource.sId` ) ) )
                    )->tag( `Button`
                        )->a( n = `text`  v = `Default`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} Pressed` ) ( `$event.oSource.sId` ) ) )
                    )->tag( `Button`
                        )->a( n = `icon`  v = `sap-icon://action`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} Pressed` ) ( `$event.oSource.sId` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
