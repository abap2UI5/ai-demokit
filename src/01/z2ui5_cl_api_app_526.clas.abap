"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.Button - Button
"! https://sdk.openui5.org/entity/sap.m.Button/sample/sap.m.sample.Button
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

  " NOTES (generation):
  " - IMPROVISED: the original press handler toasts oEvent.getSource().getId()
  "   - a client-side control id that does not exist server-side. All presses
  "   collapse to one event that shows a static text instead.

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
        )->attr( n = `xmlns`      v = `sap.m`
        )->attr( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->attr( n = `xmlns:core` v = `sap.ui.core`
        )->attr( n = `height`     v = `100%`

        )->open( `Page`
            )->attr( n = `title` v = `Page`
            )->attr( n = `class` v = `sapUiContentPadding`

            )->open( `customHeader`
                )->open( `Toolbar`
                    )->leaf( `Button`
                        )->attr( n = `type`  v = `Back`
                        )->attr( n = `press` v = client->_event( `PRESS` )
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Title`
                        )->attr( n = `text`  v = `Title`
                        )->attr( n = `level` v = `H2`
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Button`
                        )->attr( n = `icon`          v = `sap-icon://edit`
                        )->attr( n = `type`          v = `Transparent`
                        )->attr( n = `press`         v = client->_event( `PRESS` )
                        )->attr( n = `ariaLabelledBy` v = `editButtonLabel`

                )->shut(
            )->shut(

            )->open( `subHeader`
                )->open( `Toolbar`
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Button`
                        )->attr( n = `text`  v = `Default`
                        )->attr( n = `press` v = client->_event( `PRESS` )
                    )->leaf( `Button`
                        )->attr( n = `type`  v = `Reject`
                        )->attr( n = `text`  v = `Reject`
                        )->attr( n = `press` v = client->_event( `PRESS` )
                    )->leaf( `Button`
                        )->attr( n = `icon`           v = `sap-icon://action`
                        )->attr( n = `type`           v = `Transparent`
                        )->attr( n = `press`          v = client->_event( `PRESS` )
                        )->attr( n = `ariaLabelledBy` v = `actionButtonLabel`
                    )->leaf( `ToolbarSpacer`

                )->shut(
            )->shut(

            )->open( `content`
                )->open( `HBox`
                    )->open( `Button`
                        )->attr( n = `text`           v = `Default`
                        )->attr( n = `press`          v = client->_event( `PRESS` )
                        )->attr( n = `ariaDescribedBy` v = `defaultButtonDescription genericButtonDescription`

                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->attr( n = `growFactor` v = `1`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->attr( n = `type`            v = `Accept`
                        )->attr( n = `text`            v = `Accept`
                        )->attr( n = `press`           v = client->_event( `PRESS` )
                        )->attr( n = `ariaDescribedBy` v = `acceptButtonDescription genericButtonDescription`

                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->attr( n = `growFactor` v = `1`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->attr( n = `type`            v = `Reject`
                        )->attr( n = `text`            v = `Reject`
                        )->attr( n = `press`           v = client->_event( `PRESS` )
                        )->attr( n = `ariaDescribedBy` v = `rejectButtonDescription genericButtonDescription`

                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->attr( n = `growFactor` v = `1`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->attr( n = `text`            v = `Coming Soon`
                        )->attr( n = `press`           v = client->_event( `PRESS` )
                        )->attr( n = `ariaDescribedBy` v = `comingSoonButtonDescription genericButtonDescription`
                        )->attr( n = `enabled`         v = `false`

                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->attr( n = `growFactor` v = `1`

                        )->shut(
                    )->shut(

                )->shut(

                " Collection of labels (some invisible) providing ARIA descriptions for the buttons
                )->leaf( `Label`
                    )->attr( n = `id`   v = `genericButtonDescription`
                    )->attr( n = `text` v = `Note: The buttons in this sample display MessageToast when pressed.`
                )->leaf( n = `InvisibleText` ns = `core`
                    )->attr( n = `id`   v = `defaultButtonDescription`
                    )->attr( n = `text` v = `Description of default button goes here.`
                )->leaf( n = `InvisibleText` ns = `core`
                    )->attr( n = `id`   v = `acceptButtonDescription`
                    )->attr( n = `text` v = `Description of accept button goes here.`
                )->leaf( n = `InvisibleText` ns = `core`
                    )->attr( n = `id`   v = `rejectButtonDescription`
                    )->attr( n = `text` v = `Description of reject button goes here.`
                )->leaf( n = `InvisibleText` ns = `core`
                    )->attr( n = `id`   v = `comingSoonButtonDescription`
                    )->attr( n = `text` v = `This feature is not active just now.`
                )->leaf( n = `InvisibleText` ns = `core`
                    )->attr( n = `id`   v = `editButtonLabel`
                    )->attr( n = `text` v = `Edit Button Label`
                )->leaf( n = `InvisibleText` ns = `core`
                    )->attr( n = `id`   v = `actionButtonLabel`
                    )->attr( n = `text` v = `Action Button Label`

            )->shut(

            )->open( `footer`
                )->open( `Toolbar`
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Button`
                        )->attr( n = `type`  v = `Emphasized`
                        )->attr( n = `text`  v = `Emphasized`
                        )->attr( n = `press` v = client->_event( `PRESS` )
                    )->leaf( `Button`
                        )->attr( n = `text`  v = `Default`
                        )->attr( n = `press` v = client->_event( `PRESS` )
                    )->leaf( `Button`
                        )->attr( n = `icon`  v = `sap-icon://action`
                        )->attr( n = `type`  v = `Transparent`
                        )->attr( n = `press` v = client->_event( `PRESS` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `PRESS`.
        " Original controller shows evt.getSource().getId() + " Pressed";
        " the control id is client-side only, so the static toast text is shown.
        client->message_toast_display( `Button Pressed` ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
