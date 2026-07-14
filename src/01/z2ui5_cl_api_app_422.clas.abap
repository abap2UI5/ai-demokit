"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.ColorPalette - ColorPalette
"! https://sdk.openui5.org/entity/sap.m.ColorPalette/sample/sap.m.sample.ColorPalette
CLASS z2ui5_cl_api_app_422 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_422 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->attr( n = `xmlns`      v = `sap.m`
        )->attr( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->attr( n = `xmlns:form` v = `sap.ui.layout.form`

        )->open( n = `SimpleForm` ns = `form`
            )->attr( n = `editable`                v = `true`
            )->attr( n = `backgroundDesign`        v = `Transparent`
            )->attr( n = `singleContainerFullSize` v = `true`
            )->attr( n = `layout`                  v = `ResponsiveGridLayout`

            )->open( n = `toolbar` ns = `form`
                )->open( `Toolbar`
                    )->leaf( `Title`
                        )->attr( n = `text` v = `Color Palette in a Form`

                )->shut(
            )->shut(

            )->leaf( `Label`
                )->attr( n = `text` v = `Choose Color`
            )->leaf( `ColorPalette`
                )->attr( n = `colorSelect` v = client->_event( val   = `COLOR_SELECT`
                                                               t_arg = VALUE #( ( `${$parameters>/value}` ) ( `${$parameters>/defaultAction}` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `COLOR_SELECT`.
        client->message_toast_display( |Color Selected: value - { client->get_event_arg( 1 ) }, \n defaultAction - { client->get_event_arg( 2 ) }| ).

    ENDCASE.

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
