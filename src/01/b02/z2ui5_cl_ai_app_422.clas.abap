CLASS z2ui5_cl_ai_app_422 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_422 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

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
        client->message_toast_display( |Color Selected: value - { client->get_event_arg( ) }, \n defaultAction - { default_action }| ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
