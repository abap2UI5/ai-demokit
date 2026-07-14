"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sdk.openui5.org/entity/sap.m.MessageToast/sample/sap.m.sample.MessageToast
"! The Message Toast displays the message text as an overlay to the current screen. It closes
"! automatically after some time without requiring further user interaction.
CLASS z2ui5_cl_api_app_448 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_448 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->attr( n = `xmlns:l`   v = `sap.ui.layout`
        )->attr( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->attr( n = `xmlns`     v = `sap.m`

        )->open( n = `VerticalLayout` ns = `l`
            )->attr( n = `class` v = `sapUiContentPadding`
            )->attr( n = `width` v = `100%`

            )->open( n = `content` ns = `l`
                )->leaf( `Button`
                    )->attr( n = `text`  v = `Show Message Toast`
                    )->attr( n = `press` v = client->_event( `SHOW_MESSAGE_TOAST` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `SHOW_MESSAGE_TOAST` ).
      client->message_toast_display( |Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy\r\n eirmod.| ).
    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
