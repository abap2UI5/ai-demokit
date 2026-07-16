"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.ColorPalette - ColorPalette
"! https://sdk.openui5.org/entity/sap.m.ColorPalette/sample/sap.m.sample.ColorPalette
"! API USAGE AUDIT: (a) frontend_action (_event_client): NO | (b) event t_arg: YES
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
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`

        )->open( n = `SimpleForm` ns = `form`
            )->a( n = `editable`                v = `true`
            )->a( n = `backgroundDesign`        v = `Transparent`
            )->a( n = `singleContainerFullSize` v = `true`
            )->a( n = `layout`                  v = `ResponsiveGridLayout`

            )->open( n = `toolbar` ns = `form`
                )->open( `Toolbar`
                    )->leaf( `Title`
                        )->a( n = `text` v = `Color Palette in a Form`

                )->shut(
            )->shut(

            )->leaf( `Label`
                )->a( n = `text` v = `Choose Color`
            )->leaf( `ColorPalette`
                )->a( n = `colorSelect` v = client->_event( val   = `COLOR_SELECT`
                                                               t_arg = VALUE #( ( `${$parameters>/value}` ) ( `${$parameters>/defaultAction}` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `COLOR_SELECT`.
        " the boolean defaultAction parameter arrives as abap_bool (X/space) -
        " render it as true/false, like the original controller's string output
        DATA(default_action) = COND string( WHEN client->get_event_arg( 2 ) = abap_true
                                            THEN `true`
                                            ELSE `false` ).
        client->message_toast_display( |Color Selected: value - { client->get_event_arg( 1 ) }, \n defaultAction - { default_action }| ).

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
